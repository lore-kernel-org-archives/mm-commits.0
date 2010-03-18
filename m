From: akpm@linux-foundation.org
Subject: [merged] leds-gpio-fix-default-state-handling-on-of-platforms.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:08:37 -0400
Message-ID: <201003181809.o2II9Iw7007550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab0CRSJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, rpurdie@linux.intel.com, stable@kernel.org, xyzzy@speakeasy.org, mm-commits@vger.kernel.org


The patch titled
     leds-gpio: fix default state handling on OF platforms
has been removed from the -mm tree.  Its filename was
     leds-gpio-fix-default-state-handling-on-of-platforms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-gpio: fix default state handling on OF platforms
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The driver wrongly sets default state for LEDs that don't specify
default-state property.

Currently the driver handles default state this way:

memset(&led, 0, sizeof(led));
for_each_child_of_node(np, child) {
	state = of_get_property(child, "default-state", NULL);
	if (state) {
		if (!strcmp(state, "keep"))
			led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
		...
	}
	ret = create_gpio_led(&led, ...);
}

Which means that all LEDs that do not specify default-state will inherit
the last value of the default-state property, which is wrong.

This patch fixes the issue by moving LED's template initialization into
the loop body.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Acked-by: Trent Piepho <xyzzy@speakeasy.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/leds/leds-gpio.c~leds-gpio-fix-default-state-handling-on-of-platforms drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-gpio-fix-default-state-handling-on-of-platforms
+++ a/drivers/leds/leds-gpio.c
@@ -211,7 +211,6 @@ static int __devinit of_gpio_leds_probe(
 					const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->node, *child;
-	struct gpio_led led;
 	struct gpio_led_of_platform_data *pdata;
 	int count = 0, ret;
 
@@ -226,8 +225,8 @@ static int __devinit of_gpio_leds_probe(
 	if (!pdata)
 		return -ENOMEM;
 
-	memset(&led, 0, sizeof(led));
 	for_each_child_of_node(np, child) {
+		struct gpio_led led = {};
 		enum of_gpio_flags flags;
 		const char *state;
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch
gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch

