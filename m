From: akpm@linux-foundation.org
Subject: + mm-page_alloc-warn_alloc-print-nodemask.patch added to -mm tree
Date: Tue, 17 Jan 2017 14:34:54 -0800
Message-ID: <587e9c0e.asEvNPvGnHlhaBrq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdAQWna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 17:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: warn_alloc print nodemask
has been added to the -mm tree.  Its filename is
     mm-page_alloc-warn_alloc-print-nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-warn_alloc-print-nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-warn_alloc-print-nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: warn_alloc print nodemask

warn_alloc is currently used for to report an allocation failure or an
allocation stall.  We print some details of the allocation request like
the gfp mask and the request order.  We do not print the allocation
nodemask which is important when debugging the reason for the allocation
failure as well.  We alreaddy print the nodemask in the OOM report.

Add nodemask to warn_alloc and print it in warn_alloc as well.

Link: http://lkml.kernel.org/r/20170117091543.25850-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 mm/page_alloc.c    |   10 ++++++----
 mm/vmalloc.c       |    4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/mm.h~mm-page_alloc-warn_alloc-print-nodemask include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-warn_alloc-print-nodemask
+++ a/include/linux/mm.h
@@ -1938,8 +1938,8 @@ extern void si_meminfo_node(struct sysin
 extern unsigned long arch_reserved_kernel_pages(void);
 #endif
 
-extern __printf(2, 3)
-void warn_alloc(gfp_t gfp_mask, const char *fmt, ...);
+extern __printf(3, 4)
+void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff -puN mm/page_alloc.c~mm-page_alloc-warn_alloc-print-nodemask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-warn_alloc-print-nodemask
+++ a/mm/page_alloc.c
@@ -3092,12 +3092,13 @@ static void warn_alloc_show_mem(gfp_t gf
 	show_mem(filter);
 }
 
-void warn_alloc(gfp_t gfp_mask, const char *fmt, ...)
+void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
+	nodemask_t *nm = (nodemask) ? nodemask : &cpuset_current_mems_allowed;
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
 	    debug_guardpage_minorder() > 0)
@@ -3111,7 +3112,8 @@ void warn_alloc(gfp_t gfp_mask, const ch
 	pr_cont("%pV", &vaf);
 	va_end(args);
 
-	pr_cont(", mode:%#x(%pGg)\n", gfp_mask, &gfp_mask);
+	pr_cont(", mode:%#x(%pGg), nodemask=%*pbl\n", gfp_mask, &gfp_mask, nodemask_pr_args(nm));
+	cpuset_print_current_mems_allowed();
 
 	dump_stack();
 	warn_alloc_show_mem(gfp_mask);
@@ -3770,7 +3772,7 @@ retry:
 
 	/* Make sure we know about allocations which stall for too long */
 	if (time_after(jiffies, alloc_start + stall_timeout)) {
-		warn_alloc(gfp_mask,
+		warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation stalls for %ums, order:%u",
 			jiffies_to_msecs(jiffies-alloc_start), order);
 		stall_timeout += 10 * HZ;
@@ -3804,7 +3806,7 @@ retry:
 	}
 
 nopage:
-	warn_alloc(gfp_mask,
+	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
 	return page;
diff -puN mm/vmalloc.c~mm-page_alloc-warn_alloc-print-nodemask mm/vmalloc.c
--- a/mm/vmalloc.c~mm-page_alloc-warn_alloc-print-nodemask
+++ a/mm/vmalloc.c
@@ -1662,7 +1662,7 @@ static void *__vmalloc_area_node(struct
 	return area->addr;
 
 fail:
-	warn_alloc(gfp_mask,
+	warn_alloc(gfp_mask, NULL,
 			  "vmalloc: allocation failure, allocated %ld of %ld bytes",
 			  (area->nr_pages*PAGE_SIZE), area->size);
 	vfree(area->addr);
@@ -1724,7 +1724,7 @@ void *__vmalloc_node_range(unsigned long
 	return addr;
 
 fail:
-	warn_alloc(gfp_mask,
+	warn_alloc(gfp_mask, NULL,
 			  "vmalloc: allocation failure: %lu bytes", real_size);
 	return NULL;
 }
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

