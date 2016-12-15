From: akpm@linux-foundation.org
Subject: [merged] radix-tree-create-node_tag_set.patch removed from -mm
 tree
Date: Thu, 15 Dec 2016 10:48:39 -0800
Message-ID: <5852e587.Mja9NHAkgczXqgoe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753971AbcLOSsk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: create node_tag_set()
has been removed from the -mm tree.  Its filename was
     radix-tree-create-node_tag_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: create node_tag_set()

Similar to node_tag_clear(), factor node_tag_set() out of
radix_tree_range_tag_if_tagged().

Link: http://lkml.kernel.org/r/1480369871-5271-51-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-create-node_tag_set lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-create-node_tag_set
+++ a/lib/radix-tree.c
@@ -991,6 +991,22 @@ static void node_tag_clear(struct radix_
 		root_tag_clear(root, tag);
 }
 
+static void node_tag_set(struct radix_tree_root *root,
+				struct radix_tree_node *node,
+				unsigned int tag, unsigned int offset)
+{
+	while (node) {
+		if (tag_get(node, tag, offset))
+			return;
+		tag_set(node, tag, offset);
+		offset = node->offset;
+		node = node->parent;
+	}
+
+	if (!root_tag_get(root, tag))
+		root_tag_set(root, tag);
+}
+
 /**
  *	radix_tree_tag_clear - clear a tag on a radix tree node
  *	@root:		radix tree root
@@ -1229,7 +1245,7 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned long nr_to_tag,
 		unsigned int iftag, unsigned int settag)
 {
-	struct radix_tree_node *parent, *node, *child;
+	struct radix_tree_node *node, *child;
 	unsigned long maxindex;
 	unsigned long tagged = 0;
 	unsigned long index = *first_indexp;
@@ -1264,22 +1280,8 @@ unsigned long radix_tree_range_tag_if_ta
 			continue;
 		}
 
-		/* tag the leaf */
 		tagged++;
-		tag_set(node, settag, offset);
-
-		/* walk back up the path tagging interior nodes */
-		parent = node;
-		for (;;) {
-			offset = parent->offset;
-			parent = parent->parent;
-			if (!parent)
-				break;
-			/* stop if we find a node with the tag already set */
-			if (tag_get(parent, settag, offset))
-				break;
-			tag_set(parent, settag, offset);
-		}
+		node_tag_set(root, node, settag, offset);
  next:
 		/* Go to next entry in node */
 		index = ((index >> node->shift) + 1) << node->shift;
@@ -1301,12 +1303,7 @@ unsigned long radix_tree_range_tag_if_ta
 		if (tagged >= nr_to_tag)
 			break;
 	}
-	/*
-	 * We need not to tag the root tag if there is no tag which is set with
-	 * settag within the range from *first_indexp to last_index.
-	 */
-	if (tagged > 0)
-		root_tag_set(root, settag);
+
 	*first_indexp = index;
 
 	return tagged;
_

Patches currently in -mm which might be from willy@linux.intel.com are

reimplement-idr-and-ida-using-the-radix-tree.patch

