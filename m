From: akpm@linux-foundation.org
Subject: [merged]
 mm-ksm-fix-a-typo-in-comment-alreaady-already.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:18:18 -0700
Message-ID: <20200605201818.eZKciyuws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm: ksm: fix a typo in comment "alreaady"->"already"
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-a-typo-in-comment-alreaady-already.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm: ksm: fix a typo in comment "alreaady"->"already"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200410162427.13927-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-a-typo-in-comment-alreaady-already
+++ a/mm/ksm.c
@@ -612,7 +612,7 @@ static struct stable_node *alloc_stable_
 		 * Move the old stable node to the second dimension
 		 * queued in the hlist_dup. The invariant is that all
 		 * dup stable_nodes in the chain->hlist point to pages
-		 * that are wrprotected and have the exact same
+		 * that are write protected and have the exact same
 		 * content.
 		 */
 		stable_node_chain_add_dup(dup, chain);
@@ -1148,7 +1148,7 @@ static int replace_page(struct vm_area_s
 
 	/*
 	 * No need to check ksm_use_zero_pages here: we can only have a
-	 * zero_page here if ksm_use_zero_pages was enabled alreaady.
+	 * zero_page here if ksm_use_zero_pages was enabled already.
 	 */
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
 		get_page(kpage);
@@ -1608,7 +1608,7 @@ again:
 			 * continue. All KSM pages belonging to the
 			 * stable_node dups in a stable_node chain
 			 * have the same content and they're
-			 * wrprotected at all times. Any will work
+			 * write protected at all times. Any will work
 			 * fine to continue the walk.
 			 */
 			tree_page = get_ksm_page(stable_node_any,
@@ -1843,7 +1843,7 @@ again:
 			 * continue. All KSM pages belonging to the
 			 * stable_node dups in a stable_node chain
 			 * have the same content and they're
-			 * wrprotected at all times. Any will work
+			 * write protected at all times. Any will work
 			 * fine to continue the walk.
 			 */
 			tree_page = get_ksm_page(stable_node_any,
@@ -2001,7 +2001,7 @@ static void stable_tree_append(struct rm
 	 * duplicate. page_migration could break later if rmap breaks,
 	 * so we can as well crash here. We really need to check for
 	 * rmap_hlist_len == STABLE_NODE_CHAIN, but we can as well check
-	 * for other negative values as an undeflow if detected here
+	 * for other negative values as an underflow if detected here
 	 * for the first time (and not when decreasing rmap_hlist_len)
 	 * would be sign of memory corruption in the stable_node.
 	 */
_

Patches currently in -mm which might be from ethp@qq.com are
