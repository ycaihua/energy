#import "ARTextFieldWithPlaceholder.h"

#define CLEAR_BUTTON_TAG 0xbada55


@interface ARTextFieldWithPlaceholder ()
@property (nonatomic, assign) BOOL swizzledClear;
@end


@implementation ARTextFieldWithPlaceholder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.font = [UIFont serifFontWithSize:20];
    self.textColor = [UIColor blackColor];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{
        NSForegroundColorAttributeName : UIColor.artsyMediumGrey
    }];
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];

    if (!self.swizzledClear && [view class] == [UIButton class]) {
        UIView *subview = (UIView *)view.subviews.firstObject;
        if ([subview class] == [UIImageView class]) {
            [self swizzleClearButton:(UIButton *)view];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIButton *button = (UIButton *)[self viewWithTag:CLEAR_BUTTON_TAG];
    if (button) {
        button.center = CGPointMake(button.center.x, button.center.y - 3);
    }
}

- (void)swizzleClearButton:(UIButton *)button
{
    UIImageView *imageView = (UIImageView *)button.subviews.firstObject;
    UIImage *image = [imageView image];
    UIImage *templated = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:templated forState:UIControlStateNormal];
    [button setImage:templated forState:UIControlStateHighlighted];
    [button setTintColor:[UIColor whiteColor]];
    self.swizzledClear = YES;
    button.tag = CLEAR_BUTTON_TAG;
}

@end
