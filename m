From: akpm@linux-foundation.org
Subject: + radix-tree-make-radix_tree_preload-alloc-one-more-slot.patch added to -mm tree
Date: Thu, 27 Aug 2009 14:56:32 -0700
Message-ID: <200908272156.n7RLuWxA001355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZH0V5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 17:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhu.yanhai@gmail.com, jkosina@suse.cz, nickpiggin@yahoo.com.au, shijie8@gmail.com, wfg@linux.intel.com


The patch titled
     radix-tree: make radix_tree_preload alloc one more slot
has been added to the -mm tree.  Its filename is
     radix-tree-make-radix_tree_preload-alloc-one-more-slot.patch

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

