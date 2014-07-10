From: akpm@linux-foundation.org
Subject: + mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
 added to -mm tree
Date: Thu, 10 Jul 2014 15:55:24 -0700
Message-ID: <53bf19dc.f3p4j8Px41whOgG4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:42597 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaGJWzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 18:55:25 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so75548pab.3
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 15:55:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: only update per-cpu thresholds for online CPU
has been added to the -mm tree.  Its filename is
     mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: only update per-cpu thresholds for online CPU

When kswapd is awake reclaiming, the per-cpu stat thresholds are lowered
to get more accurate counts to avoid breaching watermarks.  This threshold
update iterates over all possible CPUs which is unnecessary.  Only online
CPUs need to be updated.  If a new CPU is onlined,
refresh_zone_stat_thresholds() will set the thresholds correctly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu mm/vmstat.c
--- a/mm/vmstat.c~mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu
+++ a/mm/vmstat.c
@@ -200,7 +200,7 @@ void set_pgdat_percpu_threshold(pg_data_
 			continue;
 
 		threshold = (*calculate_pressure)(zone);
-		for_each_possible_cpu(cpu)
+		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mem-hotplug-improve-zone_movable_is_highmem-logic.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

