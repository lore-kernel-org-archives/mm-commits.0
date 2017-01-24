From: akpm@linux-foundation.org
Subject: [patch 12/26] radix-tree: fix private list warnings
Date: Tue, 24 Jan 2017 15:18:16 -0800
Message-ID: <5887e0b8.c3luYjmCa+bVj2HQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41430 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdAXXSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, hannes@cmpxchg.org

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix-tree: fix private list warnings

The newly introduced warning in radix_tree_free_nodes() was testing the
wrong variable; it should have been 'old' instead of 'node'.

Fixes: ea07b862ac8e ("mm: workingset: fix use-after-free in shadow node shrinker")
Link: http://lkml.kernel.org/r/20170118163746.GA32495@cmpxchg.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix-tree-fix-private-list-warnings lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-private-list-warnings
+++ a/lib/radix-tree.c
@@ -769,7 +769,7 @@ static void radix_tree_free_nodes(struct
 			struct radix_tree_node *old = child;
 			offset = child->offset + 1;
 			child = child->parent;
-			WARN_ON_ONCE(!list_empty(&node->private_list));
+			WARN_ON_ONCE(!list_empty(&old->private_list));
 			radix_tree_node_free(old);
 			if (old == entry_to_node(node))
 				return;
_
