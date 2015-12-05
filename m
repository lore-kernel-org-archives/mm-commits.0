From: akpm@linux-foundation.org
Subject: + mm-swapfilec-use-list_nextfirst_entry.patch added to -mm tree
Date: Fri, 04 Dec 2015 16:41:59 -0800
Message-ID: <566232d7.cjHmvV1SlPteOvRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbbLEAmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:42:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, hughd@google.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use list_{next,first}_entry
has been added to the -mm tree.  Its filename is
     mm-swapfilec-use-list_nextfirst_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-use-list_nextfirst_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-use-list_nextfirst_entry.patch

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

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
mm-swapfilec-use-list_nextfirst_entry.patch
dma-mapping-use-offset_in_page-macro.patch

