From: akpm@linux-foundation.org
Subject: +
 sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch added to
 -mm tree
Date: Wed, 19 Jul 2017 15:53:01 -0700
Message-ID: <596fe2cd.0nZje7EmCwAcjJjE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932861AbdGSWxC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jack@suse.cz, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched/deadline: replace earliest dl and rq leftmost caching
has been added to the -mm tree.  Its filename is
     sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch

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
Subject: sched/deadline: replace earliest dl and rq leftmost caching

...  with the generic rbtree flavor instead.  No changes in semantics
whatsoever.

Link: http://lkml.kernel.org/r/20170629171553.2146-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/deadline.c |   50 ++++++++++++++------------------------
 kernel/sched/sched.h    |    6 +---
 2 files changed, 21 insertions(+), 35 deletions(-)

diff -puN kernel/sched/deadline.c~sched-deadline-replace-earliest-dl-and-rq-leftmost-caching kernel/sched/deadline.c
--- a/kernel/sched/deadline.c~sched-deadline-replace-earliest-dl-and-rq-leftmost-caching
+++ a/kernel/sched/deadline.c
@@ -296,7 +296,7 @@ static inline int is_leftmost(struct tas
 {
 	struct sched_dl_entity *dl_se = &p->dl;
 
-	return dl_rq->rb_leftmost == &dl_se->rb_node;
+	return dl_rq->root.rb_leftmost == &dl_se->rb_node;
 }
 
 void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime)
@@ -320,7 +320,7 @@ void init_dl_bw(struct dl_bw *dl_b)
 
 void init_dl_rq(struct dl_rq *dl_rq)
 {
-	dl_rq->rb_root = RB_ROOT;
+	dl_rq->root = RB_ROOT_CACHED;
 
 #ifdef CONFIG_SMP
 	/* zero means no -deadline tasks */
@@ -328,7 +328,7 @@ void init_dl_rq(struct dl_rq *dl_rq)
 
 	dl_rq->dl_nr_migratory = 0;
 	dl_rq->overloaded = 0;
-	dl_rq->pushable_dl_tasks_root = RB_ROOT;
+	dl_rq->pushable_dl_tasks_root = RB_ROOT_CACHED;
 #else
 	init_dl_bw(&dl_rq->dl_bw);
 #endif
@@ -410,10 +410,10 @@ static void dec_dl_migration(struct sche
 static void enqueue_pushable_dl_task(struct rq *rq, struct task_struct *p)
 {
 	struct dl_rq *dl_rq = &rq->dl;
-	struct rb_node **link = &dl_rq->pushable_dl_tasks_root.rb_node;
+	struct rb_node **link = &dl_rq->pushable_dl_tasks_root.rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct task_struct *entry;
-	int leftmost = 1;
+	bool leftmost = true;
 
 	BUG_ON(!RB_EMPTY_NODE(&p->pushable_dl_tasks));
 
@@ -425,17 +425,16 @@ static void enqueue_pushable_dl_task(str
 			link = &parent->rb_left;
 		else {
 			link = &parent->rb_right;
-			leftmost = 0;
+			leftmost = false;
 		}
 	}
 
-	if (leftmost) {
-		dl_rq->pushable_dl_tasks_leftmost = &p->pushable_dl_tasks;
+	if (leftmost)
 		dl_rq->earliest_dl.next = p->dl.deadline;
-	}
 
 	rb_link_node(&p->pushable_dl_tasks, parent, link);
-	rb_insert_color(&p->pushable_dl_tasks, &dl_rq->pushable_dl_tasks_root);
+	rb_insert_color_cached(&p->pushable_dl_tasks,
+			       &dl_rq->pushable_dl_tasks_root, leftmost);
 }
 
 static void dequeue_pushable_dl_task(struct rq *rq, struct task_struct *p)
@@ -445,24 +444,23 @@ static void dequeue_pushable_dl_task(str
 	if (RB_EMPTY_NODE(&p->pushable_dl_tasks))
 		return;
 
-	if (dl_rq->pushable_dl_tasks_leftmost == &p->pushable_dl_tasks) {
+	if (dl_rq->pushable_dl_tasks_root.rb_leftmost == &p->pushable_dl_tasks) {
 		struct rb_node *next_node;
 
 		next_node = rb_next(&p->pushable_dl_tasks);
-		dl_rq->pushable_dl_tasks_leftmost = next_node;
 		if (next_node) {
 			dl_rq->earliest_dl.next = rb_entry(next_node,
 				struct task_struct, pushable_dl_tasks)->dl.deadline;
 		}
 	}
 
-	rb_erase(&p->pushable_dl_tasks, &dl_rq->pushable_dl_tasks_root);
+	rb_erase_cached(&p->pushable_dl_tasks, &dl_rq->pushable_dl_tasks_root);
 	RB_CLEAR_NODE(&p->pushable_dl_tasks);
 }
 
 static inline int has_pushable_dl_tasks(struct rq *rq)
 {
-	return !RB_EMPTY_ROOT(&rq->dl.pushable_dl_tasks_root);
+	return !RB_EMPTY_ROOT(&rq->dl.pushable_dl_tasks_root.rb_root);
 }
 
 static int push_dl_task(struct rq *rq);
@@ -1266,7 +1264,7 @@ static void dec_dl_deadline(struct dl_rq
 		dl_rq->earliest_dl.next = 0;
 		cpudl_clear(&rq->rd->cpudl, rq->cpu);
 	} else {
-		struct rb_node *leftmost = dl_rq->rb_leftmost;
+		struct rb_node *leftmost = dl_rq->root.rb_leftmost;
 		struct sched_dl_entity *entry;
 
 		entry = rb_entry(leftmost, struct sched_dl_entity, rb_node);
@@ -1313,7 +1311,7 @@ void dec_dl_tasks(struct sched_dl_entity
 static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
-	struct rb_node **link = &dl_rq->rb_root.rb_node;
+	struct rb_node **link = &dl_rq->root.rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct sched_dl_entity *entry;
 	int leftmost = 1;
@@ -1331,11 +1329,8 @@ static void __enqueue_dl_entity(struct s
 		}
 	}
 
-	if (leftmost)
-		dl_rq->rb_leftmost = &dl_se->rb_node;
-
 	rb_link_node(&dl_se->rb_node, parent, link);
-	rb_insert_color(&dl_se->rb_node, &dl_rq->rb_root);
+	rb_insert_color_cached(&dl_se->rb_node, &dl_rq->root, leftmost);
 
 	inc_dl_tasks(dl_se, dl_rq);
 }
@@ -1347,14 +1342,7 @@ static void __dequeue_dl_entity(struct s
 	if (RB_EMPTY_NODE(&dl_se->rb_node))
 		return;
 
-	if (dl_rq->rb_leftmost == &dl_se->rb_node) {
-		struct rb_node *next_node;
-
-		next_node = rb_next(&dl_se->rb_node);
-		dl_rq->rb_leftmost = next_node;
-	}
-
-	rb_erase(&dl_se->rb_node, &dl_rq->rb_root);
+	rb_erase_cached(&dl_se->rb_node, &dl_rq->root);
 	RB_CLEAR_NODE(&dl_se->rb_node);
 
 	dec_dl_tasks(dl_se, dl_rq);
@@ -1645,7 +1633,7 @@ static void start_hrtick_dl(struct rq *r
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 						   struct dl_rq *dl_rq)
 {
-	struct rb_node *left = dl_rq->rb_leftmost;
+	struct rb_node *left = rb_first_cached(&dl_rq->root);
 
 	if (!left)
 		return NULL;
@@ -1769,7 +1757,7 @@ static int pick_dl_task(struct rq *rq, s
  */
 static struct task_struct *pick_earliest_pushable_dl_task(struct rq *rq, int cpu)
 {
-	struct rb_node *next_node = rq->dl.pushable_dl_tasks_leftmost;
+	struct rb_node *next_node = rq->dl.pushable_dl_tasks_root.rb_leftmost;
 	struct task_struct *p = NULL;
 
 	if (!has_pushable_dl_tasks(rq))
@@ -1942,7 +1930,7 @@ static struct task_struct *pick_next_pus
 	if (!has_pushable_dl_tasks(rq))
 		return NULL;
 
-	p = rb_entry(rq->dl.pushable_dl_tasks_leftmost,
+	p = rb_entry(rq->dl.pushable_dl_tasks_root.rb_leftmost,
 		     struct task_struct, pushable_dl_tasks);
 
 	BUG_ON(rq->cpu != task_cpu(p));
diff -puN kernel/sched/sched.h~sched-deadline-replace-earliest-dl-and-rq-leftmost-caching kernel/sched/sched.h
--- a/kernel/sched/sched.h~sched-deadline-replace-earliest-dl-and-rq-leftmost-caching
+++ a/kernel/sched/sched.h
@@ -549,8 +549,7 @@ struct rt_rq {
 /* Deadline class' related fields in a runqueue */
 struct dl_rq {
 	/* runqueue is an rbtree, ordered by deadline */
-	struct rb_root rb_root;
-	struct rb_node *rb_leftmost;
+	struct rb_root_cached root;
 
 	unsigned long dl_nr_running;
 
@@ -574,8 +573,7 @@ struct dl_rq {
 	 * an rb-tree, ordered by tasks' deadlines, with caching
 	 * of the leftmost (earliest deadline) element.
 	 */
-	struct rb_root pushable_dl_tasks_root;
-	struct rb_node *pushable_dl_tasks_leftmost;
+	struct rb_root_cached pushable_dl_tasks_root;
 #else
 	struct dl_bw dl_bw;
 #endif
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

