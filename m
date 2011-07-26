From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:47 -0700
Message-ID: <201107260754.p6Q7soqn003388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab1GZHzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, sguinot@lacie.com, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-netxbig: make LEDS_NETXBIG depend on LEDS_CLASS
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -365,6 +365,7 @@ config LEDS_NS2
 config LEDS_NETXBIG
 	tristate "LED support for Big Network series LEDs"
 	depends on MACH_NET2BIG_V2 || MACH_NET5BIG_V2
+	depends on LEDS_CLASS
 	default y
 	help
 	  This option enable support for LEDs found on the LaCie 2Big
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch

