From: akpm@linux-foundation.org
Subject: + ksm-separate-stable_node.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:21:50 -0800
Message-ID: <200911132321.nADNLonf032682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417AbZKMXVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:21:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: separate stable_node
has been added to the -mm tree.  Its filename is
     ksm-separate-stable_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: separate stable_node
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Though we still do well to keep rmap_items in the unstable tree without a
separate tree_item at the node, for several reasons it becomes awkward to
keep rmap_items in the stable tree without a separate stable_node: lack of
space in the nicely-sized rmap_item, the need for an anchor as rmap_items
are removed, the need for a node even when temporarily no rmap_items are
attached to it.

So declare struct stable_node (rb_node to place it in the tree and
hlist_head for the rmap_items hanging off it), and convert stable tree
handling to use it: without yet taking advantage of it.  Note how one
stable_tree_insert() of a node now has _two_ stable_tree_append()s of the
two rmap_items being merged.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  180 +++++++++++++++++++++++++++++------------------------
 1 file changed, 101 insertions(+), 79 deletions(-)

diff -puN mm/ksm.c~ksm-separate-stable_node mm/ksm.c
--- a/mm/ksm.c~ksm-separate-stable_node
+++ a/mm/ksm.c
@@ -106,34 +106,44 @@ struct ksm_scan {
 };
 
 /**
+ * struct stable_node - node of the stable rbtree
+ * @node: rb node of this ksm page in the stable tree
+ * @hlist: hlist head of rmap_items using this ksm page
+ */
+struct stable_node {
+	struct rb_node node;
+	struct hlist_head hlist;
+};
+
+/**
  * struct rmap_item - reverse mapping item for virtual addresses
  * @rmap_list: next rmap_item in mm_slot's singly-linked rmap_list
  * @filler: unused space we're making available in this patch
  * @mm: the memory structure this rmap_item is pointing into
  * @address: the virtual address this rmap_item tracks (+ flags in low bits)
  * @oldchecksum: previous checksum of the page at that virtual address
- * @node: rb_node of this rmap_item in either unstable or stable tree
- * @next: next rmap_item hanging off the same node of the stable tree
- * @prev: previous rmap_item hanging off the same node of the stable tree
+ * @node: rb node of this rmap_item in the unstable tree
+ * @head: pointer to stable_node heading this list in the stable tree
+ * @hlist: link into hlist of rmap_items hanging off that stable_node
  */
 struct rmap_item {
 	struct rmap_item *rmap_list;
 	unsigned long filler;
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
+	unsigned int oldchecksum;	/* when unstable */
 	union {
-		unsigned int oldchecksum;		/* when unstable */
-		struct rmap_item *next;			/* when stable */
-	};
-	union {
-		struct rb_node node;			/* when tree node */
-		struct rmap_item *prev;			/* in stable list */
+		struct rb_node node;	/* when node of unstable tree */
+		struct {		/* when listed from stable tree */
+			struct stable_node *head;
+			struct hlist_node hlist;
+		};
 	};
 };
 
 #define SEQNR_MASK	0x0ff	/* low bits of unstable tree seqnr */
-#define NODE_FLAG	0x100	/* is a node of unstable or stable tree */
-#define STABLE_FLAG	0x200	/* is a node or list item of stable tree */
+#define UNSTABLE_FLAG	0x100	/* is a node of the unstable tree */
+#define STABLE_FLAG	0x200	/* is listed from the stable tree */
 
 /* The stable and unstable tree heads */
 static struct rb_root root_stable_tree = RB_ROOT;
@@ -150,6 +160,7 @@ static struct ksm_scan ksm_scan = {
 };
 
 static struct kmem_cache *rmap_item_cache;
+static struct kmem_cache *stable_node_cache;
 static struct kmem_cache *mm_slot_cache;
 
 /* The number of nodes in the stable tree */
@@ -192,13 +203,19 @@ static int __init ksm_slab_init(void)
 	if (!rmap_item_cache)
 		goto out;
 
+	stable_node_cache = KSM_KMEM_CACHE(stable_node, 0);
+	if (!stable_node_cache)
+		goto out_free1;
+
 	mm_slot_cache = KSM_KMEM_CACHE(mm_slot, 0);
 	if (!mm_slot_cache)
-		goto out_free;
+		goto out_free2;
 
 	return 0;
 
-out_free:
+out_free2:
+	kmem_cache_destroy(stable_node_cache);
+out_free1:
 	kmem_cache_destroy(rmap_item_cache);
 out:
 	return -ENOMEM;
@@ -207,6 +224,7 @@ out:
 static void __init ksm_slab_free(void)
 {
 	kmem_cache_destroy(mm_slot_cache);
+	kmem_cache_destroy(stable_node_cache);
 	kmem_cache_destroy(rmap_item_cache);
 	mm_slot_cache = NULL;
 }
@@ -228,6 +246,16 @@ static inline void free_rmap_item(struct
 	kmem_cache_free(rmap_item_cache, rmap_item);
 }
 
+static inline struct stable_node *alloc_stable_node(void)
+{
+	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL);
+}
+
+static inline void free_stable_node(struct stable_node *stable_node)
+{
+	kmem_cache_free(stable_node_cache, stable_node);
+}
+
 static inline struct mm_slot *alloc_mm_slot(void)
 {
 	if (!mm_slot_cache)	/* initialization failed */
@@ -429,36 +457,22 @@ static struct page *get_ksm_page(struct 
  */
 static void remove_rmap_item_from_tree(struct rmap_item *rmap_item)
 {
-	if (in_stable_tree(rmap_item)) {
-		struct rmap_item *next_item = rmap_item->next;
+	if (rmap_item->address & STABLE_FLAG) {
+		struct stable_node *stable_node;
 
-		if (rmap_item->address & NODE_FLAG) {
-			if (next_item) {
-				rb_replace_node(&rmap_item->node,
-						&next_item->node,
-						&root_stable_tree);
-				next_item->address |= NODE_FLAG;
-				ksm_pages_sharing--;
-			} else {
-				rb_erase(&rmap_item->node, &root_stable_tree);
-				ksm_pages_shared--;
-			}
-		} else {
-			struct rmap_item *prev_item = rmap_item->prev;
-
-			BUG_ON(prev_item->next != rmap_item);
-			prev_item->next = next_item;
-			if (next_item) {
-				BUG_ON(next_item->prev != rmap_item);
-				next_item->prev = rmap_item->prev;
-			}
+		stable_node = rmap_item->head;
+		hlist_del(&rmap_item->hlist);
+		if (stable_node->hlist.first)
 			ksm_pages_sharing--;
+		else {
+			rb_erase(&stable_node->node, &root_stable_tree);
+			free_stable_node(stable_node);
+			ksm_pages_shared--;
 		}
 
-		rmap_item->next = NULL;
 		rmap_item->address &= PAGE_MASK;
 
-	} else if (rmap_item->address & NODE_FLAG) {
+	} else if (rmap_item->address & UNSTABLE_FLAG) {
 		unsigned char age;
 		/*
 		 * Usually ksmd can and must skip the rb_erase, because
@@ -859,31 +873,32 @@ up:
  * This function checks if there is a page inside the stable tree
  * with identical content to the page that we are scanning right now.
  *
- * This function return rmap_item pointer to the identical item if found,
+ * This function returns the stable tree node of identical content if found,
  * NULL otherwise.
  */
-static struct rmap_item *stable_tree_search(struct page *page,
-					    struct page **tree_pagep)
+static struct stable_node *stable_tree_search(struct page *page,
+					      struct page **tree_pagep)
 {
 	struct rb_node *node = root_stable_tree.rb_node;
+	struct stable_node *stable_node;
 
 	while (node) {
-		struct rmap_item *tree_rmap_item, *next_rmap_item;
+		struct hlist_node *hlist, *hnext;
+		struct rmap_item *tree_rmap_item;
 		struct page *tree_page;
 		int ret;
 
-		tree_rmap_item = rb_entry(node, struct rmap_item, node);
-		while (tree_rmap_item) {
+		stable_node = rb_entry(node, struct stable_node, node);
+		hlist_for_each_entry_safe(tree_rmap_item, hlist, hnext,
+					&stable_node->hlist, hlist) {
 			BUG_ON(!in_stable_tree(tree_rmap_item));
 			cond_resched();
 			tree_page = get_ksm_page(tree_rmap_item);
 			if (tree_page)
 				break;
-			next_rmap_item = tree_rmap_item->next;
 			remove_rmap_item_from_tree(tree_rmap_item);
-			tree_rmap_item = next_rmap_item;
 		}
-		if (!tree_rmap_item)
+		if (!hlist)
 			return NULL;
 
 		ret = memcmp_pages(page, tree_page);
@@ -896,7 +911,7 @@ static struct rmap_item *stable_tree_sea
 			node = node->rb_right;
 		} else {
 			*tree_pagep = tree_page;
-			return tree_rmap_item;
+			return stable_node;
 		}
 	}
 
@@ -907,31 +922,32 @@ static struct rmap_item *stable_tree_sea
  * stable_tree_insert - insert rmap_item pointing to new ksm page
  * into the stable tree.
  *
- * This function returns rmap_item if success, NULL otherwise.
+ * This function returns the stable tree node just allocated on success,
+ * NULL otherwise.
  */
-static struct rmap_item *stable_tree_insert(struct page *kpage,
-					    struct rmap_item *rmap_item)
+static struct stable_node *stable_tree_insert(struct page *kpage)
 {
 	struct rb_node **new = &root_stable_tree.rb_node;
 	struct rb_node *parent = NULL;
+	struct stable_node *stable_node;
 
 	while (*new) {
-		struct rmap_item *tree_rmap_item, *next_rmap_item;
+		struct hlist_node *hlist, *hnext;
+		struct rmap_item *tree_rmap_item;
 		struct page *tree_page;
 		int ret;
 
-		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
-		while (tree_rmap_item) {
+		stable_node = rb_entry(*new, struct stable_node, node);
+		hlist_for_each_entry_safe(tree_rmap_item, hlist, hnext,
+					&stable_node->hlist, hlist) {
 			BUG_ON(!in_stable_tree(tree_rmap_item));
 			cond_resched();
 			tree_page = get_ksm_page(tree_rmap_item);
 			if (tree_page)
 				break;
-			next_rmap_item = tree_rmap_item->next;
 			remove_rmap_item_from_tree(tree_rmap_item);
-			tree_rmap_item = next_rmap_item;
 		}
-		if (!tree_rmap_item)
+		if (!hlist)
 			return NULL;
 
 		ret = memcmp_pages(kpage, tree_page);
@@ -952,13 +968,16 @@ static struct rmap_item *stable_tree_ins
 		}
 	}
 
-	rmap_item->address |= NODE_FLAG | STABLE_FLAG;
-	rmap_item->next = NULL;
-	rb_link_node(&rmap_item->node, parent, new);
-	rb_insert_color(&rmap_item->node, &root_stable_tree);
+	stable_node = alloc_stable_node();
+	if (!stable_node)
+		return NULL;
 
-	ksm_pages_shared++;
-	return rmap_item;
+	rb_link_node(&stable_node->node, parent, new);
+	rb_insert_color(&stable_node->node, &root_stable_tree);
+
+	INIT_HLIST_HEAD(&stable_node->hlist);
+
+	return stable_node;
 }
 
 /*
@@ -1018,7 +1037,7 @@ struct rmap_item *unstable_tree_search_i
 		}
 	}
 
-	rmap_item->address |= NODE_FLAG;
+	rmap_item->address |= UNSTABLE_FLAG;
 	rmap_item->address |= (ksm_scan.seqnr & SEQNR_MASK);
 	rb_link_node(&rmap_item->node, parent, new);
 	rb_insert_color(&rmap_item->node, &root_unstable_tree);
@@ -1033,18 +1052,16 @@ struct rmap_item *unstable_tree_search_i
  * the same ksm page.
  */
 static void stable_tree_append(struct rmap_item *rmap_item,
-			       struct rmap_item *tree_rmap_item)
+			       struct stable_node *stable_node)
 {
-	rmap_item->next = tree_rmap_item->next;
-	rmap_item->prev = tree_rmap_item;
-
-	if (tree_rmap_item->next)
-		tree_rmap_item->next->prev = rmap_item;
-
-	tree_rmap_item->next = rmap_item;
+	rmap_item->head = stable_node;
 	rmap_item->address |= STABLE_FLAG;
+	hlist_add_head(&rmap_item->hlist, &stable_node->hlist);
 
-	ksm_pages_sharing++;
+	if (rmap_item->hlist.next)
+		ksm_pages_sharing++;
+	else
+		ksm_pages_shared++;
 }
 
 /*
@@ -1060,6 +1077,7 @@ static void cmp_and_merge_page(struct pa
 {
 	struct rmap_item *tree_rmap_item;
 	struct page *tree_page = NULL;
+	struct stable_node *stable_node;
 	struct page *kpage;
 	unsigned int checksum;
 	int err;
@@ -1067,8 +1085,8 @@ static void cmp_and_merge_page(struct pa
 	remove_rmap_item_from_tree(rmap_item);
 
 	/* We first start with searching the page inside the stable tree */
-	tree_rmap_item = stable_tree_search(page, &tree_page);
-	if (tree_rmap_item) {
+	stable_node = stable_tree_search(page, &tree_page);
+	if (stable_node) {
 		kpage = tree_page;
 		if (page == kpage)			/* forked */
 			err = 0;
@@ -1080,7 +1098,7 @@ static void cmp_and_merge_page(struct pa
 			 * The page was successfully merged:
 			 * add its rmap_item to the stable tree.
 			 */
-			stable_tree_append(rmap_item, tree_rmap_item);
+			stable_tree_append(rmap_item, stable_node);
 		}
 		put_page(kpage);
 		return;
@@ -1121,19 +1139,23 @@ static void cmp_and_merge_page(struct pa
 		if (kpage) {
 			remove_rmap_item_from_tree(tree_rmap_item);
 
+			stable_node = stable_tree_insert(kpage);
+			if (stable_node) {
+				stable_tree_append(tree_rmap_item, stable_node);
+				stable_tree_append(rmap_item, stable_node);
+			}
+			put_page(kpage);
+
 			/*
 			 * If we fail to insert the page into the stable tree,
 			 * we will have 2 virtual addresses that are pointing
 			 * to a ksm page left outside the stable tree,
 			 * in which case we need to break_cow on both.
 			 */
-			if (stable_tree_insert(kpage, tree_rmap_item))
-				stable_tree_append(rmap_item, tree_rmap_item);
-			else {
+			if (!stable_node) {
 				break_cow(tree_rmap_item);
 				break_cow(rmap_item);
 			}
-			put_page(kpage);
 		}
 	}
 }
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-three-remove_rmap_item_from_tree-cleanups.patch
ksm-remove-redundancies-when-merging-page.patch
ksm-cleanup-some-function-arguments.patch
ksm-singly-linked-rmap_list.patch
ksm-separate-stable_node.patch
ksm-stable_node-point-to-page-and-back.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

