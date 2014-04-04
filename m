From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:29:59 -0700
Message-ID: <533f0837.jthm24pI8eMcPNHb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaDDTaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, wen.gang.wang@oracle.com

Subject: [merged] ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t.patch removed from -mm tree
To: wen.gang.wang@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:59 -0700


The patch titled
     Subject: ocfs2: change ip_unaligned_aio to of type mutex from atomit_t
has been removed from the -mm tree.  Its filename was
     ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: change ip_unaligned_aio to of type mutex from atomit_t

There is a problem that waitqueue_active() may check stale data thus miss
a wakeup of threads waiting on ip_unaligned_aio.

The valid value of ip_unaligned_aio is only 0 and 1 so we can change it to
be of type mutex thus the above prolem is avoid.  Another benifit is that
mutex which works as FIFO is fairer than wake_up_all().

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |    6 +-----
 fs/ocfs2/aops.h  |    5 -----
 fs/ocfs2/file.c  |   15 +++------------
 fs/ocfs2/inode.h |    2 +-
 fs/ocfs2/super.c |    9 ++-------
 5 files changed, 7 insertions(+), 30 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t
+++ a/fs/ocfs2/aops.c
@@ -571,7 +571,6 @@ static void ocfs2_dio_end_io(struct kioc
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int level;
-	wait_queue_head_t *wq = ocfs2_ioend_wq(inode);
 
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
@@ -582,10 +581,7 @@ static void ocfs2_dio_end_io(struct kioc
 	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 
-		if (atomic_dec_and_test(&OCFS2_I(inode)->ip_unaligned_aio) &&
-		    waitqueue_active(wq)) {
-			wake_up_all(wq);
-		}
+		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
 
 	ocfs2_iocb_clear_rw_locked(iocb);
diff -puN fs/ocfs2/aops.h~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t
+++ a/fs/ocfs2/aops.h
@@ -102,9 +102,4 @@ enum ocfs2_iocb_lock_bits {
 #define ocfs2_iocb_is_unaligned_aio(iocb) \
 	test_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
 
-#define OCFS2_IOEND_WQ_HASH_SZ	37
-#define ocfs2_ioend_wq(v)   (&ocfs2__ioend_wq[((unsigned long)(v)) %\
-					    OCFS2_IOEND_WQ_HASH_SZ])
-extern wait_queue_head_t ocfs2__ioend_wq[OCFS2_IOEND_WQ_HASH_SZ];
-
 #endif /* OCFS2_FILE_H */
diff -puN fs/ocfs2/file.c~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t
+++ a/fs/ocfs2/file.c
@@ -2061,13 +2061,6 @@ out:
 	return ret;
 }
 
-static void ocfs2_aiodio_wait(struct inode *inode)
-{
-	wait_queue_head_t *wq = ocfs2_ioend_wq(inode);
-
-	wait_event(*wq, (atomic_read(&OCFS2_I(inode)->ip_unaligned_aio) == 0));
-}
-
 static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
 {
 	int blockmask = inode->i_sb->s_blocksize - 1;
@@ -2345,10 +2338,8 @@ relock:
 		 * Wait on previous unaligned aio to complete before
 		 * proceeding.
 		 */
-		ocfs2_aiodio_wait(inode);
-
-		/* Mark the iocb as needing a decrement in ocfs2_dio_end_io */
-		atomic_inc(&OCFS2_I(inode)->ip_unaligned_aio);
+		mutex_lock(&OCFS2_I(inode)->ip_unaligned_aio);
+		/* Mark the iocb as needing an unlock in ocfs2_dio_end_io */
 		ocfs2_iocb_set_unaligned_aio(iocb);
 	}
 
@@ -2428,7 +2419,7 @@ out_dio:
 
 	if (unaligned_dio) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
-		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
+		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
 
 out:
diff -puN fs/ocfs2/inode.h~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t
+++ a/fs/ocfs2/inode.h
@@ -44,7 +44,7 @@ struct ocfs2_inode_info
 	struct rw_semaphore		ip_xattr_sem;
 
 	/* Number of outstanding AIO's which are not page aligned */
-	atomic_t			ip_unaligned_aio;
+	struct mutex			ip_unaligned_aio;
 
 	/* These fields are protected by ip_lock */
 	spinlock_t			ip_lock;
diff -puN fs/ocfs2/super.c~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t
+++ a/fs/ocfs2/super.c
@@ -1612,14 +1612,9 @@ static int ocfs2_show_options(struct seq
 	return 0;
 }
 
-wait_queue_head_t ocfs2__ioend_wq[OCFS2_IOEND_WQ_HASH_SZ];
-
 static int __init ocfs2_init(void)
 {
-	int status, i;
