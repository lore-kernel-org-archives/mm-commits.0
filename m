From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-warn-if-freed-memory-is-still-in-use-fix.patch removed from -mm tree
Date: Thu, 20 Dec 2012 14:24:36 -0800
Message-ID: <20121220222437.114E4100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51124 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTWYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 17:24:38 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so450882qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 14:24:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-warn-if-freed-memory-is-still-in-use-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-warn-if-freed-memory-is-still-in-use-fix.patch

This patch was dropped because it was folded into mm-cma-warn-if-freed-memory-is-still-in-use.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-cma-warn-if-freed-memory-is-still-in-use-fix

Support sparsemem.

(And prevent "count" overflow if nr_pages cannot fit in signed type.)

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use-fix
+++ a/mm/page_alloc.c
@@ -5981,9 +5981,11 @@ done:
 
 void free_contig_range(unsigned long pfn, unsigned nr_pages)
 {
-	struct page *page = pfn_to_page(pfn);
-	int count = 0;
-	for (; nr_pages--; page++) {
+	unsigned int count = 0;
+
+	for (; nr_pages--; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
 		count += page_count(page) != 1;
 		__free_page(page);
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch
mm-clean-up-transparent-hugepage-sysfs-error-messages.patch

