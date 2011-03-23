From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:02 -0700
Message-ID: <201103232036.p2NKacus028145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWUkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: world-writable sysfs engine* files
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: world-writable sysfs engine* files
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to change LED settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files
+++ a/drivers/leds/leds-lp5521.c
@@ -534,7 +534,7 @@ static ssize_t lp5521_selftest(struct de
 }
 
 /* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
 
 static struct attribute *lp5521_led_attributes[] = {
@@ -548,15 +548,15 @@ static struct attribute_group lp5521_led
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
-static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
 
 static struct attribute *lp5521_attributes[] = {
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch

