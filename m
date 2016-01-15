From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:34:07 -0800
Message-ID: <569973df.Uw6R5myqpdiMURiV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: use list_for_each_entry in mark_free_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/page_alloc.c: use list_for_each_entry in mark_free_pages()

Use list_for_each_entry instead of list_for_each + list_entry to
simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
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

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

