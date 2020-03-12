From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-may_enter_fs-bool-in-shrink_page_list.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 16:43:21 -0700
Message-ID: <20200312234321.TEiHWk4Yz%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgCLXnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 19:43:22 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ktkhai@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: make may_enter_fs bool in shrink_page_list()
has been added to the -mm tree.  Its filename is
     mm-make-may_enter_fs-bool-in-shrink_page_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-may_enter_fs-bool-in-shrink_page_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-may_enter_fs-bool-in-shrink_page_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-allocate-shrinker_map-on-appropriate-numa-node.patch
mm-make-may_enter_fs-bool-in-shrink_page_list.patch
