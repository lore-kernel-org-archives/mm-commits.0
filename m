From: akpm@linux-foundation.org
Subject: - radeonfb-fix-debug-option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:17 -0700
Message-ID: <200804282158.m3SLwHCm018480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965316AbYD1V6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: fix debug option
has been removed from the -mm tree.  Its filename was
     radeonfb-fix-debug-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix debug option
From: Jean Delvare <khali@linux-fr.org>

Fix CONFIG_FB_RADEON_DEBUG.  DEBUG must be defined before including any kernel
header, otherwise dev_dbg() resolves to a no-op.  Also, when debugging is
disabled, don't set DEBUG at all instead of setting it to 0, to comply with
what the kernel headers expect.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c    |    3 ++-
 drivers/video/aty/radeon_i2c.c     |    3 ++-
 drivers/video/aty/radeon_monitor.c |    2 +-
 drivers/video/aty/radeonfb.h       |   12 +++++-------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-fix-debug-option drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-fix-debug-option
+++ a/drivers/video/aty/radeon_base.c
@@ -52,6 +52,8 @@
 
 #define RADEON_VERSION	"0.2.0"
 
+#include "radeonfb.h"
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -92,7 +94,6 @@
 
 #include "../edid.h" // MOVE THAT TO include/video
 #include "ati_ids.h"
-#include "radeonfb.h"		    
 
 #define MAX_MAPPED_VRAM	(2048*2048*4)
 #define MIN_MAPPED_VRAM	(1024*768*1)
diff -puN drivers/video/aty/radeon_i2c.c~radeonfb-fix-debug-option drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~radeonfb-fix-debug-option
+++ a/drivers/video/aty/radeon_i2c.c
@@ -1,3 +1,5 @@
+#include "radeonfb.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -11,7 +13,6 @@
 #include <asm/io.h>
 
 #include <video/radeon.h>
-#include "radeonfb.h"
 #include "../edid.h"
 
 static void radeon_gpio_setscl(void* data, int state)
diff -puN drivers/video/aty/radeon_monitor.c~radeonfb-fix-debug-option drivers/video/aty/radeon_monitor.c
--- a/drivers/video/aty/radeon_monitor.c~radeonfb-fix-debug-option
+++ a/drivers/video/aty/radeon_monitor.c
@@ -481,7 +481,7 @@ void __devinit radeon_probe_screens(stru
 		
 		RTRACE("Starting monitor auto detection...\n");
 
-#if DEBUG && defined(CONFIG_FB_RADEON_I2C)
+#if defined(DEBUG) && defined(CONFIG_FB_RADEON_I2C)
 		{
 			u8 *EDIDs[4] = { NULL, NULL, NULL, NULL };
 			int mon_types[4] = {MT_NONE, MT_NONE, MT_NONE, MT_NONE};
diff -puN drivers/video/aty/radeonfb.h~radeonfb-fix-debug-option drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-fix-debug-option
+++ a/drivers/video/aty/radeonfb.h
@@ -1,6 +1,10 @@
 #ifndef __RADEONFB_H__
 #define __RADEONFB_H__
 
+#ifdef CONFIG_FB_RADEON_DEBUG
+#define DEBUG		1
+#endif
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -367,13 +371,7 @@ struct radeonfb_info {
 /*
  * Debugging stuffs
  */
-#ifdef CONFIG_FB_RADEON_DEBUG
-#define DEBUG		1
-#else
-#define DEBUG		0
-#endif
