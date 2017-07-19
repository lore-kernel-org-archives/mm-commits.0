From: akpm@linux-foundation.org
Subject: + rbtree-cache-leftmost-node-internally.patch added to -mm tree
Date: Wed, 19 Jul 2017 15:52:56 -0700
Message-ID: <596fe2c8.PbjkQrJIhwVCa1o+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932861AbdGSWw5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, airlied@linux.ie, axboe@fb.com, benve@cisco.com, christian.koenig@amd.com, dbueso@suse.de, dledford@redhat.com, hch@infradead.org, jack@suse.cz, jasowang@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, mst@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: cache leftmost node internally
has been added to the -mm tree.  Its filename is
     rbtree-cache-leftmost-node-internally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-cache-leftmost-node-internally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-cache-leftmost-node-internally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: rbtree: cache leftmost node internally

Patch series "rbtree: Cache leftmost node internally", v3.

A series to extending rbtrees to internally cache the leftmost node such
that we can have fast overlap check optimization for all interval tree
users[1].  The benefits of this series are that:

(i)   Unify users that do internal leftmost node caching.
(ii)  Optimize all interval tree users.
(iii) Convert at least two new users (epoll and procfs) to the new interface.

Patch 1: Layout the rb machinery.

Patches 2-5:  Make use of the internal leftmost node in scheduler and
rt mutexes and cfq.

Patch 6: Implements fast overlap checks for interval trees.

Patch 7: rocket science.

Patches 8,9: New patches that convert to O(1) rb_first_cached().



This patch (of 9):

Red-black tree semantics imply that nodes with smaller or greater (or
equal for duplicates) keys always be to the left and right, respectively. 
For the kernel this is extremely evident when considering our rb_first()
semantics.  Enabling lookups for the smallest node in the tree in O(1) can
save a good chunk of cycles in not having to walk down the tree each time.
To this end there are a few core users that explicitly do this, such as
the scheduler and rtmutexes.  There is also the desire for interval trees
to have this optimization allowing faster overlap checking.

This patch introduces a new 'struct rb_root_cached' which is just the root
with a cached pointer to the leftmost node.  The reason why the regular
rb_root was not extended instead of adding a new structure was that this
allows the user to have the choice between memory footprint and actual
tree performance.  The new wrappers on top of the regular rb_root calls
are:

- rb_first_cached(cached_root) -- which is a fast replacement
     for rb_first.

- rb_insert_color_cached(node, cached_root, new)

- rb_erase_cached(node, cached_root)

In addition, augmented cached interfaces are also added for basic
insertion and deletion operations; which becomes important for the
interval tree changes.

With the exception of the inserts, which adds a bool for updating the new
leftmost, the interfaces are kept the same.  To this end, porting rb users
to the cached version becomes really trivial, and keeping current rbtree
semantics for users that don't care about the optimization requires zero
overhead.

Link: http://lkml.kernel.org/r/20170629171553.2146-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h           |   11 +++++++++
 include/linux/rbtree_augmented.h |   33 +++++++++++++++++++++++++---
 lib/rbtree.c                     |   34 ++++++++++++++++++++++++-----
 3 files changed, 70 insertions(+), 8 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-cache-leftmost-node-internally include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-cache-leftmost-node-internally
+++ a/include/linux/rbtree.h
@@ -44,10 +44,15 @@ struct rb_root {
 	struct rb_node *rb_node;
 };
 
+struct rb_root_cached {
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+};
 
 #define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3))
 
 #define RB_ROOT	(struct rb_root) { NULL, }
+#define RB_ROOT_CACHED (struct rb_root_cached) { {NULL, }, NULL }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)  (READ_ONCE((root)->rb_node) == NULL)
@@ -69,6 +74,12 @@ extern struct rb_node *rb_prev(const str
 extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);
 
+extern void rb_insert_color_cached(struct rb_node *,
+				   struct rb_root_cached *, bool);
+extern void rb_erase_cached(struct rb_node *node, struct rb_root_cached *);
+/* Same as rb_first(), but O(1) */
+#define rb_first_cached(root) (root)->rb_leftmost
+
 /* Postorder iteration - always visit the parent after its children */
 extern struct rb_node *rb_first_postorder(const struct rb_root *);
 extern struct rb_node *rb_next_postorder(const struct rb_node *);
diff -puN include/linux/rbtree_augmented.h~rbtree-cache-leftmost-node-internally include/linux/rbtree_augmented.h
--- a/include/linux/rbtree_augmented.h~rbtree-cache-leftmost-node-internally
+++ a/include/linux/rbtree_augmented.h
@@ -41,7 +41,9 @@ struct rb_augment_callbacks {
 	void (*rotate)(struct rb_node *old, struct rb_node *new);
 };
 
-extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+extern void __rb_insert_augmented(struct rb_node *node,
+				  struct rb_root *root,
+				  bool newleft, struct rb_node **leftmost,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
 /*
  * Fixup the rbtree and update the augmented information when rebalancing.
@@ -57,7 +59,16 @@ static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
 {
-	__rb_insert_augmented(node, root, augment->rotate);
+	__rb_insert_augmented(node, root, false, NULL, augment->rotate);
+}
+
+static inline void
+rb_insert_augmented_cached(struct rb_node *node,
+			   struct rb_root_cached *root, bool newleft,
+			   const struct rb_augment_callbacks *augment)
+{
+	__rb_insert_augmented(node, &root->rb_root,
+			      newleft, &root->rb_leftmost, augment->rotate);
 }
 
 #define RB_DECLARE_CALLBACKS(rbstatic, rbname, rbstruct, rbfield,	\
@@ -150,6 +161,7 @@ extern void __rb_erase_color(struct rb_n
 
 static __always_inline struct rb_node *
 __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		     struct rb_node **leftmost,
 		     const struct rb_augment_callbacks *augment)
 {
 	struct rb_node *child = node->rb_right;
@@ -157,6 +169,9 @@ __rb_erase_augmented(struct rb_node *nod
 	struct rb_node *parent, *rebalance;
 	unsigned long pc;
 
+	if (leftmost && node == *leftmost)
+		*leftmost = rb_next(node);
+
 	if (!tmp) {
 		/*
 		 * Case 1: node to erase has no more than 1 child (easy!)
@@ -256,9 +271,21 @@ static __always_inline void
 rb_erase_augmented(struct rb_node *node, struct rb_root *root,
 		   const struct rb_augment_callbacks *augment)
 {
-	struct rb_node *rebalance = __rb_erase_augmented(node, root, augment);
+	struct rb_node *rebalance = __rb_erase_augmented(node, root,
+							 NULL, augment);
 	if (rebalance)
 		__rb_erase_color(rebalance, root, augment->rotate);
 }
 
+static __always_inline void
+rb_erase_augmented_cached(struct rb_node *node, struct rb_root_cached *root,
+			  const struct rb_augment_callbacks *augment)
+{
+	struct rb_node *rebalance = __rb_erase_augmented(node, &root->rb_root,
+							 &root->rb_leftmost,
+							 augment);
+	if (rebalance)
+		__rb_erase_color(rebalance, &root->rb_root, augment->rotate);
+}
+
 #endif	/* _LINUX_RBTREE_AUGMENTED_H */
diff -puN lib/rbtree.c~rbtree-cache-leftmost-node-internally lib/rbtree.c
--- a/lib/rbtree.c~rbtree-cache-leftmost-node-internally
+++ a/lib/rbtree.c
@@ -95,10 +95,14 @@ __rb_rotate_set_parents(struct rb_node *
 
 static __always_inline void
 __rb_insert(struct rb_node *node, struct rb_root *root,
+	    bool newleft, struct rb_node **leftmost,
 	    void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
 	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
 
+	if (newleft)
+		*leftmost = node;
+
 	while (true) {
 		/*
 		 * Loop invariant: node is red
@@ -434,19 +438,38 @@ static const struct rb_augment_callbacks
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
-	__rb_insert(node, root, dummy_rotate);
+	__rb_insert(node, root, false, NULL, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_insert_color);
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *rebalance;
-	rebalance = __rb_erase_augmented(node, root, &dummy_callbacks);
+	rebalance = __rb_erase_augmented(node, root,
+					 NULL, &dummy_callbacks);
 	if (rebalance)
 		____rb_erase_color(rebalance, root, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_erase);
 
+void rb_insert_color_cached(struct rb_node *node,
+			    struct rb_root_cached *root, bool leftmost)
+{
+	__rb_insert(node, &root->rb_root, leftmost,
+		    &root->rb_leftmost, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_insert_color_cached);
+
+void rb_erase_cached(struct rb_node *node, struct rb_root_cached *root)
+{
+	struct rb_node *rebalance;
+	rebalance = __rb_erase_augmented(node, &root->rb_root,
+					 &root->rb_leftmost, &dummy_callbacks);
+	if (rebalance)
+		____rb_erase_color(rebalance, &root->rb_root, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_erase_cached);
+
 /*
  * Augmented rbtree manipulation functions.
  *
@@ -455,9 +478,10 @@ EXPORT_SYMBOL(rb_erase);
  */
 
 void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+			   bool newleft, struct rb_node **leftmost,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
-	__rb_insert(node, root, augment_rotate);
+	__rb_insert(node, root, newleft, leftmost, augment_rotate);
 }
 EXPORT_SYMBOL(__rb_insert_augmented);
 
@@ -502,7 +526,7 @@ struct rb_node *rb_next(const struct rb_
 	 * as we can.
 	 */
 	if (node->rb_right) {
-		node = node->rb_right; 
+		node = node->rb_right;
 		while (node->rb_left)
 			node=node->rb_left;
 		return (struct rb_node *)node;
@@ -534,7 +558,7 @@ struct rb_node *rb_prev(const struct rb_
 	 * as we can.
 	 */
 	if (node->rb_left) {
-		node = node->rb_left; 
+		node = node->rb_left;
 		while (node->rb_right)
 			node=node->rb_right;
 		return (struct rb_node *)node;
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch

