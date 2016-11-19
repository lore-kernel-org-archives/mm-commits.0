From: akpm@linux-foundation.org
Subject: +
 mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch added to
 -mm tree
Date: Fri, 18 Nov 2016 16:45:34 -0800
Message-ID: <582fa0ae.JsmlwT/wP3nafjL9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbcKSApf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 19:45:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: turn shadow node shrinker bugs into warnings
has been added to the -mm tree.  Its filename is
     mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-khugepaged-close-use-after-free-race-during-shmem-collapsing.patch
mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch
mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch
lib-radix-tree-native-accounting-of-exceptional-entries.patch
lib-radix-tree-check-accounting-of-existing-slot-replacement-users.patch
lib-radix-tree-add-entry-deletion-support-to-__radix_tree_replace.patch
lib-radix-tree-update-callback-for-changing-leaf-nodes.patch
mm-workingset-move-shadow-entry-tracking-to-radix-tree-exceptional-tracking.patch
mm-workingset-restore-refault-tracking-for-single-page-files.patch

