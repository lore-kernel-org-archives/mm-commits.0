From: akpm@linux-foundation.org
Subject: - fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch removed from -mm tree
Date: Wed, 09 May 2007 03:04:29 -0700
Message-ID: <200705091004.l49A4TU5020752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754917AbXEIKEu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:04:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fsaio: add a wait queue arg to the wait_bit action() routine
has been removed from the -mm tree.  Its filename was
     fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fsaio: add a wait queue arg to the wait_bit action() routine
From: Suparna Bhattacharya <suparna@in.ibm.com>

Add a wait queue parameter to the action routine called by __wait_on_bit to
allow it to determine whether to block or not.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                  |    2 +-
 fs/inode.c                   |    2 +-
 fs/nfs/inode.c               |    2 +-
 fs/nfs/nfs4proc.c            |    2 +-
 fs/nfs/pagelist.c            |    2 +-
 include/linux/sunrpc/sched.h |    3 ++-
 include/linux/wait.h         |   18 ++++++++++++------
 include/linux/writeback.h    |    2 +-
 kernel/wait.c                |   14 ++++++++------
 mm/filemap.c                 |    2 +-
 net/sunrpc/sched.c           |    5 +++--
 11 files changed, 32 insertions(+), 22 deletions(-)

diff -puN fs/buffer.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine fs/buffer.c
--- a/fs/buffer.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/fs/buffer.c
@@ -55,7 +55,7 @@ init_buffer(struct buffer_head *bh, bh_e
 	bh->b_private = private;
 }
 
-static int sleep_on_buffer(void *word)
+static int sleep_on_buffer(void *word, wait_queue_t *wait)
 {
 	io_schedule();
 	return 0;
diff -puN fs/inode.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine fs/inode.c
--- a/fs/inode.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/fs/inode.c
@@ -1253,7 +1253,7 @@ int inode_needs_sync(struct inode *inode
 
 EXPORT_SYMBOL(inode_needs_sync);
 
-int inode_wait(void *word)
+int inode_wait(void *word, wait_queue_t *wait)
 {
 	schedule();
 	return 0;
diff -puN fs/nfs/inode.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine fs/nfs/inode.c
--- a/fs/nfs/inode.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/fs/nfs/inode.c
@@ -386,7 +386,7 @@ void nfs_setattr_update_inode(struct ino
 	}
 }
 
-static int nfs_wait_schedule(void *word)
+static int nfs_wait_schedule(void *word, wait_queue_t *wait)
 {
 	if (signal_pending(current))
 		return -ERESTARTSYS;
diff -puN fs/nfs/nfs4proc.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/fs/nfs/nfs4proc.c
@@ -2696,7 +2696,7 @@ nfs4_async_handle_error(struct rpc_task 
 	return 0;
 }
 
-static int nfs4_wait_bit_interruptible(void *word)
+static int nfs4_wait_bit_interruptible(void *word, wait_queue_t *wait)
 {
 	if (signal_pending(current))
 		return -ERESTARTSYS;
diff -puN fs/nfs/pagelist.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/fs/nfs/pagelist.c
@@ -176,7 +176,7 @@ nfs_release_request(struct nfs_page *req
 	nfs_page_free(req);
 }
 
-static int nfs_wait_bit_interruptible(void *word)
+static int nfs_wait_bit_interruptible(void *word, wait_queue_t *wait)
 {
 	int ret = 0;
 
diff -puN include/linux/sunrpc/sched.h~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine include/linux/sunrpc/sched.h
--- a/include/linux/sunrpc/sched.h~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/include/linux/sunrpc/sched.h
@@ -267,7 +267,8 @@ void *		rpc_malloc(struct rpc_task *, si
 void		rpc_free(struct rpc_task *);
 int		rpciod_up(void);
 void		rpciod_down(void);
-int		__rpc_wait_for_completion_task(struct rpc_task *task, int (*)(void *));
+int		__rpc_wait_for_completion_task(struct rpc_task *task,
+				int (*)(void *, wait_queue_t *wait));
 #ifdef RPC_DEBUG
 void		rpc_show_tasks(void);
 #endif
diff -puN include/linux/wait.h~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine include/linux/wait.h
--- a/include/linux/wait.h~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/include/linux/wait.h
@@ -145,11 +145,15 @@ void FASTCALL(__wake_up(wait_queue_head_
 extern void FASTCALL(__wake_up_locked(wait_queue_head_t *q, unsigned int mode));
 extern void FASTCALL(__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr));
 void FASTCALL(__wake_up_bit(wait_queue_head_t *, void *, int));
-int FASTCALL(__wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned));
-int FASTCALL(__wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned));
+int FASTCALL(__wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *,
+	int (*)(void *, wait_queue_t *), unsigned));
+int FASTCALL(__wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *,
+	int (*)(void *, wait_queue_t *), unsigned));
 void FASTCALL(wake_up_bit(void *, int));
-int FASTCALL(out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned));
-int FASTCALL(out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned));
+int FASTCALL(out_of_line_wait_on_bit(void *, int, int (*)(void *,
+	wait_queue_t *), unsigned));
+int FASTCALL(out_of_line_wait_on_bit_lock(void *, int, int (*)(void *,
+	wait_queue_t *), unsigned));
 wait_queue_head_t *FASTCALL(bit_waitqueue(void *, int));
 
 #define wake_up(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 1, NULL)
@@ -427,7 +431,8 @@ int wake_bit_function(wait_queue_t *wait
  * but has no intention of setting it.
  */
 static inline int wait_on_bit(void *word, int bit,
-				int (*action)(void *), unsigned mode)
+				int (*action)(void *, wait_queue_t *),
+				unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
@@ -451,7 +456,8 @@ static inline int wait_on_bit(void *word
  * clear with the intention of setting it, and when done, clearing it.
  */
 static inline int wait_on_bit_lock(void *word, int bit,
-				int (*action)(void *), unsigned mode)
+				int (*action)(void *, wait_queue_t *),
+				unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
diff -puN include/linux/writeback.h~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine include/linux/writeback.h
--- a/include/linux/writeback.h~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/include/linux/writeback.h
@@ -66,7 +66,7 @@ struct writeback_control {
  */	
 int writeback_inodes(struct writeback_control *wbc);
 void wake_up_inode(struct inode *inode);
-int inode_wait(void *);
+int inode_wait(void *, wait_queue_t *);
 int sync_inodes_sb(struct super_block *, int wait);
 int sync_inodes(int wait);
 
diff -puN kernel/wait.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine kernel/wait.c
--- a/kernel/wait.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/kernel/wait.c
@@ -159,14 +159,14 @@ EXPORT_SYMBOL(wake_bit_function);
  */
 int __sched fastcall
 __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
-			int (*action)(void *), unsigned mode)
+			int (*action)(void *, wait_queue_t *), unsigned mode)
 {
 	int ret = 0;
 
 	do {
 		prepare_to_wait(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags))
-			ret = (*action)(q->key.flags);
+			ret = (*action)(q->key.flags, &q->wait);
 	} while (test_bit(q->key.bit_nr, q->key.flags) && !ret);
 	finish_wait(wq, &q->wait);
 	return ret;
@@ -174,7 +174,8 @@ __wait_on_bit(wait_queue_head_t *wq, str
 EXPORT_SYMBOL(__wait_on_bit);
 
 int __sched fastcall out_of_line_wait_on_bit(void *word, int bit,
-					int (*action)(void *), unsigned mode)
+					int (*action)(void *, wait_queue_t *),
+					unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
 	DEFINE_WAIT_BIT(wait, word, bit);
@@ -185,14 +186,14 @@ EXPORT_SYMBOL(out_of_line_wait_on_bit);
 
 int __sched fastcall
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
-			int (*action)(void *), unsigned mode)
+			int (*action)(void *, wait_queue_t *), unsigned mode)
 {
 	int ret = 0;
 
 	do {
 		prepare_to_wait_exclusive(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags)) {
-			if ((ret = (*action)(q->key.flags)))
+			if ((ret = (*action)(q->key.flags, &q->wait)))
 				break;
 		}
 	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
@@ -202,7 +203,8 @@ __wait_on_bit_lock(wait_queue_head_t *wq
 EXPORT_SYMBOL(__wait_on_bit_lock);
 
 int __sched fastcall out_of_line_wait_on_bit_lock(void *word, int bit,
-					int (*action)(void *), unsigned mode)
+				int (*action)(void *, wait_queue_t *wait),
+				unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
 	DEFINE_WAIT_BIT(wait, word, bit);
diff -puN mm/filemap.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine mm/filemap.c
--- a/mm/filemap.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/mm/filemap.c
@@ -133,7 +133,7 @@ void remove_from_page_cache(struct page 
 	write_unlock_irq(&mapping->tree_lock);
 }
 
-static int sleep_on_page(void *word)
+static int sleep_on_page(void *word, wait_queue_t *wait)
 {
 	io_schedule();
 	return 0;
diff -puN net/sunrpc/sched.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine
+++ a/net/sunrpc/sched.c
@@ -259,7 +259,7 @@ void rpc_init_wait_queue(struct rpc_wait
 }
 EXPORT_SYMBOL(rpc_init_wait_queue);
 
-static int rpc_wait_bit_interruptible(void *word)
+static int rpc_wait_bit_interruptible(void *word, wait_queue_t *wait)
 {
 	if (signal_pending(current))
 		return -ERESTARTSYS;
@@ -295,7 +295,8 @@ static void rpc_mark_complete_task(struc
 /*
  * Allow callers to wait for completion of an RPC call
  */
-int __rpc_wait_for_completion_task(struct rpc_task *task, int (*action)(void *))
+int __rpc_wait_for_completion_task(struct rpc_task *task, int (*action)(
+			void *, wait_queue_t *wait))
 {
 	if (action == NULL)
 		action = rpc_wait_bit_interruptible;
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-is-unlikely.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
