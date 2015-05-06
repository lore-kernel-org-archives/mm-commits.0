From: akpm@linux-foundation.org
Subject: [withdrawn] zram-close-race-by-open-overriding.patch removed from -mm tree
Date: Wed, 06 May 2015 12:52:30 -0700
Message-ID: <554a70fe.jM9WcExhUd0s6XaK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbEFTwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: close race by open overriding
has been removed from the -mm tree.  Its filename was
     zram-close-race-by-open-overriding.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: close race by open overriding

ba6b17d68c8e3aa8d ("zram: fix umount-reset_store-mount race condition")
introduced bdev->bd_mutex to protect a race between mount and reset.  At
that time, we don't have dynamic zram-add/remove feature so it was okay.

However, as we introduce dynamic device feature, bd_mutex became
trouble.

	CPU 0

echo 1 > /sys/block/zram<id>/reset
  -> kernfs->s_active(A)
    -> zram:reset_store->bd_mutex(B)

	CPU 1

echo <id> > /sys/class/zram/zram-remove
  ->zram:zram_remove: bd_mutex(B)
  -> sysfs_remove_group
    -> kernfs->s_active(A)

IOW, AB -> BA deadlock

The reason we are holding bd_mutex for zram_remove is to prevent
any incoming open /dev/zram[0-9]. Otherwise, we could remove zram
others already have opened. But it causes above deadlock problem.

To fix the problem, this patch overrides block_device.open and
it returns -EBUSY if zram asserts he claims zram to reset so any
incoming open will be failed so we don't need to hold bd_mutex
for zram_remove ayn more.

This patch is to prepare for zram-add/remove feature.

[sergey.senozhatsky@gmail.com: simplify reset_store()]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   53 ++++++++++++++++++++------------
 drivers/block/zram/zram_drv.h |    4 ++
 2 files changed, 38 insertions(+), 19 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-close-race-by-open-overriding drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-close-race-by-open-overriding
+++ a/drivers/block/zram/zram_drv.c
@@ -1068,45 +1068,60 @@ static ssize_t reset_store(struct device
 	struct zram *zram;
 	struct block_device *bdev;
 
+	ret = kstrtou16(buf, 10, &do_reset);
+	if (ret)
+		return ret;
+
+	if (!do_reset)
+		return -EINVAL;
+
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
-
 	if (!bdev)
 		return -ENOMEM;
 
 	mutex_lock(&bdev->bd_mutex);
-	/* Do not reset an active device! */
-	if (bdev->bd_openers) {
-		ret = -EBUSY;
-		goto out;
+	/* Do not reset an active device or claimed device */
+	if (bdev->bd_openers || zram->claim) {
+		mutex_unlock(&bdev->bd_mutex);
+		bdput(bdev);
+		return -EBUSY;
 	}
 
-	ret = kstrtou16(buf, 10, &do_reset);
-	if (ret)
-		goto out;
-
-	if (!do_reset) {
-		ret = -EINVAL;
-		goto out;
-	}
+	/* From now on, anyone can't open /dev/zram[0-9] */
+	zram->claim = true;
+	mutex_unlock(&bdev->bd_mutex);
 
-	/* Make sure all pending I/O is finished */
+	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-
-	mutex_unlock(&bdev->bd_mutex);
 	revalidate_disk(zram->disk);
 	bdput(bdev);
 
+	mutex_lock(&bdev->bd_mutex);
+	zram->claim = false;
+	mutex_unlock(&bdev->bd_mutex);
+
 	return len;
+}
+
+static int zram_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret = 0;
+	struct zram *zram;
+
+	WARN_ON(!mutex_is_locked(&bdev->bd_mutex));
+
+	zram = bdev->bd_disk->private_data;
+	/* zram was claimed to reset so open request fails */
+	if (zram->claim)
+		ret = -EBUSY;
 
-out:
-	mutex_unlock(&bdev->bd_mutex);
-	bdput(bdev);
 	return ret;
 }
 
 static const struct block_device_operations zram_devops = {
+	.open = zram_open,
 	.swap_slot_free_notify = zram_slot_free_notify,
 	.rw_page = zram_rw_page,
 	.owner = THIS_MODULE
diff -puN drivers/block/zram/zram_drv.h~zram-close-race-by-open-overriding drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-close-race-by-open-overriding
+++ a/drivers/block/zram/zram_drv.h
@@ -115,5 +115,9 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	char compressor[10];
+	/*
+	 * zram is claimed so open request will be failed
+	 */
+	bool claim; /* Protected by bdev->bd_mutex */
 };
 #endif
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-remove-obsolete-zram_debug-option.patch
zsmalloc-remove-obsolete-zsmalloc_debug.patch
zram-add-dynamic-device-add-remove-functionality.patch

