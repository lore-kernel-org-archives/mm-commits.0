From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-find_get_pages_range-in-filemap_range_has_page.patch removed from
 -mm tree
Date: Thu, 07 Sep 2017 11:39:10 -0700
Message-ID: <20170907183910.ADEKLbDCW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755674AbdIGSjL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use find_get_pages_range() in filemap_range_has_page()
has been removed from the -mm tree.  Its filename was
     mm-use-find_get_pages_range-in-filemap_range_has_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: use find_get_pages_range() in filemap_range_has_page()

We want only pages from given range in filemap_range_has_page(),
furthermore we want at most a single page.  So use find_get_pages_range()
instead of pagevec_lookup() and remove unnecessary code.

Link: http://lkml.kernel.org/r/20170726114704.7626-10-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/filemap.c~mm-use-find_get_pages_range-in-filemap_range_has_page mm/filemap.c
--- a/mm/filemap.c~mm-use-find_get_pages_range-in-filemap_range_has_page
+++ a/mm/filemap.c
@@ -393,8 +393,7 @@ bool filemap_range_has_page(struct addre
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
-	struct pagevec pvec;
-	bool ret;
+	struct page *page;
 
 	if (end_byte < start_byte)
 		return false;
@@ -402,12 +401,10 @@ bool filemap_range_has_page(struct addre
 	if (mapping->nrpages == 0)
 		return false;
 
-	pagevec_init(&pvec, 0);
-	if (!pagevec_lookup(&pvec, mapping, &index, 1))
+	if (!find_get_pages_range(mapping, &index, end, 1, &page))
 		return false;
-	ret = (pvec.pages[0]->index <= end);
-	pagevec_release(&pvec);
-	return ret;
+	put_page(page);
+	return true;
 }
 EXPORT_SYMBOL(filemap_range_has_page);
 
_

Patches currently in -mm which might be from jack@suse.cz are


