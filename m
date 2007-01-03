From: akpm@osdl.org
Subject: - fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:16:19 -0800
Message-ID: <200701032216.l03MGJPG000592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55323 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbXACWRQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:17:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, bcrl@kvack.org, drepper@redhat.com, hch@lst.de, mingo@elte.hu, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fsaio: add a wait queue parameter to the wait_bit action routine
has been removed from the -mm tree.  Its filename was
     fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fsaio: add a wait queue parameter to the wait_bit action routine
From: Suparna Bhattacharya <suparna@in.ibm.com>

Currently native linux AIO is properly supported (in the sense of actually
being asynchronous) only for files opened with O_DIRECT.  While this suffices
for a major (and most visible) user of AIO, i.e.  databases, other types of
users like Samba require AIO support for regular file IO.  Also, for glibc
POSIX AIO to be able to switch to using native AIO instead of the current
simulation using threads, it needs/expects asynchronous behaviour for both
O_DIRECT and buffered file AIO.

This patchset implements changes to make filesystem AIO read and write
asynchronous for the non O_DIRECT case.  This is mainly relevant in the case
of reads of uncached or partially cached files, and O_SYNC writes.  

Instead of translating regular IO to [AIO + wait], it translates AIO to
[regular IO - blocking + retries].  The intent of implementing it this way is
to avoid modifying or slowing down normal usage, by keeping it pretty much the
way it is without AIO, while avoiding code duplication.  Instead we make AIO
vs regular IO checks inside io_schedule(), i.e.  at the blocking points.  The
low-level unit of distinction is a wait queue entry, which in the AIO case is
contained in an iocb and in the synchronous IO case is associated with the
calling task.

The core idea is that is we complete as much IO as we can in a non-blocking
fashion, and then continue the remaining part of the transfer again when woken
up asynchronously via a wait queue callback when pages are ready ...  thus
each iteration progresses through more of the request until it is completed. 
The interesting part here is that owing largely to the idempotence in the way
radix-tree page cache traveral happens, every iteration is simply a smaller
read/write.  Almost all of the iocb manipulation and advancement in the AIO
case happens in the high level AIO code, and rather than in regular
VFS/filesystem paths.

The following is a sampling of comparative aio-stress results with the patches
(each run starts with uncached files):

---------------------------------------------
				
aio-stress throughput comparisons (in MB/s):

file size 1GB, record size 64KB, depth 64, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
4 way Pentium III SMP box, Adaptec AIC-7896/7 Ultra2 SCSI, 40 MB/s
Filesystem: ext2

----------------------------------------------------------------------------
			Buffered (non O_DIRECT)
			Vanilla		Patched		O_DIRECT
----------------------------------------------------------------------------
						       Vanilla Patched
Random-Read		10.08		23.91		18.91,   18.98
Random-O_SYNC-Write	 8.86		15.84		16.51,   16.53
Sequential-Read		31.49		33.00		31.86,   31.79
Sequential-O_SYNC-Write  8.68		32.60		31.45,   32.44
Random-Write		31.09 (19.65)	30.90 (19.65)	
Sequential-Write	30.84 (28.94)	30.09 (28.39)

----------------------------------------------------------------------------



This patch:

Add a wait queue parameter to the action routine called by __wait_on_bit to
allow it to determine whether to block or not.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

diff -puN fs/buffer.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine fs/buffer.c
--- a/fs/buffer.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/fs/buffer.c
@@ -55,7 +55,7 @@ init_buffer(struct buffer_head *bh, bh_e
 	bh->b_private = private;
 }
 
-static int sleep_on_buffer(void *word)
+static int sleep_on_buffer(void *word, wait_queue_t *wq)
 {
 	io_schedule();
 	return 0;
diff -puN fs/inode.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine fs/inode.c
--- a/fs/inode.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/fs/inode.c
@@ -1278,7 +1278,7 @@ void remove_dquot_ref(struct super_block
 
 #endif
 
-int inode_wait(void *word)
+int inode_wait(void *word, wait_queue_t *wait)
 {
 	schedule();
 	return 0;
diff -puN fs/nfs/inode.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine fs/nfs/inode.c
--- a/fs/nfs/inode.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/fs/nfs/inode.c
@@ -376,7 +376,7 @@ void nfs_setattr_update_inode(struct ino
 	}
 }
 
-static int nfs_wait_schedule(void *word)
+static int nfs_wait_schedule(void *word, wait_queue_t *wait)
 {
 	if (signal_pending(current))
 		return -ERESTARTSYS;
diff -puN fs/nfs/nfs4proc.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/fs/nfs/nfs4proc.c
@@ -2738,7 +2738,7 @@ nfs4_async_handle_error(struct rpc_task 
 	return 0;
 }
 
-static int nfs4_wait_bit_interruptible(void *word)
+static int nfs4_wait_bit_interruptible(void *word, wait_queue_t *wait)
 {
 	if (signal_pending(current))
 		return -ERESTARTSYS;
diff -puN fs/nfs/pagelist.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/fs/nfs/pagelist.c
@@ -176,7 +176,7 @@ nfs_release_request(struct nfs_page *req
 	nfs_page_free(req);
 }
 
-static int nfs_wait_bit_interruptible(void *word)
+static int nfs_wait_bit_interruptible(void *word, wait_queue_t *wait)
 {
 	int ret = 0;
 
diff -puN include/linux/sunrpc/sched.h~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine include/linux/sunrpc/sched.h
--- a/include/linux/sunrpc/sched.h~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/include/linux/sunrpc/sched.h
@@ -268,7 +268,8 @@ void *		rpc_malloc(struct rpc_task *, si
 void		rpc_free(struct rpc_task *);
 int		rpciod_up(void);
 void		rpciod_down(void);
-int		__rpc_wait_for_completion_task(struct rpc_task *task, int (*)(void *));
+int		__rpc_wait_for_completion_task(struct rpc_task *task,
+				int (*)(void *, wait_queue_t *wait));
 #ifdef RPC_DEBUG
 void		rpc_show_tasks(void);
 #endif
diff -puN include/linux/wait.h~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine include/linux/wait.h
--- a/include/linux/wait.h~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
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
diff -puN include/linux/writeback.h~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine include/linux/writeback.h
--- a/include/linux/writeback.h~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/include/linux/writeback.h
@@ -66,7 +66,7 @@ struct writeback_control {
  */	
 void writeback_inodes(struct writeback_control *wbc);
 void wake_up_inode(struct inode *inode);
-int inode_wait(void *);
+int inode_wait(void *, wait_queue_t *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
 
diff -puN kernel/wait.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine kernel/wait.c
--- a/kernel/wait.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
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
diff -puN mm/filemap.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine mm/filemap.c
--- a/mm/filemap.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/mm/filemap.c
@@ -133,7 +133,7 @@ void remove_from_page_cache(struct page 
 	write_unlock_irq(&mapping->tree_lock);
 }
 
-static int sleep_on_page(void *word)
+static int sleep_on_page(void *word, wait_queue_t *wq)
 {
 	io_schedule();
 	return 0;
diff -puN net/sunrpc/sched.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine
+++ a/net/sunrpc/sched.c
@@ -258,7 +258,7 @@ void rpc_init_wait_queue(struct rpc_wait
 }
 EXPORT_SYMBOL(rpc_init_wait_queue);
 
-static int rpc_wait_bit_interruptible(void *word)
+static int rpc_wait_bit_interruptible(void *word, wait_queue_t *wait)
 {
 	if (signal_pending(current))
 		return -ERESTARTSYS;
@@ -294,7 +294,8 @@ static void rpc_mark_complete_task(struc
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

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_slow.patch
fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-filesystem-aio-read-tidy.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
