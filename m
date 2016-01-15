From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:42 -0800
Message-ID: <5699738a.TYGxjcuoZ1ZGpOfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbcAOWcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: add new tracepoint, test_pages_isolated
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/page_isolation.c: add new tracepoint, test_pages_isolated

cma allocation should be guranteeded to succeed.  But sometimes it can
fail in the current implementation.  To track down the problem, we need to
know which page is problematic and this new tracepoint will report it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/page_isolation.h |   38 ++++++++++++++++++++++++
 mm/page_isolation.c                   |    5 +++
 2 files changed, 43 insertions(+)

diff -puN /dev/null include/trace/events/page_isolation.h
--- /dev/null
+++ a/include/trace/events/page_isolation.h
@@ -0,0 +1,38 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM page_isolation
+
+#if !defined(_TRACE_PAGE_ISOLATION_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PAGE_ISOLATION_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(test_pages_isolated,
+
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long fin_pfn),
+
+	TP_ARGS(start_pfn, end_pfn, fin_pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start_pfn)
+		__field(unsigned long, end_pfn)
+		__field(unsigned long, fin_pfn)
+	),
+
+	TP_fast_assign(
+		__entry->start_pfn = start_pfn;
+		__entry->end_pfn = end_pfn;
+		__entry->fin_pfn = fin_pfn;
+	),
+
+	TP_printk("start_pfn=0x%lx end_pfn=0x%lx fin_pfn=0x%lx ret=%s",
+		__entry->start_pfn, __entry->end_pfn, __entry->fin_pfn,
+		__entry->end_pfn == __entry->fin_pfn ? "success" : "fail")
+);
+
+#endif /* _TRACE_PAGE_ISOLATION_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/page_isolation.c~mm-page_isolation-add-new-tracepoint-test_pages_isolated mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-add-new-tracepoint-test_pages_isolated
+++ a/mm/page_isolation.c
@@ -9,6 +9,9 @@
 #include <linux/hugetlb.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/page_isolation.h>
+
 static int set_migratetype_isolate(struct page *page,
 				bool skip_hwpoisoned_pages)
 {
@@ -268,6 +271,8 @@ int test_pages_isolated(unsigned long st
 						skip_hwpoisoned_pages);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
+	trace_test_pages_isolated(start_pfn, end_pfn, pfn);
+
 	return pfn < end_pfn ? -EBUSY : 0;
 }
 
_

Patches currently in -mm which might be from js1304@gmail.com are


