From: akpm@linux-foundation.org
Subject: [merged] mm-cma-warn-if-freed-memory-is-still-in-use.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:27 -0800
Message-ID: <20121221203928.736B2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:42275 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2LUUjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:31 -0500
Received: by mail-bk0-f73.google.com with SMTP id jf3so272423bkc.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, kyungmin.park@samsung.com, mina86@mina86.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: WARN if freed memory is still in use
has been removed from the -mm tree.  Its filename was
     mm-cma-warn-if-freed-memory-is-still-in-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: WARN if freed memory is still in use

Memory returned to free_contig_range() must have no other references.  Let
kernel to complain loudly if page reference count is not equal to 1.

[rientjes@google.com: support sparsemem]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use
+++ a/mm/page_alloc.c
@@ -5978,8 +5978,15 @@ done:
 
 void free_contig_range(unsigned long pfn, unsigned nr_pages)
 {
-	for (; nr_pages--; ++pfn)
-		__free_page(pfn_to_page(pfn));
+	unsigned int count = 0;
+
+	for (; nr_pages--; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		count += page_count(page) != 1;
+		__free_page(page);
+	}
+	WARN(count != 0, "%d pages are still in use!\n", count);
 }
 #endif
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
cma-make-putback_lru_pages-call-conditional.patch
cma-make-putback_lru_pages-call-conditional-fix.patch

