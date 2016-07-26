From: akpm@linux-foundation.org
Subject: [withdrawn]
 mem-hotplug-use-gfp_highuser_movable-in-alloc_migrate_target.patch removed
 from -mm tree
Date: Tue, 26 Jul 2016 13:17:33 -0700
Message-ID: <5797c55d.OgpmozReVWZB3a6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbcGZURe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 16:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: use GFP_HIGHUSER_MOVABLE in, alloc_migrate_target()
has been removed from the -mm tree.  Its filename was
     mem-hotplug-use-gfp_highuser_movable-in-alloc_migrate_target.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: use GFP_HIGHUSER_MOVABLE in, alloc_migrate_target()

alloc_migrate_target() is called from migrate_pages(), and the page is
always from user space, so we can add __GFP_HIGHMEM directly.

Link: http://lkml.kernel.org/r/57884EAA.9030603@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/page_isolation.c~mem-hotplug-use-gfp_highuser_movable-in-alloc_migrate_target mm/page_isolation.c
--- a/mm/page_isolation.c~mem-hotplug-use-gfp_highuser_movable-in-alloc_migrate_target
+++ a/mm/page_isolation.c
@@ -283,8 +283,6 @@ int test_pages_isolated(unsigned long st
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
 				  int **resultp)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
-
 	/*
 	 * TODO: allocate a destination hugepage from a nearest neighbor node,
 	 * accordance with memory policy of the user process if possible. For
@@ -294,9 +292,6 @@ struct page *alloc_migrate_target(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					    next_node_in(page_to_nid(page),
 							 node_online_map));
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
