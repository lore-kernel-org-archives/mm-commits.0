From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:09 -0700
Message-ID: <201103232041.p2NKfjBS028677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933369Ab1CWUzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: use list_move() instead of list_del()/list_add() combination
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: use list_move() instead of list_del()/list_add() combination
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination
+++ a/mm/page_alloc.c
@@ -867,9 +867,8 @@ static int move_freepages(struct zone *z
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

origin.patch
linux-next.patch

