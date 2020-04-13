From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 15:32:32 -0700
Message-ID: <20200413223232.8xJf0hmhS%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389641AbgDMWce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 18:32:34 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw, chenqiwu@xiaomi.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/swapfile: use list_{prev,next}_entry() instead of open-coding
has been added to the -mm tree.  Its filename is
     mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch
mm-replace-zero-length-array-with-flexible-array-member.patch
