From: akpm@linux-foundation.org
Subject: + mm-use-find_get_pages_range-in-filemap_range_has_page.patch
 added to -mm tree
Date: Wed, 26 Jul 2017 15:18:00 -0700
Message-ID: <59791518.0CFEJ5VN0YL6J3fS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWSB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use find_get_pages_range() in filemap_range_has_page()
has been added to the -mm tree.  Its filename is
     mm-use-find_get_pages_range-in-filemap_range_has_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-find_get_pages_range-in-filemap_range_has_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-find_get_pages_range-in-filemap_range_has_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fscache-remove-unused-now_uncached-callback.patch
mm-make-pagevec_lookup-update-index.patch
mm-implement-find_get_pages_range.patch
fs-fix-performance-regression-in-clean_bdev_aliases.patch
ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch
ext4-use-pagevec_lookup_range-in-writeback-code.patch
hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch
fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch
mm-use-find_get_pages_range-in-filemap_range_has_page.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range.patch

