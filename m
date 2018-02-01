From: akpm@linux-foundation.org
Subject: [patch 117/119] mm/swap.c: make functions and their
 kernel-doc agree
Date: Wed, 31 Jan 2018 16:21:19 -0800
Message-ID: <20180201002119.gHAgwwnNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAAVV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:21:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, jack@suse.cz, mhocko@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org, willy@infradead.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/swap.c: make functions and their kernel-doc agree

Fix some basic kernel-doc notation in mm/swap.c:
- for function lru_cache_add_anon(), make its kernel-doc function name
  match its function name and change colon to hyphen following the
  function name
- for function pagevec_lookup_entries(), change the function parameter
  name from nr_pages to nr_entries since that is more descriptive of
  what the parameter actually is and then it matches the kernel-doc
  comments also

Fix function kernel-doc to match the change in commit 67fd707f4681:
- drop the kernel-doc notation for @nr_pages from pagevec_lookup_range()
  and correct the function description for that change

Link: http://lkml.kernel.org/r/3b42ee3e-04a9-a6ca-6be4-f00752a114fe@infradead.org
Fixes: 67fd707f4681 ("mm: remove nr_pages argument from pagevec_lookup_{,range}_tag()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/swap.c~mm-swapc-make-functions-and-their-kernel-doc-agree mm/swap.c
--- a/mm/swap.c~mm-swapc-make-functions-and-their-kernel-doc-agree
+++ a/mm/swap.c
@@ -411,7 +411,7 @@ static void __lru_cache_add(struct page
 }
 
 /**
- * lru_cache_add: add a page to the page lists
+ * lru_cache_add_anon - add a page to the page lists
  * @page: the page to add
  */
 void lru_cache_add_anon(struct page *page)
@@ -930,10 +930,10 @@ EXPORT_SYMBOL(__pagevec_lru_add);
  */
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
 				struct address_space *mapping,
-				pgoff_t start, unsigned nr_pages,
+				pgoff_t start, unsigned nr_entries,
 				pgoff_t *indices)
 {
-	pvec->nr = find_get_entries(mapping, start, nr_pages,
+	pvec->nr = find_get_entries(mapping, start, nr_entries,
 				    pvec->pages, indices);
 	return pagevec_count(pvec);
 }
@@ -965,9 +965,8 @@ void pagevec_remove_exceptionals(struct
  * @mapping:	The address_space to search
  * @start:	The starting page index
  * @end:	The final page index
- * @nr_pages:	The maximum number of pages
  *
- * pagevec_lookup_range() will search for and return a group of up to @nr_pages
+ * pagevec_lookup_range() will search for & return a group of up to PAGEVEC_SIZE
  * pages in the mapping starting from index @start and upto index @end
  * (inclusive).  The pages are placed in @pvec.  pagevec_lookup() takes a
  * reference against the pages in @pvec.
@@ -977,7 +976,7 @@ void pagevec_remove_exceptionals(struct
  * also update @start to index the next page for the traversal.
  *
  * pagevec_lookup_range() returns the number of pages which were found. If this
- * number is smaller than @nr_pages, the end of specified range has been
+ * number is smaller than PAGEVEC_SIZE, the end of specified range has been
  * reached.
  */
 unsigned pagevec_lookup_range(struct pagevec *pvec,
_
