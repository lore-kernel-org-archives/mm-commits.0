From: akpm@linux-foundation.org
Subject: + mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch
 added to -mm tree
Date: Wed, 01 Apr 2015 13:02:21 -0700
Message-ID: <551c4ecd.WTbCmqpGgSd57jh1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbbDAUCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 16:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.strogin@partner.samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mingo@elte.hu, mpn@google.com, rostedt@goodmis.org, stefan.strogin@gmail.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add trace events for CMA allocations and freeings
has been added to the -mm tree.  Its filename is
     mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/trace/events/cma.h |   63 +++++++++++++++++++++++++++++++++++
 mm/cma.c                   |    5 ++
 2 files changed, 68 insertions(+)

diff -puN /dev/null include/trace/events/cma.h
--- /dev/null
+++ a/include/trace/events/cma.h
@@ -0,0 +1,63 @@
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
 
+	trace_cma_alloc(page ? pfn : -1UL, page, count);
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

mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch

