From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 058/128] mm/swapfile: use list_{prev,next}_entry()
 instead of open-coding
Date: Mon, 01 Jun 2020 21:48:36 -0700
Message-ID: <20200602044836.KlGG_BTAi%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBEsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:39 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw, chenqiwu@xiaomi.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org, willy@infradead.org, yang.shi@linux.alibaba.com

From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/swapfile: use list_{prev,next}_entry() instead of open-coding

Use list_{prev,next}_entry() instead of list_entry() for better
code readability.

Link: http://lkml.kernel.org/r/1586599916-15456-2-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-use-list_prevnext_entry-instead-of-open-coding
+++ a/mm/swapfile.c
@@ -3654,7 +3654,7 @@ static bool swap_count_continued(struct
 
 	spin_lock(&si->cont_lock);
 	offset &= ~PAGE_MASK;
-	page = list_entry(head->lru.next, struct page, lru);
+	page = list_next_entry(head, lru);
 	map = kmap_atomic(page) + offset;
 
 	if (count == SWAP_MAP_MAX)	/* initial increment from swap_map */
@@ -3666,13 +3666,13 @@ static bool swap_count_continued(struct
 		 */
 		while (*map == (SWAP_CONT_MAX | COUNT_CONTINUED)) {
 			kunmap_atomic(map);
-			page = list_entry(page->lru.next, struct page, lru);
+			page = list_next_entry(page, lru);
 			BUG_ON(page == head);
 			map = kmap_atomic(page) + offset;
 		}
 		if (*map == SWAP_CONT_MAX) {
 			kunmap_atomic(map);
-			page = list_entry(page->lru.next, struct page, lru);
+			page = list_next_entry(page, lru);
 			if (page == head) {
 				ret = false;	/* add count continuation */
 				goto out;
@@ -3682,12 +3682,10 @@ init_map:		*map = 0;		/* we didn't zero
 		}
 		*map += 1;
 		kunmap_atomic(map);
-		page = list_entry(page->lru.prev, struct page, lru);
-		while (page != head) {
+		while ((page = list_prev_entry(page, lru)) != head) {
 			map = kmap_atomic(page) + offset;
 			*map = COUNT_CONTINUED;
 			kunmap_atomic(map);
-			page = list_entry(page->lru.prev, struct page, lru);
 		}
 		ret = true;			/* incremented */
 
@@ -3698,7 +3696,7 @@ init_map:		*map = 0;		/* we didn't zero
 		BUG_ON(count != COUNT_CONTINUED);
 		while (*map == COUNT_CONTINUED) {
 			kunmap_atomic(map);
-			page = list_entry(page->lru.next, struct page, lru);
+			page = list_next_entry(page, lru);
 			BUG_ON(page == head);
 			map = kmap_atomic(page) + offset;
 		}
@@ -3707,13 +3705,11 @@ init_map:		*map = 0;		/* we didn't zero
 		if (*map == 0)
 			count = 0;
 		kunmap_atomic(map);
-		page = list_entry(page->lru.prev, struct page, lru);
-		while (page != head) {
+		while ((page = list_prev_entry(page, lru)) != head) {
 			map = kmap_atomic(page) + offset;
 			*map = SWAP_CONT_MAX | count;
 			count = COUNT_CONTINUED;
 			kunmap_atomic(map);
-			page = list_entry(page->lru.prev, struct page, lru);
 		}
 		ret = count == COUNT_CONTINUED;
 	}
_
