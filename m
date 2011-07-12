From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch added to -mm tree
Date: Tue, 12 Jul 2011 16:44:20 -0700
Message-ID: <201107122344.p6CNiKPP011494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753650Ab1GLXpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 19:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, rpurdie@rpsys.net, sguinot@lacie.com


The patch titled
     drivers/leds/leds-netxbig: make LEDS_NETXBIG depend on LEDS_CLASS
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch

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
Subject: drivers/leds/leds-netxbig: make LEDS_NETXBIG depend on LEDS_CLASS
From: Axel Lin <axel.lin@gmail.com>

We call led_classdev_register/led_classdev_unregister in
create_netxbig_led/delete_netxbig_led, thus make LEDS_NETXBIG depend on
LEDS_CLASS.

This patch fixes below build error if LEDS_CLASS is not configured.

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `create_netxbig_led':
drivers/leds/leds-netxbig.c:350: undefined reference to `led_classdev_register'
drivers/leds/leds-netxbig.c:361: undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `delete_netxbig_led':
drivers/leds/leds-netxbig.c:313: undefined reference to `led_classdev_unregister'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/Kconfig~drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class
+++ a/drivers/leds/Kconfig
@@ -357,6 +357,7 @@ config LEDS_NS2
 config LEDS_NETXBIG
 	tristate "LED support for Big Network series LEDs"
 	depends on MACH_NET2BIG_V2 || MACH_NET5BIG_V2
+	depends on LEDS_CLASS
 	default y
 	help
 	  This option enable support for LEDs found on the LaCie 2Big
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch
drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch

