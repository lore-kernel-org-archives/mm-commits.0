From: akpm@linux-foundation.org
Subject: [obsolete] radix-tree-make-radix_tree_preload-alloc-one-more-slot.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:10:09 -0700
Message-ID: <200908312110.n7VLAAE9002740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbZHaVKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhu.yanhai@gmail.com, jkosina@suse.cz, nickpiggin@yahoo.com.au, shijie8@gmail.com, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     radix-tree: make radix_tree_preload alloc one more slot
has been removed from the -mm tree.  Its filename was
     radix-tree-make-radix_tree_preload-alloc-one-more-slot.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: make radix_tree_preload alloc one more slot
From: Zhu Yanhai <zhu.yanhai@gmail.com>

The operations against radix tree always use paths with
RADIX_TREE_MAX_PATH + 1 slots, but radix_tree_preload only pre-allocs
RADIX_TREE_MAX_PATH slots at present, which causes radix_tree_node_alloc
tries to do kmem_cache_alloc at the last slot even if we don't have
gfp_mask & __GFP_WAIT in hand.

Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Wu Fengguang <wfg@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix-tree-make-radix_tree_preload-alloc-one-more-slot lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-make-radix_tree_preload-alloc-one-more-slot
+++ a/lib/radix-tree.c
@@ -79,7 +79,7 @@ static struct kmem_cache *radix_tree_nod
  */
 struct radix_tree_preload {
 	int nr;
-	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
+	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH + 1];
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
_

Patches currently in -mm which might be from zhu.yanhai@gmail.com are

radix-tree-make-radix_tree_preload-alloc-one-more-slot.patch
linux-next.patch

