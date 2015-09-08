From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-race-between-crashed-dio-and-rm.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:02:41 -0700
Message-ID: <55ef22c1.thdVFJLUAuPXIsMf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix race between crashed dio and rm
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-race-between-crashed-dio-and-rm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix race between crashed dio and rm

There is a race case between crashed dio and rm, which will lead to
OCFS2_VALID_FL not set read-only.

N1                              N2
------------------------------------------------------------------------
dd with direct flag
                                rm file
crashed with an dio entry left
in orphan dir
                                clear OCFS2_VALID_FL in
                                ocfs2_remove_inode
                                recover N1 and read the corrupted inode,
                                and set filesystem read-only

So we skip the inode deletion this time and wait for dio entry
recovered first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c   |    9 +++++++++
 fs/ocfs2/journal.c |    4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/inode.c~ocfs2-fix-race-between-crashed-dio-and-rm fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-fix-race-between-crashed-dio-and-rm
+++ a/fs/ocfs2/inode.c
@@ -971,6 +971,7 @@ static void ocfs2_delete_inode(struct in
 	int wipe, status;
 	sigset_t oldset;
 	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
 
 	trace_ocfs2_delete_inode(inode->i_ino,
 				 (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1025,6 +1026,14 @@ static void ocfs2_delete_inode(struct in
 		goto bail_unlock_nfs_sync;
 	}
 
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	/* Skip inode deletion and wait for dio orphan entry recovered
+	 * first */
+	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ocfs2_cleanup_delete_inode(inode, 0);
+		goto bail_unlock_inode;
+	}
+
 	/* Query the cluster. This will be the final decision made
 	 * before we go ahead and wipe the inode. */
 	status = ocfs2_query_inode_wipe(inode, di_bh, &wipe);
diff -puN fs/ocfs2/journal.c~ocfs2-fix-race-between-crashed-dio-and-rm fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-race-between-crashed-dio-and-rm
+++ a/fs/ocfs2/journal.c
@@ -2210,7 +2210,9 @@ static int ocfs2_recover_orphans(struct
 			 * ocfs2_delete_inode. */
 			oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
 			spin_unlock(&oi->ip_lock);
-		} else if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
+		}
+
+		if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
 				(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
 			ret = ocfs2_truncate_file(inode, di_bh,
 					i_size_read(inode));
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


