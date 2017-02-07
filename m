From: akpm@linux-foundation.org
Subject: [failures]
 mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch removed from -mm tree
Date: Tue, 07 Feb 2017 14:14:39 -0800
Message-ID: <589a46cf.jh2ggj8YoAc1qFsQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754757AbdBGWUw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 17:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject:  mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix

there is no need to have both pcpu_drain and pcpu_drain_mutex visible
outside of drain_all_pages. This might just attract abuse.

Link: http://lkml.kernel.org/r/20170207202755.24571-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix
+++ a/mm/page_alloc.c
@@ -92,10 +92,6 @@ EXPORT_PER_CPU_SYMBOL(_numa_mem_);
 int _node_numa_mem_[MAX_NUMNODES];
 #endif
 
-/* work_structs for global per-cpu drains */
-DEFINE_MUTEX(pcpu_drain_mutex);
-DEFINE_PER_CPU(struct work_struct, pcpu_drain);
-
 #ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
 volatile unsigned long latent_entropy __latent_entropy;
 EXPORT_SYMBOL(latent_entropy);
@@ -2364,6 +2360,8 @@ static void drain_local_pages_wq(struct
  */
 void drain_all_pages(struct zone *zone)
 {
+	static DEFINE_PER_CPU(struct work_struct, pcpu_drain);
+	static DEFINE_MUTEX(pcpu_drain_mutex);
 	int cpu;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context-fix.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

