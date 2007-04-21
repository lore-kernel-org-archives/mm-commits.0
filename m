From: akpm@linux-foundation.org
Subject: + lib-percpu_counter_mod64.patch added to -mm tree
Date: Sat, 21 Apr 2007 02:55:04 -0700
Message-ID: <200704210955.l3L9t4L9003682@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500AbXDUJzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 05:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lib: percpu_counter_mod64
has been added to the -mm tree.  Its filename is
     lib-percpu_counter_mod64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: percpu_counter_mod64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Add percpu_counter_mod64() to allow large modifications.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    9 +++++++++
 lib/percpu_counter.c           |   28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN include/linux/percpu_counter.h~lib-percpu_counter_mod64 include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_mod64
+++ a/include/linux/percpu_counter.h
@@ -36,6 +36,7 @@ static inline void percpu_counter_destro
 }
 
 void percpu_counter_mod(struct percpu_counter *fbc, s32 amount);
+void percpu_counter_mod64(struct percpu_counter *fbc, s64 amount);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
@@ -81,6 +82,14 @@ percpu_counter_mod(struct percpu_counter
 	preempt_enable();
 }
 
+static inline void
+percpu_counter_mod64(struct percpu_counter *fbc, s64 amount)
+{
+	preempt_disable();
+	fbc->count += amount;
+	preempt_enable();
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
diff -puN lib/percpu_counter.c~lib-percpu_counter_mod64 lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter_mod64
+++ a/lib/percpu_counter.c
@@ -25,6 +25,34 @@ void percpu_counter_mod(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_mod);
 
+void percpu_counter_mod64(struct percpu_counter *fbc, s64 amount)
+{
+	long count;
+	s32 *pcount;
+	int cpu;
+
+	if (amount >= FBC_BATCH || amount <= -FBC_BATCH) {
+		spin_lock(&fbc->lock);
+		fbc->count += amount;
+		spin_unlock(&fbc->lock);
+		return;
+	}
+
+	cpu = get_cpu();
+	pcount = per_cpu_ptr(fbc->counters, cpu);
+	count = *pcount + amount;
+	if (count >= FBC_BATCH || count <= -FBC_BATCH) {
+		spin_lock(&fbc->lock);
+		fbc->count += count;
+		*pcount = 0;
+		spin_unlock(&fbc->lock);
+	} else {
+		*pcount = count;
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(percpu_counter_mod64);
+
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
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
