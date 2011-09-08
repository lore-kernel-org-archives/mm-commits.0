From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-gpioc-use-gpio_get_value_cansleep-when-initializing.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:57:43 -0700
Message-ID: <201109082357.p88NvhdU016155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980Ab1IHX56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.daney@cavium.com, grant.likely@secretlab.ca, rpurdie@rpsys.net, xyzzy@speakeasy.org


The patch titled
     drivers/leds/leds-gpio.c: use gpio_get_value_cansleep() when initializing
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-gpioc-use-gpio_get_value_cansleep-when-initializing.patch

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
Subject: drivers/leds/leds-gpio.c: use gpio_get_value_cansleep() when initializing
From: David Daney <david.daney@cavium.com>

I get the following warning:

------------[ cut here ]------------
WARNING: at drivers/gpio/gpiolib.c:1559 __gpio_get_value+0x90/0x98()
Modules linked in:
Call Trace:
[<ffffffff81440950>] dump_stack+0x8/0x34
[<ffffffff81141478>] warn_slowpath_common+0x78/0xa0
[<ffffffff812f0958>] __gpio_get_value+0x90/0x98
[<ffffffff81434f04>] create_gpio_led+0xdc/0x194
[<ffffffff8143524c>] gpio_led_probe+0x290/0x36c
[<ffffffff8130e8b0>] driver_probe_device+0x78/0x1b0
[<ffffffff8130eaa8>] __driver_attach+0xc0/0xc8
[<ffffffff8130d7ac>] bus_for_each_dev+0x64/0xb0
[<ffffffff8130e130>] bus_add_driver+0x1c8/0x2a8
[<ffffffff8130f100>] driver_register+0x90/0x180
[<ffffffff81100438>] do_one_initcall+0x38/0x160

---[ end trace ee38723fbefcd65c ]---

My GPIOs are on an I2C port expander, so we must use the *_cansleep()
variant of the GPIO functions.  This is was not being done in
create_gpio_led().

We can change gpio_get_value() to gpio_get_value_cansleep() because it is
only called from the platform_driver probe function, which is a context
where we can sleep.

Only tested on my gpio_cansleep() system, but it seems safe for all
systems.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-gpio.c~drivers-leds-leds-gpioc-use-gpio_get_value_cansleep-when-initializing drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~drivers-leds-leds-gpioc-use-gpio_get_value_cansleep-when-initializing
+++ a/drivers/leds/leds-gpio.c
@@ -122,7 +122,7 @@ static int __devinit create_gpio_led(con
 	}
 	led_dat->cdev.brightness_set = gpio_led_set;
 	if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
-		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
+		state = !!gpio_get_value_cansleep(led_dat->gpio) ^ led_dat->active_low;
 	else
 		state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
 	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
_

Patches currently in -mm which might be from david.daney@cavium.com are

linux-next.patch
drivers-leds-leds-gpioc-use-gpio_get_value_cansleep-when-initializing.patch

