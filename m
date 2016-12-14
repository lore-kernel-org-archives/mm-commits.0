From: akpm@linux-foundation.org
Subject: [merged]
 mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:25:23 -0800
Message-ID: <58519ca3.gjagnaBndvZo9kRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: turn shadow node shrinker bugs into warnings
has been removed from the -mm tree.  Its filename was
     mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: turn shadow node shrinker bugs into warnings

When the shadow page shrinker tries to reclaim a radix tree node but finds
it in an unexpected state - it should contain no pages, and non-zero
shadow entries - there is no need to kill the executing task or even the
entire system.  Warn about the invalid state, then leave that tree node
be.  Simply don't put it back on the shadow LRU for future reclaim and
move on.

Link: http://lkml.kernel.org/r/20161117191138.22769-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/workingset.c~mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings mm/workingset.c
--- a/mm/workingset.c~mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings
+++ a/mm/workingset.c
@@ -418,23 +418,27 @@ static enum lru_status shadow_lru_isolat
 	 * no pages, so we expect to be able to remove them all and
 	 * delete and free the empty node afterwards.
 	 */
-	BUG_ON(!workingset_node_shadows(node));
-	BUG_ON(workingset_node_pages(node));
-
+	if (WARN_ON_ONCE(!workingset_node_shadows(node)))
+		goto out_invalid;
+	if (WARN_ON_ONCE(workingset_node_pages(node)))
+		goto out_invalid;
 	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
 		if (node->slots[i]) {
-			BUG_ON(!radix_tree_exceptional_entry(node->slots[i]));
+			if (WARN_ON_ONCE(!radix_tree_exceptional_entry(node->slots[i])))
+				goto out_invalid;
+			if (WARN_ON_ONCE(!mapping->nrexceptional))
+				goto out_invalid;
 			node->slots[i] = NULL;
 			workingset_node_shadows_dec(node);
-			BUG_ON(!mapping->nrexceptional);
 			mapping->nrexceptional--;
 		}
 	}
-	BUG_ON(workingset_node_shadows(node));
+	if (WARN_ON_ONCE(workingset_node_shadows(node)))
+		goto out_invalid;
 	inc_node_state(page_pgdat(virt_to_page(node)), WORKINGSET_NODERECLAIM);
-	if (!__radix_tree_delete_node(&mapping->page_tree, node))
-		BUG();
+	__radix_tree_delete_node(&mapping->page_tree, node);
 
+out_invalid:
 	spin_unlock(&mapping->tree_lock);
 	ret = LRU_REMOVED_RETRY;
 out:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


