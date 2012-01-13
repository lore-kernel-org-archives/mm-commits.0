From: akpm@linux-foundation.org
Subject: [merged] mm-remove-del_page_from_lru-add-page_off_lru.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:57 -0800
Message-ID: <20120113203558.12FFC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab2AMUf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:59 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove del_page_from_lru, add page_off_lru
has been removed from the -mm tree.  Its filename was
     mm-remove-del_page_from_lru-add-page_off_lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove del_page_from_lru, add page_off_lru

del_page_from_lru() repeats del_page_from_lru_list(), also working out
which LRU the page was on, clearing the relevant bits.  Decouple those
functions: remove del_page_from_lru() and add page_off_lru().

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   15 +++++++++------
 mm/swap.c                 |    4 ++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_inline.h~mm-remove-del_page_from_lru-add-page_off_lru include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-remove-del_page_from_lru-add-page_off_lru
+++ a/include/linux/mm_inline.h
@@ -54,8 +54,14 @@ static inline enum lru_list page_lru_bas
 	return LRU_INACTIVE_ANON;
 }
 
-static inline void
-del_page_from_lru(struct zone *zone, struct page *page)
+/**
+ * page_off_lru - which LRU list was page on? clearing its lru flags.
+ * @page: the page to test
+ *
+ * Returns the LRU list a page was on, as an index into the array of LRU
+ * lists; and clears its Unevictable or Active flags, ready for freeing.
+ */
+static inline enum lru_list page_off_lru(struct page *page)
 {
 	enum lru_list lru;
 
@@ -69,9 +75,7 @@ del_page_from_lru(struct zone *zone, str
 			lru += LRU_ACTIVE;
 		}
 	}
-	mem_cgroup_lru_del_list(page, lru);
-	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
+	return lru;
 }
 
 /**
@@ -92,7 +96,6 @@ static inline enum lru_list page_lru(str
 		if (PageActive(page))
 			lru += LRU_ACTIVE;
 	}
-
 	return lru;
 }
 
diff -puN mm/swap.c~mm-remove-del_page_from_lru-add-page_off_lru mm/swap.c
--- a/mm/swap.c~mm-remove-del_page_from_lru-add-page_off_lru
+++ a/mm/swap.c
@@ -53,7 +53,7 @@ static void __page_cache_release(struct 
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		VM_BUG_ON(!PageLRU(page));
 		__ClearPageLRU(page);
-		del_page_from_lru(zone, page);
+		del_page_from_lru_list(zone, page, page_off_lru(page));
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
 }
@@ -617,7 +617,7 @@ void release_pages(struct page **pages, 
 			}
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
-			del_page_from_lru(zone, page);
+			del_page_from_lru_list(zone, page, page_off_lru(page));
 		}
 
 		list_add(&page->lru, &pages_to_free);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
prio_tree-debugging-patch.patch

