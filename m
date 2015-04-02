From: akpm@linux-foundation.org
Subject: +
 mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch added to -mm tree
Date: Thu, 02 Apr 2015 13:56:10 -0700
Message-ID: <551dacea.djOQqaHpj9U9/km9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbDBU4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 16:56:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan.strogin@gmail.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mingo@elte.hu, mpn@google.com, rostedt@goodmis.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix
has been added to the -mm tree.  Its filename is
     mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefan Strogin <stefan.strogin@gmail.com>
Subject: mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix

Trace 'align' too in cma_alloc trace event.

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

 include/trace/events/cma.h |   11 +++++++----
 mm/cma.c                   |    2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN include/trace/events/cma.h~mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix include/trace/events/cma.h
--- a/include/trace/events/cma.h~mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix
+++ a/include/trace/events/cma.h
@@ -10,26 +10,29 @@
 TRACE_EVENT(cma_alloc,
 
 	TP_PROTO(unsigned long pfn, const struct page *page,
-		 unsigned int count),
+		 unsigned int count, unsigned int align),
 
-	TP_ARGS(pfn, page, count),
+	TP_ARGS(pfn, page, count, align),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
 		__field(const struct page *, page)
 		__field(unsigned int, count)
+		__field(unsigned int, align)
 	),
 
 	TP_fast_assign(
 		__entry->pfn = pfn;
 		__entry->page = page;
 		__entry->count = count;
+		__entry->align = align;
 	),
 
-	TP_printk("pfn=%lx page=%p count=%u",
+	TP_printk("pfn=%lx page=%p count=%u align=%u",
 		  __entry->pfn,
 		  __entry->page,
-		  __entry->count)
+		  __entry->count,
+		  __entry->align)
 );
 
 TRACE_EVENT(cma_release,
diff -puN mm/cma.c~mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix mm/cma.c
--- a/mm/cma.c~mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix
+++ a/mm/cma.c
@@ -416,7 +416,7 @@ struct page *cma_alloc(struct cma *cma,
 		start = bitmap_no + mask + 1;
 	}
 
-	trace_cma_alloc(page ? pfn : -1UL, page, count);
+	trace_cma_alloc(page ? pfn : -1UL, page, count, align);
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 	return page;
_

Patches currently in -mm which might be from stefan.strogin@gmail.com are

mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch
mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch

