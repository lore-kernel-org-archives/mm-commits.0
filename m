From: akpm@linux-foundation.org
Subject: + ocfs2-fix-race-between-dio-and-recover-orphan.patch added to
 -mm tree
Date: Fri, 10 Jul 2015 14:34:10 -0700
Message-ID: <55a03a52./Xb/7GL8EhvZmyhC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbbGJVeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix race between dio and recover orphan
has been added to the -mm tree.  Its filename is
     ocfs2-fix-race-between-dio-and-recover-orphan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-race-between-dio-and-recover-orphan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-race-between-dio-and-recover-orphan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix race between dio and recover orphan

During direct io the inode will be added to orphan first and then deleted
from orphan.  There is a race window that the orphan entry will be deleted
twice and thus trigger the BUG when validating OCFS2_DIO_ORPHANED_FL in
ocfs2_del_inode_from_orphan.

ocfs2_direct_IO_write
    ...
    ocfs2_add_inode_to_orphan
    >>>>>>>> race window.
             1) another node may rm the file and then down, this node
             take care of orphan recovery and clear flag
             OCFS2_DIO_ORPHANED_FL.
             2) since rw lock is unlocked, it may race with another
             orphan recovery and append dio.
    ocfs2_del_inode_from_orphan

So take inode mutex lock when recovering orphans and make rw unlock at the
end of aio write in case of append dio.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c    |    9 ++++++---
 fs/ocfs2/file.c    |    2 +-
 fs/ocfs2/inode.h   |    2 --
 fs/ocfs2/journal.c |    8 ++++----
 fs/ocfs2/namei.c   |   42 +++++++++++++-----------------------------
 fs/ocfs2/super.c   |    2 --
 6 files changed, 24 insertions(+), 41 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/aops.c
@@ -627,10 +627,13 @@ static void ocfs2_dio_end_io(struct kioc
 		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
 
-	ocfs2_iocb_clear_rw_locked(iocb);
+	/* Let rw unlock to be done later to protect append direct io write */
+	if (offset + bytes <= i_size_read(inode)) {
+		ocfs2_iocb_clear_rw_locked(iocb);
 
-	level = ocfs2_iocb_rw_locked_level(iocb);
-	ocfs2_rw_unlock(inode, level);
+		level = ocfs2_iocb_rw_locked_level(iocb);
+		ocfs2_rw_unlock(inode, level);
+	}
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
diff -puN fs/ocfs2/file.c~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/file.c
@@ -2410,7 +2410,7 @@ no_sync:
 		unaligned_dio = 0;
 	}
 
-	if (unaligned_dio) {
+	if (unaligned_dio && ocfs2_iocb_is_unaligned_aio(iocb)) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
diff -puN fs/ocfs2/inode.h~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/inode.h
@@ -81,8 +81,6 @@ struct ocfs2_inode_info
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
 
-	wait_queue_head_t append_dio_wq;
-
 	struct dquot *i_dquot[MAXQUOTAS];
 };
 
diff -puN fs/ocfs2/journal.c~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/journal.c
@@ -2170,6 +2170,7 @@ static int ocfs2_recover_orphans(struct
 		iter = oi->ip_next_orphan;
 		oi->ip_next_orphan = NULL;
 
+		mutex_lock(&inode->i_mutex);
 		ret = ocfs2_rw_lock(inode, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2206,17 +2207,16 @@ static int ocfs2_recover_orphans(struct
 			ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
 			if (ret)
 				mlog_errno(ret);
-
-			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
 unlock_inode:
 		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+		di_bh = NULL;
 unlock_rw:
 		ocfs2_rw_unlock(inode, 1);
 next:
+		mutex_unlock(&inode->i_mutex);
 		iput(inode);
-		brelse(di_bh);
-		di_bh = NULL;
 		inode = iter;
 	}
 
diff -puN fs/ocfs2/namei.c~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/namei.c
@@ -2570,27 +2570,6 @@ leave:
 	return status;
 }
 
-static int ocfs2_dio_orphan_recovered(struct inode *inode)
-{
-	int ret;
-	struct buffer_head *di_bh = NULL;
-	struct ocfs2_dinode *di = NULL;
-
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return 0;
-	}
-
-	di = (struct ocfs2_dinode *) di_bh->b_data;
-	ret = !(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
-	ocfs2_inode_unlock(inode, 1);
-	brelse(di_bh);
-
-	return ret;
-}
-
-#define OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL 10000
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct inode *inode)
 {
@@ -2602,7 +2581,6 @@ int ocfs2_add_inode_to_orphan(struct ocf
 	handle_t *handle = NULL;
 	struct ocfs2_dinode *di = NULL;
 
-restart:
 	status = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2612,15 +2590,21 @@ restart:
 	di = (struct ocfs2_dinode *) di_bh->b_data;
 	/*
 	 * Another append dio crashed?
-	 * If so, wait for recovery first.
+	 * If so, manually recover it first.
 	 */
 	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
-		ocfs2_inode_unlock(inode, 1);
-		brelse(di_bh);
-		wait_event_interruptible_timeout(OCFS2_I(inode)->append_dio_wq,
-				ocfs2_dio_orphan_recovered(inode),
-				msecs_to_jiffies(OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL));
-		goto restart;
+		status = ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
+		if (status < 0) {
+			if (status != -ENOSPC)
+				mlog_errno(status);
+			goto bail_unlock_inode;
+		}
+
+		status = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_unlock_inode;
+		}
 	}
 
 	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
diff -puN fs/ocfs2/super.c~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/super.c
@@ -1746,8 +1746,6 @@ static void ocfs2_inode_init_once(void *
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
-	init_waitqueue_head(&oi->append_dio_wq);
