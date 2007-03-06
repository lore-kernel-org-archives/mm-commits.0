From: akpm@linux-foundation.org
Subject: - reiser4-get-rid-of-semaphores-wherever-it-is-possible.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:56 -0800
Message-ID: <200703060159.l261xuU6008659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965676AbXCFCAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: get rid of semaphores wherever it is possible
has been removed from the -mm tree.  Its filename was
     reiser4-get-rid-of-semaphores-wherever-it-is-possible.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: get rid of semaphores wherever it is possible
From: Alexander Zarochentsev <zam@namesys.com>

this patch addresses your warnings:
> wbq.sem should be using a completion for the "wait until entd finishes", not
> a semaphore.  Because there's a teeny theoretical race when using semaphores
> this way which completions were designed to avoid.  (The waker can still be
> playing with the semaphore when it has gone out of scope on the wakee's
> stack).
...
> write_page_by_ent(): the "spin until entd thread" thing is gross.
...
> semaphores are deprecated.  Please switch to mutexes and/or completions where
> appropriate and possible

delete semaphore, reiser4 inode loading semaphore, commit semaphore, bitmap
node semaphore are replaced by mutexes;
flush semaphore removed, it was discovered that use of flush semaphore
leads to a deadlock;
writeback request semaphore wbq->sem is replaced by a completion;
flush queue i/o completion semaphore and lock_stack semaphore
are replaced by wait queues.

reiser4 inode still uses R/W semaphore for protecting
unix_file_info->container.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/block_alloc.c         |   18 +++++------
 fs/reiser4/context.c             |    2 -
 fs/reiser4/entd.c                |   47 ++++++++---------------------
 fs/reiser4/entd.h                |    2 -
 fs/reiser4/flush.c               |    9 -----
 fs/reiser4/flush_queue.c         |    8 ++--
 fs/reiser4/init_super.c          |    8 ----
 fs/reiser4/inode.c               |   28 ++++++-----------
 fs/reiser4/inode.h               |    2 -
 fs/reiser4/lock.c                |   43 ++++----------------------
 fs/reiser4/lock.h                |   35 ++++-----------------
 fs/reiser4/plugin/file/file.c    |   12 +++----
 fs/reiser4/plugin/space/bitmap.c |   23 ++++++--------
 fs/reiser4/safe_link.c           |    2 -
 fs/reiser4/super.h               |   15 +++------
 fs/reiser4/txnmgr.c              |   15 ++++-----
 fs/reiser4/txnmgr.h              |   10 +++---
 fs/reiser4/wander.c              |    4 +-
 18 files changed, 94 insertions(+), 189 deletions(-)

diff -puN fs/reiser4/block_alloc.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/block_alloc.c
--- a/fs/reiser4/block_alloc.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/block_alloc.c
@@ -345,7 +345,7 @@ int reiser4_grab_space(__u64 count, reis
  * Solution is to reserve 5% of disk space for truncates and
  * unlinks. Specifically, normal space grabbing requests don't grab space from
  * reserved area. Only requests with BA_RESERVED bit in flags are allowed to
- * drain it. Per super block delete_sema semaphore is used to allow only one
+ * drain it. Per super block delete mutex is used to allow only one
  * thread at a time to grab from reserved area.
  *
  * Grabbing from reserved area should always be performed with BA_CAN_COMMIT
@@ -360,9 +360,9 @@ int reiser4_grab_reserved(struct super_b
 
 	assert("nikita-3175", flags & BA_CAN_COMMIT);
 
-	/* Check the delete semaphore already taken by us, we assume that
+	/* Check the delete mutex already taken by us, we assume that
 	 * reading of machine word is atomic. */
-	if (sbinfo->delete_sema_owner == current) {
+	if (sbinfo->delete_mutex_owner == current) {
 		if (reiser4_grab_space
 		    (count, (flags | BA_RESERVED) & ~BA_CAN_COMMIT)) {
 			warning("zam-1003",
@@ -375,9 +375,9 @@ int reiser4_grab_reserved(struct super_b
 	}
 
 	if (reiser4_grab_space(count, flags)) {
-		down(&sbinfo->delete_sema);
-		assert("nikita-2929", sbinfo->delete_sema_owner == NULL);
-		sbinfo->delete_sema_owner = current;
+		mutex_lock(&sbinfo->delete_mutex);
+		assert("nikita-2929", sbinfo->delete_mutex_owner == NULL);
+		sbinfo->delete_mutex_owner = current;
 
 		if (reiser4_grab_space(count, flags | BA_RESERVED)) {
 			warning("zam-833",
@@ -395,9 +395,9 @@ void reiser4_release_reserved(struct sup
 	reiser4_super_info_data *info;
 
 	info = get_super_private(super);
-	if (info->delete_sema_owner == current) {
-		info->delete_sema_owner = NULL;
-		up(&info->delete_sema);
+	if (info->delete_mutex_owner == current) {
+		info->delete_mutex_owner = NULL;
+		mutex_unlock(&info->delete_mutex);
 	}
 }
 
diff -puN fs/reiser4/context.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/context.c
@@ -181,7 +181,7 @@ static void reiser4_done_context(reiser4
 		assert("nikita-1936", reiser4_no_counters_are_held());
 		assert("nikita-2626", list_empty_careful(reiser4_taps_list()));
 		assert("zam-1004", ergo(get_super_private(context->super),
-					get_super_private(context->super)->delete_sema_owner !=
+					get_super_private(context->super)->delete_mutex_owner !=
 					current));
 
 		/* release all grabbed but as yet unused blocks */
diff -puN fs/reiser4/entd.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/entd.c
@@ -68,9 +68,10 @@ int reiser4_init_entd(struct super_block
 	return 0;
 }
 
-static void __put_wbq(entd_context *ent, struct wbq *rq)
+static void put_wbq(struct wbq *rq)
 {
-	up(&rq->sem);
+	iput(rq->mapping->host);
+	complete(&rq->completion);
 }
 
 /* ent should be locked */
@@ -78,7 +79,7 @@ static struct wbq *__get_wbq(entd_contex
 {
 	struct wbq *wbq;
 
-	if (list_empty_careful(&ent->todo_list))
+	if (list_empty(&ent->todo_list))
 		return NULL;
 
 	ent->nr_todo_reqs --;
@@ -87,16 +88,6 @@ static struct wbq *__get_wbq(entd_contex
 	return wbq;
 }
 
-static void wakeup_all_wbq(entd_context * ent)
-{
-	struct wbq *rq;
-
-	spin_lock(&ent->guard);
-	while ((rq = __get_wbq(ent)) != NULL)
-		__put_wbq(ent, rq);
-	spin_unlock(&ent->guard);
-}
-
 /* ent thread function */
 static int entd(void *arg)
 {
@@ -118,9 +109,9 @@ static int entd(void *arg)
 
 		spin_lock(&ent->guard);
 		while (ent->nr_todo_reqs != 0) {
-			struct wbq *rq, *next;
+			struct wbq *rq;
 
-			assert("", list_empty_careful(&ent->done_list));
+			assert("", list_empty(&ent->done_list));
 
 			/* take request from the queue head */
 			rq = __get_wbq(ent);
@@ -131,21 +122,19 @@ static int entd(void *arg)
 			entd_set_comm("!");
 			entd_flush(super, rq);
 
-			iput(rq->mapping->host);
-			up(&(rq->sem));
+			put_wbq(rq);
 
 			/*
 			 * wakeup all requestors and iput their inodes
 			 */
 			spin_lock(&ent->guard);
-			list_for_each_entry_safe(rq, next, &ent->done_list, link) {
-				list_del_init(&(rq->link));
+			while (!list_empty(&ent->done_list)) {
+				rq = list_entry(ent->done_list.next, struct wbq, link);
+				list_del_init(&rq->link);
 				ent->nr_done_reqs --;
 				spin_unlock(&ent->guard);
-
 				assert("", rq->written == 1);
-				iput(rq->mapping->host);
-				up(&(rq->sem));
+				put_wbq(rq);
 				spin_lock(&ent->guard);
 			}
 		}
@@ -169,10 +158,7 @@ static int entd(void *arg)
 			finish_wait(&ent->wait, &__wait);
 		}
 	}
-	spin_lock(&ent->guard);
 	BUG_ON(ent->nr_todo_reqs != 0);
-	spin_unlock(&ent->guard);
-	wakeup_all_wbq(ent);
 	return 0;
 }
 
@@ -310,7 +296,7 @@ int write_page_by_ent(struct page *page,
 	rq.mapping = inode->i_mapping;
 	rq.node = NULL;
 	rq.written = 0;
-	sema_init(&rq.sem, 0);
+	init_completion(&rq.completion);
 
 	/* add request to entd's list of writepage requests */
 	spin_lock(&ent->guard);
@@ -322,14 +308,7 @@ int write_page_by_ent(struct page *page,
 	spin_unlock(&ent->guard);
 
 	/* wait until entd finishes */
-	down(&rq.sem);
-
-	/*
-	 * spin until entd thread which did up(&rq.sem) does not need rq
-	 * anymore
-	 */
-	spin_lock(&ent->guard);
-	spin_unlock(&ent->guard);
+	wait_for_completion(&rq.completion);
 
 	if (rq.written)
 		/* Eventually ENTD has written the page to disk. */
diff -puN fs/reiser4/entd.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/entd.h
--- a/fs/reiser4/entd.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/entd.h
@@ -22,7 +22,7 @@ struct wbq {
 	struct writeback_control *wbc;
 	struct page *page;
 	struct address_space *mapping;
-	struct semaphore sem;
+	struct completion completion;
 	jnode *node; /* set if ent thread captured requested page */
 	int written; /* set if ent thread wrote requested page */
 };
diff -puN fs/reiser4/flush.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/flush.c
--- a/fs/reiser4/flush.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/flush.c
@@ -661,9 +661,8 @@ jnode_flush(jnode * node, long nr_to_wri
 	assert("jmacd-76619", lock_stack_isclean(get_current_lock_stack()));
 	assert("nikita-3022", reiser4_schedulable());
 
-	/* lock ordering: delete_sema and flush_sema are unordered */
 	assert("nikita-3185",
-	       get_current_super_private()->delete_sema_owner != current);
+	       get_current_super_private()->delete_mutex_owner != current);
 
 	/* allocate right_scan, left_scan and flush_pos */
 	right_scan =
@@ -676,9 +675,6 @@ jnode_flush(jnode * node, long nr_to_wri
 
 	sb = reiser4_get_current_sb();
 	sbinfo = get_super_private(sb);
-	if (!reiser4_is_set(sb, REISER4_MTFLUSH)) {
-		down(&sbinfo->flush_sema);
-	}
 
 	/* Flush-concurrency debug code */
 #if REISER4_DEBUG
@@ -878,9 +874,6 @@ jnode_flush(jnode * node, long nr_to_wri
 
 	reiser4_leave_flush(sb);
 
-	if (!reiser4_is_set(sb, REISER4_MTFLUSH))
-		up(&sbinfo->flush_sema);
-
 	return ret;
 }
 
diff -puN fs/reiser4/flush_queue.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/flush_queue.c
@@ -102,7 +102,7 @@ static void init_fq(flush_queue_t * fq)
 
 	INIT_LIST_HEAD(ATOM_FQ_LIST(fq));
 
-	sema_init(&fq->io_sem, 0);
+	init_waitqueue_head(&fq->wait);
 	spin_lock_init(&fq->guard);
 }
 
@@ -241,7 +241,7 @@ static int wait_io(flush_queue_t * fq, i
 		blk_run_address_space(reiser4_get_super_fake(super)->i_mapping);
 
 		if (!(super->s_flags & MS_RDONLY))
-			down(&fq->io_sem);
+			wait_event(fq->wait, atomic_read(&fq->nr_submitted) == 0);
 
 		/* Ask the caller to re-acquire the locks and call this
 		   function again. Note: this technique is commonly used in
@@ -442,9 +442,9 @@ end_io_handler(struct bio *bio, unsigned
 		atomic_add(nr_errors, &fq->nr_errors);
 
 		/* If all write requests registered in this "fq" are done we up
-		 * the semaphore. */
+		 * the waiter. */
 		if (atomic_sub_and_test(bio->bi_vcnt, &fq->nr_submitted))
-			up(&fq->io_sem);
+			wake_up(&fq->wait);
 	}
 
 	bio_put(bio);
diff -puN fs/reiser4/init_super.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/init_super.c
@@ -30,8 +30,7 @@ int reiser4_init_fs_info(struct super_bl
 	ON_DEBUG(INIT_LIST_HEAD(&sbinfo->all_jnodes));
 	ON_DEBUG(spin_lock_init(&sbinfo->all_guard));
 
-	sema_init(&sbinfo->delete_sema, 1);
-	sema_init(&sbinfo->flush_sema, 1);
+	mutex_init(&sbinfo->delete_mutex);
 	spin_lock_init(&(sbinfo->guard));
 
 	/*  initialize per-super-block d_cursor resources */
@@ -441,8 +440,6 @@ do {						\
 	PUSH_BIT_OPT("bsdgroups", REISER4_BSD_GID);
 	/* turn on 32 bit times */
 	PUSH_BIT_OPT("32bittimes", REISER4_32_BIT_TIMES);
-	/* turn off concurrent flushing */
-	PUSH_BIT_OPT("mtflush", REISER4_MTFLUSH);
 	/*
 	 * Don't load all bitmap blocks at mount time, it is useful for
 	 * machines with tiny RAM and large disks.
@@ -513,9 +510,6 @@ do {						\
 		warning("nikita-2497", "optimal_io_size is too small");
 		return RETERR(-EINVAL);
 	}
-
-	/* disable single-threaded flush as it leads to deadlock */
-	sbinfo->fs_flags |= (1 << REISER4_MTFLUSH);
 	return result;
 }
 
diff -puN fs/reiser4/inode.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/inode.c
--- a/fs/reiser4/inode.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/inode.c
@@ -370,35 +370,29 @@ static int reiser4_inode_find_actor(stru
 /* hook for kmem_cache_create */
 void loading_init_once(reiser4_inode * info)
 {
-	sema_init(&info->loading, 1);
+	mutex_init(&info->loading);
 }
 
 /* for reiser4_alloc_inode */
 void loading_alloc(reiser4_inode * info)
 {
-#if REISER4_DEBUG
-	assert("vs-1717", down_trylock(&info->loading) == 0);
-	up(&info->loading);
-#endif
+	assert("vs-1717", !mutex_is_locked(&info->loading));
 }
 
 /* for reiser4_destroy */
 void loading_destroy(reiser4_inode * info)
 {
-#if REISER4_DEBUG
-	assert("vs-1717", down_trylock(&info->loading) == 0);
-	up(&info->loading);
-#endif
+	assert("vs-1717a", !mutex_is_locked(&info->loading));
 }
 
-static void loading_down(reiser4_inode * info)
+static void loading_begin(reiser4_inode * info)
 {
-	down(&info->loading);
+	mutex_lock(&info->loading);
 }
 
-static void loading_up(reiser4_inode * info)
+static void loading_end(reiser4_inode * info)
 {
-	up(&info->loading);
+	mutex_unlock(&info->loading);
 }
 
 /**
@@ -447,7 +441,7 @@ struct inode *reiser4_iget(struct super_
 	   is the reiser4 repacker, see repacker-related functions in
 	   plugin/item/extent.c */
 	if (!is_inode_loaded(inode)) {
-		loading_down(info);
+		loading_begin(info);
 		if (!is_inode_loaded(inode)) {
 			/* locking: iget5_locked returns locked inode */
 			assert("nikita-1941", !is_inode_loaded(inode));
@@ -459,7 +453,7 @@ struct inode *reiser4_iget(struct super_
 			   read_inode() to read stat data from the disk */
 			result = read_inode(inode, key, silent);
 		} else
-			loading_up(info);
+			loading_end(info);
 	}
 
 	if (inode->i_state & I_NEW)
@@ -467,7 +461,7 @@ struct inode *reiser4_iget(struct super_
 
 	if (is_bad_inode(inode)) {
 		assert("vs-1717", result != 0);
-		loading_up(info);
+		loading_end(info);
 		iput(inode);
 		inode = ERR_PTR(result);
 	} else if (REISER4_DEBUG) {
@@ -496,7 +490,7 @@ void reiser4_iget_complete(struct inode 
 
 	if (!is_inode_loaded(inode)) {
 		reiser4_inode_set_flag(inode, REISER4_LOADED);
-		loading_up(reiser4_inode_data(inode));
+		loading_end(reiser4_inode_data(inode));
 	}
 }
 
diff -puN fs/reiser4/inode.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/inode.h
@@ -142,7 +142,7 @@ struct reiser4_inode {
 	/* block number of virtual root for this object. See comment above
 	 * fs/reiser4/search.c:handle_vroot() */
 	reiser4_block_nr vroot;
-	struct semaphore loading;
+	struct mutex loading;
 };
 
 void loading_init_once(reiser4_inode *);
diff -puN fs/reiser4/lock.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/lock.c
--- a/fs/reiser4/lock.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/lock.c
@@ -934,19 +934,13 @@ int longterm_lock_znode(
 
 		/* This time, a return of (ret == 0) means we can lock, so we
 		   should break out of the loop. */
-		if (likely(ret != -E_REPEAT || non_blocking)) {
+		if (likely(ret != -E_REPEAT || non_blocking))
 			break;
-		}
 
 		/* Lock is unavailable, we have to wait. */
-
-		/* By having semaphore initialization here we cannot lose
-		   wakeup signal even if it comes after `nr_signaled' field
-		   check. */
 		ret = reiser4_prepare_to_sleep(owner);
-		if (unlikely(ret != 0)) {
+		if (unlikely(ret != 0))
 			break;
-		}
 
 		assert_spin_locked(&(node->lock.guard));
 		if (hipri) {
@@ -1025,7 +1019,7 @@ void init_lock_stack(lock_stack * owner	
 	INIT_LIST_HEAD(&owner->requestors_link);
 	spin_lock_init(&owner->sguard);
 	owner->curpri = 1;
-	sema_init(&owner->sema, 0);
+	init_waitqueue_head(&owner->wait);
 }
 
 /* Initializes lock object. */
@@ -1104,29 +1098,6 @@ int reiser4_check_deadlock(void)
 int reiser4_prepare_to_sleep(lock_stack * owner)
 {
 	assert("nikita-1847", owner == get_current_lock_stack());
-	/* NOTE(Zam): We cannot reset the lock semaphore here because it may
-	   clear wake-up signal. The initial design was to re-check all
-	   conditions under which we continue locking, release locks or sleep
-	   until conditions are changed. However, even lock.c does not follow
-	   that design.  So, wake-up signal which is stored in semaphore state
-	   could we loosen by semaphore reset.  The less complex scheme without
-	   resetting the semaphore is enough to not to loose wake-ups.
-
-	   if (0) {
-
-	   NOTE-NIKITA: I commented call to sema_init() out hoping
-	   that it is the reason or thread sleeping in
-	   down(&owner->sema) without any other thread running.
-
-	   Anyway, it is just an optimization: is semaphore is not
-	   reinitialised at this point, in the worst case
-	   longterm_lock_znode() would have to iterate its loop once
-	   more.
-	   spin_lock_stack(owner);
-	   sema_init(&owner->sema, 0);
-	   spin_unlock_stack(owner);
-	   }
-	 */
 
 	/* We return -E_DEADLOCK if one or more "give me the lock" messages are
 	 * counted in nr_signaled */
@@ -1140,7 +1111,8 @@ int reiser4_prepare_to_sleep(lock_stack 
 /* Wakes up a single thread */
 void __reiser4_wake_up(lock_stack * owner)
 {
-	up(&owner->sema);
+	atomic_set(&owner->wakeup, 1);
+	wake_up(&owner->wait);
 }
 
 /* Puts a thread to sleep */
@@ -1148,8 +1120,9 @@ void reiser4_go_to_sleep(lock_stack * ow
 {
 	/* Well, we might sleep here, so holding of any spinlocks is no-no */
 	assert("nikita-3027", reiser4_schedulable());
-	/* return down_interruptible(&owner->sema); */
-	down(&owner->sema);
+
+	wait_event(owner->wait, atomic_read(&owner->wakeup));
+	atomic_set(&owner->wakeup, 0);
 }
 
 int lock_stack_isclean(lock_stack * owner)
diff -puN fs/reiser4/lock.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/lock.h
--- a/fs/reiser4/lock.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/lock.h
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/pagemap.h>	/* for PAGE_CACHE_SIZE */
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
+#include <linux/wait.h>
 
 /* Per-znode lock object */
 struct zlock {
@@ -131,33 +131,12 @@ struct lock_stack {
 	   locking.
 	 */
 	lock_request request;
-	/* It is a lock_stack's synchronization object for when process sleeps
-	   when requested lock not on this lock_stack but which it wishes to
-	   add to this lock_stack is not immediately available. It is used
-	   instead of wait_queue_t object due to locking problems (lost wake
-	   up). "lost wakeup" occurs when process is waken up before he actually
-	   becomes 'sleepy' (through sleep_on()). Using of semaphore object is
-	   simplest way to avoid that problem.
-
-	   A semaphore is used in the following way: only the process that is
-	   the owner of the lock_stack initializes it (to zero) and calls
-	   down(sema) on it. Usually this causes the process to sleep on the
-	   semaphore. Other processes may wake him up by calling up(sema). The
-	   advantage to a semaphore is that up() and down() calls are not
-	   required to preserve order. Unlike wait_queue it works when process
-	   is woken up before getting to sleep.
-
-	   NOTE-NIKITA: Transaction manager is going to have condition variables
-	   (&kcondvar_t) anyway, so this probably will be replaced with
-	   one in the future.
-
-	   After further discussion, Nikita has shown me that Zam's implementation is
-	   exactly a condition variable.  The znode's {zguard,requestors_list} represents
-	   condition variable and the lock_stack's {sguard,semaphore} guards entry and
-	   exit from the condition variable's wait queue.  But the existing code can't
-	   just be replaced with a more general abstraction, and I think its fine the way
-	   it is. */
-	struct semaphore sema;
+	/* the following two fields are the lock stack's
+	 * synchronization object to use with the standard linux/wait.h
+	 * interface. See reiser4_go_to_sleep and __reiser4_wake_up for
+	 * usage details. */
+	wait_queue_head_t wait;
+	atomic_t wakeup;
 #if REISER4_DEBUG
 	int nr_locks;		/* number of lock handles in the above list */
 #endif
diff -puN fs/reiser4/plugin/file/file.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/plugin/file/file.c
@@ -394,7 +394,7 @@ cut_file_items(struct inode *inode, loff
 					break;
 			}
 
-			/* the below does up(sbinfo->delete_sema). Do not get folled */
+			/* the below does up(sbinfo->delete_mutex). Do not get folled */
 			reiser4_release_reserved(inode->i_sb);
 
 			/* reiser4_cut_tree_object() was interrupted probably because
@@ -414,7 +414,7 @@ cut_file_items(struct inode *inode, loff
 		break;
 	}
 
-	/* the below does up(sbinfo->delete_sema). Do not get folled */
+	/* the below does up(sbinfo->delete_mutex). Do not get folled */
 	reiser4_release_reserved(inode->i_sb);
 
 	return result;
@@ -482,7 +482,7 @@ static int shorten_file(struct inode *in
 	page = read_cache_page(inode->i_mapping, index, filler, NULL);
 	if (IS_ERR(page)) {
 		/*
-		 * the below does up(sbinfo->delete_sema). Do not get
+		 * the below does up(sbinfo->delete_mutex). Do not get
 		 * confused
 		 */
 		reiser4_release_reserved(inode->i_sb);
@@ -496,7 +496,7 @@ static int shorten_file(struct inode *in
 	if (!PageUptodate(page)) {
 		page_cache_release(page);
 		/*
-		 * the below does up(sbinfo->delete_sema). Do not get
+		 * the below does up(sbinfo->delete_mutex). Do not get
 		 * confused
 		 */
 		reiser4_release_reserved(inode->i_sb);
@@ -516,7 +516,7 @@ static int shorten_file(struct inode *in
 	if (result) {
 		page_cache_release(page);
 		/*
-		 * the below does up(sbinfo->delete_sema). Do not get
+		 * the below does up(sbinfo->delete_mutex). Do not get
 		 * confused
 		 */
 		reiser4_release_reserved(inode->i_sb);
@@ -531,7 +531,7 @@ static int shorten_file(struct inode *in
 	kunmap_atomic(kaddr, KM_USER0);
 	unlock_page(page);
 	page_cache_release(page);
-	/* the below does up(sbinfo->delete_sema). Do not get confused */
+	/* the below does up(sbinfo->delete_mutex). Do not get confused */
 	reiser4_release_reserved(inode->i_sb);
 	return 0;
 }
diff -puN fs/reiser4/plugin/space/bitmap.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/plugin/space/bitmap.c
--- a/fs/reiser4/plugin/space/bitmap.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/plugin/space/bitmap.c
@@ -13,7 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/fs.h>		/* for struct super_block  */
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <linux/vmalloc.h>
 #include <asm/div64.h>
 
@@ -72,7 +72,7 @@ typedef unsigned long ulong_t;
 /* Block allocation/deallocation are done through special bitmap objects which
    are allocated in an array at fs mount. */
 struct bitmap_node {
-	struct semaphore sema;	/* long term lock object */
+	struct mutex mutex;	/* long term lock object */
 
 	jnode *wjnode;		/* j-nodes for WORKING ... */
 	jnode *cjnode;		/* ... and COMMIT bitmap blocks */
@@ -702,7 +702,7 @@ init_bnode(struct bitmap_node *bnode,
 {
 	memset(bnode, 0, sizeof(struct bitmap_node));
 
-	sema_init(&bnode->sema, 1);
+	mutex_init(&bnode->mutex);
 	atomic_set(&bnode->loaded, 0);
 }
 
@@ -826,14 +826,14 @@ static int load_and_lock_bnode(struct bi
 	if (atomic_read(&bnode->loaded)) {
 		/* bitmap is already loaded, nothing to do */
 		check_bnode_loaded(bnode);
-		down(&bnode->sema);
+		mutex_lock(&bnode->mutex);
 		assert("nikita-2827", atomic_read(&bnode->loaded));
 		return 0;
 	}
 
 	ret = prepare_bnode(bnode, &cjnode, &wjnode);
 	if (ret == 0) {
-		down(&bnode->sema);
+		mutex_lock(&bnode->mutex);
 
 		if (!atomic_read(&bnode->loaded)) {
 			assert("nikita-2822", cjnode != NULL);
@@ -850,13 +850,12 @@ static int load_and_lock_bnode(struct bi
 				atomic_set(&bnode->loaded, 1);
 				/* working bitmap is initialized by on-disk
 				 * commit bitmap. This should be performed
-				 * under semaphore. */
+				 * under mutex. */
 				memcpy(bnode_working_data(bnode),
 				       bnode_commit_data(bnode),
 				       bmap_size(current_blocksize));
-			} else {
-				up(&bnode->sema);
-			}
+			} else
+				mutex_unlock(&bnode->mutex);
 		} else
 			/* race: someone already loaded bitmap while we were
 			 * busy initializing data. */
@@ -878,7 +877,7 @@ static int load_and_lock_bnode(struct bi
 static void release_and_unlock_bnode(struct bitmap_node *bnode)
 {
 	check_bnode_loaded(bnode);
-	up(&bnode->sema);
+	mutex_unlock(&bnode->mutex);
 }
 
 /* This function does all block allocation work but only for one bitmap
@@ -1547,7 +1546,7 @@ int reiser4_destroy_allocator_bitmap(rei
 	for (i = 0; i < bitmap_blocks_nr; i++) {
 		struct bitmap_node *bnode = data->bitmap + i;
 
-		down(&bnode->sema);
+		mutex_lock(&bnode->mutex);
 
 #if REISER4_DEBUG
 		if (atomic_read(&bnode->loaded)) {
@@ -1564,7 +1563,7 @@ int reiser4_destroy_allocator_bitmap(rei
 		}
 #endif
 		done_bnode(bnode);
-		up(&bnode->sema);
+		mutex_unlock(&bnode->mutex);
 	}
 
 	vfree(data->bitmap);
diff -puN fs/reiser4/safe_link.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/safe_link.c
--- a/fs/reiser4/safe_link.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/safe_link.c
@@ -131,7 +131,7 @@ int safe_link_grab(reiser4_tree * tree, 
 	int result;
 
 	grab_space_enable();
-	/* The sbinfo->delete semaphore can be taken here.
+	/* The sbinfo->delete_mutex can be taken here.
 	 * safe_link_release() should be called before leaving reiser4
 	 * context. */
 	result =
diff -puN fs/reiser4/super.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/super.h
--- a/fs/reiser4/super.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/super.h
@@ -44,8 +44,6 @@ typedef enum {
 	REISER4_BSD_GID = 2,
 	/* [mac]_time are 32 bit in inode */
 	REISER4_32_BIT_TIMES = 3,
-	/* allow concurrent flushes */
-	REISER4_MTFLUSH = 4,
 	/* load all bitmap blocks at mount time */
 	REISER4_DONT_LOAD_BITMAP = 5,
 	/* enforce atomicity during write(2) */
@@ -109,7 +107,7 @@ typedef struct object_ops {
 
     ->last_committed_tx
 
-   is protected by ->tmgr.commit_semaphore
+   is protected by ->tmgr.commit_mutex
 
    Invariants involving this data-type:
 
@@ -242,16 +240,13 @@ struct reiser4_super_info_data {
 	ra_params_t ra_params;
 
 	/*
-	 * A semaphore for serializing cut tree operation if out-of-free-space:
+	 * A mutex for serializing cut tree operation if out-of-free-space:
 	 * the only one cut_tree thread is allowed to grab space from reserved
 	 * area (it is 5% of disk space)
 	 */
-	struct semaphore delete_sema;
-	/* task owning ->delete_sema */
-	struct task_struct *delete_sema_owner;
-
-	/* serialize semaphore */
-	struct semaphore flush_sema;
+	struct mutex delete_mutex;
+	/* task owning ->delete_mutex */
+	struct task_struct *delete_mutex_owner;
 
 	/* Diskmap's blocknumber */
 	__u64 diskmap_block;
diff -puN fs/reiser4/txnmgr.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/txnmgr.c
@@ -338,7 +338,7 @@ void reiser4_init_txnmgr(txn_mgr *mgr)
 	mgr->id_count = 1;
 	INIT_LIST_HEAD(&mgr->atoms_list);
 	spin_lock_init(&mgr->tmgr_lock);
-	sema_init(&mgr->commit_semaphore, 1);
+	mutex_init(&mgr->commit_mutex);
 }
 
 /**
@@ -1002,9 +1002,8 @@ static int commit_current_atom(long *nr_
 	assert("zam-887", get_current_context()->trans->atom == *atom);
 	assert("jmacd-151", atom_isopen(*atom));
 
-	/* lock ordering: delete_sema and commit_sema are unordered */
 	assert("nikita-3184",
-	       get_current_super_private()->delete_sema_owner != current);
+	       get_current_super_private()->delete_mutex_owner != current);
 
 	for (flushiters = 0;; ++flushiters) {
 		ret =
@@ -1056,20 +1055,20 @@ static int commit_current_atom(long *nr_
 	assert("zam-906", list_empty(ATOM_WB_LIST(*atom)));
 
 	/* isolate critical code path which should be executed by only one
-	 * thread using tmgr semaphore */
-	down(&sbinfo->tmgr.commit_semaphore);
+	 * thread using tmgr mutex */
+	mutex_lock(&sbinfo->tmgr.commit_mutex);
 
 	ret = reiser4_write_logs(nr_submitted);
 	if (ret < 0)
 		reiser4_panic("zam-597", "write log failed (%ld)\n", ret);
 
-	/* The atom->ovrwr_nodes list is processed under commit semaphore held
+	/* The atom->ovrwr_nodes list is processed under commit mutex held
 	   because of bitmap nodes which are captured by special way in
 	   reiser4_pre_commit_hook_bitmap(), that way does not include
 	   capture_fuse_wait() as a capturing of other nodes does -- the commit
-	   semaphore is used for transaction isolation instead. */
+	   mutex is used for transaction isolation instead. */
 	reiser4_invalidate_list(ATOM_OVRWR_LIST(*atom));
-	up(&sbinfo->tmgr.commit_semaphore);
+	mutex_unlock(&sbinfo->tmgr.commit_mutex);
 
 	reiser4_invalidate_list(ATOM_CLEAN_LIST(*atom));
 	reiser4_invalidate_list(ATOM_WB_LIST(*atom));
diff -puN fs/reiser4/txnmgr.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/txnmgr.h
@@ -15,7 +15,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
+#include <linux/wait.h>
 
 /* TYPE DECLARATIONS */
 
@@ -367,8 +367,8 @@ struct txn_mgr {
 	/* A counter used to assign atom->atom_id values. */
 	__u32 id_count;
 
-	/* a semaphore object for commit serialization */
-	struct semaphore commit_semaphore;
+	/* a mutex object for commit serialization */
+	struct mutex commit_mutex;
 
 	/* a list of all txnmrgs served by particular daemon. */
 	struct list_head linkage;
@@ -648,8 +648,8 @@ struct flush_queue {
 	atomic_t nr_errors;
 	/* An atom this flush queue is attached to */
 	txn_atom *atom;
-	/* A semaphore for waiting on i/o completion */
-	struct semaphore io_sem;
+	/* A wait queue head to wait on i/o completion */
+	wait_queue_head_t wait;
 #if REISER4_DEBUG
 	/* A thread which took this fq in exclusive use, NULL if fq is free,
 	 * used for debugging. */
diff -puN fs/reiser4/wander.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible fs/reiser4/wander.c
--- a/fs/reiser4/wander.c~reiser4-get-rid-of-semaphores-wherever-it-is-possible
+++ a/fs/reiser4/wander.c
@@ -137,7 +137,7 @@
    versions in the reiser4 in-memory super block.  They get modified only at
    atom commit time.  The atom's commit thread has an exclusive access to those
    "committed" fields because the log writer implementation supports only one
-   atom commit a time (there is a per-fs "commit" semaphore).  At
+   atom commit a time (there is a per-fs "commit" mutex).  At
    that time "committed" counters are modified using per-atom information
    collected during the transaction. These counters are stored on disk as a
    part of tx head block when atom is committed.
@@ -1218,7 +1218,7 @@ int reiser4_write_logs(long *nr_submitte
 
 	/* relocate set is on the atom->clean_nodes list after
 	 * current_atom_complete_writes() finishes. It can be safely
-	 * uncaptured after commit_semaphore is taken, because any atom that
+	 * uncaptured after commit_mutex is locked, because any atom that
 	 * captures these nodes is guaranteed to commit after current one.
 	 *
 	 * This can only be done after reiser4_pre_commit_hook(), because it is where
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-get-rid-of-semaphores-wherever-it-is-possible.patch
reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch
reiser4-use-generic-file-read.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-simplify-reading-of-partially-converted-files.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
