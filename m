From: akpm@linux-foundation.org
Subject: [to-be-updated] radix-tree-fix-private-list-warnings.patch
 removed from -mm tree
Date: Wed, 18 Jan 2017 13:04:52 -0800
Message-ID: <587fd874.akz58WApp+Aqf0PC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdARV2b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:28:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix private list warnings
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-private-list-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix-tree: fix private list warnings

The newly introduced warning in radix_tree_free_nodes() was testing the
wrong variable; it should have been 'old' instead of 'node'.  Rather than
replace that one instance, I noticed that we can simply put the
WARN_ON_ONCE in radix_tree_node_free() and it will be just as effective.

Fixes: ea07b862ac8e ("mm: workingset: fix use-after-free in shadow node shrinker")
Link: http://lkml.kernel.org/r/1484270903-24307-1-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-private-list-warnings lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-private-list-warnings
+++ a/lib/radix-tree.c
@@ -365,6 +365,7 @@ static void radix_tree_node_rcu_free(str
 static inline void
 radix_tree_node_free(struct radix_tree_node *node)
 {
+	WARN_ON_ONCE(!list_empty(&node->private_list));
 	call_rcu(&node->rcu_head, radix_tree_node_rcu_free);
 }
 
@@ -640,7 +641,6 @@ static inline void radix_tree_shrink(str
 				update_node(node, private);
 		}
 
-		WARN_ON_ONCE(!list_empty(&node->private_list));
 		radix_tree_node_free(node);
 	}
 }
@@ -667,7 +667,6 @@ static void delete_node(struct radix_tre
 			root->rnode = NULL;
 		}
 
-		WARN_ON_ONCE(!list_empty(&node->private_list));
 		radix_tree_node_free(node);
 
 		node = parent;
@@ -769,7 +768,6 @@ static void radix_tree_free_nodes(struct
 			struct radix_tree_node *old = child;
 			offset = child->offset + 1;
 			child = child->parent;
-			WARN_ON_ONCE(!list_empty(&node->private_list));
 			radix_tree_node_free(old);
 			if (old == entry_to_node(node))
 				return;
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

find_bit-micro-optimise-find_next__bit.patch
find_bit-micro-optimise-find_next__bit-v2.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch

