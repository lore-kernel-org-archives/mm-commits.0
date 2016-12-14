From: akpm@linux-foundation.org
Subject: [patch 093/114] radix-tree: move rcu_head into a union with
 private_list
Date: Wed, 14 Dec 2016 15:08:34 -0800
Message-ID: <5851d0f2.DJUlDAJHknbtzQOa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933077AbcLNXIl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@infradead.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@infradead.org>
Subject: radix-tree: move rcu_head into a union with private_list

I want to be able to reference node->parent after freeing node.  Currently
node->parent is in a union with rcu_head, so it is overwritten when the
node is put on the RCU list.  We know that private_list is not referenced
after the node is freed, so it is safe for these two members to share
space.

Link: http://lkml.kernel.org/r/1480369871-5271-50-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   14 ++++----------
 lib/radix-tree.c           |    1 +
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-move-rcu_head-into-a-union-with-private_list include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-move-rcu_head-into-a-union-with-private_list
+++ a/include/linux/radix-tree.h
@@ -85,18 +85,12 @@ struct radix_tree_node {
 	unsigned char	offset;		/* Slot offset in parent */
 	unsigned char	count;		/* Total entry count */
 	unsigned char	exceptional;	/* Exceptional entry count */
+	struct radix_tree_node *parent;		/* Used when ascending tree */
+	void *private_data;			/* For tree user */
 	union {
-		struct {
-			/* Used when ascending tree */
-			struct radix_tree_node *parent;
-			/* For tree user */
-			void *private_data;
-		};
-		/* Used when freeing node */
-		struct rcu_head	rcu_head;
+		struct list_head private_list;	/* For tree user */
+		struct rcu_head	rcu_head;	/* Used when freeing node */
 	};
-	/* For tree user */
-	struct list_head private_list;
 	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
diff -puN lib/radix-tree.c~radix-tree-move-rcu_head-into-a-union-with-private_list lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-move-rcu_head-into-a-union-with-private_list
+++ a/lib/radix-tree.c
@@ -325,6 +325,7 @@ static void radix_tree_node_rcu_free(str
 		tag_clear(node, i, 0);
 
 	node->slots[0] = NULL;
+	INIT_LIST_HEAD(&node->private_list);
 
 	kmem_cache_free(radix_tree_node_cachep, node);
 }
_
