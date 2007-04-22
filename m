From: akpm@linux-foundation.org
Subject: - mm-expose-bdi-statistics-in-sysfs.patch removed from -mm tree
Date: Sun, 22 Apr 2007 12:02:19 -0700
Message-ID: <200704221902.l3MJ2JkH032081@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965679AbXDVTCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 15:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: expose BDI statistics in sysfs.
has been removed from the -mm tree.  Its filename was
     mm-expose-bdi-statistics-in-sysfs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: expose BDI statistics in sysfs.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Expose the per BDI stats in /sys/block/<dev>/queue/*

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN block/ll_rw_blk.c~mm-expose-bdi-statistics-in-sysfs block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~mm-expose-bdi-statistics-in-sysfs
+++ a/block/ll_rw_blk.c
@@ -3923,6 +3923,15 @@ static ssize_t queue_max_hw_sectors_show
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nr_reclaimable_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lld\n", bdi_stat(&q->backing_dev_info, BDI_RECLAIMABLE));
+}
+
+static ssize_t queue_nr_writeback_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lld\n", bdi_stat(&q->backing_dev_info, BDI_WRITEBACK));
+}
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -3947,6 +3956,16 @@ static struct queue_sysfs_entry queue_ma
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_reclaimable_entry = {
+	.attr = {.name = "reclaimable_pages", .mode = S_IRUGO },
+	.show = queue_nr_reclaimable_show,
+};
+
+static struct queue_sysfs_entry queue_writeback_entry = {
+	.attr = {.name = "writeback_pages", .mode = S_IRUGO },
+	.show = queue_nr_writeback_show,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -3958,6 +3977,8 @@ static struct attribute *default_attrs[]
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
+	&queue_reclaimable_entry.attr,
+	&queue_writeback_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
mm-optimize-kill_bdev.patch
mm-optimize-kill_bdev-fix.patch
mm-optimize-acorn-partition-truncate.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
exec-fix-remove_arg_zero-add-comment.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
mm-expose-bdi-statistics-in-sysfs.patch
mm-expose-bdi-statistics-in-sysfs-printk-fixes.patch
mm-per-device-dirty-threshold.patch
