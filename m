From: akpm@linux-foundation.org
Subject: - w1-new-driver-ds2431-chip-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:58:52 -0700
Message-ID: <200810152358.m9FNwq95024656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbYJOX7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bernhard.weirich@riedel.net, bgardner@wabtec.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1-new-driver-ds2431-chip-fix
has been removed from the -mm tree.  Its filename was
     w1-new-driver-ds2431-chip-fix.patch

This patch was dropped because it was folded into w1-new-driver-ds2431-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-new-driver-ds2431-chip-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ben Gardner <bgardner@wabtec.com>
Cc: Bernhard Weirich <bernhard.weirich@riedel.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2431.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2431.c~w1-new-driver-ds2431-chip-fix drivers/w1/slaves/w1_ds2431.c
--- a/drivers/w1/slaves/w1_ds2431.c~w1-new-driver-ds2431-chip-fix
+++ a/drivers/w1/slaves/w1_ds2431.c
@@ -1,5 +1,5 @@
 /*
- *	w1_DS2431.c - w1 family 2d (DS2431) driver
+ * w1_ds2431.c - w1 family 2d (DS2431) driver
  *
  * Copyright (c) 2008 Bernhard Weirich <bernhard.weirich@riedel.net>
  *
@@ -41,7 +41,7 @@
 #define W1_F2D_READ_RETRIES		10
 #define W1_F2D_READ_MAXLEN		8
 
-/**
+/*
  * Check the file size bounds and adjusts count as needed.
  * This would not be needed if the file size didn't reset to 0 after a write.
  */
@@ -56,7 +56,7 @@ static inline size_t w1_f2d_fix_count(lo
 	return count;
 }
 
-/**
+/*
  * Read a block from W1 ROM two times and compares the results.
  * If they are equal they are returned, otherwise the read
  * is repeated W1_F2D_READ_RETRIES times.
@@ -88,8 +88,6 @@ static int w1_f2d_readblock(struct w1_sl
 
 		if (!memcmp(cmp, buf, count))
 			return 0;
-
-
 	} while (--tries);
 
 	dev_err(&sl->dev, "proof reading failed %d times\n",
@@ -98,7 +96,6 @@ static int w1_f2d_readblock(struct w1_sl
 	return -1;
 }
 
-
 static ssize_t w1_f2d_read_bin(struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
@@ -134,7 +131,7 @@ static ssize_t w1_f2d_read_bin(struct ko
 	return count;
 }
 
-/**
+/*
  * Writes to the scratchpad and reads it back for verification.
  * Then copies the scratchpad to EEPROM.
  * The data must be aligned at W1_F2D_SCRATCH_SIZE bytes and
@@ -279,10 +276,7 @@ static struct bin_attribute w1_f2d_bin_a
 
 static int w1_f2d_add_slave(struct w1_slave *sl)
 {
-	int err;
-	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f2d_bin_attr);
-
-	return err;
+	return sysfs_create_bin_file(&sl->dev.kobj, &w1_f2d_bin_attr);
 }
 
 static void w1_f2d_remove_slave(struct w1_slave *sl)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

