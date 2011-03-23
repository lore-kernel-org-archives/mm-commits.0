From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:05 -0700
Message-ID: <201103232036.p2NKafh1028152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWUk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5523.c: world-writable engine* sysfs files
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5523.c: world-writable engine* sysfs files
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to change LED settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files
+++ a/drivers/leds/leds-lp5523.c
@@ -713,7 +713,7 @@ static ssize_t store_current(struct devi
 }
 
 /* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
 
 static struct attribute *lp5523_led_attributes[] = {
@@ -727,21 +727,21 @@ static struct attribute_group lp5523_led
 };
 
 /* device attributes */
-static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
 		   show_engine1_mode, store_engine1_mode);
-static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUSR,
 		   show_engine2_mode, store_engine2_mode);
-static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUSR,
 		   show_engine3_mode, store_engine3_mode);
-static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUSR,
 		   show_engine1_leds, store_engine1_leds);
-static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUSR,
 		   show_engine2_leds, store_engine2_leds);
-static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUSR,
 		   show_engine3_leds, store_engine3_leds);
-static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
 
 static struct attribute *lp5523_attributes[] = {
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch

