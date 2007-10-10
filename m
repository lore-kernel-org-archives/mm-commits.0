From: akpm@linux-foundation.org
Subject: - lockstat-documentation.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:09:58 -0700
Message-ID: <200710102109.l9AL9wGT025818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757238AbXJJVKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     lockstat: documentation
has been removed from the -mm tree.  Its filename was
     lockstat-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockstat: documentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide some documentation for CONFIG_LOCK_STAT.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lockstat.txt |  120 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug          |    2 
 2 files changed, 122 insertions(+)

diff -puN /dev/null Documentation/lockstat.txt
--- /dev/null
+++ a/Documentation/lockstat.txt
@@ -0,0 +1,120 @@
+
+LOCK STATISTICS
+
+- WHAT
+
+As the name suggests, it provides statistics on locks.
+
+- WHY
+
+Because things like lock contention can severely impact performance.
+
+- HOW
+
+Lockdep already has hooks in the lock functions and maps lock instances to
+lock classes. We build on that. The graph below shows the relation between
+the lock functions and the various hooks therein.
+
+        __acquire
+            |
+           lock _____
+            |        \
+            |    __contended
+            |         |
+            |       <wait>
+            | _______/
+            |/
+            |
+       __acquired
+            |
+            .
+          <hold>
+            .
+            |
+       __release
+            |
+         unlock
+
+lock, unlock	- the regular lock functions
+__*		- the hooks
+<> 		- states
+
+With these hooks we provide the following statistics:
+
+ con-bounces       - number of lock contention that involved x-cpu data
+ contentions       - number of lock acquisitions that had to wait
+ wait time min     - shortest (non-0) time we ever had to wait for a lock
+           max     - longest time we ever had to wait for a lock
+           total   - total time we spend waiting on this lock
+ acq-bounces       - number of lock acquisitions that involved x-cpu data
+ acquisitions      - number of times we took the lock
+ hold time min     - shortest (non-0) time we ever held the lock
+           max     - longest time we ever held the lock
+           total   - total time this lock was held
+
+From these number various other statistics can be derived, such as:
+
+ hold time average = hold time total / acquisitions
+
+These numbers are gathered per lock class, per read/write state (when
+applicable).
+
+It also tracks 4 contention points per class. A contention point is a call site
+that had to wait on lock acquisition.
+
+ - USAGE
+
+Look at the current lock statistics:
+
+( line numbers not part of actual output, done for clarity in the explanation
+  below )
+
+# less /proc/lock_stat
+
+01 lock_stat version 0.2
+02 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+03                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
+04 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+05
+06               &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
+07               &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
+08               --------------------------
+09                 &inode->i_data.tree_lock              0          [<ffffffff8027c08f>] add_to_page_cache+0x5f/0x190
+10
+11 ...............................................................................................................................................................................................
+12
+13                              dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
+14                              -----------
+15                              dcache_lock            180          [<ffffffff802c0d7e>] sys_getcwd+0x11e/0x230
+16                              dcache_lock            165          [<ffffffff802c002a>] d_alloc+0x15a/0x210
+17                              dcache_lock             33          [<ffffffff8035818d>] _atomic_dec_and_lock+0x4d/0x70
+18                              dcache_lock              1          [<ffffffff802beef8>] shrink_dcache_parent+0x18/0x130
+
+This excerpt shows the first two lock class statistics. Line 01 shows the
+output version - each time the format changes this will be updated. Line 02-04
+show the header with column descriptions. Lines 05-10 and 13-18 show the actual
+statistics. These statistics come in two parts; the actual stats separated by a
+short separator (line 08, 14) from the contention points.
+
+The first lock (05-10) is a read/write lock, and shows two lines above the
+short separator. The contention points don't match the column descriptors,
+they have two: contentions and [<IP>] symbol.
+
+
+View the top contending locks:
+
+# grep : /proc/lock_stat | head
+              &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
+              &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
+                             dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
+                         &inode->i_mutex:           161            286 18446744073709       62882.54     1244614.55           3653          20598 18446744073709       62318.60     1693822.74
+                         &zone->lru_lock:            94             94           0.53           7.33          92.10           4366          32690           0.29          59.81       16350.06
+              &inode->i_data.i_mmap_lock:            79             79           0.40           3.77          53.03          11779          87755           0.28         116.93       29898.44
+                        &q->__queue_lock:            48             50           0.52          31.62          86.31            774          13131           0.17         113.08       12277.52
+                        &rq->rq_lock_key:            43             47           0.74          68.50         170.63           3706          33929           0.22         107.99       17460.62
+                      &rq->rq_lock_key#2:            39             46           0.75           6.68          49.03           2979          32292           0.17         125.17       17137.63
+                         tasklist_lock-W:            15             15           1.45          10.87          32.70           1201           7390           0.58          62.55       13648.47
+
+Clear the statistics:
+
+# echo 0 > /proc/lock_stat
diff -puN lib/Kconfig.debug~lockstat-documentation lib/Kconfig.debug
--- a/lib/Kconfig.debug~lockstat-documentation
+++ a/lib/Kconfig.debug
@@ -294,6 +294,8 @@ config LOCK_STAT
 	help
 	 This feature enables tracking lock contention points
 
+	 For more details, see Documentation/lockstat.txt
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

git-sched.patch
radix-tree-use-indirect-bit.patch
nfs-remove-congestion_end.patch
lib-percpu_counter_add.patch
lib-percpu_counter_sub.patch
lib-percpu_counter-variable-batch.patch
lib-make-percpu_counter_add-take-s64.patch
lib-percpu_counter_set.patch
lib-percpu_counter_sum_positive.patch
lib-percpu_count_sum.patch
lib-percpu_counter_init-error-handling.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
lib-floating-proportions.patch
mm-per-device-dirty-threshold.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-per-device-dirty-threshold-fix.patch
mm-dirty-balancing-for-tasks.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
lockdep-give-each-filesystem-its-own-inode-lock-class.patch
lockdep-annotate-kprobes-irq-fiddling.patch
lockdep-annotate-kprobes-irq-fiddling-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
