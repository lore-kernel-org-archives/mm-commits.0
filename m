From: akpm@linux-foundation.org
Subject: [merged] page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:44 -0700
Message-ID: <200906171833.n5HIXiev032264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760021AbZFQSec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: move check for disabled anti-fragmentation out of fastpath
has been removed from the -mm tree.  Its filename was
     page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: move check for disabled anti-fragmentation out of fastpath
From: Mel Gorman <mel@csn.ul.ie>

On low-memory systems, anti-fragmentation gets disabled as there is
nothing it can do and it would just incur overhead shuffling pages between
lists constantly.  Currently the check is made in the free page fast path
for every page.  This patch moves it to a slow path.  On machines with low
memory, there will be small amount of additional overhead as pages get
shuffled between lists but it should quickly settle.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ---
 mm/page_alloc.c        |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath include/linux/mmzone.h
--- a/include/linux/mmzone.h~page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath
+++ a/include/linux/mmzone.h
@@ -50,9 +50,6 @@ extern int page_group_by_mobility_disabl
 
 static inline int get_pageblock_migratetype(struct page *page)
 {
-	if (unlikely(page_group_by_mobility_disabled))
-		return MIGRATE_UNMOVABLE;
-
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
diff -puN mm/page_alloc.c~page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath
+++ a/mm/page_alloc.c
@@ -168,6 +168,10 @@ int page_group_by_mobility_disabled __re
 
 static void set_pageblock_migratetype(struct page *page, int migratetype)
 {
+
+	if (unlikely(page_group_by_mobility_disabled))
+		migratetype = MIGRATE_UNMOVABLE;
+
 	set_pageblock_flags_group(page, (unsigned long)migratetype,
 					PB_migrate, PB_migrate_end);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

