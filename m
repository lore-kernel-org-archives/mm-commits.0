From: akpm@linux-foundation.org
Subject: [merged] mm-swapfilec-use-list_nextfirst_entry.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:16 -0800
Message-ID: <569973e8.YfLMiQC7NknAs31b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, hughd@google.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use list_{next,first}_entry
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-use-list_nextfirst_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/swapfile.c: use list_{next,first}_entry

To make the intention clearer, use list_{next,first}_entry instead of
list_entry().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN mm/swapfile.c~mm-swapfilec-use-list_nextfirst_entry mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-use-list_nextfirst_entry
+++ a/mm/swapfile.c
@@ -165,8 +165,6 @@ static void discard_swap_cluster(struct
 	int found_extent = 0;
 
 	while (nr_pages) {
-		struct list_head *lh;
-
 		if (se->start_page <= start_page &&
 		    start_page < se->start_page + se->nr_pages) {
 			pgoff_t offset = start_page - se->start_page;
@@ -188,8 +186,7 @@ static void discard_swap_cluster(struct
 				break;
 		}
 
-		lh = se->list.next;
-		se = list_entry(lh, struct swap_extent, list);
+		se = list_next_entry(se, list);
 	}
 }
 
@@ -903,7 +900,7 @@ int swp_swapcount(swp_entry_t entry)
 	VM_BUG_ON(page_private(page) != SWP_CONTINUED);
 
 	do {
-		page = list_entry(page->lru.next, struct page, lru);
+		page = list_next_entry(page, lru);
 		map = kmap_atomic(page);
 		tmp_count = map[offset];
 		kunmap_atomic(map);
@@ -1633,14 +1630,11 @@ static sector_t map_swap_entry(swp_entry
 	se = start_se;
 
 	for ( ; ; ) {
-		struct list_head *lh;
-
 		if (se->start_page <= offset &&
 				offset < (se->start_page + se->nr_pages)) {
 			return se->start_block + (offset - se->start_page);
 		}
-		lh = se->list.next;
-		se = list_entry(lh, struct swap_extent, list);
+		se = list_next_entry(se, list);
 		sis->curr_swap_extent = se;
 		BUG_ON(se == start_se);		/* It *must* be present */
 	}
@@ -1664,7 +1658,7 @@ static void destroy_swap_extents(struct
 	while (!list_empty(&sis->first_swap_extent.list)) {
 		struct swap_extent *se;
 
-		se = list_entry(sis->first_swap_extent.list.next,
+		se = list_first_entry(&sis->first_swap_extent.list,
 				struct swap_extent, list);
 		list_del(&se->list);
 		kfree(se);
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

