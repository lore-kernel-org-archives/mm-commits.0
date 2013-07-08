From: akpm@linux-foundation.org
Subject: [merged] block-do-not-pass-disk-names-as-format-strings.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:45 -0700
Message-ID: <51db11c1.4Q/KBgKO9gQ3HOlN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3GHTXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, keescook@chromium.org

Subject: [merged] block-do-not-pass-disk-names-as-format-strings.patch removed from -mm tree
To: keescook@chromium.org,axboe@kernel.dk,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:45 -0700


The patch titled
     Subject: block: do not pass disk names as format strings
has been removed from the -mm tree.  Its filename was
     block-do-not-pass-disk-names-as-format-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: block: do not pass disk names as format strings

Disk names may contain arbitrary strings, so they must not be interpreted
as format strings. It seems that only md allows arbitrary strings to be
used for disk names, but this could allow for a local memory corruption
from uid 0 into ring 0.

CVE-2013-2851

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c              |    2 +-
 drivers/block/nbd.c        |    3 ++-
 drivers/scsi/osd/osd_uld.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN block/genhd.c~block-do-not-pass-disk-names-as-format-strings block/genhd.c
--- a/block/genhd.c~block-do-not-pass-disk-names-as-format-strings
+++ a/block/genhd.c
@@ -512,7 +512,7 @@ static void register_disk(struct gendisk
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
diff -puN drivers/block/nbd.c~block-do-not-pass-disk-names-as-format-strings drivers/block/nbd.c
--- a/drivers/block/nbd.c~block-do-not-pass-disk-names-as-format-strings
+++ a/drivers/block/nbd.c
@@ -714,7 +714,8 @@ static int __nbd_ioctl(struct block_devi
 		else
 			blk_queue_flush(nbd->disk->queue, 0);
 
-		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
+		thread = kthread_create(nbd_thread, nbd, "%s",
+					nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
diff -puN drivers/scsi/osd/osd_uld.c~block-do-not-pass-disk-names-as-format-strings drivers/scsi/osd/osd_uld.c
--- a/drivers/scsi/osd/osd_uld.c~block-do-not-pass-disk-names-as-format-strings
+++ a/drivers/scsi/osd/osd_uld.c
@@ -485,7 +485,7 @@ static int osd_probe(struct device *dev)
 	oud->class_dev.class = &osd_uld_class;
 	oud->class_dev.parent = dev;
 	oud->class_dev.release = __remove;
-	error = dev_set_name(&oud->class_dev, disk->disk_name);
+	error = dev_set_name(&oud->class_dev, "%s", disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
 		goto err_put_cdev;
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
isdn-clean-up-debug-format-string-usage.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

