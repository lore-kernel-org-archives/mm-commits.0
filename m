From: akpm@linux-foundation.org
Subject: [patch 106/162] raxix-tree: introduce
 CONFIG_RADIX_TREE_MULTIORDER
Date: Fri, 20 May 2016 17:01:54 -0700
Message-ID: <573fa572.GQdux1eJw21TBgl7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcEUABz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: raxix-tree: introduce CONFIG_RADIX_TREE_MULTIORDER

I've been receiving increasingly concerned notes from 0day about how much
my recent changes have been bloating the radix tree.  Make it happier by
only including multiorder support if CONFIG_TRANSPARENT_HUGEPAGES is set. 
This is an independent Kconfig option, so other radix tree users can also
set it if they have a need.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig                             |    3 ++
 lib/radix-tree.c                        |   26 +++++++++++++++-------
 mm/Kconfig                              |    1 
 tools/testing/radix-tree/linux/kernel.h |    1 
 4 files changed, 23 insertions(+), 8 deletions(-)

diff -puN lib/Kconfig~introduce-config_radix_tree_multiorder lib/Kconfig
--- a/lib/Kconfig~introduce-config_radix_tree_multiorder
+++ a/lib/Kconfig
@@ -362,6 +362,9 @@ config INTERVAL_TREE
 
 	  for more information.
 
+config RADIX_TREE_MULTIORDER
+	bool
+
 config ASSOCIATIVE_ARRAY
 	bool
 	help
diff -puN lib/radix-tree.c~introduce-config_radix_tree_multiorder lib/radix-tree.c
--- a/lib/radix-tree.c~introduce-config_radix_tree_multiorder
+++ a/lib/radix-tree.c
@@ -484,6 +484,7 @@ int __radix_tree_create(struct radix_tre
 		slot = node->slots[offset];
 	}
 
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
 	/* Insert pointers to the canonical entry */
 	if ((shift - order) > 0) {
 		int i, n = 1 << (shift - order);
@@ -499,6 +500,7 @@ int __radix_tree_create(struct radix_tre
 			node->count++;
 		}
 	}
+#endif
 
 	if (nodep)
 		*nodep = node;
@@ -1469,6 +1471,20 @@ bool __radix_tree_delete_node(struct rad
 	return deleted;
 }
 
+static inline void delete_sibling_entries(struct radix_tree_node *node,
+					void *ptr, unsigned offset)
+{
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	int i;
+	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
+		if (node->slots[offset + i] != ptr)
+			break;
+		node->slots[offset + i] = NULL;
+		node->count--;
+	}
+#endif
+}
+
 /**
  *	radix_tree_delete_item    -    delete an item from a radix tree
  *	@root:		radix tree root
@@ -1484,7 +1500,7 @@ void *radix_tree_delete_item(struct radi
 			     unsigned long index, void *item)
 {
 	struct radix_tree_node *node;
-	unsigned int offset, i;
+	unsigned int offset;
 	void **slot;
 	void *entry;
 	int tag;
@@ -1513,13 +1529,7 @@ void *radix_tree_delete_item(struct radi
 			radix_tree_tag_clear(root, index, tag);
 	}
 
-	/* Delete any sibling slots pointing to this slot */
-	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
-		if (node->slots[offset + i] != ptr_to_indirect(slot))
-			break;
-		node->slots[offset + i] = NULL;
-		node->count--;
-	}
+	delete_sibling_entries(node, ptr_to_indirect(slot), offset);
 	node->slots[offset] = NULL;
 	node->count--;
 
diff -puN mm/Kconfig~introduce-config_radix_tree_multiorder mm/Kconfig
--- a/mm/Kconfig~introduce-config_radix_tree_multiorder
+++ a/mm/Kconfig
@@ -404,6 +404,7 @@ config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select COMPACTION
+	select RADIX_TREE_MULTIORDER
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
 	  huge tlb transparently to the applications whenever possible.
diff -puN tools/testing/radix-tree/linux/kernel.h~introduce-config_radix_tree_multiorder tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~introduce-config_radix_tree_multiorder
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -9,6 +9,7 @@
 
 #include "../../include/linux/compiler.h"
 
+#define CONFIG_RADIX_TREE_MULTIORDER
 #define CONFIG_SHMEM
 #define CONFIG_SWAP
 
_
