From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:30 -0700
Message-ID: <20120531191830.7B6F1A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58095 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab2EaTSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:31 -0400
Received: by qcsp5 with SMTP id p5so136473qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, FlorianSchandinat@gmx.de, hsweeten@visionengravers.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/apple_bl.c: include header for exported symbol prototypes
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: drivers/video/backlight/apple_bl.c: include header for exported symbol prototypes

Include the header to pickup the exported symbol prototype.

Quites the sparse warning:

warning: symbol 'apple_bl_register' was not declared. Should it be static?
warning: symbol 'apple_bl_unregister' was not declared. Should it be static?

[akpm@linux-foundation.org: fix resulting build error]
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/apple_bl.c |    1 +
 include/linux/apple_bl.h           |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/apple_bl.c~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes drivers/video/backlight/apple_bl.c
--- a/drivers/video/backlight/apple_bl.c~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes
+++ a/drivers/video/backlight/apple_bl.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/atomic.h>
+#include <linux/apple_bl.h>
 
 static struct backlight_device *apple_backlight_device;
 
diff -puN include/linux/apple_bl.h~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes include/linux/apple_bl.h
--- a/include/linux/apple_bl.h~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes
+++ a/include/linux/apple_bl.h
@@ -5,7 +5,7 @@
 #ifndef _LINUX_APPLE_BL_H
 #define _LINUX_APPLE_BL_H
 
-#ifdef CONFIG_BACKLIGHT_APPLE
+#if defined(CONFIG_BACKLIGHT_APPLE) || defined(CONFIG_BACKLIGHT_APPLE_MODULE)
 
 extern int apple_bl_register(void);
 extern void apple_bl_unregister(void);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
init-disable-sparse-checking-of-the-mounto-source-files.patch

