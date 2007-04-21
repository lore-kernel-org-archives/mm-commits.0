From: akpm@linux-foundation.org
Subject: + mm-scalable-bdi-statistics-counters.patch added to -mm tree
Date: Sat, 21 Apr 2007 02:55:08 -0700
Message-ID: <200704210955.l3L9t87Q003691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933069AbXDUJzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 05:55:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: scalable bdi statistics counters.
has been added to the -mm tree.  Its filename is
     mm-scalable-bdi-statistics-counters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: scalable bdi statistics counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide scalable per backing_dev_info statistics counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |   50 ++++++++++++++++++++++++++++++++--
 mm/backing-dev.c            |   26 +++++++++++++++++
 2 files changed, 74 insertions(+), 2 deletions(-)

diff -puN include/linux/backing-dev.h~mm-scalable-bdi-statistics-counters include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-scalable-bdi-statistics-counters
+++ a/include/linux/backing-dev.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_BACKING_DEV_H
 #define _LINUX_BACKING_DEV_H
 
+#include <linux/percpu_counter.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -24,6 +25,10 @@ enum bdi_state {
 
 typedef int (congested_fn)(void *, int);
 
+enum bdi_stat_item {
+	NR_BDI_STAT_ITEMS
+};
+
 struct backing_dev_info {
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
@@ -32,14 +37,55 @@ struct backing_dev_info {
 	void *congested_data;	/* Pointer to aux data for congested func */
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
+
+	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 };
 
-static inline void bdi_init(struct backing_dev_info *bdi)
+void bdi_init(struct backing_dev_info *bdi);
+void bdi_destroy(struct backing_dev_info *bdi);
+
+static inline void __mod_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item, s32 amount)
+{
+	percpu_counter_mod(&bdi->bdi_stat[item], amount);
+}
+
+static inline void __inc_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	__mod_bdi_stat(bdi, item, 1);
+}
+
+static inline void inc_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__inc_bdi_stat(bdi, item);
+	local_irq_restore(flags);
+}
+
+static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
 {
+	__mod_bdi_stat(bdi, item, -1);
+}
+
+static inline void dec_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__dec_bdi_stat(bdi, item);
+	local_irq_restore(flags);
 }
 
-static inline void bdi_destroy(struct backing_dev_info *bdi)
+static inline s64 bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
 {
+	return percpu_counter_read_positive(&bdi->bdi_stat[item]);
 }
 
 /*
diff -puN mm/backing-dev.c~mm-scalable-bdi-statistics-counters mm/backing-dev.c
--- a/mm/backing-dev.c~mm-scalable-bdi-statistics-counters
+++ a/mm/backing-dev.c
@@ -5,6 +5,30 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 
+void bdi_init(struct backing_dev_info *bdi)
+{
+	int i;
+
+	if (!(bdi_cap_writeback_dirty(bdi) || bdi_cap_account_dirty(bdi)))
+		return;
+
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
+		percpu_counter_init(&bdi->bdi_stat[i], 0);
+}
+EXPORT_SYMBOL(bdi_init);
+
+void bdi_destroy(struct backing_dev_info *bdi)
+{
+	int i;
+
+	if (!(bdi_cap_writeback_dirty(bdi) || bdi_cap_account_dirty(bdi)))
+		return;
+
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
+		percpu_counter_destroy(&bdi->bdi_stat[i]);
+}
+EXPORT_SYMBOL(bdi_destroy);
+
 static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
@@ -70,3 +94,5 @@ long congestion_wait_interruptible(int r
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait_interruptible);
+
+
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
nfs-remove-congestion_end.patch
lib-dampen-the-percpu_counter-fbc_batch.patch
lib-percpu_counter_mod64.patch
mm-bdi-init-hooks.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
mm-per-device-dirty-threshold.patch
