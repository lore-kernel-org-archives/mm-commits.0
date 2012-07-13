From: akpm@linux-foundation.org
Subject: + backlight-move-register-definitions-from-header-to-source.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:54:23 -0700
Message-ID: <20120713215424.917215C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44370 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2GMVy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:54:27 -0400
Received: by eekd4 with SMTP id d4so149598eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:54:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: move register definitions from header to source
has been added to the -mm tree.  Its filename is
     backlight-move-register-definitions-from-header-to-source.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
