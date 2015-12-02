From: akpm@linux-foundation.org
Subject: + mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch added to -mm tree
Date: Wed, 02 Dec 2015 14:53:39 -0800
Message-ID: <565f7673.tm6/uc3ErW5SdRy9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbbLBWxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:53:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: use list_for_each_entry in mark_free_pages()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch

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
Subject: mm/page_alloc.c: use list_for_each_entry in mark_free_pages()

Use list_for_each_entry instead of list_for_each + list_entry to
simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-use-list_for_each_entry-in-mark_free_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-use-list_for_each_entry-in-mark_free_pages
+++ a/mm/page_alloc.c
@@ -1980,7 +1980,7 @@ void mark_free_pages(struct zone *zone)
 	unsigned long pfn, max_zone_pfn;
 	unsigned long flags;
 	unsigned int order, t;
-	struct list_head *curr;
+	struct page *page;
 
 	if (zone_is_empty(zone))
 		return;
@@ -1990,17 +1990,17 @@ void mark_free_pages(struct zone *zone)
 	max_zone_pfn = zone_end_pfn(zone);
 	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 		if (pfn_valid(pfn)) {
-			struct page *page = pfn_to_page(pfn);
-
+			page = pfn_to_page(pfn);
 			if (!swsusp_page_is_forbidden(page))
 				swsusp_unset_page_free(page);
 		}
 
 	for_each_migratetype_order(order, t) {
-		list_for_each(curr, &zone->free_area[order].free_list[t]) {
+		list_for_each_entry(page,
+				&zone->free_area[order].free_list[t], lru) {
 			unsigned long i;
 
-			pfn = page_to_pfn(list_entry(curr, struct page, lru));
+			pfn = page_to_pfn(page);
 			for (i = 0; i < (1UL << order); i++)
 				swsusp_set_page_free(pfn_to_page(pfn + i));
 		}
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
dma-mapping-use-offset_in_page-macro.patch

