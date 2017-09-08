From: akpm@linux-foundation.org
Subject: [patch 072/126] sched/fair: replace cfs_rq->rb_leftmost
Date: Fri, 08 Sep 2017 16:14:55 -0700
Message-ID: <20170908231455.cmW7TaYLd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXO4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org

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
@@ -530,7 +530,7 @@ void print_cfs_rq(struct seq_file *m, in
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
@@ -9312,7 +9299,7 @@ static void set_curr_task_fair(struct rq
 
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
