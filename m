From: akpm@linux-foundation.org
Subject: [patch 101/127] mm: consolidate warn_alloc_failed users
Date: Fri, 07 Oct 2016 17:01:55 -0700
Message-ID: <57f83773.Nl88TnuqEOtUy3Gw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754756AbcJHAB4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: consolidate warn_alloc_failed users

warn_alloc_failed is currently used from the page and vmalloc allocators. 
This is a good reuse of the code except that vmalloc would appreciate a
slightly different warning message.  This is already handled by the fmt
parameter except that

"%s: page allocation failure: order:%u, mode:%#x(%pGg)"

is printed anyway.  This might be quite misleading because it might be a
vmalloc failure which leads to the warning while the page allocator is not
the culprit here.  Fix this by always using the fmt string and only print
the context that makes sense for the particular context (e.g.  order makes
only very little sense for the vmalloc context).  Rename the function to
not miss any user and also because a later patch will reuse it also for
!failure cases.

Link: http://lkml.kernel.org/r/20160929084407.7004-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 ++---
 mm/page_alloc.c    |   27 ++++++++++++---------------
 mm/vmalloc.c       |   14 ++++++--------
 3 files changed, 20 insertions(+), 26 deletions(-)

diff -puN include/linux/mm.h~mm-consolidate-warn_alloc_failed-users include/linux/mm.h
--- a/include/linux/mm.h~mm-consolidate-warn_alloc_failed-users
+++ a/include/linux/mm.h
@@ -1916,9 +1916,8 @@ extern void si_meminfo_node(struct sysin
 extern unsigned long arch_reserved_kernel_pages(void);
 #endif
 
-extern __printf(3, 4)
-void warn_alloc_failed(gfp_t gfp_mask, unsigned int order,
-		const char *fmt, ...);
+extern __printf(2, 3)
+void warn_alloc(gfp_t gfp_mask, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff -puN mm/page_alloc.c~mm-consolidate-warn_alloc_failed-users mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consolidate-warn_alloc_failed-users
+++ a/mm/page_alloc.c
@@ -2979,9 +2979,11 @@ static DEFINE_RATELIMIT_STATE(nopage_rs,
 		DEFAULT_RATELIMIT_INTERVAL,
 		DEFAULT_RATELIMIT_BURST);
 
-void warn_alloc_failed(gfp_t gfp_mask, unsigned int order, const char *fmt, ...)
+void warn_alloc(gfp_t gfp_mask, const char *fmt, ...)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
+	struct va_format vaf;
+	va_list args;
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
 	    debug_guardpage_minorder() > 0)
@@ -2999,22 +3001,16 @@ void warn_alloc_failed(gfp_t gfp_mask, u
 	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
-	if (fmt) {
-		struct va_format vaf;
-		va_list args;
+	pr_warn("%s: ", current->comm);
 
-		va_start(args, fmt);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_cont("%pV", &vaf);
+	va_end(args);
 
-		vaf.fmt = fmt;
-		vaf.va = &args;
+	pr_cont(", mode:%#x(%pGg)\n", gfp_mask, &gfp_mask);
 
-		pr_warn("%pV", &vaf);
-
-		va_end(args);
-	}
-
-	pr_warn("%s: page allocation failure: order:%u, mode:%#x(%pGg)\n",
-		current->comm, order, gfp_mask, &gfp_mask);
 	dump_stack();
 	if (!should_suppress_show_mem())
 		show_mem(filter);
@@ -3680,7 +3676,8 @@ retry:
 	}
 
 nopage:
-	warn_alloc_failed(gfp_mask, order, NULL);
+	warn_alloc(gfp_mask,
+			"page allocation failure: order:%u", order);
 got_pg:
 	return page;
 }
diff -puN mm/vmalloc.c~mm-consolidate-warn_alloc_failed-users mm/vmalloc.c
--- a/mm/vmalloc.c~mm-consolidate-warn_alloc_failed-users
+++ a/mm/vmalloc.c
@@ -1601,7 +1601,6 @@ static void *__vmalloc_node(unsigned lon
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node)
 {
-	const int order = 0;
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
@@ -1629,9 +1628,9 @@ static void *__vmalloc_area_node(struct
 		struct page *page;
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_pages(alloc_mask, order);
+			page = alloc_page(alloc_mask);
 		else
-			page = alloc_pages_node(node, alloc_mask, order);
+			page = alloc_pages_node(node, alloc_mask, 0);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
@@ -1648,8 +1647,8 @@ static void *__vmalloc_area_node(struct
 	return area->addr;
 
 fail:
-	warn_alloc_failed(gfp_mask, order,
-			  "vmalloc: allocation failure, allocated %ld of %ld bytes\n",
+	warn_alloc(gfp_mask,
+			  "vmalloc: allocation failure, allocated %ld of %ld bytes",
 			  (area->nr_pages*PAGE_SIZE), area->size);
 	vfree(area->addr);
 	return NULL;
@@ -1710,9 +1709,8 @@ void *__vmalloc_node_range(unsigned long
 	return addr;
 
 fail:
-	warn_alloc_failed(gfp_mask, 0,
-			  "vmalloc: allocation failure: %lu bytes\n",
-			  real_size);
+	warn_alloc(gfp_mask,
+			  "vmalloc: allocation failure: %lu bytes", real_size);
 	return NULL;
 }
 
_
