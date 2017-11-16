From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch removed from -mm
 tree
Date: Thu, 16 Nov 2017 12:01:58 -0800
Message-ID: <20171116200158.heVPbP_Iy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUB7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:01:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use pagevec_lookup_range_tag() in write_cache_pages()
has been removed from the -mm tree.  Its filename was
     mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: use pagevec_lookup_range_tag() in write_cache_pages()

Use pagevec_lookup_range_tag() in write_cache_pages() as it is interested
only in pages from given range.  Remove unnecessary code resulting from
this.

Link: http://lkml.kernel.org/r/20171009151359.31984-12-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff -puN mm/page-writeback.c~mm-use-pagevec_lookup_range_tag-in-write_cache_pages mm/page-writeback.c
--- a/mm/page-writeback.c~mm-use-pagevec_lookup_range_tag-in-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2196,30 +2196,14 @@ retry:
 	while (!done && (index <= end)) {
 		int i;
 
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			/*
-			 * At this point, the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or
-			 * even swizzled back from swapper_space to tmpfs file
-			 * mapping. However, page->index will not change
-			 * because we have a reference on the page.
-			 */
-			if (page->index > end) {
-				/*
-				 * can't be range_cyclic (1st pass) because
-				 * end == -1 in that case.
-				 */
-				done = 1;
-				break;
-			}
