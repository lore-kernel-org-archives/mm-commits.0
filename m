From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:18:36 -0700
Message-ID: <543c177c.CNeVhYm25cbIdXMq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: move cache_flusharray() out of unlikely.text section
has been removed from the -mm tree.  Its filename was
     mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: move cache_flusharray() out of unlikely.text section

Now, due to likely keyword, compiled code of cache_flusharray() is on
unlikely.text section.  Although it is uncommon case compared to free to
cpu cache case, it is common case than free_block().  But, free_block() is
on normal text section.  This patch fix this odd situation to remove
likely keyword.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-move-cache_flusharray-out-of-unlikelytext-section mm/slab.c
--- a/mm/slab.c~mm-slab-move-cache_flusharray-out-of-unlikelytext-section
+++ a/mm/slab.c
@@ -3399,7 +3399,7 @@ static inline void __cache_free(struct k
 	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
 		return;
 
-	if (likely(ac->avail < ac->limit)) {
+	if (ac->avail < ac->limit) {
 		STATS_INC_FREEHIT(cachep);
 	} else {
 		STATS_INC_FREEMISS(cachep);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

