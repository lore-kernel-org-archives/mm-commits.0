From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch added to -mm tree
Date: Mon, 14 Mar 2011 15:16:59 -0700
Message-ID: <201103142217.p2EMGxVr014169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab1CNWSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 18:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5521.c: world-writable sysfs engine* files
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch

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
drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch
drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch
drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch
drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch
drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file.patch

