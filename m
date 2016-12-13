From: akpm@linux-foundation.org
Subject: [patch 063/123] lib: radix-tree: check accounting of existing
 slot replacement users
Date: Mon, 12 Dec 2016 16:43:43 -0800
Message-ID: <584f443f.0SwEQ9Cew+H6IQVj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAnp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: lib: radix-tree: check accounting of existing slot replacement users

The bug in khugepaged fixed earlier in this series shows that radix tree
slot replacement is fragile; and it will become more so when not only
NULL<->!NULL transitions need to be caught but transitions from and to
exceptional entries as well.  We need checks.

Re-implement radix_tree_replace_slot() on top of the sanity-checked
__radix_tree_replace().  This requires existing callers to also pass the
radix tree root, but it'll warn us when somebody replaces slots with
contents that need proper accounting (transitions between NULL entries,
real entries, exceptional entries) and where a replacement through the
slot pointer would corrupt the radix tree node counts.

Link: http://lkml.kernel.org/r/20161117193021.GB23430@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap.c                   |    2 
 drivers/sh/intc/virq.c                |    2 
 fs/dax.c                              |    4 -
 include/linux/radix-tree.h            |   16 ------
 lib/radix-tree.c                      |   63 ++++++++++++++++++------
 mm/filemap.c                          |    4 -
 mm/khugepaged.c                       |    5 +
 mm/migrate.c                          |    4 -
 mm/truncate.c                         |    2 
 tools/testing/radix-tree/multiorder.c |    2 
 10 files changed, 64 insertions(+), 40 deletions(-)

diff -puN arch/s390/mm/gmap.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users arch/s390/mm/gmap.c
--- a/arch/s390/mm/gmap.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/arch/s390/mm/gmap.c
@@ -1015,7 +1015,7 @@ static inline void gmap_insert_rmap(stru
 	if (slot) {
 		rmap->next = radix_tree_deref_slot_protected(slot,
 							&sg->guest_table_lock);
-		radix_tree_replace_slot(slot, rmap);
+		radix_tree_replace_slot(&sg->host_to_rmap, slot, rmap);
 	} else {
 		rmap->next = NULL;
 		radix_tree_insert(&sg->host_to_rmap, vmaddr >> PAGE_SHIFT,
diff -puN drivers/sh/intc/virq.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users drivers/sh/intc/virq.c
--- a/drivers/sh/intc/virq.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/drivers/sh/intc/virq.c
@@ -254,7 +254,7 @@ restart:
 
 		radix_tree_tag_clear(&d->tree, entry->enum_id,
 				     INTC_TAG_VIRQ_NEEDS_ALLOC);
-		radix_tree_replace_slot((void **)entries[i],
+		radix_tree_replace_slot(&d->tree, (void **)entries[i],
 					&intc_irq_xlate[irq]);
 	}
 
diff -puN fs/dax.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users fs/dax.c
--- a/fs/dax.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/fs/dax.c
@@ -342,7 +342,7 @@ static inline void *lock_slot(struct add
 		radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
 
 	entry |= RADIX_DAX_ENTRY_LOCK;
-	radix_tree_replace_slot(slot, (void *)entry);
+	radix_tree_replace_slot(&mapping->page_tree, slot, (void *)entry);
 	return (void *)entry;
 }
 
@@ -356,7 +356,7 @@ static inline void *unlock_slot(struct a
 		radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
 
 	entry &= ~(unsigned long)RADIX_DAX_ENTRY_LOCK;
-	radix_tree_replace_slot(slot, (void *)entry);
+	radix_tree_replace_slot(&mapping->page_tree, slot, (void *)entry);
 	return (void *)entry;
 }
 
diff -puN include/linux/radix-tree.h~lib-radix-tree-check-accounting-of-existing-slot-replacement-users include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/include/linux/radix-tree.h
@@ -249,20 +249,6 @@ static inline int radix_tree_exception(v
 	return unlikely((unsigned long)arg & RADIX_TREE_ENTRY_MASK);
 }
 
-/**
- * radix_tree_replace_slot	- replace item in a slot
- * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
- * @item:	new item to store in the slot.
- *
- * For use with radix_tree_lookup_slot().  Caller must hold tree write locked
- * across slot lookup and replacement.
- */
-static inline void radix_tree_replace_slot(void **pslot, void *item)
-{
-	BUG_ON(radix_tree_is_internal_node(item));
-	rcu_assign_pointer(*pslot, item);
-}
-
 int __radix_tree_create(struct radix_tree_root *root, unsigned long index,
 			unsigned order, struct radix_tree_node **nodep,
 			void ***slotp);
@@ -280,6 +266,8 @@ void **radix_tree_lookup_slot(struct rad
 void __radix_tree_replace(struct radix_tree_root *root,
 			  struct radix_tree_node *node,
 			  void **slot, void *item);
+void radix_tree_replace_slot(struct radix_tree_root *root,
+			     void **slot, void *item);
 bool __radix_tree_delete_node(struct radix_tree_root *root,
 			      struct radix_tree_node *node);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
diff -puN lib/radix-tree.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/lib/radix-tree.c
@@ -753,19 +753,10 @@ void *radix_tree_lookup(struct radix_tre
 }
 EXPORT_SYMBOL(radix_tree_lookup);
 
-/**
- * __radix_tree_replace		- replace item in a slot
- * @root:	radix tree root
- * @node:	pointer to tree node
- * @slot:	pointer to slot in @node
- * @item:	new item to store in the slot.
- *
- * For use with __radix_tree_lookup().  Caller must hold tree write locked
- * across slot lookup and replacement.
- */
-void __radix_tree_replace(struct radix_tree_root *root,
-			  struct radix_tree_node *node,
-			  void **slot, void *item)
+static void replace_slot(struct radix_tree_root *root,
+			 struct radix_tree_node *node,
+			 void **slot, void *item,
+			 bool warn_typeswitch)
 {
 	void *old = rcu_dereference_raw(*slot);
 	int exceptional;
@@ -776,7 +767,7 @@ void __radix_tree_replace(struct radix_t
 	exceptional = !!radix_tree_exceptional_entry(item) -
 		      !!radix_tree_exceptional_entry(old);
 
-	WARN_ON_ONCE(exceptional && !node && slot != (void **)&root->rnode);
+	WARN_ON_ONCE(warn_typeswitch && exceptional);
 
 	if (node)
 		node->exceptional += exceptional;
@@ -785,6 +776,50 @@ void __radix_tree_replace(struct radix_t
 }
 
 /**
+ * __radix_tree_replace		- replace item in a slot
+ * @root:	radix tree root
+ * @node:	pointer to tree node
+ * @slot:	pointer to slot in @node
+ * @item:	new item to store in the slot.
+ *
+ * For use with __radix_tree_lookup().  Caller must hold tree write locked
+ * across slot lookup and replacement.
+ */
+void __radix_tree_replace(struct radix_tree_root *root,
+			  struct radix_tree_node *node,
+			  void **slot, void *item)
+{
+	/*
+	 * This function supports replacing exceptional entries, but
+	 * that needs accounting against the node unless the slot is
+	 * root->rnode.
+	 */
+	replace_slot(root, node, slot, item,
+		     !node && slot != (void **)&root->rnode);
+}
+
+/**
+ * radix_tree_replace_slot	- replace item in a slot
+ * @root:	radix tree root
+ * @slot:	pointer to slot
+ * @item:	new item to store in the slot.
+ *
+ * For use with radix_tree_lookup_slot(), radix_tree_gang_lookup_slot(),
+ * radix_tree_gang_lookup_tag_slot().  Caller must hold tree write locked
+ * across slot lookup and replacement.
+ *
+ * NOTE: This cannot be used to switch between non-entries (empty slots),
+ * regular entries, and exceptional entries, as that requires accounting
+ * inside the radix tree node. When switching from one type of entry to
+ * another, use __radix_tree_lookup() and __radix_tree_replace().
+ */
+void radix_tree_replace_slot(struct radix_tree_root *root,
+			     void **slot, void *item)
+{
+	replace_slot(root, NULL, slot, item, true);
+}
+
+/**
  *	radix_tree_tag_set - set a tag on a radix tree node
  *	@root:		radix tree root
  *	@index:		index key
diff -puN mm/filemap.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users mm/filemap.c
--- a/mm/filemap.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/mm/filemap.c
@@ -147,7 +147,7 @@ static int page_cache_tree_insert(struct
 						      false);
 		}
 	}
-	radix_tree_replace_slot(slot, page);
+	radix_tree_replace_slot(&mapping->page_tree, slot, page);
 	mapping->nrpages++;
 	if (node) {
 		workingset_node_pages_inc(node);
@@ -196,7 +196,7 @@ static void page_cache_tree_delete(struc
 			shadow = NULL;
 		}
 
-		radix_tree_replace_slot(slot, shadow);
+		radix_tree_replace_slot(&mapping->page_tree, slot, shadow);
 
 		if (!node)
 			break;
diff -puN mm/khugepaged.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users mm/khugepaged.c
--- a/mm/khugepaged.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/mm/khugepaged.c
@@ -1426,7 +1426,7 @@ static void collapse_shmem(struct mm_str
 		list_add_tail(&page->lru, &pagelist);
 
 		/* Finally, replace with the new page. */
-		radix_tree_replace_slot(slot,
+		radix_tree_replace_slot(&mapping->page_tree, slot,
 				new_page + (index % HPAGE_PMD_NR));
 
 		slot = radix_tree_iter_next(&iter);
@@ -1538,7 +1538,8 @@ tree_unlocked:
 			/* Unfreeze the page. */
 			list_del(&page->lru);
 			page_ref_unfreeze(page, 2);
-			radix_tree_replace_slot(slot, page);
+			radix_tree_replace_slot(&mapping->page_tree,
+						slot, page);
 			spin_unlock_irq(&mapping->tree_lock);
 			putback_lru_page(page);
 			unlock_page(page);
diff -puN mm/migrate.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users mm/migrate.c
--- a/mm/migrate.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/mm/migrate.c
@@ -482,7 +482,7 @@ int migrate_page_move_mapping(struct add
 		SetPageDirty(newpage);
 	}
 
-	radix_tree_replace_slot(pslot, newpage);
+	radix_tree_replace_slot(&mapping->page_tree, pslot, newpage);
 
 	/*
 	 * Drop cache reference from old page by unfreezing
@@ -556,7 +556,7 @@ int migrate_huge_page_move_mapping(struc
 
 	get_page(newpage);
 
-	radix_tree_replace_slot(pslot, newpage);
+	radix_tree_replace_slot(&mapping->page_tree, pslot, newpage);
 
 	page_ref_unfreeze(page, expected_count - 1);
 
diff -puN mm/truncate.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users mm/truncate.c
--- a/mm/truncate.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/mm/truncate.c
@@ -49,7 +49,7 @@ static void clear_exceptional_entry(stru
 		goto unlock;
 	if (*slot != entry)
 		goto unlock;
-	radix_tree_replace_slot(slot, NULL);
+	radix_tree_replace_slot(&mapping->page_tree, slot, NULL);
 	mapping->nrexceptional--;
 	if (!node)
 		goto unlock;
diff -puN tools/testing/radix-tree/multiorder.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~lib-radix-tree-check-accounting-of-existing-slot-replacement-users
+++ a/tools/testing/radix-tree/multiorder.c
@@ -146,7 +146,7 @@ static void multiorder_check(unsigned lo
 
 	slot = radix_tree_lookup_slot(&tree, index);
 	free(*slot);
-	radix_tree_replace_slot(slot, item2);
+	radix_tree_replace_slot(&tree, slot, item2);
 	for (i = min; i < max; i++) {
 		struct item *item = item_lookup(&tree, i);
 		assert(item != 0);
_
