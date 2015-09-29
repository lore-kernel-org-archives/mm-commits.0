From: akpm@linux-foundation.org
Subject: + ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch
 added to -mm tree
Date: Tue, 29 Sep 2015 16:19:28 -0700
Message-ID: <560b1c80.bpPeGJh0adgD+gbR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbbI2XT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: only take lock if dio entry when recover orphans
has been added to the -mm tree.  Its filename is
     ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch

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
Subject: ocfs2: only take lock if dio entry when recover orphans

We have no need to take inode mutex, rw and inode lock if it is not dio
entry when recover orphans.  Optimize it by adding a flag
OCFS2_INODE_DIO_ORPHAN_ENTRY to ocfs2_inode_info to reduce contention.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.h   |    2 +
 fs/ocfs2/journal.c |   86 +++++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 39 deletions(-)

diff -puN fs/ocfs2/inode.h~ocfs2-only-take-lock-if-dio-entry-when-recover-orphans fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-only-take-lock-if-dio-entry-when-recover-orphans
+++ a/fs/ocfs2/inode.h
@@ -112,6 +112,8 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_OPEN_DIRECT		0x00000020
 /* Tell the inode wipe code it's not in orphan dir */
 #define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000040
+/* Entry in orphan dir with 'dio-' prefix */
+#define OCFS2_INODE_DIO_ORPHAN_ENTRY	0x00000080
 
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff -puN fs/ocfs2/journal.c~ocfs2-only-take-lock-if-dio-entry-when-recover-orphans fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-only-take-lock-if-dio-entry-when-recover-orphans
+++ a/fs/ocfs2/journal.c
@@ -2049,6 +2049,10 @@ static int ocfs2_orphan_filldir(struct d
 	if (IS_ERR(iter))
 		return 0;
 
+	if (!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
+			OCFS2_DIO_ORPHAN_PREFIX_LEN))
+		OCFS2_I(iter)->ip_flags |= OCFS2_INODE_DIO_ORPHAN_ENTRY;
+
 	/* Skip inodes which are already added to recover list, since dio may
 	 * happen concurrently with unlink/rename */
 	if (OCFS2_I(iter)->ip_next_orphan) {
@@ -2195,25 +2199,51 @@ static int ocfs2_recover_orphans(struct
 		iter = oi->ip_next_orphan;
 		oi->ip_next_orphan = NULL;
 
-		mutex_lock(&inode->i_mutex);
-		ret = ocfs2_rw_lock(inode, 1);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto next;
-		}
-		/*
-		 * We need to take and drop the inode lock to
-		 * force read inode from disk.
-		 */
-		ret = ocfs2_inode_lock(inode, &di_bh, 1);
-		if (ret) {
-			mlog_errno(ret);
-			goto unlock_rw;
-		}
+		if (oi->ip_flags & OCFS2_INODE_DIO_ORPHAN_ENTRY) {
+			mutex_lock(&inode->i_mutex);
+			ret = ocfs2_rw_lock(inode, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto unlock_mutex;
+			}
+			/*
+			 * We need to take and drop the inode lock to
+			 * force read inode from disk.
+			 */
+			ret = ocfs2_inode_lock(inode, &di_bh, 1);
+			if (ret) {
+				mlog_errno(ret);
+				goto unlock_rw;
+			}
 
-		di = (struct ocfs2_dinode *)di_bh->b_data;
+			di = (struct ocfs2_dinode *)di_bh->b_data;
 
-		if (inode->i_nlink == 0) {
+			if (di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)) {
+				ret = ocfs2_truncate_file(inode, di_bh,
+						i_size_read(inode));
+				if (ret < 0) {
+					if (ret != -ENOSPC)
+						mlog_errno(ret);
+					goto unlock_inode;
+				}
+
+				ret = ocfs2_del_inode_from_orphan(osb, inode,
+						di_bh, 0, 0);
+				if (ret)
+					mlog_errno(ret);
+			}
+unlock_inode:
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+			di_bh = NULL;
+unlock_rw:
+			ocfs2_rw_unlock(inode, 1);
+unlock_mutex:
+			mutex_unlock(&inode->i_mutex);
+
+			/* clear dio flag in ocfs2_inode_info */
+			oi->ip_flags &= ~OCFS2_INODE_DIO_ORPHAN_ENTRY;
+		} else {
 			spin_lock(&oi->ip_lock);
 			/* Set the proper information to get us going into
 			 * ocfs2_delete_inode. */
@@ -2221,28 +2251,6 @@ static int ocfs2_recover_orphans(struct
 			spin_unlock(&oi->ip_lock);
 		}
 
-		if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
-				(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
-			ret = ocfs2_truncate_file(inode, di_bh,
-					i_size_read(inode));
-			if (ret < 0) {
-				if (ret != -ENOSPC)
-					mlog_errno(ret);
-				goto unlock_inode;
-			}
-
-			ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
-			if (ret)
-				mlog_errno(ret);
-		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
-unlock_inode:
-		ocfs2_inode_unlock(inode, 1);
-		brelse(di_bh);
-		di_bh = NULL;
-unlock_rw:
-		ocfs2_rw_unlock(inode, 1);
-next:
-		mutex_unlock(&inode->i_mutex);
 		iput(inode);
 		inode = iter;
 	}
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-improve-performance-for-localalloc.patch
ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan.patch
ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

