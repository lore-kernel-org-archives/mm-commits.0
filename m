From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-ot200_bl-build.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:08 -0700
Message-ID: <20120326192908.6C32FA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39289 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2CZT3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:10 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so233174wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, christian.gmeiner@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: fix ot200_bl build
has been removed from the -mm tree.  Its filename was
     backlight-fix-ot200_bl-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: backlight: fix ot200_bl build

Fix build error when GPIO_CS5535 is not enabled:

drivers/built-in.o: In function `ot200_backlight_probe':
ot200_bl.c:(.text+0x205bf): undefined reference to `cs5535_gpio_set'
ot200_bl.c:(.text+0x205d1): undefined reference to `cs5535_gpio_set'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/Kconfig~backlight-fix-ot200_bl-build drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-fix-ot200_bl-build
+++ a/drivers/video/backlight/Kconfig
@@ -343,7 +343,7 @@ config BACKLIGHT_LP855X
 
 config BACKLIGHT_OT200
 	tristate "Backlight driver for ot200 visualisation device"
-	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT
+	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT && GPIO_CS5535
 	help
 	  To compile this driver as a module, choose M here: the module will be
 	  called ot200_bl.
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

