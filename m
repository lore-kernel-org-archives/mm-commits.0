From: akpm@linux-foundation.org
Subject: [patch 128/142] mm, page_alloc: warn_alloc print nodemask
Date: Wed, 22 Feb 2017 15:46:10 -0800
Message-ID: <58ae22c2.3kUn3m9CIzIL7GjR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbdBVXqL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz

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
@@ -1942,8 +1942,8 @@ extern void si_meminfo_node(struct sysin
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
@@ -3028,12 +3028,13 @@ static void warn_alloc_show_mem(gfp_t gf
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
@@ -3047,7 +3048,8 @@ void warn_alloc(gfp_t gfp_mask, const ch
 	pr_cont("%pV", &vaf);
 	va_end(args);
 
-	pr_cont(", mode:%#x(%pGg)\n", gfp_mask, &gfp_mask);
+	pr_cont(", mode:%#x(%pGg), nodemask=%*pbl\n", gfp_mask, &gfp_mask, nodemask_pr_args(nm));
+	cpuset_print_current_mems_allowed();
 
 	dump_stack();
 	warn_alloc_show_mem(gfp_mask);
@@ -3724,7 +3726,7 @@ retry:
 
 	/* Make sure we know about allocations which stall for too long */
 	if (time_after(jiffies, alloc_start + stall_timeout)) {
-		warn_alloc(gfp_mask,
+		warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation stalls for %ums, order:%u",
 			jiffies_to_msecs(jiffies-alloc_start), order);
 		stall_timeout += 10 * HZ;
@@ -3775,7 +3777,7 @@ nopage:
 	if (read_mems_allowed_retry(cpuset_mems_cookie))
 		goto retry_cpuset;
 
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
