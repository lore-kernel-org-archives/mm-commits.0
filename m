From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:05:49 -0800
Message-ID: <563d081d.bZIz1+fBO7HkRyKK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033242AbbKFUFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: only take lock if dio entry when recover orphans
has been removed from the -mm tree.  Its filename was
     ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
