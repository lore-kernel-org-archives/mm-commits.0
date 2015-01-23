From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch removed from -mm tree
Date: Thu, 22 Jan 2015 16:30:21 -0800
Message-ID: <54c1961d.SyN6pKupXqyPYcmQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbbAWAaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 19:30:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix leftover orphan entry caused by append O_DIRECT write crash
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix leftover orphan entry caused by append O_DIRECT write crash

If one node has crashed with orphan entry leftover, another node which do
append O_DIRECT write to the same file will override the
i_dio_orphaned_slot.  Then the old entry won't be cleaned forever.  If
this case happens, we let it wait for orphan recovery first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.h   |    2 ++
 fs/ocfs2/journal.c |    2 ++
 fs/ocfs2/namei.c   |   37 +++++++++++++++++++++++++++++++++++--
 fs/ocfs2/super.c   |    2 ++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/inode.h~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash
+++ a/fs/ocfs2/inode.h
@@ -81,6 +81,8 @@ struct ocfs2_inode_info
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
 
+	wait_queue_head_t append_dio_wq;
+
 	struct dquot *i_dquot[MAXQUOTAS];
 };
 
diff -puN fs/ocfs2/journal.c~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash
+++ a/fs/ocfs2/journal.c
@@ -2210,6 +2210,8 @@ static int ocfs2_recover_orphans(struct
 			ret = ocfs2_del_inode_from_orphan(osb, inode, 0, 0);
 			if (ret)
 				mlog_errno(ret);
+
+			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
 
 next:
diff -puN fs/ocfs2/namei.c~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash
+++ a/fs/ocfs2/namei.c
@@ -2681,6 +2681,26 @@ leave:
 	return status;
 }
 
+static int ocfs2_dio_orphan_recovered(struct inode *inode)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return 0;
+	}
+
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+	ret = !(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+	return ret;
+}
+
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct inode *inode)
 {
@@ -2693,12 +2713,26 @@ int ocfs2_add_inode_to_orphan(struct ocf
 	struct ocfs2_dinode *di = NULL;
 	bool orphaned = false;
 
+restart:
 	status = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+	/*
+	 * Another append dio crashed?
+	 * If so, wait for recovery first.
+	 */
+	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+		wait_event_interruptible(OCFS2_I(inode)->append_dio_wq,
+				ocfs2_dio_orphan_recovered(inode));
+		goto restart;
+	}
+
 	status = ocfs2_dio_prepare_orphan_dir(osb, &orphan_dir_inode,
 			OCFS2_I(inode)->ip_blkno,
 			orphan_name,
@@ -2711,8 +2745,7 @@ int ocfs2_add_inode_to_orphan(struct ocf
 				"orphan dir %llu.\n",
 				OCFS2_I(inode)->ip_blkno,
 				OCFS2_I(orphan_dir_inode)->ip_blkno);
-		di = (struct ocfs2_dinode *) di_bh->b_data;
-		if (!(di->i_flags & le32_to_cpu(OCFS2_ORPHANED_FL))) {
+		if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
 			mlog_errno(status);
 			goto bail_unlock_orphan;
 		}
diff -puN fs/ocfs2/super.c~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash
+++ a/fs/ocfs2/super.c
@@ -1776,6 +1776,8 @@ static void ocfs2_inode_init_once(void *
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
+	init_waitqueue_head(&oi->append_dio_wq);
+
 	ocfs2_metadata_cache_init(INODE_CACHE(&oi->vfs_inode),
 				  &ocfs2_inode_caching_ops);
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
linux-next.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

