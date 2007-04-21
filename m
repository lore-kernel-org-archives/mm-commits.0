From: akpm@linux-foundation.org
Subject: + mm-per-device-dirty-threshold.patch added to -mm tree
Date: Sat, 21 Apr 2007 02:55:15 -0700
Message-ID: <200704210955.l3L9tFi9003706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbXDUJzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 05:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: per device dirty threshold
has been added to the -mm tree.  Its filename is
     mm-per-device-dirty-threshold.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: per device dirty threshold
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Scale writeback cache per backing device, proportional to its writeout speed.

By decoupling the BDI dirty thresholds a number of problems we currently have
will go away, namely:

 - mutual interference starvation (for any number of BDIs);
 - deadlocks with stacked BDIs (loop, FUSE and local NFS mounts).

It might be that all dirty pages are for a single BDI while other BDIs are
idling.  By giving each BDI a 'fair' share of the dirty limit, each one can
have dirty pages outstanding and make progress.

A global threshold also creates a deadlock for stacked BDIs; when A writes to
B, and A generates enough dirty pages to get throttled, B will never start
writeback until the dirty pages go away.  Again, by giving each BDI its own
'independent' dirty limit, this problem is avoided.

So the problem is to determine how to distribute the total dirty limit across
the BDIs fairly and efficiently.  A DBI that has a large dirty limit but does
not have any dirty pages outstanding is a waste.

What is done is to keep a floating proportion between the DBIs based on
writeback completions.  This way faster/more active devices get a larger share
than slower/idle devices.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |   51 +++++++++
 mm/backing-dev.c            |    3 
 mm/page-writeback.c         |  181 ++++++++++++++++++++++++++++------
 3 files changed, 206 insertions(+), 29 deletions(-)

diff -puN include/linux/backing-dev.h~mm-per-device-dirty-threshold include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-per-device-dirty-threshold
+++ a/include/linux/backing-dev.h
@@ -28,6 +28,7 @@ typedef int (congested_fn)(void *, int);
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
 	BDI_WRITEBACK,
+	BDI_WRITEOUT,
 	NR_BDI_STAT_ITEMS
 };
 
@@ -41,6 +42,13 @@ struct backing_dev_info {
 	void *unplug_io_data;
 
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
+
+	/*
+	 * data used for scaling the writeback cache
+	 */
+	spinlock_t lock;	/* protect the cycle count */
+	unsigned long cycles;	/* writeout cycles */
+	int dirty_exceeded;
 };
 
 void bdi_init(struct backing_dev_info *bdi);
@@ -52,6 +60,12 @@ static inline void __mod_bdi_stat(struct
 	percpu_counter_mod(&bdi->bdi_stat[item], amount);
 }
 
+static inline void __mod_bdi_stat64(struct backing_dev_info *bdi,
+		enum bdi_stat_item item, s64 amount)
+{
+	percpu_counter_mod64(&bdi->bdi_stat[item], amount);
+}
+
 static inline void __inc_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item)
 {
@@ -84,12 +98,49 @@ static inline void dec_bdi_stat(struct b
 	local_irq_restore(flags);
 }
 
+static inline s64 __bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	return percpu_counter_read(&bdi->bdi_stat[item]);
+}
+
 static inline s64 bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item)
 {
 	return percpu_counter_read_positive(&bdi->bdi_stat[item]);
 }
 
+static inline s64 __bdi_stat_sum(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	return percpu_counter_sum(&bdi->bdi_stat[item]);
+}
+
+static inline s64 bdi_stat_sum(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	s64 sum;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	sum = __bdi_stat_sum(bdi, item);
+	local_irq_restore(flags);
+
+	return sum;
+}
+
+/*
+ * maximal error of a stat counter.
+ */
+static inline unsigned long bdi_stat_delta(void)
+{
+#ifdef CONFIG_SMP
+	return NR_CPUS * FBC_BATCH;
+#else
+	return 1UL;
+#endif
+}
+
 /*
  * Flags in backing_dev_info::capability
  * - The first two flags control whether dirty pages will contribute to the
diff -puN mm/backing-dev.c~mm-per-device-dirty-threshold mm/backing-dev.c
--- a/mm/backing-dev.c~mm-per-device-dirty-threshold
+++ a/mm/backing-dev.c
@@ -12,6 +12,9 @@ void bdi_init(struct backing_dev_info *b
 	if (!(bdi_cap_writeback_dirty(bdi) || bdi_cap_account_dirty(bdi)))
 		return;
 
+	spin_lock_init(&bdi->lock);
+	bdi->cycles = 0;
+	bdi->dirty_exceeded = 0;
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_init(&bdi->bdi_stat[i], 0);
 }
diff -puN mm/page-writeback.c~mm-per-device-dirty-threshold mm/page-writeback.c
--- a/mm/page-writeback.c~mm-per-device-dirty-threshold
+++ a/mm/page-writeback.c
@@ -49,8 +49,6 @@
  */
 static long ratelimit_pages = 32;
 
-static int dirty_exceeded __cacheline_aligned_in_smp;	/* Dirty mem may be over limit */
-
 /*
  * When balance_dirty_pages decides that the caller needs to perform some
  * non-background writeback, this is how many pages it will attempt to write.
@@ -103,6 +101,88 @@ EXPORT_SYMBOL(laptop_mode);
 static void background_writeout(unsigned long _min_pages);
 
 /*
+ * Scale the writeback cache size proportional to the relative writeout speeds.
+ *
+ * We do this by tracking a floating average per BDI and a global floating
+ * average. We optimize away the '/= 2' for the global average by noting that:
+ *
+ *  if (++i > thresh) i /= 2:
+ *
+ * Can be approximated by:
+ *
+ *   thresh/2 + (++i % thresh/2)
+ *
+ * Furthermore, when we choose thresh to be 2^n it can be written in terms of
+ * binary operations and wraparound artifacts disappear.
+ *
+ * Also note that this yields a natural counter of the elapsed periods:
+ *
+ *   i / thresh
+ *
+ * Its monotonous increasing property can be applied to mitigate the wrap-
+ * around issue.
+ */
+static int vm_cycle_shift __read_mostly;
+static struct percpu_counter vm_writeout_total;
+
+/*
+ * Sync up the per BDI average to the global cycle.
+ */
+static void bdi_writeout_norm(struct backing_dev_info *bdi)
+{
+	int bits = vm_cycle_shift;
+	unsigned long cycle = 1UL << bits;
+	unsigned long mask = ~(cycle - 1);
+	unsigned long global_cycle = percpu_counter_read(&vm_writeout_total);
+	unsigned long flags;
+
+	global_cycle <<= 1;
+	global_cycle &= mask;
+
+	if ((bdi->cycles & mask) == global_cycle)
+		return;
+
+	spin_lock_irqsave(&bdi->lock, flags);
+	bdi->cycles &= mask;
+	while (bdi->cycles != global_cycle) {
+		unsigned long val = __bdi_stat(bdi, BDI_WRITEOUT);
+		unsigned long half = (val + 1) >> 1;
+
+		if (!val)
+			break;
+
+		__mod_bdi_stat64(bdi, BDI_WRITEOUT, -half);
+		bdi->cycles += cycle;
+	}
+	bdi->cycles = global_cycle;
+	spin_unlock_irqrestore(&bdi->lock, flags);
+}
+
+static void __bdi_writeout_inc(struct backing_dev_info *bdi)
+{
+	bdi_writeout_norm(bdi);
+
+	__inc_bdi_stat(bdi, BDI_WRITEOUT);
+	percpu_counter_mod(&vm_writeout_total, 1);
+}
+
+void get_writeout_scale(struct backing_dev_info *bdi, long *scale, long *div)
+{
+	int bits = vm_cycle_shift - 1;
+	unsigned long cycle = 1UL << bits;
+	unsigned long mask = cycle - 1;
+	unsigned long total = percpu_counter_read(&vm_writeout_total);
+
+	if (bdi_cap_writeback_dirty(bdi)) {
+		bdi_writeout_norm(bdi);
+		*scale = bdi_stat(bdi, BDI_WRITEOUT);
+	} else
+		*scale = 0;
+
+	*div = cycle + (total & mask);
+}
+
+/*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
  *
@@ -158,8 +238,8 @@ static unsigned long determine_dirtyable
 }
 
 static void
-get_dirty_limits(long *pbackground, long *pdirty,
-					struct address_space *mapping)
+get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi)
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
@@ -193,6 +273,30 @@ get_dirty_limits(long *pbackground, long
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+
+	if (bdi) {
+		long long tmp = dirty;
+		long reserve;
+		long scale, div;
+
+		get_writeout_scale(bdi, &scale, &div);
+
+		tmp *= scale;
+		do_div(tmp, div);
+
+		reserve = dirty -
+			(global_page_state(NR_FILE_DIRTY) +
+			 global_page_state(NR_WRITEBACK) +
+			 global_page_state(NR_UNSTABLE_NFS));
+
+		if (reserve < 0)
+			reserve = 0;
+
+		reserve += bdi_stat(bdi, BDI_RECLAIMABLE) +
+			bdi_stat(bdi, BDI_WRITEBACK);
+
+		*pbdi_dirty = min((long)tmp, reserve);
+	}
 }
 
 /*
@@ -204,9 +308,11 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long nr_reclaimable;
+	long bdi_nr_reclaimable;
+	long bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
+	long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
 
@@ -221,15 +327,15 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		get_dirty_limits(&background_thresh, &dirty_thresh, mapping);
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
-			dirty_thresh)
+		get_dirty_limits(&background_thresh, &dirty_thresh,
+				&bdi_thresh, bdi);
+		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 				break;
 
-		if (!dirty_exceeded)
-			dirty_exceeded = 1;
+		if (!bdi->dirty_exceeded)
+			bdi->dirty_exceeded = 1;
 
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
@@ -237,16 +343,27 @@ static void balance_dirty_pages(struct a
 		 * written to the server's write cache, but has not yet
 		 * been flushed to permanent storage.
 		 */
-		if (nr_reclaimable) {
+		if (bdi_nr_reclaimable) {
 			writeback_inodes(&wbc);
-			get_dirty_limits(&background_thresh,
-					 	&dirty_thresh, mapping);
-			nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-			if (nr_reclaimable +
-				global_page_state(NR_WRITEBACK)
-					<= dirty_thresh)
-						break;
+
+			get_dirty_limits(&background_thresh, &dirty_thresh,
+				       &bdi_thresh, bdi);
+
+			if (bdi_thresh < 2*bdi_stat_delta()) {
+				bdi_nr_reclaimable =
+					bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+				bdi_nr_writeback =
+					bdi_stat_sum(bdi, BDI_WRITEBACK);
+			} else {
+				bdi_nr_reclaimable =
+					bdi_stat(bdi, BDI_RECLAIMABLE);
+				bdi_nr_writeback =
+					bdi_stat(bdi, BDI_WRITEBACK);
+			}
+
+			if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+				break;
+
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
@@ -254,9 +371,9 @@ static void balance_dirty_pages(struct a
 		congestion_wait(WRITE, HZ/10);
 	}
 
-	if (nr_reclaimable + global_page_state(NR_WRITEBACK)
-		<= dirty_thresh && dirty_exceeded)
-			dirty_exceeded = 0;
+	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
+			bdi->dirty_exceeded)
+		bdi->dirty_exceeded = 0;
 
 	if (writeback_in_progress(bdi))
 		return;		/* pdflush is already working this queue */
@@ -270,7 +387,9 @@ static void balance_dirty_pages(struct a
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-	     (!laptop_mode && (nr_reclaimable > background_thresh)))
+			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
+					  + global_page_state(NR_UNSTABLE_NFS)
+					  > background_thresh)))
 		pdflush_operation(background_writeout, 0);
 }
 
@@ -306,7 +425,7 @@ void balance_dirty_pages_ratelimited_nr(
 	unsigned long *p;
 
 	ratelimit = ratelimit_pages;
-	if (dirty_exceeded)
+	if (mapping->backing_dev_info->dirty_exceeded)
 		ratelimit = 8;
 
 	/*
@@ -342,7 +461,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	}
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
@@ -377,7 +496,7 @@ static void background_writeout(unsigned
 		long background_thresh;
 		long dirty_thresh;
 
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
@@ -585,6 +704,8 @@ void __init page_writeback_init(void)
 	mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
+	vm_cycle_shift = 1 + ilog2(vm_total_pages);
+	percpu_counter_init(&vm_writeout_total, 0);
 }
 
 /**
@@ -988,8 +1109,10 @@ int test_clear_page_writeback(struct pag
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
-			if (bdi_cap_writeback_dirty(bdi))
+			if (bdi_cap_writeback_dirty(bdi)) {
 				__dec_bdi_stat(bdi, BDI_WRITEBACK);
+				__bdi_writeout_inc(bdi);
+			}
 		}
 		write_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
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
