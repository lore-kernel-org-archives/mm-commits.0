From: akpm@linux-foundation.org
Subject: +
 locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
 added to -mm tree
Date: Wed, 26 Jul 2017 14:14:42 -0700
Message-ID: <59790642.jv+OJAUTlbY0INLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: locking/rtmutex: replace top-waiter and pi_waiters leftmost caching
has been added to the -mm tree.  Its filename is
     locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch

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
Subject: locking/rtmutex: replace top-waiter and pi_waiters leftmost caching

... with the generic rbtree flavor instead. No changes
in semantics whatsoever.

Link: http://lkml.kernel.org/r/20170719014603.19029-10-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h       |    5 +---
 include/linux/rtmutex.h         |   11 ++++-----
 include/linux/sched.h           |    3 --
 kernel/fork.c                   |    3 --
 kernel/locking/rtmutex-debug.c  |    2 -
 kernel/locking/rtmutex.c        |   35 +++++++++---------------------
 kernel/locking/rtmutex_common.h |   12 +++++-----
 7 files changed, 27 insertions(+), 44 deletions(-)

diff -puN include/linux/init_task.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching include/linux/init_task.h
--- a/include/linux/init_task.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/include/linux/init_task.h
@@ -181,9 +181,8 @@ extern struct cred init_cred;
 
 #ifdef CONFIG_RT_MUTEXES
 # define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters = RB_ROOT,						\
-	.pi_top_task = NULL,						\
-	.pi_waiters_leftmost = NULL,
+	.pi_waiters = RB_ROOT_CACHED,					\
+	.pi_top_task = NULL,
 #else
 # define INIT_RT_MUTEXES(tsk)
 #endif
diff -puN include/linux/rtmutex.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching include/linux/rtmutex.h
--- a/include/linux/rtmutex.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/include/linux/rtmutex.h
@@ -22,18 +22,17 @@ extern int max_lock_depth; /* for sysctl
  * The rt_mutex structure
  *
  * @wait_lock:	spinlock to protect the structure
- * @waiters:	rbtree root to enqueue waiters in priority order
- * @waiters_leftmost: top waiter
+ * @waiters:	rbtree root to enqueue waiters in priority order;
+ *              caches top-waiter (leftmost node).
  * @owner:	the mutex owner
  */
 struct rt_mutex {
 	raw_spinlock_t		wait_lock;
-	struct rb_root          waiters;
-	struct rb_node          *waiters_leftmost;
+	struct rb_root_cached   waiters;
 	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	int			save_state;
-	const char 		*name, *file;
+	const char		*name, *file;
 	int			line;
 	void			*magic;
 #endif
@@ -84,7 +83,7 @@ do { \
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .waiters = RB_ROOT \
+	, .waiters = RB_ROOT_CACHED \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
 	__DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)}
diff -puN include/linux/sched.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching include/linux/sched.h
--- a/include/linux/sched.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/include/linux/sched.h
@@ -811,8 +811,7 @@ struct task_struct {
 
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task: */
-	struct rb_root			pi_waiters;
-	struct rb_node			*pi_waiters_leftmost;
+	struct rb_root_cached		pi_waiters;
 	/* Updated under owner's pi_lock and rq lock */
 	struct task_struct		*pi_top_task;
 	/* Deadlock detection and priority inheritance handling: */
diff -puN kernel/fork.c~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching kernel/fork.c
--- a/kernel/fork.c~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/kernel/fork.c
@@ -1458,8 +1458,7 @@ static void rt_mutex_init_task(struct ta
 {
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	p->pi_waiters = RB_ROOT;
-	p->pi_waiters_leftmost = NULL;
+	p->pi_waiters = RB_ROOT_CACHED;
 	p->pi_top_task = NULL;
 	p->pi_blocked_on = NULL;
 #endif
diff -puN kernel/locking/rtmutex-debug.c~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching kernel/locking/rtmutex-debug.c
--- a/kernel/locking/rtmutex-debug.c~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/kernel/locking/rtmutex-debug.c
@@ -58,7 +58,7 @@ static void printk_lock(struct rt_mutex
 
 void rt_mutex_debug_task_free(struct task_struct *task)
 {
-	DEBUG_LOCKS_WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters));
+	DEBUG_LOCKS_WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters.rb_root));
 	DEBUG_LOCKS_WARN_ON(task->pi_blocked_on);
 }
 
diff -puN kernel/locking/rtmutex.c~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching kernel/locking/rtmutex.c
--- a/kernel/locking/rtmutex.c~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/kernel/locking/rtmutex.c
@@ -271,10 +271,10 @@ rt_mutex_waiter_equal(struct rt_mutex_wa
 static void
 rt_mutex_enqueue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
 {
-	struct rb_node **link = &lock->waiters.rb_node;
+	struct rb_node **link = &lock->waiters.rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct rt_mutex_waiter *entry;
-	int leftmost = 1;
+	bool leftmost = true;
 
 	while (*link) {
 		parent = *link;
@@ -283,15 +283,12 @@ rt_mutex_enqueue(struct rt_mutex *lock,
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
-			leftmost = 0;
+			leftmost = false;
 		}
 	}
 
-	if (leftmost)
-		lock->waiters_leftmost = &waiter->tree_entry;
-
 	rb_link_node(&waiter->tree_entry, parent, link);
-	rb_insert_color(&waiter->tree_entry, &lock->waiters);
+	rb_insert_color_cached(&waiter->tree_entry, &lock->waiters, leftmost);
 }
 
 static void
@@ -300,20 +297,17 @@ rt_mutex_dequeue(struct rt_mutex *lock,
 	if (RB_EMPTY_NODE(&waiter->tree_entry))
 		return;
 
-	if (lock->waiters_leftmost == &waiter->tree_entry)
-		lock->waiters_leftmost = rb_next(&waiter->tree_entry);
-
-	rb_erase(&waiter->tree_entry, &lock->waiters);
+	rb_erase_cached(&waiter->tree_entry, &lock->waiters);
 	RB_CLEAR_NODE(&waiter->tree_entry);
 }
 
 static void
 rt_mutex_enqueue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
 {
-	struct rb_node **link = &task->pi_waiters.rb_node;
+	struct rb_node **link = &task->pi_waiters.rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct rt_mutex_waiter *entry;
-	int leftmost = 1;
+	bool leftmost = true;
 
 	while (*link) {
 		parent = *link;
@@ -322,15 +316,12 @@ rt_mutex_enqueue_pi(struct task_struct *
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
-			leftmost = 0;
+			leftmost = false;
 		}
 	}
 
-	if (leftmost)
-		task->pi_waiters_leftmost = &waiter->pi_tree_entry;
-
 	rb_link_node(&waiter->pi_tree_entry, parent, link);
-	rb_insert_color(&waiter->pi_tree_entry, &task->pi_waiters);
+	rb_insert_color_cached(&waiter->pi_tree_entry, &task->pi_waiters, leftmost);
 }
 
 static void
@@ -339,10 +330,7 @@ rt_mutex_dequeue_pi(struct task_struct *
 	if (RB_EMPTY_NODE(&waiter->pi_tree_entry))
 		return;
 
-	if (task->pi_waiters_leftmost == &waiter->pi_tree_entry)
-		task->pi_waiters_leftmost = rb_next(&waiter->pi_tree_entry);
-
-	rb_erase(&waiter->pi_tree_entry, &task->pi_waiters);
+	rb_erase_cached(&waiter->pi_tree_entry, &task->pi_waiters);
 	RB_CLEAR_NODE(&waiter->pi_tree_entry);
 }
 
@@ -1657,8 +1645,7 @@ void __rt_mutex_init(struct rt_mutex *lo
 {
 	lock->owner = NULL;
 	raw_spin_lock_init(&lock->wait_lock);
-	lock->waiters = RB_ROOT;
-	lock->waiters_leftmost = NULL;
+	lock->waiters = RB_ROOT_CACHED;
 
 	if (name && key)
 		debug_rt_mutex_init(lock, name, key);
diff -puN kernel/locking/rtmutex_common.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching kernel/locking/rtmutex_common.h
--- a/kernel/locking/rtmutex_common.h~locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching
+++ a/kernel/locking/rtmutex_common.h
@@ -42,7 +42,7 @@ struct rt_mutex_waiter {
  */
 static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
 {
-	return !RB_EMPTY_ROOT(&lock->waiters);
+	return !RB_EMPTY_ROOT(&lock->waiters.rb_root);
 }
 
 static inline struct rt_mutex_waiter *
@@ -50,8 +50,8 @@ rt_mutex_top_waiter(struct rt_mutex *loc
 {
 	struct rt_mutex_waiter *w;
 
-	w = rb_entry(lock->waiters_leftmost, struct rt_mutex_waiter,
-		     tree_entry);
+	w = rb_entry(lock->waiters.rb_leftmost,
+		     struct rt_mutex_waiter, tree_entry);
 	BUG_ON(w->lock != lock);
 
 	return w;
@@ -59,14 +59,14 @@ rt_mutex_top_waiter(struct rt_mutex *loc
 
 static inline int task_has_pi_waiters(struct task_struct *p)
 {
-	return !RB_EMPTY_ROOT(&p->pi_waiters);
+	return !RB_EMPTY_ROOT(&p->pi_waiters.rb_root);
 }
 
 static inline struct rt_mutex_waiter *
 task_top_pi_waiter(struct task_struct *p)
 {
-	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
-			pi_tree_entry);
+	return rb_entry(p->pi_waiters.rb_leftmost,
+			struct rt_mutex_waiter, pi_tree_entry);
 }
 
 /*
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

