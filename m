From: akpm@linux-foundation.org
Subject: [merged] block-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:15 -0800
Message-ID: <20130228201315.A474531C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55959 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3B1UNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:16 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245192yen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     block-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: block: convert to idr_alloc()

Convert to the much saner new idr interface.  Both bsg and genhd
protect idr w/ mutex making preloading unnecessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bsg.c   |   26 +++++++++-----------------
 block/genhd.c |   21 ++++++---------------
 2 files changed, 15 insertions(+), 32 deletions(-)

diff -puN block/bsg.c~block-convert-to-idr_alloc block/bsg.c
--- a/block/bsg.c~block-convert-to-idr_alloc
+++ a/block/bsg.c
@@ -997,7 +997,7 @@ int bsg_register_queue(struct request_qu
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
-	int ret, minor;
+	int ret;
 	struct device *class_dev = NULL;
 	const char *devname;
 
@@ -1017,23 +1017,16 @@ int bsg_register_queue(struct request_qu
 
 	mutex_lock(&bsg_mutex);
 
-	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
+	ret = idr_alloc(&bsg_minor_idr, bcd, 0, BSG_MAX_DEVS, GFP_KERNEL);
+	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			printk(KERN_ERR "bsg: too many bsg devices\n");
+			ret = -EINVAL;
+		}
 		goto unlock;
 	}
 
-	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
-	if (ret < 0)
-		goto unlock;
-
-	if (minor >= BSG_MAX_DEVS) {
-		printk(KERN_ERR "bsg: too many bsg devices\n");
-		ret = -EINVAL;
-		goto remove_idr;
-	}
-
-	bcd->minor = minor;
+	bcd->minor = ret;
 	bcd->queue = q;
 	bcd->parent = get_device(parent);
 	bcd->release = release;
@@ -1059,8 +1052,7 @@ unregister_class_dev:
 	device_unregister(class_dev);
 put_dev:
 	put_device(parent);
-remove_idr:
-	idr_remove(&bsg_minor_idr, minor);
+	idr_remove(&bsg_minor_idr, bcd->minor);
 unlock:
 	mutex_unlock(&bsg_mutex);
 	return ret;
diff -puN block/genhd.c~block-convert-to-idr_alloc block/genhd.c
--- a/block/genhd.c~block-convert-to-idr_alloc
+++ a/block/genhd.c
@@ -411,7 +411,7 @@ static int blk_mangle_minor(int minor)
 int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 {
 	struct gendisk *disk = part_to_disk(part);
-	int idx, rc;
+	int idx;
 
 	/* in consecutive minor range? */
 	if (part->partno < disk->minors) {
@@ -420,20 +420,11 @@ int blk_alloc_devt(struct hd_struct *par
 	}
 
 	/* allocate ext devt */
-	do {
-		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
-			return -ENOMEM;
-		mutex_lock(&ext_devt_mutex);
-		rc = idr_get_new(&ext_devt_idr, part, &idx);
-		if (!rc && idx >= NR_EXT_DEVT) {
-			idr_remove(&ext_devt_idr, idx);
-			rc = -EBUSY;
-		}
-		mutex_unlock(&ext_devt_mutex);
-	} while (rc == -EAGAIN);
-
-	if (rc)
-		return rc;
+	mutex_lock(&ext_devt_mutex);
+	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_KERNEL);
+	mutex_unlock(&ext_devt_mutex);
+	if (idx < 0)
+		return idx == -ENOSPC ? -EBUSY : idx;
 
 	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

