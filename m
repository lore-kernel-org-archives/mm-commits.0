From: akpm@linux-foundation.org
Subject: [merged] slab-do-not-call-compound_head-in-page_get_cache.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:32 -0700
Message-ID: <20120820195632.C689C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34156 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:34 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4032395obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cl@linux-foundation.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: do not call compound_head() in page_get_cache()
has been removed from the -mm tree.  Its filename was
     slab-do-not-call-compound_head-in-page_get_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: slab: do not call compound_head() in page_get_cache()

page_get_cache() does not need to call compound_head(), as its unique
caller virt_to_slab() already makes sure to return a head page.

Additionally, removing the compound_head() call makes page_get_cache()
consistent with page_get_slab().

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/slab.c~slab-do-not-call-compound_head-in-page_get_cache mm/slab.c
--- a/mm/slab.c~slab-do-not-call-compound_head-in-page_get_cache
+++ a/mm/slab.c
@@ -517,7 +517,6 @@ static bool slab_max_order_set __initdat
 
 static inline struct kmem_cache *page_get_cache(struct page *page)
 {
-	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return page->slab_cache;
 }
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch

