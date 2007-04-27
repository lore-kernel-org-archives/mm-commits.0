From: akpm@linux-foundation.org
Subject: - move-free-pages-between-lists-on-steal-fix-2.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:08:38 -0700
Message-ID: <200704270808.l3R88cZf022911@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755480AbXD0IIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     fix BUG_ON check at move_freepages()
has been removed from the -mm tree.  Its filename was
     move-free-pages-between-lists-on-steal-fix-2.patch

This patch was dropped because it was folded into move-free-pages-between-lists-on-steal.patch

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

move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
fix-section-mismatch-of-memory-hotplug-related-code.patch
add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
