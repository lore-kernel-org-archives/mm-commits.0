From: akpm@linux-foundation.org
Subject: [nacked] mm-vmstat-regularize-up-and-smp-behavior.patch removed
 from -mm tree
Date: Wed, 10 Sep 2014 14:06:37 -0700
Message-ID: <5410bd5d.1TawaiYOZFawc6C9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaIJVGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 17:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, leon@leon.nu, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: regularize UP and SMP behavior
has been removed from the -mm tree.  Its filename was
     mm-vmstat-regularize-up-and-smp-behavior.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmstat: regularize UP and SMP behavior

zone_page_state and friends are an API hazard because of the difference in
behaviour between SMP and UP is very surprising.  There is a good reason
to allow NR_ALLOC_BATCH to go negative -- when the counter is reset the
negative value takes recent activity into account.  NR_ALLOC_BATCH callers
that matter access the raw counter but the API hazard is a lesson.

This patch makes zone_page_state, global_page_state and
zone_page_state_snapshot return the same values on SMP and UP as saving
the branches on UP is unlikely to make a measurable performance
difference.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Leon Romanovsky <leon@leon.nu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-regularize-up-and-smp-behavior include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-regularize-up-and-smp-behavior
+++ a/include/linux/vmstat.h
@@ -120,10 +120,8 @@ static inline void zone_page_state_add(l
 static inline unsigned long global_page_state(enum zone_stat_item item)
 {
 	long x = atomic_long_read(&vm_stat[item]);
-#ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
-#endif
 	return x;
 }
 
@@ -131,10 +129,8 @@ static inline unsigned long zone_page_st
 					enum zone_stat_item item)
 {
 	long x = atomic_long_read(&zone->vm_stat[item]);
-#ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
-#endif
 	return x;
 }
 
@@ -153,10 +149,10 @@ static inline unsigned long zone_page_st
 	int cpu;
 	for_each_online_cpu(cpu)
 		x += per_cpu_ptr(zone->pageset, cpu)->vm_stat_diff[item];
-
+#endif
 	if (x < 0)
 		x = 0;
-#endif
+
 	return x;
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-fix-zone-allocation-fairness-on-up.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
mm-clean-up-zone-flags.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

