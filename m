From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-page_alloc-fix-setting-of-zone_fair_depleted-on-up.patch removed from
 -mm tree
Date: Tue, 09 Sep 2014 12:47:06 -0700
Message-ID: <540f593a.BBDKGGabDs9WRBk+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaIITrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2014 15:47:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix setting of ZONE_FAIR_DEPLETED on UP
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-setting-of-zone_fair_depleted-on-up.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm/page_alloc.c: fix setting of ZONE_FAIR_DEPLETED on UP

Commit 4ffeaf3560a52b4a69 ("mm: page_alloc: reduce cost of the fair zone
allocation policy") broke the fair zone allocation policy on UP with these
hunks:

: diff --git a/mm/page_alloc.c b/mm/page_alloc.c
: index 6e5e8f7..fb99081 100644
: --- a/mm/page_alloc.c
: +++ b/mm/page_alloc.c
: @@ -1612,6 +1612,9 @@ again:
:         }
: 
:         __mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
: +       if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&
: +           !zone_is_fair_depleted(zone))
: +               zone_set_flag(zone, ZONE_FAIR_DEPLETED);
: 
:         __count_zone_vm_events(PGALLOC, zone, 1 << order);
:         zone_statistics(preferred_zone, zone, gfp_flags);
: @@ -1966,8 +1985,10 @@ zonelist_scan:
:                 if (alloc_flags & ALLOC_FAIR) {
:                         if (!zone_local(preferred_zone, zone))
:                                 break;
: -                       if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
: +                       if (zone_is_fair_depleted(zone)) {
: +                               nr_fair_skipped++;
:                                 continue;
: +                       }
:                 }

The problem is that a <= check was replaced with a ==.  On SMP it doesn't
matter because negative values are returned as zero due to per-CPU drift
which is not possible in the UP case.  Vlastimil Babka correctly pointed
out that this can be negative due to high-order allocations.  This patch
fixes the problem.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-setting-of-zone_fair_depleted-on-up mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-setting-of-zone_fair_depleted-on-up
+++ a/mm/page_alloc.c
@@ -1612,7 +1612,7 @@ again:
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
-	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&
+	if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0 &&
 	    !zone_is_fair_depleted(zone))
 		zone_set_flag(zone, ZONE_FAIR_DEPLETED);
 
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
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

