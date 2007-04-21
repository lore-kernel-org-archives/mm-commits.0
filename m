From: akpm@linux-foundation.org
Subject: + lib-dampen-the-percpu_counter-fbc_batch.patch added to -mm tree
Date: Sat, 21 Apr 2007 02:55:03 -0700
Message-ID: <200704210955.l3L9t3tH003679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932658AbXDUJzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 05:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lib: dampen the percpu_counter FBC_BATCH
has been added to the -mm tree.  Its filename is
     lib-dampen-the-percpu_counter-fbc_batch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: dampen the percpu_counter FBC_BATCH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

With the current logic the percpu_counter's accuracy delta is quadric wrt the
number of cpus in the system, reduce this to O(n ln n).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/percpu_counter.h~lib-dampen-the-percpu_counter-fbc_batch include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-dampen-the-percpu_counter-fbc_batch
+++ a/include/linux/percpu_counter.h
@@ -11,6 +11,7 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
+#include <linux/log2.h>
 
 #ifdef CONFIG_SMP
 
@@ -20,11 +21,7 @@ struct percpu_counter {
 	s32 *counters;
 };
 
-#if NR_CPUS >= 16
-#define FBC_BATCH	(NR_CPUS*2)
-#else
-#define FBC_BATCH	(NR_CPUS*4)
-#endif
+#define FBC_BATCH	(8*ilog2(NR_CPUS))
 
 static inline void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
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
