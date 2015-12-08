From: akpm@linux-foundation.org
Subject: +
 mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 14:26:19 -0800
Message-ID: <5667590b.5r3PKCrZ7Dd9jZ6N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbLHW0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:26:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead.c, mm/vmscan.c: use lru_to_page instead of list_to_page
has been added to the -mm tree.  Its filename is
     mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/readahead.c, mm/vmscan.c: use lru_to_page instead of list_to_page

list_to_page() in readahead.c is the same as lru_to_page() in vmscan.c. 
So I move lru_to_page to internal.h and drop list_to_page().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    2 ++
 mm/readahead.c |    8 +++-----
 mm/vmscan.c    |    2 --
 3 files changed, 5 insertions(+), 7 deletions(-)

diff -puN mm/internal.h~mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page mm/internal.h
--- a/mm/internal.h~mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page
+++ a/mm/internal.h
@@ -119,6 +119,8 @@ extern int isolate_lru_page(struct page
 extern void putback_lru_page(struct page *page);
 extern bool zone_reclaimable(struct zone *zone);
 
+#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
+
 /*
  * in mm/rmap.c:
  */
diff -puN mm/readahead.c~mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page
+++ a/mm/readahead.c
@@ -32,8 +32,6 @@ file_ra_state_init(struct file_ra_state
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
-#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
-
 /*
  * see if a page needs releasing upon read_cache_pages() failure
  * - the caller of read_cache_pages() may have set PG_private or PG_fscache
@@ -64,7 +62,7 @@ static void read_cache_pages_invalidate_
 	struct page *victim;
 
 	while (!list_empty(pages)) {
-		victim = list_to_page(pages);
+		victim = lru_to_page(pages);
 		list_del(&victim->lru);
 		read_cache_pages_invalidate_page(mapping, victim);
 	}
@@ -87,7 +85,7 @@ int read_cache_pages(struct address_spac
 	int ret = 0;
 
 	while (!list_empty(pages)) {
-		page = list_to_page(pages);
+		page = lru_to_page(pages);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping, page->index,
 				mapping_gfp_constraint(mapping, GFP_KERNEL))) {
@@ -125,7 +123,7 @@ static int read_pages(struct address_spa
 	}
 
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
-		struct page *page = list_to_page(pages);
+		struct page *page = lru_to_page(pages);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping, page->index,
 				mapping_gfp_constraint(mapping, GFP_KERNEL))) {
diff -puN mm/vmscan.c~mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page mm/vmscan.c
--- a/mm/vmscan.c~mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page
+++ a/mm/vmscan.c
@@ -106,8 +106,6 @@ struct scan_control {
 	unsigned long nr_reclaimed;
 };
 
-#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
