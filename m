From: akpm@linux-foundation.org
Subject: + mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch
 added to -mm tree
Date: Mon, 29 Jul 2013 15:43:59 -0700
Message-ID: <51f6f02f.0wqzd14UKH46Z2BO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3G2WoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sjenning@linux.vnet.ibm.com, riel@redhat.com, David.Woodhouse@intel.com, cody@linux.vnet.ibm.com

Subject: + mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch added to -mm tree
To: cody@linux.vnet.ibm.com,David.Woodhouse@intel.com,riel@redhat.com,sjenning@linux.vnet.ibm.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:43:59 -0700


The patch titled
     Subject: mm/zswap: use postorder iteration when destroying rbtree
has been added to the -mm tree.  Its filename is
     mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/zswap: use postorder iteration when destroying rbtree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN mm/zswap.c~mm-zswap-use-postorder-iteration-when-destroying-rbtree mm/zswap.c
--- a/mm/zswap.c~mm-zswap-use-postorder-iteration-when-destroying-rbtree
+++ a/mm/zswap.c
@@ -790,26 +790,14 @@ static void zswap_frontswap_invalidate_p
 static void zswap_frontswap_invalidate_area(unsigned type)
 {
 	struct zswap_tree *tree = zswap_trees[type];
-	struct rb_node *node;
-	struct zswap_entry *entry;
+	struct zswap_entry *entry, *n;
 
 	if (!tree)
 		return;
 
 	/* walk the tree and free everything */
 	spin_lock(&tree->lock);
-	/*
-	 * TODO: Even though this code should not be executed because
-	 * the try_to_unuse() in swapoff should have emptied the tree,
-	 * it is very wasteful to rebalance the tree after every
-	 * removal when we are freeing the whole tree.
-	 *
-	 * If post-order traversal code is ever added to the rbtree
-	 * implementation, it should be used here.
-	 */
-	while ((node = rb_first(&tree->rbroot))) {
-		entry = rb_entry(node, struct zswap_entry, rbnode);
-		rb_erase(&entry->rbnode, &tree->rbroot);
+	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode) {
 		zbud_free(tree->pool, entry->handle);
 		zswap_entry_cache_free(entry);
 		atomic_dec(&zswap_stored_pages);
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch
rbtree-add-postorder-iteration-functions.patch
rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch
rbtree_test-add-test-for-postorder-iteration.patch
rbtree-allow-tests-to-run-as-builtin.patch
mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch

