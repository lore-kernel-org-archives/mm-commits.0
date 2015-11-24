From: akpm@linux-foundation.org
Subject: + ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
 added to -mm tree
Date: Mon, 23 Nov 2015 16:25:07 -0800
Message-ID: <5653ae63.vh7Fqp3OC+cV92bB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbKXAZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 19:25:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix ip_unaligned_aio deadlock with dio work queue
has been added to the -mm tree.  Its filename is
     ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix ip_unaligned_aio deadlock with dio work queue

In the current implementation of unaligned aio+dio, lock order behave as
follow:

in user process context:
  -> call io_submit()
    -> get i_mutex
		<== window1
      -> get ip_unaligned_aio
        -> submit direct io to block device
    -> release i_mutex
  -> io_submit() return

in dio work queue context(the work queue is created in __blockdev_direct_IO):
  -> release ip_unaligned_aio
		<== window2
    -> get i_mutex
      -> clear unwritten flag & change i_size
    -> release i_mutex

There is a limitation to the thread number of dio work queue.  256 at
default.  If all 256 thread are in the above 'window2' stage, and there is
a user process in the 'window1' stage, the system will became deadlock. 
Since the user process hold i_mutex to wait ip_unaligned_aio lock, while
there is a direct bio hold ip_unaligned_aio mutex who is waiting for a dio
work queue thread to be schedule.  But all the dio work queue thread is
waiting for i_mutex lock in 'window2'.

This case only happened in a test which send a large number(more than 256)
of aio at one io_submit() call.

My design is to remove ip_unaligned_aio lock.  Change it to a sync io
instead.  Just like ip_unaligned_aio lock, serialize the unaligned aio
dio.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |    6 ------
 fs/ocfs2/aops.h  |    7 -------
 fs/ocfs2/file.c  |   27 +++++++++------------------
 fs/ocfs2/inode.h |    3 ---
 fs/ocfs2/super.c |    1 -
 5 files changed, 9 insertions(+), 35 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/aops.c
@@ -2388,12 +2388,6 @@ static void ocfs2_dio_end_io(struct kioc
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
-	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
-		ocfs2_iocb_clear_unaligned_aio(iocb);
-
-		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
-	}
-
 	if (private)
 		ocfs2_dio_end_io_write(inode, private, offset, bytes);
 
diff -puN fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/aops.h
@@ -93,11 +93,4 @@ enum ocfs2_iocb_lock_bits {
 #define ocfs2_iocb_rw_locked_level(iocb) \
 	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
 
-#define ocfs2_iocb_set_unaligned_aio(iocb) \
-	set_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_clear_unaligned_aio(iocb) \
-	clear_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_is_unaligned_aio(iocb) \
-	test_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
-
 #endif /* OCFS2_FILE_H */
diff -puN fs/ocfs2/file.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/file.c
@@ -2170,7 +2170,7 @@ static ssize_t ocfs2_file_write_iter(str
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
-	int unaligned_dio = 0;
+	void *saved_ki_complete = NULL;
 	int append_write = ((iocb->ki_pos + count) >=
 			i_size_read(inode) ? 1 : 0);
 
@@ -2233,17 +2233,12 @@ static ssize_t ocfs2_file_write_iter(str
 		goto out;
 	}
 
-	if (direct_io && !is_sync_kiocb(iocb))
-		unaligned_dio = ocfs2_is_io_unaligned(inode, count, iocb->ki_pos);
-
-	if (unaligned_dio) {
+	if (direct_io && !is_sync_kiocb(iocb) &&
+	    ocfs2_is_io_unaligned(inode, count, iocb->ki_pos)) {
 		/*
-		 * Wait on previous unaligned aio to complete before
-		 * proceeding.
+		 * Make it a sync io if it's an unaligned aio.
 		 */
-		mutex_lock(&OCFS2_I(inode)->ip_unaligned_aio);
-		/* Mark the iocb as needing an unlock in ocfs2_dio_end_io */
-		ocfs2_iocb_set_unaligned_aio(iocb);
+		saved_ki_complete = xchg(&iocb->ki_complete, NULL);
 	}
 
 	/* communicate with ocfs2_dio_end_io */
@@ -2264,11 +2259,10 @@ static ssize_t ocfs2_file_write_iter(str
 	 */
 	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
 		rw_level = -1;
-		unaligned_dio = 0;
 	}
 
 	if (unlikely(written <= 0))
-		goto no_sync;
+		goto out;
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) ||
 	    IS_SYNC(inode)) {
@@ -2290,13 +2284,10 @@ static ssize_t ocfs2_file_write_iter(str
 						      iocb->ki_pos - 1);
 	}
 
-no_sync:
-	if (unaligned_dio && ocfs2_iocb_is_unaligned_aio(iocb)) {
-		ocfs2_iocb_clear_unaligned_aio(iocb);
-		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
-	}
-
 out:
+	if (saved_ki_complete)
+		xchg(&iocb->ki_complete, saved_ki_complete);
+
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
 
diff -puN fs/ocfs2/inode.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/inode.h
@@ -43,9 +43,6 @@ struct ocfs2_inode_info
 	/* protects extended attribute changes on this inode */
 	struct rw_semaphore		ip_xattr_sem;
 
-	/* Number of outstanding AIO's which are not page aligned */
-	struct mutex			ip_unaligned_aio;
-
 	/* These fields are protected by ip_lock */
 	spinlock_t			ip_lock;
 	u32				ip_open_count;
diff -puN fs/ocfs2/super.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/super.c
@@ -1742,7 +1742,6 @@ static void ocfs2_inode_init_once(void *
 	INIT_LIST_HEAD(&oi->ip_io_markers);
 	INIT_LIST_HEAD(&oi->ip_unwritten_list);
 	oi->ip_dir_start_lookup = 0;
-	mutex_init(&oi->ip_unaligned_aio);
 	init_rwsem(&oi->ip_alloc_sem);
 	init_rwsem(&oi->ip_xattr_sem);
 	mutex_init(&oi->ip_io_mutex);
_

Patches currently in -mm which might be from ryan.ding@oracle.com are

ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
ocfs2-test-target-page-before-change-it.patch
ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
ocfs2-record-unwritten-extents-when-populate-write-desc.patch
ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
ocfs2-code-clean-up-for-direct-io.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch
ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

