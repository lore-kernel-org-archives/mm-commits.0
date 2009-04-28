From: akpm@linux-foundation.org
Subject: + mm-fix-committed_as-underfolow-on-large-nr_cpus-environment.patch added to -mm tree
Date: Tue, 28 Apr 2009 12:57:38 -0700
Message-ID: <200904281957.n3SJvcKv005163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbZD1UDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm: fix Committed_AS underfolow on large NR_CPUS environment
has been added to the -mm tree.  Its filename is
     mm-fix-committed_as-underfolow-on-large-nr_cpus-environment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix Committed_AS underfolow on large NR_CPUS environment
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The Committed_AS field can underflow in certain situations:

>         # while true; do cat /proc/meminfo  | grep _AS; sleep 1; done | uniq -c
>               1 Committed_AS: 18446744073709323392 kB
>              11 Committed_AS: 18446744073709455488 kB
>               6 Committed_AS:    35136 kB
>               5 Committed_AS: 18446744073709454400 kB
>               7 Committed_AS:    35904 kB
>               3 Committed_AS: 18446744073709453248 kB
>               2 Committed_AS:    34752 kB
>               9 Committed_AS: 18446744073709453248 kB
>               8 Committed_AS:    34752 kB
>               3 Committed_AS: 18446744073709320960 kB
>               7 Committed_AS: 18446744073709454080 kB
>               3 Committed_AS: 18446744073709320960 kB
>               5 Committed_AS: 18446744073709454080 kB
>               6 Committed_AS: 18446744073709320960 kB

Because NR_CPUS can be greater than 1000 and meminfo_proc_show() does
not check for underflow.

But NR_CPUS proportional isn't good calculation.  In general,
possibility of lock contention is proportional to the number of online
cpus, not theorical maximum cpus (NR_CPUS).

The current kernel has generic percpu-counter stuff.  using it is right
way.  it makes code simplify and percpu_counter_read_positive() don't
make underflow issue.

Reported-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>		[All kernel versions]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c    |    2 -
 include/linux/mman.h |    9 ++------
 mm/mmap.c            |   12 +++++-----
 mm/nommu.c           |   13 ++++++-----
 mm/swap.c            |   46 -----------------------------------------
 5 files changed, 17 insertions(+), 65 deletions(-)

diff -puN fs/proc/meminfo.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment
+++ a/fs/proc/meminfo.c
@@ -35,7 +35,7 @@ static int meminfo_proc_show(struct seq_
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	si_meminfo(&i);
 	si_swapinfo(&i);
-	committed = atomic_long_read(&vm_committed_space);
+	committed = percpu_counter_read_positive(&vm_committed_as);
 	allowed = ((totalram_pages - hugetlb_total_pages())
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
diff -puN include/linux/mman.h~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment include/linux/mman.h
--- a/include/linux/mman.h~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment
+++ a/include/linux/mman.h
@@ -12,21 +12,18 @@
 
 #ifdef __KERNEL__
 #include <linux/mm.h>
+#include <linux/percpu_counter.h>
 
 #include <asm/atomic.h>
 
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern atomic_long_t vm_committed_space;
+extern struct percpu_counter vm_committed_as;
 
-#ifdef CONFIG_SMP
-extern void vm_acct_memory(long pages);
-#else
 static inline void vm_acct_memory(long pages)
 {
-	atomic_long_add(pages, &vm_committed_space);
+	percpu_counter_add(&vm_committed_as, pages);
 }
-#endif
 
 static inline void vm_unacct_memory(long pages)
 {
diff -puN mm/mmap.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment mm/mmap.c
--- a/mm/mmap.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment
+++ a/mm/mmap.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
+struct percpu_counter vm_committed_as;
 
 /*
  * Check that a process has enough memory to allocate a new virtual
@@ -179,11 +179,7 @@ int __vm_enough_memory(struct mm_struct 
 	if (mm)
 		allowed -= mm->total_vm / 32;
 
-	/*
-	 * cast `allowed' as a signed long because vm_committed_space
-	 * sometimes has a negative value
-	 */
-	if (atomic_long_read(&vm_committed_space) < (long)allowed)
+	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
 	vm_unacct_memory(pages);
@@ -2481,4 +2477,8 @@ void mm_drop_all_locks(struct mm_struct 
  */
 void __init mmap_init(void)
 {
+	int ret;
+
+	ret = percpu_counter_init(&vm_committed_as, 0);
+	VM_BUG_ON(ret);
 }
diff -puN mm/nommu.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment mm/nommu.c
--- a/mm/nommu.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment
+++ a/mm/nommu.c
@@ -62,7 +62,7 @@ void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
-atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
+struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
@@ -463,6 +463,10 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
  */
 void __init mmap_init(void)
 {
+	int ret;
+
+	ret = percpu_counter_init(&vm_committed_as, 0);
+	VM_BUG_ON(ret);
 	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
 }
 
@@ -1847,12 +1851,9 @@ int __vm_enough_memory(struct mm_struct 
 	if (mm)
 		allowed -= mm->total_vm / 32;
 
-	/*
-	 * cast `allowed' as a signed long because vm_committed_space
-	 * sometimes has a negative value
-	 */
-	if (atomic_long_read(&vm_committed_space) < (long)allowed)
+	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
+
 error:
 	vm_unacct_memory(pages);
 
diff -puN mm/swap.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment mm/swap.c
--- a/mm/swap.c~mm-fix-committed_as-underfolow-on-large-nr_cpus-environment
+++ a/mm/swap.c
@@ -491,49 +491,6 @@ unsigned pagevec_lookup_tag(struct pagev
 
 EXPORT_SYMBOL(pagevec_lookup_tag);
 
-#ifdef CONFIG_SMP
-/*
- * We tolerate a little inaccuracy to avoid ping-ponging the counter between
- * CPUs
- */
-#define ACCT_THRESHOLD	max(16, NR_CPUS * 2)
-
-static DEFINE_PER_CPU(long, committed_space);
-
-void vm_acct_memory(long pages)
-{
-	long *local;
-
-	preempt_disable();
-	local = &__get_cpu_var(committed_space);
-	*local += pages;
-	if (*local > ACCT_THRESHOLD || *local < -ACCT_THRESHOLD) {
-		atomic_long_add(*local, &vm_committed_space);
-		*local = 0;
-	}
-	preempt_enable();
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* Drop the CPU's cached committed space back into the central pool. */
-static int cpu_swap_callback(struct notifier_block *nfb,
-			     unsigned long action,
-			     void *hcpu)
-{
-	long *committed;
-
-	committed = &per_cpu(committed_space, (long)hcpu);
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		atomic_long_add(*committed, &vm_committed_space);
-		*committed = 0;
-		drain_cpu_pagevecs((long)hcpu);
-	}
-	return NOTIFY_OK;
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-#endif /* CONFIG_SMP */
-
 /*
  * Perform any setup for the swap system
  */
@@ -554,7 +511,4 @@ void __init swap_setup(void)
 	 * Right now other parts of the system means that we
 	 * _really_ don't want to cluster much more
 	 */
-#ifdef CONFIG_HOTPLUG_CPU
-	hotcpu_notifier(cpu_swap_callback, 0);
-#endif
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_shrink_usage.patch
mm-fix-committed_as-underfolow-on-large-nr_cpus-environment.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-add-file-based-rss-accounting.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

