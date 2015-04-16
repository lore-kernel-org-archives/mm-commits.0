From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:48 -0700
Message-ID: <552fe8e0.5ys2439hsAVCIRKj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbbDPQrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.strogin@partner.samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mingo@elte.hu, mpn@google.com, rostedt@goodmis.org, stefan.strogin@gmail.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add trace events for CMA allocations and freeings
has been removed from the -mm tree.  Its filename was
     mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stefan Strogin <s.strogin@partner.samsung.com>
Subject: mm: cma: add trace events for CMA allocations and freeings

Add trace events for cma_alloc() and cma_release().

The cma_alloc tracepoint is used both for successful and failed allocations,
in case of allocation failure pfn=-1UL is stored and printed.

Signed-off-by: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mpn@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |   66 +++++++++++++++++++++++++++++++++++
 mm/cma.c                   |    5 ++
 2 files changed, 71 insertions(+)

diff -puN /dev/null include/trace/events/cma.h
--- /dev/null
+++ a/include/trace/events/cma.h
@@ -0,0 +1,66 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cma
+
+#if !defined(_TRACE_CMA_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CMA_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(cma_alloc,
+
+	TP_PROTO(unsigned long pfn, const struct page *page,
+		 unsigned int count, unsigned int align),
+
+	TP_ARGS(pfn, page, count, align),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(const struct page *, page)
+		__field(unsigned int, count)
+		__field(unsigned int, align)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->page = page;
+		__entry->count = count;
+		__entry->align = align;
+	),
+
+	TP_printk("pfn=%lx page=%p count=%u align=%u",
+		  __entry->pfn,
+		  __entry->page,
+		  __entry->count,
+		  __entry->align)
+);
+
+TRACE_EVENT(cma_release,
+
+	TP_PROTO(unsigned long pfn, const struct page *page,
+		 unsigned int count),
+
+	TP_ARGS(pfn, page, count),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(const struct page *, page)
+		__field(unsigned int, count)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->page = page;
+		__entry->count = count;
+	),
+
+	TP_printk("pfn=%lx page=%p count=%u",
+		  __entry->pfn,
+		  __entry->page,
+		  __entry->count)
+);
+
+#endif /* _TRACE_CMA_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/cma.c~mm-cma-add-trace-events-for-cma-allocations-and-freeings mm/cma.c
--- a/mm/cma.c~mm-cma-add-trace-events-for-cma-allocations-and-freeings
+++ a/mm/cma.c
@@ -23,6 +23,7 @@
 #  define DEBUG
 #endif
 #endif
+#define CREATE_TRACE_POINTS
 
 #include <linux/memblock.h>
 #include <linux/err.h>
@@ -34,6 +35,7 @@
 #include <linux/cma.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <trace/events/cma.h>
 
 #include "cma.h"
 
@@ -414,6 +416,8 @@ struct page *cma_alloc(struct cma *cma,
 		start = bitmap_no + mask + 1;
 	}
 
+	trace_cma_alloc(page ? pfn : -1UL, page, count, align);
+
 	pr_debug("%s(): returned %p\n", __func__, page);
 	return page;
 }
@@ -446,6 +450,7 @@ bool cma_release(struct cma *cma, const
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, pfn, count);
+	trace_cma_release(pfn, pages, count);
 
 	return true;
 }
_

Patches currently in -mm which might be from s.strogin@partner.samsung.com are

origin.patch

