From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
 added to -mm tree
Date: Thu, 23 Apr 2015 15:01:36 -0700
Message-ID: <55396bc0.YtmLjSp1ZIMU32Z7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbbDWWBh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:01:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a tiny race when truncate dio orohaned entry
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch

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
Subject: ocfs2: fix a tiny race when truncate dio orohaned entry

Once dio crashed it will leave an entry in orphan dir.  And orphan scan
will take care of the clean up.  There is a tiny race case that the same
entry will be truncated twice and then trigger the BUG in
ocfs2_del_inode_from_orphan.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c    |   12 ++++++++++
 fs/ocfs2/journal.c |   47 +++++++++++++++++++------------------------
 fs/ocfs2/namei.c   |   22 ++++----------------
 fs/ocfs2/namei.h   |    4 +--
 4 files changed, 39 insertions(+), 46 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry
+++ a/fs/ocfs2/aops.c
@@ -925,13 +925,23 @@ clean_orphan:
 		int update_isize = written > 0 ? 1 : 0;
 		loff_t end = update_isize ? offset + written : 0;
 
-		tmp_ret = ocfs2_del_inode_from_orphan(osb, inode,
+		tmp_ret = ocfs2_inode_lock(inode, &di_bh, 1);
+		if (tmp_ret < 0) {
+			ret = tmp_ret;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		tmp_ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
 				update_isize, end);
 		if (tmp_ret < 0) {
 			ret = tmp_ret;
+			mlog_errno(ret);
 			goto out;
 		}
 
+		ocfs2_inode_unlock(inode, 1);
+
 		tmp_ret = jbd2_journal_force_commit(journal);
 		if (tmp_ret < 0) {
 			ret = tmp_ret;
diff -puN fs/ocfs2/journal.c~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry
+++ a/fs/ocfs2/journal.c
@@ -2137,6 +2137,8 @@ static int ocfs2_recover_orphans(struct
 	struct inode *inode = NULL;
 	struct inode *iter;
 	struct ocfs2_inode_info *oi;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
 
 	trace_ocfs2_recover_orphans(slot);
 
@@ -2157,16 +2159,22 @@ static int ocfs2_recover_orphans(struct
 		iter = oi->ip_next_orphan;
 		oi->ip_next_orphan = NULL;
 
+		ret = ocfs2_rw_lock(inode, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto next;
+		}
 		/*
 		 * We need to take and drop the inode lock to
 		 * force read inode from disk.
 		 */
-		ret = ocfs2_inode_lock(inode, NULL, 0);
+		ret = ocfs2_inode_lock(inode, &di_bh, 1);
 		if (ret) {
 			mlog_errno(ret);
-			goto next;
+			goto unlock_rw;
 		}
-		ocfs2_inode_unlock(inode, 0);
+
+		di = (struct ocfs2_dinode *)di_bh->b_data;
 
 		if (inode->i_nlink == 0) {
 			spin_lock(&oi->ip_lock);
@@ -2174,43 +2182,30 @@ static int ocfs2_recover_orphans(struct
 			 * ocfs2_delete_inode. */
 			oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
 			spin_unlock(&oi->ip_lock);
-		} else if (orphan_reco_type == ORPHAN_NEED_TRUNCATE) {
-			struct buffer_head *di_bh = NULL;
-
-			ret = ocfs2_rw_lock(inode, 1);
-			if (ret) {
-				mlog_errno(ret);
-				goto next;
-			}
-
-			ret = ocfs2_inode_lock(inode, &di_bh, 1);
-			if (ret < 0) {
-				ocfs2_rw_unlock(inode, 1);
-				mlog_errno(ret);
-				goto next;
-			}
-
+		} else if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
+				(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
 			ret = ocfs2_truncate_file(inode, di_bh,
 					i_size_read(inode));
-			ocfs2_inode_unlock(inode, 1);
-			ocfs2_rw_unlock(inode, 1);
-			brelse(di_bh);
 			if (ret < 0) {
 				if (ret != -ENOSPC)
 					mlog_errno(ret);
-				goto next;
+				goto unlock_inode;
 			}
 
-			ret = ocfs2_del_inode_from_orphan(osb, inode, 0, 0);
+			ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
 			if (ret)
 				mlog_errno(ret);
 
 			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
-
+unlock_inode:
+		ocfs2_inode_unlock(inode, 1);
+unlock_rw:
+		ocfs2_rw_unlock(inode, 1);
 next:
 		iput(inode);
-
+		brelse(di_bh);
+		di_bh = NULL;
 		inode = iter;
 	}
 
diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry
+++ a/fs/ocfs2/namei.c
@@ -2670,30 +2670,22 @@ bail:
 }
 
 int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
-		struct inode *inode, int update_isize,
-		loff_t end)
+		struct inode *inode, struct buffer_head *di_bh,
+		int update_isize, loff_t end)
 {
 	struct inode *orphan_dir_inode = NULL;
 	struct buffer_head *orphan_dir_bh = NULL;
-	struct buffer_head *di_bh = NULL;
-	struct ocfs2_dinode *di = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	handle_t *handle = NULL;
 	int status = 0;
 
-	status = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-	di = (struct ocfs2_dinode *) di_bh->b_data;
-
 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
 			ORPHAN_DIR_SYSTEM_INODE,
 			le16_to_cpu(di->i_dio_orphaned_slot));
 	if (!orphan_dir_inode) {
 		status = -ENOENT;
 		mlog_errno(status);
-		goto bail_unlock_inode;
+		goto bail;
 	}
 
 	mutex_lock(&orphan_dir_inode->i_mutex);
@@ -2702,7 +2694,7 @@ int ocfs2_del_inode_from_orphan(struct o
 		mutex_unlock(&orphan_dir_inode->i_mutex);
 		iput(orphan_dir_inode);
 		mlog_errno(status);
-		goto bail_unlock_inode;
+		goto bail;
 	}
 
 	handle = ocfs2_start_trans(osb,
@@ -2749,10 +2741,6 @@ bail_unlock_orphan:
 	brelse(orphan_dir_bh);
 	iput(orphan_dir_inode);
 
-bail_unlock_inode:
-	ocfs2_inode_unlock(inode, 1);
-	brelse(di_bh);
-
 bail:
 	return status;
 }
diff -puN fs/ocfs2/namei.h~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry fs/ocfs2/namei.h
--- a/fs/ocfs2/namei.h~ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry
+++ a/fs/ocfs2/namei.h
@@ -42,8 +42,8 @@ int ocfs2_create_inode_in_orphan(struct
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 		struct inode *inode);
 int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
-		struct inode *inode, int update_isize,
-		loff_t end);
+		struct inode *inode, struct buffer_head *di_bh,
+		int update_isize, loff_t end);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

