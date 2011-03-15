From: akpm@linux-foundation.org
Subject: + mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch added to -mm tree
Date: Tue, 15 Mar 2011 16:17:17 -0700
Message-ID: <201103152317.p2FNHHh0018335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540Ab1COXSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 19:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mm/page_alloc.c: use list_move() instead of list_del()/list_add() combination
has been added to the -mm tree.  Its filename is
     mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: use list_move() instead of list_del()/list_add() combination
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination
+++ a/mm/page_alloc.c
@@ -863,9 +863,8 @@ static int move_freepages(struct zone *z
 		}
 
 		order = page_order(page);
-		list_del(&page->lru);
-		list_add(&page->lru,
-			&zone->free_area[order].free_list[migratetype]);
+		list_move(&page->lru,
+			  &zone->free_area[order].free_list[migratetype]);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch
mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch
listh-add-debug-version-of-list_empty.patch

