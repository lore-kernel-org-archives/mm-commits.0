From: akpm@linux-foundation.org
Subject: [merged] loop-cleanup-partitions-when-detaching-loop-device.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:34 -0700
Message-ID: <20130325194534.B5C6831C1B3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35530 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3CYTpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:35 -0400
Received: by mail-qa0-f74.google.com with SMTP id k4so436676qaq.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: psusi@ubuntu.com, akpm@linux-foundation.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: loop: cleanup partitions when detaching loop device
has been removed from the -mm tree.  Its filename was
     loop-cleanup-partitions-when-detaching-loop-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Phillip Susi <psusi@ubuntu.com>
Subject: loop: cleanup partitions when detaching loop device

Any partitions added by user space to the loop device were being left in
place after detaching the loop device.  This was because the detach path
issued a BLKRRPART to clean up partitions if LO_FLAGS_PARTSCAN was set,
meaning that the partitions were auto scanned on attach.  Replace this
BLKRRPART with code that unconditionally cleans up partitions on detach
instead.

The user-visible effect of this bug is that the partition devnodes still
show up after detaching the backing file, and I think the partitions
remained in place after attaching a new file even though it had different
or no partitions at all.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
Cc: Jens Axboe <axboe@kernel.dk>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#32: FILE: drivers/block/loop.c:1051:
+	if (bdev)
+	{

WARNING: line over 80 characters
#39: FILE: drivers/block/loop.c:1058:
+		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);

total: 1 errors, 1 warnings, 26 lines checked

./patches/loop-cleanup-partitions-when-detaching-loop-device.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Phillip Susi <psusi@ubuntu.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: loop-cleanup-partitions-when-detaching-loop-device-fix

add comment, per Phillip

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Phillip Susi <psusi@ubuntu.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: loop-cleanup-partitions-when-detaching-loop-device-fix-fix

export delete_partition() to modules

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Phillip Susi <psusi@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partition-generic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device drivers/block/loop.c
diff -puN block/partition-generic.c~loop-cleanup-partitions-when-detaching-loop-device block/partition-generic.c
--- a/block/partition-generic.c~loop-cleanup-partitions-when-detaching-loop-device
+++ a/block/partition-generic.c
@@ -236,6 +236,7 @@ void __delete_partition(struct hd_struct
 {
 	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
 }
+EXPORT_SYMBOL(delete_partition);
 
 void delete_partition(struct gendisk *disk, int partno)
 {
_

Patches currently in -mm which might be from psusi@ubuntu.com are

linux-next.patch

