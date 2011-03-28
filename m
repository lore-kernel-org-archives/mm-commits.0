From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 28 Mar 2011 13:39:43 -0700
Message-ID: <201103282039.p2SKd56v027595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab1C1Ujg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 16:39:36 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p2SKd56o016931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2011 13:39:05 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_bitmap.c |    4 ----
 drivers/mtd/Kconfig              |    3 ---
 drivers/mtd/mtd_blkdevs.c        |    6 ------
 3 files changed, 13 deletions(-)

diff -puN drivers/block/drbd/drbd_bitmap.c~linux-next-git-rejects drivers/block/drbd/drbd_bitmap.c
--- a/drivers/block/drbd/drbd_bitmap.c~linux-next-git-rejects
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -28,10 +28,6 @@
 #include <linux/drbd.h>
 #include <linux/slab.h>
 #include <asm/kmap_types.h>
-<<<<<<< HEAD
-
-=======
->>>>>>> FETCH_HEAD
 #include "drbd_int.h"
 
 
diff -puN drivers/mtd/Kconfig~linux-next-git-rejects drivers/mtd/Kconfig
--- a/drivers/mtd/Kconfig~linux-next-git-rejects
+++ a/drivers/mtd/Kconfig
@@ -325,7 +325,6 @@ config MTD_OOPS
 	  To use, add console=ttyMTDx to the kernel command line,
 	  where x is the MTD device number to use.
 
-<<<<<<< HEAD
 config MTD_SWAP
 	tristate "Swap on MTD device support"
 	depends on MTD && SWAP
@@ -336,8 +335,6 @@ config MTD_SWAP
 	  The driver provides wear leveling by storing erase counter into the
 	  OOB.
 
-=======
->>>>>>> FETCH_HEAD
 source "drivers/mtd/chips/Kconfig"
 
 source "drivers/mtd/maps/Kconfig"
diff -puN drivers/mtd/mtd_blkdevs.c~linux-next-git-rejects drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~linux-next-git-rejects
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -119,7 +119,6 @@ static int do_blktrans_request(struct mt
 	}
 }
 
-<<<<<<< HEAD
 int mtd_blktrans_cease_background(struct mtd_blktrans_dev *dev)
 {
 	if (kthread_should_stop())
@@ -129,8 +128,6 @@ int mtd_blktrans_cease_background(struct
 }
 EXPORT_SYMBOL_GPL(mtd_blktrans_cease_background);
 
-=======
->>>>>>> FETCH_HEAD
 static int mtd_blktrans_thread(void *arg)
 {
 	struct mtd_blktrans_dev *dev = arg;
@@ -144,7 +141,6 @@ static int mtd_blktrans_thread(void *arg
 
 		dev->bg_stop = false;
 		if (!req && !(req = blk_fetch_request(rq))) {
-<<<<<<< HEAD
 			if (tr->background && !background_done) {
 				spin_unlock_irq(rq->queue_lock);
 				mutex_lock(&dev->lock);
@@ -158,8 +154,6 @@ static int mtd_blktrans_thread(void *arg
 				background_done = !dev->bg_stop;
 				continue;
 			}
-=======
->>>>>>> FETCH_HEAD
 			set_current_state(TASK_INTERRUPTIBLE);
 
 			if (kthread_should_stop())
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

