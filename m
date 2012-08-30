From: akpm@linux-foundation.org
Subject: + kmemleak-use-rbtree-instead-of-prio-tree.patch added to -mm tree
Date: Thu, 30 Aug 2012 14:34:48 -0700
Message-ID: <20120830213449.AA30420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:42990 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2H3Vex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 17:34:53 -0400
Received: by wgbdt11 with SMTP id dt11so120846wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 14:34:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, catalin.marinas@arm.com, dhillf@gmail.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: kmemleak: use rbtree instead of prio tree
has been added to the -mm tree.  Its filename is
     kmemleak-use-rbtree-instead-of-prio-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: kmemleak: use rbtree instead of prio tree

kmemleak uses a tree where each node represents an allocated memory object
in order to quickly find out what object a given address is part of. 
However, the objects don't overlap, so rbtrees are a better choice than
prio tree for this use.  They are both faster and have lower memory
overhead.

Tested by booting a kernel with kmemleak enabled, loading the
kmemleak_test module, and looking for the expected messages.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   99 ++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 49 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-use-rbtree-instead-of-prio-tree mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-use-rbtree-instead-of-prio-tree
+++ a/mm/kmemleak.c
@@ -29,7 +29,7 @@
  * - kmemleak_lock (rwlock): protects the object_list modifications and
  *   accesses to the object_tree_root. The object_list is the main list
  *   holding the metadata (struct kmemleak_object) for the allocated memory
- *   blocks. The object_tree_root is a priority search tree used to look-up
+ *   blocks. The object_tree_root is a red black tree used to look-up
  *   metadata based on a pointer to the corresponding memory block.  The
  *   kmemleak_object structures are added to the object_list and
  *   object_tree_root in the create_object() function called from the
@@ -71,7 +71,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/kthread.h>
-#include <linux/prio_tree.h>
+#include <linux/rbtree.h>
 #include <linux/fs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -132,7 +132,7 @@ struct kmemleak_scan_area {
  * Structure holding the metadata for each allocated memory block.
  * Modifications to such objects should be made while holding the
  * object->lock. Insertions or deletions from object_list, gray_list or
- * tree_node are already protected by the corresponding locks or mutex (see
+ * rb_node are already protected by the corresponding locks or mutex (see
  * the notes on locking above). These objects are reference-counted
  * (use_count) and freed using the RCU mechanism.
  */
@@ -141,7 +141,7 @@ struct kmemleak_object {
 	unsigned long flags;		/* object status flags */
 	struct list_head object_list;
 	struct list_head gray_list;
-	struct prio_tree_node tree_node;
+	struct rb_node rb_node;
 	struct rcu_head rcu;		/* object_list lockless traversal */
 	/* object usage count; object freed when use_count == 0 */
 	atomic_t use_count;
@@ -182,9 +182,9 @@ struct kmemleak_object {
 static LIST_HEAD(object_list);
 /* the list of gray-colored objects (see color_gray comment below) */
 static LIST_HEAD(gray_list);
-/* prio search tree for object boundaries */
-static struct prio_tree_root object_tree_root;
-/* rw_lock protecting the access to object_list and prio_tree_root */
+/* search tree for object boundaries */
+static struct rb_root object_tree_root = RB_ROOT;
+/* rw_lock protecting the access to object_list and object_tree_root */
 static DEFINE_RWLOCK(kmemleak_lock);
 
 /* allocation caches for kmemleak internal data */
@@ -380,7 +380,7 @@ static void dump_object_info(struct kmem
 	trace.entries = object->trace;
 
 	pr_notice("Object 0x%08lx (size %zu):\n",
-		  object->tree_node.start, object->size);
+		  object->pointer, object->size);
 	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
 		  object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
@@ -392,32 +392,32 @@ static void dump_object_info(struct kmem
 }
 
 /*
- * Look-up a memory block metadata (kmemleak_object) in the priority search
+ * Look-up a memory block metadata (kmemleak_object) in the object search
  * tree based on a pointer value. If alias is 0, only values pointing to the
  * beginning of the memory block are allowed. The kmemleak_lock must be held
  * when calling this function.
  */
 static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 {
-	struct prio_tree_node *node;
-	struct prio_tree_iter iter;
-	struct kmemleak_object *object;
+	struct rb_node *rb = object_tree_root.rb_node;
 
-	prio_tree_iter_init(&iter, &object_tree_root, ptr, ptr);
-	node = prio_tree_next(&iter);
-	if (node) {
-		object = prio_tree_entry(node, struct kmemleak_object,
-					 tree_node);
-		if (!alias && object->pointer != ptr) {
+	while (rb) {
+		struct kmemleak_object *object =
+			rb_entry(rb, struct kmemleak_object, rb_node);
+		if (ptr < object->pointer)
+			rb = object->rb_node.rb_left;
+		else if (object->pointer + object->size <= ptr)
+			rb = object->rb_node.rb_right;
+		else if (object->pointer == ptr || alias)
+			return object;
+		else {
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
 				      ptr);
 			dump_object_info(object);
-			object = NULL;
+			break;
 		}
-	} else
-		object = NULL;
-
-	return object;
+	}
+	return NULL;
 }
 
 /*
@@ -471,7 +471,7 @@ static void put_object(struct kmemleak_o
 }
 
 /*
- * Look up an object in the prio search tree and increase its use_count.
+ * Look up an object in the object search tree and increase its use_count.
  */
 static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
 {
@@ -516,8 +516,8 @@ static struct kmemleak_object *create_ob
 					     int min_count, gfp_t gfp)
 {
 	unsigned long flags;
-	struct kmemleak_object *object;
-	struct prio_tree_node *node;
+	struct kmemleak_object *object, *parent;
+	struct rb_node **link, *rb_parent;
 
 	object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
 	if (!object) {
@@ -560,32 +560,34 @@ static struct kmemleak_object *create_ob
 	/* kernel backtrace */
 	object->trace_len = __save_stack_trace(object->trace);
 
-	INIT_PRIO_TREE_NODE(&object->tree_node);
-	object->tree_node.start = ptr;
-	object->tree_node.last = ptr + size - 1;
-
 	write_lock_irqsave(&kmemleak_lock, flags);
 
 	min_addr = min(min_addr, ptr);
 	max_addr = max(max_addr, ptr + size);
-	node = prio_tree_insert(&object_tree_root, &object->tree_node);
-	/*
-	 * The code calling the kernel does not yet have the pointer to the
-	 * memory block to be able to free it.  However, we still hold the
-	 * kmemleak_lock here in case parts of the kernel started freeing
-	 * random memory blocks.
-	 */
-	if (node != &object->tree_node) {
-		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
-			      "(already existing)\n", ptr);
-		kmem_cache_free(object_cache, object);
-		object = lookup_object(ptr, 1);
-		spin_lock(&object->lock);
-		dump_object_info(object);
-		spin_unlock(&object->lock);
-
-		goto out;
+	link = &object_tree_root.rb_node;
+	rb_parent = NULL;
+	while (*link) {
+		rb_parent = *link;
+		parent = rb_entry(rb_parent, struct kmemleak_object, rb_node);
+		if (ptr + size <= parent->pointer)
+			link = &parent->rb_node.rb_left;
+		else if (parent->pointer + parent->size <= ptr)
+			link = &parent->rb_node.rb_right;
+		else {
+			kmemleak_stop("Cannot insert 0x%lx into the object "
+				      "search tree (overlaps existing)\n",
+				      ptr);
+			kmem_cache_free(object_cache, object);
+			object = parent;
+			spin_lock(&object->lock);
+			dump_object_info(object);
+			spin_unlock(&object->lock);
+			goto out;
+		}
 	}
+	rb_link_node(&object->rb_node, rb_parent, link);
+	rb_insert_color(&object->rb_node, &object_tree_root);
+
 	list_add_tail_rcu(&object->object_list, &object_list);
 out:
 	write_unlock_irqrestore(&kmemleak_lock, flags);
@@ -601,7 +603,7 @@ static void __delete_object(struct kmeml
 	unsigned long flags;
 
 	write_lock_irqsave(&kmemleak_lock, flags);
-	prio_tree_remove(&object_tree_root, &object->tree_node);
+	rb_erase(&object->rb_node, &object_tree_root);
 	list_del_rcu(&object->object_list);
 	write_unlock_irqrestore(&kmemleak_lock, flags);
 
@@ -1769,7 +1771,6 @@ void __init kmemleak_init(void)
 
 	object_cache = KMEM_CACHE(kmemleak_object, SLAB_NOLEAKTRACE);
 	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);
-	INIT_PRIO_TREE_ROOT(&object_tree_root);
 
 	if (crt_early_log >= ARRAY_SIZE(early_log))
 		pr_warning("Early log buffer exceeded (%d), please increase "
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-adjust-final-endif-position-in-mm-internalh.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch

