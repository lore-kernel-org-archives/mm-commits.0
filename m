From: akpm@linux-foundation.org
Subject: + mm-add-extra-free-kbytes-tunable.patch added to -mm tree
Date: Thu, 01 Sep 2011 15:03:13 -0700
Message-ID: <201109012203.p81M3Dpf031847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab1IAWEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2011 18:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com


The patch titled
     mm: add extra free kbytes tunable
has been added to the -mm tree.  Its filename is
     mm-add-extra-free-kbytes-tunable.patch

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
Subject: mm: add extra free kbytes tunable
From: Rik van Riel <riel@redhat.com>

Add a userspace visible knob to tell the VM to keep an extra amount of
memory free, by increasing the gap between each zone's min and low
watermarks.

This is useful for realtime applications that call system calls and have a
bound on the number of allocations that happen in any short time period. 
In this application, extra_free_kbytes would be left at an amount equal to
or larger than than the maximum number of allocations that happen in any
burst.

It may also be useful to reduce the memory use of virtual machines
(temporarily?), in a way that does not cause memory fragmentation like
ballooning does.

Signed-off-by: Rik van Riel<riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   16 ++++++++++++++++
 kernel/sysctl.c             |    9 +++++++++
 mm/page_alloc.c             |   32 +++++++++++++++++++++++++-------
 3 files changed, 50 insertions(+), 7 deletions(-)

diff -puN Documentation/sysctl/vm.txt~add-extra-free-kbytes-tunable Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~add-extra-free-kbytes-tunable
+++ a/Documentation/sysctl/vm.txt
@@ -28,6 +28,7 @@ Currently, these files are in /proc/sys/
 - dirty_writeback_centisecs
 - drop_caches
 - extfrag_threshold
+- extra_free_kbytes
 - hugepages_treat_as_movable
 - hugetlb_shm_group
 - laptop_mode
@@ -168,6 +169,21 @@ fragmentation index is <= extfrag_thresh
 
 ==============================================================
 
+extra_free_kbytes
+
+This parameter tells the VM to keep extra free memory between the threshold
+where background reclaim (kswapd) kicks in, and the threshold where direct
+reclaim (by allocating processes) kicks in.
+
+This is useful for workloads that require low latency memory allocations
+and have a bounded burstiness in memory allocations, for example a
+realtime application that receives and transmits network traffic
+(causing in-kernel memory allocations) with a maximum total message burst
+size of 200MB may need 200MB of extra free memory to avoid direct reclaim
+related latencies.
+
+==============================================================
+
 hugepages_treat_as_movable
 
 This parameter is only useful when kernelcore= is specified at boot time to
diff -puN kernel/sysctl.c~add-extra-free-kbytes-tunable kernel/sysctl.c
--- a/kernel/sysctl.c~add-extra-free-kbytes-tunable
+++ a/kernel/sysctl.c
@@ -96,6 +96,7 @@ extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
+extern int extra_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
@@ -1189,6 +1190,14 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 	{
+		.procname	= "extra_free_kbytes",
+		.data		= &extra_free_kbytes,
+		.maxlen		= sizeof(extra_free_kbytes),
+		.mode		= 0644,
+		.proc_handler	= min_free_kbytes_sysctl_handler,
+		.extra1		= &zero,
+	},
+	{
 		.procname	= "percpu_pagelist_fraction",
 		.data		= &percpu_pagelist_fraction,
 		.maxlen		= sizeof(percpu_pagelist_fraction),
diff -puN mm/page_alloc.c~add-extra-free-kbytes-tunable mm/page_alloc.c
--- a/mm/page_alloc.c~add-extra-free-kbytes-tunable
+++ a/mm/page_alloc.c
@@ -175,8 +175,20 @@ static char * const zone_names[MAX_NR_ZO
 	 "Movable",
 };
 
+/*
+ * Try to keep at least this much lowmem free.  Do not allow normal
+ * allocations below this point, only high priority ones. Automatically
+ * tuned according to the amount of memory in the system.
+ */
 int min_free_kbytes = 1024;
 
+/*
+ * Extra memory for the system to try freeing. Used to temporarily
+ * free memory, to make space for new workloads. Anyone can allocate
+ * down to the min watermarks controlled by min_free_kbytes above.
+ */
+int extra_free_kbytes = 0;
+
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
 static unsigned long __meminitdata dma_reserve;
@@ -5142,6 +5154,7 @@ static void setup_per_zone_lowmem_reserv
 void setup_per_zone_wmarks(void)
 {
 	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
+	unsigned long pages_low = extra_free_kbytes >> (PAGE_SHIFT - 10);
 	unsigned long lowmem_pages = 0;
 	struct zone *zone;
 	unsigned long flags;
@@ -5153,11 +5166,14 @@ void setup_per_zone_wmarks(void)
 	}
 
 	for_each_zone(zone) {
-		u64 tmp;
+		u64 min, low;
 
 		spin_lock_irqsave(&zone->lock, flags);
-		tmp = (u64)pages_min * zone->present_pages;
-		do_div(tmp, lowmem_pages);
+		min = (u64)pages_min * zone->present_pages;
+		do_div(min, lowmem_pages);
+		low = (u64)pages_low * zone->present_pages;
+		do_div(low, vm_total_pages);
+
 		if (is_highmem(zone)) {
 			/*
 			 * __GFP_HIGH and PF_MEMALLOC allocations usually don't
@@ -5181,11 +5197,13 @@ void setup_per_zone_wmarks(void)
 			 * If it's a lowmem zone, reserve a number of pages
 			 * proportionate to the zone's size.
 			 */
-			zone->watermark[WMARK_MIN] = tmp;
+			zone->watermark[WMARK_MIN] = min;
 		}
 
-		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
-		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
+		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) +
+					low + (min >> 2);
+		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) +
+					low + (min >> 1);
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -5283,7 +5301,7 @@ module_init(init_per_zone_wmark_min)
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
  *	that we can call two helper functions whenever min_free_kbytes
- *	changes.
+ *	or extra_free_kbytes changes.
  */
 int min_free_kbytes_sysctl_handler(ctl_table *table, int write, 
 	void __user *buffer, size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-add-extra-free-kbytes-tunable.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch

