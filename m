From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-may_enter_fs-bool-in-shrink_page_list.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:39:57 -0700
Message-ID: <20200403203957.5C4m6q-mw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ktkhai@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: make may_enter_fs bool in shrink_page_list()
has been removed from the -mm tree.  Its filename was
     mm-make-may_enter_fs-bool-in-shrink_page_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: mm/vmscan.c: make may_enter_fs bool in shrink_page_list()

This gives some size improvement:

$size mm/vmscan.o (before)
   text	   data	    bss	    dec	    hex	filename
  53670	  24123	     12	  77805	  12fed	mm/vmscan.o

$size mm/vmscan.o (after)
   text	   data	    bss	    dec	    hex	filename
  53648	  24123	     12	  77783	  12fd7	mm/vmscan.o

Link: http://lkml.kernel.org/r/Message-ID:
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-make-may_enter_fs-bool-in-shrink_page_list
+++ a/mm/vmscan.c
@@ -1084,9 +1084,8 @@ static unsigned long shrink_page_list(st
 	while (!list_empty(page_list)) {
 		struct address_space *mapping;
 		struct page *page;
-		int may_enter_fs;
 		enum page_references references = PAGEREF_RECLAIM;
-		bool dirty, writeback;
+		bool dirty, writeback, may_enter_fs;
 		unsigned int nr_pages;
 
 		cond_resched();
@@ -1267,7 +1266,7 @@ static unsigned long shrink_page_list(st
 						goto activate_locked_split;
 				}
 
-				may_enter_fs = 1;
+				may_enter_fs = true;
 
 				/* Adding to swap updated mapping */
 				mapping = page_mapping(page);
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are
