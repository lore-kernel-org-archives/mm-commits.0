From: akpm@linux-foundation.org
Subject: [patch 056/119] mm: use find_get_pages_range() in
 filemap_range_has_page()
Date: Wed, 06 Sep 2017 16:21:40 -0700
Message-ID: <20170906232140.ICR3G8tsb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49972 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdIFXVl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
