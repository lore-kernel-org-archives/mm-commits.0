From: akpm@linux-foundation.org
Subject: + mm-cma-remove-watermark-hacks-fix.patch added to -mm tree
Date: Wed, 14 Nov 2012 14:41:38 -0800
Message-ID: <20121114224138.A41F1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62941 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2KNWlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:41:39 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so105154vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:41:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com


The patch titled
     Subject: mm: cma: remove watermark hacks (fix)
has been added to the -mm tree.  Its filename is
     mm-cma-remove-watermark-hacks-fix.patch

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
Subject: mm: cma: remove watermark hacks (fix)

mm/page_alloc.c: In function `alloc_contig_range':
mm/page_alloc.c:5825:15: warning: unused variable `zone' [-Wunused-variable]

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-cma-remove-watermark-hacks-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-remove-watermark-hacks-fix
+++ a/mm/page_alloc.c
@@ -5822,7 +5822,6 @@ static int __alloc_contig_migrate_range(
 int alloc_contig_range(unsigned long start, unsigned long end,
 		       unsigned migratetype)
 {
-	struct zone *zone = page_zone(pfn_to_page(start));
 	unsigned long outer_start, outer_end;
 	int ret = 0, order;
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch
mm-cma-remove-watermark-hacks.patch
mm-cma-remove-watermark-hacks-fix.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch

