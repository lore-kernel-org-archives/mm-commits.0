From: akpm@linux-foundation.org
Subject: + leds-gpio-fix-default-state-handling-on-of-platforms.patch added to -mm tree
Date: Mon, 08 Feb 2010 13:05:06 -0800
Message-ID: <201002082105.o18L56F3002880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0BHVG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 16:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, rpurdie@linux.intel.com, xyzzy@speakeasy.org


The patch titled
     leds-gpio: fix default state handling on OF platforms
has been added to the -mm tree.  Its filename is
     leds-gpio-fix-default-state-handling-on-of-platforms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Richard Purdie <rpurdie@linux.intel.com>
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

linux-next.patch
leds-gpio-fix-default-state-handling-on-of-platforms.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

