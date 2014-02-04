From: akpm@linux-foundation.org
Subject: + lib-radix_tree-tree-node-interface.patch added to -mm tree
Date: Tue, 04 Feb 2014 15:14:55 -0800
Message-ID: <52f1746f.jcKNR3nsW/jHIr8v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935943AbaBDXO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 18:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: + lib-radix_tree-tree-node-interface.patch added to -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 15:14:55 -0800


The patch titled
     Subject: lib: radix_tree: tree node interface
has been added to the -mm tree.  Its filename is
     lib-radix_tree-tree-node-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-radix_tree-tree-node-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-radix_tree-tree-node-interface.patch

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
Subject: lib: radix_tree: tree node interface

Make struct radix_tree_node part of the public interface and provide API
functions to create, look up, and delete whole nodes.  Refactor the
existing insert, look up, delete functions on top of these new node
primitives.

This will allow the VM to track and garbage collect page cache radix tree
nodes.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   34 ++++
 lib/radix-tree.c           |  261 +++++++++++++++++++----------------
 2 files changed, 180 insertions(+), 115 deletions(-)

diff -puN include/linux/radix-tree.h~lib-radix_tree-tree-node-interface include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix_tree-tree-node-interface
+++ a/include/linux/radix-tree.h
@@ -60,6 +60,33 @@ static inline int radix_tree_is_indirect
 
 #define RADIX_TREE_MAX_TAGS 3
 
+#ifdef __KERNEL__
+#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
+#else
+#define RADIX_TREE_MAP_SHIFT	3	/* For more stressful testing */
+#endif
+
+#define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
+#define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
+
+#define RADIX_TREE_TAG_LONGS	\
+	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
+
+struct radix_tree_node {
+	unsigned int	height;		/* Height from the bottom */
+	unsigned int	count;
+	union {
+		struct radix_tree_node *parent;	/* Used when ascending tree */
+		struct rcu_head	rcu_head;	/* Used when freeing node */
+	};
+	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
+	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
+};
+
+#define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
+#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
+					  RADIX_TREE_MAP_SHIFT))
+
 /* root tags are stored in gfp_mask, shifted by __GFP_BITS_SHIFT */
 struct radix_tree_root {
 	unsigned int		height;
@@ -101,6 +128,7 @@ do {									\
  *   concurrently with other readers.
  *
  * The notable exceptions to this rule are the following functions:
+ * __radix_tree_lookup
  * radix_tree_lookup
  * radix_tree_lookup_slot
  * radix_tree_tag_get
@@ -216,9 +244,15 @@ static inline void radix_tree_replace_sl
 	rcu_assign_pointer(*pslot, item);
 }
 
+int __radix_tree_create(struct radix_tree_root *root, unsigned long index,
+			struct radix_tree_node **nodep, void ***slotp);
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
+void *__radix_tree_lookup(struct radix_tree_root *root, unsigned long index,
+			  struct radix_tree_node **nodep, void ***slotp);
 void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
 void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+bool __radix_tree_delete_node(struct radix_tree_root *root, unsigned long index,
+			      struct radix_tree_node *node);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
 unsigned int
diff -puN lib/radix-tree.c~lib-radix_tree-tree-node-interface lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix_tree-tree-node-interface
+++ a/lib/radix-tree.c
@@ -35,33 +35,6 @@
 #include <linux/hardirq.h>		/* in_interrupt() */
 
 
-#ifdef __KERNEL__
-#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
-#else
-#define RADIX_TREE_MAP_SHIFT	3	/* For more stressful testing */
-#endif
-
-#define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
-#define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
-
-#define RADIX_TREE_TAG_LONGS	\
-	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
-
-struct radix_tree_node {
-	unsigned int	height;		/* Height from the bottom */
-	unsigned int	count;
-	union {
-		struct radix_tree_node *parent;	/* Used when ascending tree */
-		struct rcu_head	rcu_head;	/* Used when freeing node */
-	};
-	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
-	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
-};
-
-#define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
-#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
-					  RADIX_TREE_MAP_SHIFT))
-
 /*
  * The height_to_maxindex array needs to be one deeper than the maximum
  * path as height 0 holds only 1 entry.
@@ -387,23 +360,28 @@ out:
 }
 
 /**
- *	radix_tree_insert    -    insert into a radix tree
+ *	__radix_tree_create	-	create a slot in a radix tree
  *	@root:		radix tree root
  *	@index:		index key
- *	@item:		item to insert
+ *	@nodep:		returns node
+ *	@slotp:		returns slot
  *
- *	Insert an item into the radix tree at position @index.
+ *	Create, if necessary, and return the node and slot for an item
+ *	at position @index in the radix tree @root.
+ *
+ *	Until there is more than one item in the tree, no nodes are
+ *	allocated and @root->rnode is used as a direct slot instead of
+ *	pointing to a node, in which case *@nodep will be NULL.
+ *
+ *	Returns -ENOMEM, or 0 for success.
  */
-int radix_tree_insert(struct radix_tree_root *root,
-			unsigned long index, void *item)
+int __radix_tree_create(struct radix_tree_root *root, unsigned long index,
+			struct radix_tree_node **nodep, void ***slotp)
 {
 	struct radix_tree_node *node = NULL, *slot;
-	unsigned int height, shift;
-	int offset;
+	unsigned int height, shift, offset;
 	int error;
 
-	BUG_ON(radix_tree_is_indirect_ptr(item));
-
 	/* Make sure the tree is high enough.  */
 	if (index > radix_tree_maxindex(root->height)) {
 		error = radix_tree_extend(root, index);
@@ -439,16 +417,40 @@ int radix_tree_insert(struct radix_tree_
 		height--;
 	}
 
-	if (slot != NULL)
+	if (nodep)
+		*nodep = node;
+	if (slotp)
+		*slotp = node ? node->slots + offset : (void **)&root->rnode;
+	return 0;
+}
+
+/**
+ *	radix_tree_insert    -    insert into a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@item:		item to insert
+ *
+ *	Insert an item into the radix tree at position @index.
+ */
+int radix_tree_insert(struct radix_tree_root *root,
+			unsigned long index, void *item)
+{
+	struct radix_tree_node *node;
+	void **slot;
+	int error;
+
+	BUG_ON(radix_tree_is_indirect_ptr(item));
+
+	error = __radix_tree_create(root, index, &node, &slot);
+	if (*slot != NULL)
 		return -EEXIST;
+	rcu_assign_pointer(*slot, item);
 
 	if (node) {
 		node->count++;
-		rcu_assign_pointer(node->slots[offset], item);
-		BUG_ON(tag_get(node, 0, offset));
-		BUG_ON(tag_get(node, 1, offset));
+		BUG_ON(tag_get(node, 0, index & RADIX_TREE_MAP_MASK));
+		BUG_ON(tag_get(node, 1, index & RADIX_TREE_MAP_MASK));
 	} else {
-		rcu_assign_pointer(root->rnode, item);
 		BUG_ON(root_tag_get(root, 0));
 		BUG_ON(root_tag_get(root, 1));
 	}
@@ -457,15 +459,26 @@ int radix_tree_insert(struct radix_tree_
 }
 EXPORT_SYMBOL(radix_tree_insert);
 
-/*
- * is_slot == 1 : search for the slot.
- * is_slot == 0 : search for the node.
+/**
+ *	__radix_tree_lookup	-	lookup an item in a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@nodep:		returns node
+ *	@slotp:		returns slot
+ *
+ *	Lookup and return the item at position @index in the radix
+ *	tree @root.
+ *
+ *	Until there is more than one item in the tree, no nodes are
+ *	allocated and @root->rnode is used as a direct slot instead of
+ *	pointing to a node, in which case *@nodep will be NULL.
  */
-static void *radix_tree_lookup_element(struct radix_tree_root *root,
-				unsigned long index, int is_slot)
+void *__radix_tree_lookup(struct radix_tree_root *root, unsigned long index,
+			  struct radix_tree_node **nodep, void ***slotp)
 {
+	struct radix_tree_node *node, *parent;
 	unsigned int height, shift;
-	struct radix_tree_node *node, **slot;
+	void **slot;
 
 	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
@@ -474,7 +487,12 @@ static void *radix_tree_lookup_element(s
 	if (!radix_tree_is_indirect_ptr(node)) {
 		if (index > 0)
 			return NULL;
-		return is_slot ? (void *)&root->rnode : node;
+
+		if (nodep)
+			*nodep = NULL;
+		if (slotp)
+			*slotp = (void **)&root->rnode;
+		return node;
 	}
 	node = indirect_to_ptr(node);
 
@@ -485,8 +503,8 @@ static void *radix_tree_lookup_element(s
 	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
 
 	do {
-		slot = (struct radix_tree_node **)
-			(node->slots + ((index>>shift) & RADIX_TREE_MAP_MASK));
+		parent = node;
+		slot = node->slots + ((index >> shift) & RADIX_TREE_MAP_MASK);
 		node = rcu_dereference_raw(*slot);
 		if (node == NULL)
 			return NULL;
@@ -495,7 +513,11 @@ static void *radix_tree_lookup_element(s
 		height--;
 	} while (height > 0);
 
-	return is_slot ? (void *)slot : indirect_to_ptr(node);
+	if (nodep)
+		*nodep = parent;
+	if (slotp)
+		*slotp = slot;
+	return node;
 }
 
 /**
@@ -513,7 +535,11 @@ static void *radix_tree_lookup_element(s
  */
 void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
 {
-	return (void **)radix_tree_lookup_element(root, index, 1);
+	void **slot;
+
+	if (!__radix_tree_lookup(root, index, NULL, &slot))
+		return NULL;
+	return slot;
 }
 EXPORT_SYMBOL(radix_tree_lookup_slot);
 
@@ -531,7 +557,7 @@ EXPORT_SYMBOL(radix_tree_lookup_slot);
  */
 void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
 {
-	return radix_tree_lookup_element(root, index, 0);
+	return __radix_tree_lookup(root, index, NULL, NULL);
 }
 EXPORT_SYMBOL(radix_tree_lookup);
 
@@ -1260,6 +1286,56 @@ static inline void radix_tree_shrink(str
 }
 
 /**
+ *	__radix_tree_delete_node    -    try to free node after clearing a slot
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@node:		node containing @index
+ *
+ *	After clearing the slot at @index in @node from radix tree
+ *	rooted at @root, call this function to attempt freeing the
+ *	node and shrinking the tree.
+ *
+ *	Returns %true if @node was freed, %false otherwise.
+ */
+bool __radix_tree_delete_node(struct radix_tree_root *root, unsigned long index,
+			      struct radix_tree_node *node)
+{
+	bool deleted = false;
+
+	do {
+		struct radix_tree_node *parent;
+
+		if (node->count) {
+			if (node == indirect_to_ptr(root->rnode)) {
+				radix_tree_shrink(root);
+				if (root->height == 0)
+					deleted = true;
+			}
+			return deleted;
+		}
+
+		parent = node->parent;
+		if (parent) {
+			index >>= RADIX_TREE_MAP_SHIFT;
+
+			parent->slots[index & RADIX_TREE_MAP_MASK] = NULL;
+			parent->count--;
+		} else {
+			root_tag_clear_all(root);
+			root->height = 0;
+			root->rnode = NULL;
+		}
+
+		radix_tree_node_free(node);
+		deleted = true;
+
+		node = parent;
+	} while (node);
+
+	return deleted;
+}
+
+/**
  *	radix_tree_delete_item    -    delete an item from a radix tree
  *	@root:		radix tree root
  *	@index:		index key
@@ -1273,43 +1349,26 @@ static inline void radix_tree_shrink(str
 void *radix_tree_delete_item(struct radix_tree_root *root,
 			     unsigned long index, void *item)
 {
-	struct radix_tree_node *node = NULL;
-	struct radix_tree_node *slot = NULL;
-	struct radix_tree_node *to_free;
-	unsigned int height, shift;
+	struct radix_tree_node *node;
+	unsigned int offset;
+	void **slot;
+	void *entry;
 	int tag;
-	int uninitialized_var(offset);
 
-	height = root->height;
-	if (index > radix_tree_maxindex(height))
-		goto out;
+	entry = __radix_tree_lookup(root, index, &node, &slot);
+	if (!entry)
+		return NULL;
 
-	slot = root->rnode;
-	if (height == 0) {
+	if (item && entry != item)
+		return NULL;
+
+	if (!node) {
 		root_tag_clear_all(root);
 		root->rnode = NULL;
-		goto out;
+		return entry;
 	}
-	slot = indirect_to_ptr(slot);
-	shift = height * RADIX_TREE_MAP_SHIFT;
 
-	do {
-		if (slot == NULL)
-			goto out;
-
-		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		node = slot;
-		slot = slot->slots[offset];
-	} while (shift);
-
-	if (slot == NULL)
-		goto out;
-
-	if (item && slot != item) {
-		slot = NULL;
-		goto out;
-	}
+	offset = index & RADIX_TREE_MAP_MASK;
 
 	/*
 	 * Clear all tags associated with the item to be deleted.
@@ -1320,40 +1379,12 @@ void *radix_tree_delete_item(struct radi
 			radix_tree_tag_clear(root, index, tag);
 	}
 
-	to_free = NULL;
-	/* Now free the nodes we do not need anymore */
-	while (node) {
-		node->slots[offset] = NULL;
-		node->count--;
-		/*
-		 * Queue the node for deferred freeing after the
-		 * last reference to it disappears (set NULL, above).
-		 */
-		if (to_free)
-			radix_tree_node_free(to_free);
-
-		if (node->count) {
-			if (node == indirect_to_ptr(root->rnode))
-				radix_tree_shrink(root);
-			goto out;
-		}
-
-		/* Node with zero slots in use so free it */
-		to_free = node;
-
-		index >>= RADIX_TREE_MAP_SHIFT;
-		offset = index & RADIX_TREE_MAP_MASK;
-		node = node->parent;
-	}
+	node->slots[offset] = NULL;
+	node->count--;
 
-	root_tag_clear_all(root);
-	root->height = 0;
-	root->rnode = NULL;
-	if (to_free)
-		radix_tree_node_free(to_free);
+	__radix_tree_delete_node(root, index, node);
 
-out:
-	return slot;
+	return entry;
 }
 EXPORT_SYMBOL(radix_tree_delete_item);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

