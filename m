From: akpm@linux-foundation.org
Subject: + mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory.patch added to -mm tree
Date: Mon, 04 Feb 2013 15:08:56 -0800
Message-ID: <20130204230856.A39F131C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:35701 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3BDXI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 18:08:57 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so703695qeb.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 15:08:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com


The patch titled
     Subject: mm: cma: fix accounting of CMA pages placed in high memory
has been added to the -mm tree.  Its filename is
     mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: fix accounting of CMA pages placed in high memory

The total number of low memory pages is determined as totalram_pages -
totalhigh_pages, so without this patch all CMA pageblocks placed in
highmem were accounted to low memory.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory
+++ a/mm/page_alloc.c
@@ -787,6 +787,10 @@ void __init init_cma_reserved_pageblock(
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	__free_pages(page, pageblock_order);
 	totalram_pages += pageblock_nr_pages;
+#ifdef CONFIG_HIGHMEM
+	if (PageHighMem(page))
+		totalhigh_pages += pageblock_nr_pages;
+#endif
 }
 #endif
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
cma-make-putback_lru_pages-call-conditional.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory.patch

