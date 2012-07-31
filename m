From: akpm@linux-foundation.org
Subject: [merged] backlight-move-register-definitions-from-header-to-source.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:43 -0700
Message-ID: <20120731185043.BA4D91E005B@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2GaSuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:44 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: move register definitions from header to source
has been removed from the -mm tree.  Its filename was
     backlight-move-register-definitions-from-header-to-source.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: move register definitions from header to source

ROM boundary definitions are no need to be exported because these are used
= only in lp855x driver internally.

And few code cosmetic changes

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    8 ++++++--
 include/linux/lp855x.h              |    6 ------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-move-register-definitions-from-header-to-source drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-move-register-definitions-from-header-to-source
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -17,8 +17,12 @@
 #include <linux/lp855x.h>
 
 /* Registers */
-#define BRIGHTNESS_CTRL		(0x00)
-#define DEVICE_CTRL		(0x01)
+#define BRIGHTNESS_CTRL		0x00
+#define DEVICE_CTRL		0x01
+#define EEPROM_START		0xA0
+#define EEPROM_END		0xA7
+#define EPROM_START		0xA0
+#define EPROM_END		0xAF
 
 #define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
diff -puN include/linux/lp855x.h~backlight-move-register-definitions-from-header-to-source include/linux/lp855x.h
--- a/include/linux/lp855x.h~backlight-move-register-definitions-from-header-to-source
+++ a/include/linux/lp855x.h
@@ -47,12 +47,6 @@
 				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
 #define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
 
-/* ROM area boundary */
-#define EEPROM_START	(0xA0)
-#define EEPROM_END	(0xA7)
-#define EPROM_START	(0xA0)
-#define EPROM_END	(0xAF)
