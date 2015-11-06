From: akpm@linux-foundation.org
Subject: [merged]
 ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:16:11 -0800
Message-ID: <563d0a8b./grFyEn08Npd2yth%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162949AbbKFUQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: don't fail stable tree lookups if walking over stale stable_nodes
has been removed from the -mm tree.  Its filename was
     ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: don't fail stable tree lookups if walking over stale stable_nodes

The stable_nodes can become stale at any time if the underlying pages gets
freed.  The stable_node gets collected and removed from the stable rbtree
if that is detected during the rbtree lookups.

Don't fail the lookup if running into stale stable_nodes, just restart the
lookup after collecting the stale stable_nodes.  Otherwise the CPU spent
in the preparation stage is wasted and the lookup must be repeated at the
next loop potentially failing a second time in a second stale stable_node.

If we don't prune aggressively we delay the merging of the unstable node
candidates and at the same time we delay the freeing of the stale
stable_nodes.  Keeping stale stable_nodes around wastes memory and it
can't provide any benefit.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff -puN mm/ksm.c~ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes mm/ksm.c
--- a/mm/ksm.c~ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes
+++ a/mm/ksm.c
@@ -1177,8 +1177,18 @@ again:
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
 		tree_page = get_ksm_page(stable_node, false);
-		if (!tree_page)
-			return NULL;
+		if (!tree_page) {
+			/*
+			 * If we walked over a stale stable_node,
+			 * get_ksm_page() will call rb_erase() and it
+			 * may rebalance the tree from under us. So
+			 * restart the search from scratch. Returning
+			 * NULL would be safe too, but we'd generate
+			 * false negative insertions just because some
+			 * stable_node was stale.
+			 */
+			goto again;
+		}
 
 		ret = memcmp_pages(page, tree_page);
 		put_page(tree_page);
@@ -1254,12 +1264,14 @@ static struct stable_node *stable_tree_i
 	unsigned long kpfn;
 	struct rb_root *root;
 	struct rb_node **new;
-	struct rb_node *parent = NULL;
+	struct rb_node *parent;
 	struct stable_node *stable_node;
 
 	kpfn = page_to_pfn(kpage);
 	nid = get_kpfn_nid(kpfn);
 	root = root_stable_tree + nid;
+again:
+	parent = NULL;
 	new = &root->rb_node;
 
 	while (*new) {
@@ -1269,8 +1281,18 @@ static struct stable_node *stable_tree_i
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
 		tree_page = get_ksm_page(stable_node, false);
-		if (!tree_page)
-			return NULL;
+		if (!tree_page) {
+			/*
+			 * If we walked over a stale stable_node,
+			 * get_ksm_page() will call rb_erase() and it
+			 * may rebalance the tree from under us. So
+			 * restart the search from scratch. Returning
+			 * NULL would be safe too, but we'd generate
+			 * false negative insertions just because some
+			 * stable_node was stale.
+			 */
+			goto again;
+		}
 
 		ret = memcmp_pages(kpage, tree_page);
 		put_page(tree_page);
_

Patches currently in -mm which might be from aarcange@redhat.com are


