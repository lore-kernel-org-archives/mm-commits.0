From: akpm@linux-foundation.org
Subject: + backlight-fix-ot200_bl-build.patch added to -mm tree
Date: Wed, 29 Feb 2012 15:58:59 -0800
Message-ID: <20120229235859.AA9E9A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:64445 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab2B2X7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 18:59:02 -0500
Received: by wgbdt11 with SMTP id dt11so364wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 15:59:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, christian.gmeiner@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: fix ot200_bl build
has been added to the -mm tree.  Its filename is
     backlight-fix-ot200_bl-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: backlight: fix ot200_bl build

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
backlight-fix-ot200_bl-build.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
rtc-ds1307-generalise-ram-size-and-offset-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

