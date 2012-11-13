From: akpm@linux-foundation.org
Subject: + mm-cma-warn-if-freed-memory-is-still-in-use.patch added to -mm tree
Date: Tue, 13 Nov 2012 15:30:34 -0800
Message-ID: <20121113233034.A5BB4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50364 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2KMXaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 18:30:35 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so934388yen.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 15:30:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, mina86@mina86.com


The patch titled
     Subject: mm: cma: WARN if freed memory is still in use
has been added to the -mm tree.  Its filename is
     mm-cma-warn-if-freed-memory-is-still-in-use.patch

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
Subject: mm: cma: WARN if freed memory is still in use

Memory returned to free_contig_range() must have no other references.  Let
kernel to complain loudly if page reference count is not equal to 1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use
+++ a/mm/page_alloc.c
@@ -5929,8 +5929,13 @@ done:
 
 void free_contig_range(unsigned long pfn, unsigned nr_pages)
 {
-	for (; nr_pages--; ++pfn)
-		__free_page(pfn_to_page(pfn));
+	struct page *page = pfn_to_page(pfn);
+	int count = 0;
+	for (; nr_pages--; page++) {
+		count += page_count(page) != 1;
+		__free_page(page);
+	}
+	WARN(count != 0, "%d pages are still in use!\n", count);
 }
 #endif
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch
mm-cma-remove-watermark-hacks.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch

