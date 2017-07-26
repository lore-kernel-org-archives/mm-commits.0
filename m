From: akpm@linux-foundation.org
Subject: + sched-fair-replace-cfs_rq-rb_leftmost.patch added to -mm tree
Date: Wed, 26 Jul 2017 14:14:38 -0700
Message-ID: <5979063e.nYY4Mj6seSCVKdZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVOj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched/fair: replace cfs_rq->rb_leftmost
has been added to the -mm tree.  Its filename is
     sched-fair-replace-cfs_rq-rb_leftmost.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-fair-replace-cfs_rq-rb_leftmost.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-fair-replace-cfs_rq-rb_leftmost.patch

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
Subject: sched/fair: replace cfs_rq->rb_leftmost

... with the generic rbtree flavor instead. No changes
in semantics whatsoever.

Link: http://lkml.kernel.org/r/20170719014603.19029-8-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/debug.c |    2 +-
 kernel/sched/fair.c  |   39 +++++++++++++--------------------------
 kernel/sched/sched.h |    3 +--
 3 files changed, 15 insertions(+), 29 deletions(-)

diff -puN kernel/sched/debug.c~sched-fair-replace-cfs_rq-rb_leftmost kernel/sched/debug.c
--- a/kernel/sched/debug.c~sched-fair-replace-cfs_rq-rb_leftmost
+++ a/kernel/sched/debug.c
@@ -488,7 +488,7 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(cfs_rq->exec_clock));
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	if (cfs_rq->rb_leftmost)
+	if (rb_first_cached(&cfs_rq->tasks_timeline))
 		MIN_vruntime = (__pick_first_entity(cfs_rq))->vruntime;
 	last = __pick_last_entity(cfs_rq);
 	if (last)
diff -puN kernel/sched/fair.c~sched-fair-replace-cfs_rq-rb_leftmost kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-fair-replace-cfs_rq-rb_leftmost
+++ a/kernel/sched/fair.c
@@ -513,6 +513,7 @@ static inline int entity_before(struct s
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
+	struct rb_node *leftmost = rb_first_cached(&cfs_rq->tasks_timeline);
 
 	u64 vruntime = cfs_rq->min_vruntime;
 
@@ -523,10 +524,9 @@ static void update_min_vruntime(struct c
 			curr = NULL;
 	}
 
-	if (cfs_rq->rb_leftmost) {
-		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
-						   struct sched_entity,
-						   run_node);
+	if (leftmost) { /* non-empty tree */
+		struct sched_entity *se;
+		se = rb_entry(leftmost, struct sched_entity, run_node);
 
 		if (!curr)
 			vruntime = se->vruntime;
@@ -547,10 +547,10 @@ static void update_min_vruntime(struct c
  */
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
+	struct rb_node **link = &cfs_rq->tasks_timeline.rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	int leftmost = 1;
+	bool leftmost = true;
 
 	/*
 	 * Find the right place in the rbtree:
@@ -566,36 +566,23 @@ static void __enqueue_entity(struct cfs_
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
-			leftmost = 0;
+			leftmost = false;
 		}
 	}
 
-	/*
-	 * Maintain a cache of leftmost tree entries (it is frequently
-	 * used):
-	 */
-	if (leftmost)
-		cfs_rq->rb_leftmost = &se->run_node;
-
 	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_insert_color_cached(&se->run_node,
+			       &cfs_rq->tasks_timeline, leftmost);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->rb_leftmost == &se->run_node) {
-		struct rb_node *next_node;
-
-		next_node = rb_next(&se->run_node);
-		cfs_rq->rb_leftmost = next_node;
-	}
-
-	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_erase_cached(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
 struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
-	struct rb_node *left = cfs_rq->rb_leftmost;
+	struct rb_node *left = rb_first_cached(&cfs_rq->tasks_timeline);
 
 	if (!left)
 		return NULL;
@@ -616,7 +603,7 @@ static struct sched_entity *__pick_next_
 #ifdef CONFIG_SCHED_DEBUG
 struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
-	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
+	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline.rb_root);
 
 	if (!last)
 		return NULL;
@@ -9171,7 +9158,7 @@ static void set_curr_task_fair(struct rq
 
 void init_cfs_rq(struct cfs_rq *cfs_rq)
 {
-	cfs_rq->tasks_timeline = RB_ROOT;
+	cfs_rq->tasks_timeline = RB_ROOT_CACHED;
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
diff -puN kernel/sched/sched.h~sched-fair-replace-cfs_rq-rb_leftmost kernel/sched/sched.h
--- a/kernel/sched/sched.h~sched-fair-replace-cfs_rq-rb_leftmost
+++ a/kernel/sched/sched.h
@@ -426,8 +426,7 @@ struct cfs_rq {
 	u64 min_vruntime_copy;
 #endif
 
-	struct rb_root tasks_timeline;
-	struct rb_node *rb_leftmost;
+	struct rb_root_cached tasks_timeline;
 
 	/*
 	 * 'curr' points to currently running entity on this cfs_rq.
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
rbtree-optimize-root-check-during-rebalancing-loop.patch
rbtree-add-some-additional-comments-for-rebalancing-cases.patch
lib-rbtree_testc-make-input-module-parameters.patch
lib-rbtree_testc-add-inorder-traversal-test.patch
lib-rbtree_testc-support-rb_root_cached.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch
mem-memcg-cache-rightmost-node.patch
block-cfq-cache-rightmost-rb_node.patch

