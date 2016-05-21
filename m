From: akpm@linux-foundation.org
Subject: [patch 107/162] radix-tree: add missing sibling entry
 functionality
Date: Fri, 20 May 2016 17:01:57 -0700
Message-ID: <573fa575.9fXijM8gDaar+f8K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcEUAB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: add missing sibling entry functionality

The code I previously added to enable multiorder radix tree entries was
untested and therefore buggy.  This commit adds the support functions that
Ross and I decided were necessary over a four-week period of iterating
various designs.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN lib/radix-tree.c~radix-tree-add-missing-sibling-entry-functionality lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-missing-sibling-entry-functionality
+++ a/lib/radix-tree.c
@@ -80,6 +80,46 @@ static inline void *indirect_to_ptr(void
 	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
 
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+/* Sibling slots point directly to another slot in the same node */
+static inline bool is_sibling_entry(struct radix_tree_node *parent, void *node)
+{
+	void **ptr = node;
+	return (parent->slots <= ptr) &&
+			(ptr < parent->slots + RADIX_TREE_MAP_SIZE);
+}
+#else
+static inline bool is_sibling_entry(struct radix_tree_node *parent, void *node)
+{
+	return false;
+}
+#endif
+
+static inline unsigned long get_slot_offset(struct radix_tree_node *parent,
+						 void **slot)
+{
+	return slot - parent->slots;
+}
+
+static unsigned radix_tree_descend(struct radix_tree_node *parent,
+				struct radix_tree_node **nodep, unsigned offset)
+{
+	void **entry = rcu_dereference_raw(parent->slots[offset]);
+
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	if (radix_tree_is_indirect_ptr(entry)) {
+		unsigned long siboff = get_slot_offset(parent, entry);
+		if (siboff < RADIX_TREE_MAP_SIZE) {
+			offset = siboff;
+			entry = rcu_dereference_raw(parent->slots[offset]);
+		}
+	}
+#endif
+
+	*nodep = (void *)entry;
+	return offset;
+}
+
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
 	return root->gfp_mask & __GFP_BITS_MASK;
_
