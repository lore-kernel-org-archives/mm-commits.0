From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch added to -mm tree
Date: Thu, 10 Jul 2014 15:55:25 -0700
Message-ID: <53bf19dd.gAob4erL+60rg+Ex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:37733 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaGJWz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 18:55:26 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so76845pde.0
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 15:55:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered
has been added to the -mm tree.  Its filename is
     mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch

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
Subject: mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered

The purpose of numa_zonelist_order=zone is to preserve lower zones for use
with 32-bit devices.  If locality is preferred then the
numa_zonelist_order=node policy should be used.  Unfortunately, the fair
zone allocation policy overrides this by skipping zones on remote nodes
until the lower one is found.  While this makes sense from a page aging
and performance perspective, it breaks the expected zonelist policy.  This
patch restores the expected behaviour for zone-list ordering.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered
+++ a/mm/page_alloc.c
@@ -1965,7 +1965,7 @@ zonelist_scan:
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
-				continue;
+				break;
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
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

