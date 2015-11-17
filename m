From: akpm@linux-foundation.org
Subject: + mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 14:42:52 -0800
Message-ID: <564bad6c.7Masv4NIlXKM3nZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbbKQWmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 17:42:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: add new tracepoint, test_pages_isolated
has been added to the -mm tree.  Its filename is
     mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
mm-cma-always-check-which-page-cause-allocation-failure.patch

