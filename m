From: akpm@linux-foundation.org
Subject: [merged] mm-break-out-page-allocation-warning-code.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:14 -0700
Message-ID: <201105252027.p4PKRbGG014593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932590Ab1EYUt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mina86@mina86.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: break out page allocation warning code
has been removed from the -mm tree.  Its filename was
     mm-break-out-page-allocation-warning-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: break out page allocation warning code
From: Dave Hansen <dave@linux.vnet.ibm.com>

This originally started as a simple patch to give vmalloc() some more
verbose output on failure on top of the plain page allocator messages. 
Johannes suggested that it might be nicer to lead with the vmalloc() info
_before_ the page allocator messages.

But, I do think there's a lot of value in what __alloc_pages_slowpath()
does with its filtering and so forth.

This patch creates a new function which other allocators can call instead
of relying on the internal page allocator warnings.  It also gives this
function private rate-limiting which separates it from other
printk_ratelimit() users.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 mm/page_alloc.c    |   62 ++++++++++++++++++++++++++++---------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~mm-break-out-page-allocation-warning-code include/linux/mm.h
--- a/include/linux/mm.h~mm-break-out-page-allocation-warning-code
+++ a/include/linux/mm.h
@@ -1387,6 +1387,8 @@ extern void si_meminfo(struct sysinfo * 
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
 
+extern void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
+
 extern void setup_per_cpu_pageset(void);
 
 extern void zone_pcp_update(struct zone *zone);
diff -puN mm/page_alloc.c~mm-break-out-page-allocation-warning-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-break-out-page-allocation-warning-code
+++ a/mm/page_alloc.c
@@ -30,6 +30,7 @@
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 #include <linux/oom.h>
 #include <linux/notifier.h>
 #include <linux/topology.h>
@@ -1736,6 +1737,45 @@ static inline bool should_suppress_show_
 	return ret;
 }
 
+static DEFINE_RATELIMIT_STATE(nopage_rs,
+		DEFAULT_RATELIMIT_INTERVAL,
+		DEFAULT_RATELIMIT_BURST);
+
+void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
+{
+	va_list args;
+	unsigned int filter = SHOW_MEM_FILTER_NODES;
+
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
+		return;
+
+	/*
+	 * This documents exceptions given to allocations in certain
+	 * contexts that are allowed to allocate outside current's set
+	 * of allowed nodes.
+	 */
+	if (!(gfp_mask & __GFP_NOMEMALLOC))
+		if (test_thread_flag(TIF_MEMDIE) ||
+		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
+			filter &= ~SHOW_MEM_FILTER_NODES;
+	if (in_interrupt() || !(gfp_mask & __GFP_WAIT))
+		filter &= ~SHOW_MEM_FILTER_NODES;
+
+	if (fmt) {
+		printk(KERN_WARNING);
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+	}
+
+	pr_warning("%s: page allocation failure: order:%d, mode:0x%x\n",
+		   current->comm, order, gfp_mask);
+
+	dump_stack();
+	if (!should_suppress_show_mem())
+		show_mem(filter);
+}
+
 static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 				unsigned long pages_reclaimed)
@@ -2178,27 +2218,7 @@ rebalance:
 	}
 
 nopage:
-	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
-		unsigned int filter = SHOW_MEM_FILTER_NODES;
-
-		/*
-		 * This documents exceptions given to allocations in certain
-		 * contexts that are allowed to allocate outside current's set
-		 * of allowed nodes.
-		 */
-		if (!(gfp_mask & __GFP_NOMEMALLOC))
-			if (test_thread_flag(TIF_MEMDIE) ||
-			    (current->flags & (PF_MEMALLOC | PF_EXITING)))
-				filter &= ~SHOW_MEM_FILTER_NODES;
-		if (in_interrupt() || !wait)
-			filter &= ~SHOW_MEM_FILTER_NODES;
