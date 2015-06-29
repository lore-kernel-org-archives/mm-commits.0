From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:40 -0700
Message-ID: <5591ac58.QG/3h4NdTUad0ywN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbbF2Ugl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove OCFS2_IOCB_SEM lock type in direct io
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: remove OCFS2_IOCB_SEM lock type in direct io

In ocfs2 direct read/write, OCFS2_IOCB_SEM lock type is used to protect
inode->i_alloc_sem rw semaphore lock in the earlier kernel version. 
However, in the latest kernel, inode->i_alloc_sem rw semaphore lock is not
used at all, so OCFS2_IOCB_SEM lock type needs to be removed.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    3 ---
 fs/ocfs2/aops.h |    7 -------
 fs/ocfs2/file.c |   31 ++++---------------------------
 3 files changed, 4 insertions(+), 37 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io
+++ a/fs/ocfs2/aops.c
@@ -619,9 +619,6 @@ static void ocfs2_dio_end_io(struct kioc
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
-	if (ocfs2_iocb_is_sem_locked(iocb))
-		ocfs2_iocb_clear_sem_locked(iocb);
-
 	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 
diff -puN fs/ocfs2/aops.h~ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io
+++ a/fs/ocfs2/aops.h
@@ -79,7 +79,6 @@ static inline void ocfs2_iocb_set_rw_loc
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
 	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_SEM,
 	OCFS2_IOCB_UNALIGNED_IO,
 	OCFS2_IOCB_NUM_LOCKS
 };
@@ -88,12 +87,6 @@ enum ocfs2_iocb_lock_bits {
 	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
 #define ocfs2_iocb_rw_locked_level(iocb) \
 	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_set_sem_locked(iocb) \
-	set_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_clear_sem_locked(iocb) \
-	clear_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_is_sem_locked(iocb) \
-	test_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
 
 #define ocfs2_iocb_set_unaligned_aio(iocb) \
 	set_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
diff -puN fs/ocfs2/file.c~ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-remove-ocfs2_iocb_sem-lock-type-in-direct-io
+++ a/fs/ocfs2/file.c
@@ -2250,7 +2250,7 @@ out:
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
-	int direct_io, appending, rw_level, have_alloc_sem  = 0;
+	int direct_io, appending, rw_level;
 	int can_do_direct, has_refcount = 0;
 	ssize_t written = 0;
 	ssize_t ret;
@@ -2279,16 +2279,7 @@ static ssize_t ocfs2_file_write_iter(str
 
 	mutex_lock(&inode->i_mutex);
 
-	ocfs2_iocb_clear_sem_locked(iocb);
-
 relock:
-	/* to match setattr's i_mutex -> rw_lock ordering */
-	if (direct_io) {
-		have_alloc_sem = 1;
-		/* communicate with ocfs2_dio_end_io */
-		ocfs2_iocb_set_sem_locked(iocb);
-	}
-
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2298,7 +2289,7 @@ relock:
 	ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
 		mlog_errno(ret);
-		goto out_sems;
+		goto out_mutex;
 	}
 
 	/*
@@ -2347,7 +2338,6 @@ relock:
 	if (direct_io && !can_do_direct) {
 		ocfs2_rw_unlock(inode, rw_level);
 
-		have_alloc_sem = 0;
 		rw_level = -1;
 
 		direct_io = 0;
@@ -2416,7 +2406,6 @@ no_sync:
 	 */
 	if ((ret == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
 		rw_level = -1;
-		have_alloc_sem = 0;
 		unaligned_dio = 0;
 	}
 
@@ -2429,10 +2418,7 @@ out:
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
 
-out_sems:
-	if (have_alloc_sem)
-		ocfs2_iocb_clear_sem_locked(iocb);
-
+out_mutex:
 	mutex_unlock(&inode->i_mutex);
 
 	if (written)
@@ -2473,7 +2459,7 @@ bail:
 static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 				   struct iov_iter *to)
 {
-	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
+	int ret = 0, rw_level = -1, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = file_inode(filp);
 
@@ -2490,16 +2476,11 @@ static ssize_t ocfs2_file_read_iter(stru
 		goto bail;
 	}
 
-	ocfs2_iocb_clear_sem_locked(iocb);
-
 	/*
 	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
 	 */
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		have_alloc_sem = 1;
-		ocfs2_iocb_set_sem_locked(iocb);
-
 		ret = ocfs2_rw_lock(inode, 0);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2535,13 +2516,9 @@ static ssize_t ocfs2_file_read_iter(stru
 	/* see ocfs2_file_write_iter */
 	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
 		rw_level = -1;
-		have_alloc_sem = 0;
 	}
 
 bail:
-	if (have_alloc_sem)
-		ocfs2_iocb_clear_sem_locked(iocb);
