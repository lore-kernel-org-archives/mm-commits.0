From: akpm@linux-foundation.org
Subject: + move-free-pages-between-lists-on-steal-fix-2.patch added to -mm tree
Date: Thu, 08 Mar 2007 00:15:31 -0800
Message-ID: <200703080815.l288FVGg022927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030218AbXCHIPs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 03:15:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     fix BUG_ON check at move_freepages()
has been added to the -mm tree.  Its filename is
     move-free-pages-between-lists-on-steal-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix BUG_ON check at move_freepages()
From: Yasunori Goto <y-goto@jp.fujitsu.com>

The BUG_ON() check at move_freepages() is wrong.  Its end_page is
start_page + MAX_ORDER_NR_PAGES.  So, it can be next zone.  BUG_ON() should
check "end_page - 1".

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal-fix-2
+++ a/mm/page_alloc.c
@@ -673,7 +673,7 @@ int move_freepages(struct zone *zone,
 	unsigned long order;
 	int blocks_moved = 0;
 
-	BUG_ON(page_zone(start_page) != page_zone(end_page));
+	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
 
 	for (page = start_page; page < end_page;) {
 		if (!PageBuddy(page)) {
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

move-free-pages-between-lists-on-steal-fix-2.patch
