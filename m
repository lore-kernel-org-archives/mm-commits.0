From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:20 -0700
Message-ID: <51db11a8./ByEMjtrVOiQMQ4u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHTXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [merged] ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:20 -0700


The patch titled
     Subject: ocfs2: need rollback when journal_access failed in ocfs2_orphan_add()
has been removed from the -mm tree.  Its filename was
     ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: need rollback when journal_access failed in ocfs2_orphan_add()

While adding a file into orphan dir in ocfs2_orphan_add(), it calls
__ocfs2_add_entry() before ocfs2_journal_access_di().  If
ocfs2_journal_access_di() failed, the file is added into orphan dir, and
orphan dir dinode updated, but file dinode has not been updated. 
Accordingly, the data is not consistent between file dinode and orphan
dir.

So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(), and
if ocfs2_journal_access_di() failed, orphan_fe and
orphan_dir_inode->i_nlink need rollback.

This bug was added by 3939fda4 ("Ocfs2: Journaling i_flags and
i_orphaned_slot when adding inode to orphan dir.").

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Acked-by: Jeff Liu <jeff.liu@oracle.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add
+++ a/fs/ocfs2/namei.c
@@ -2012,6 +2012,21 @@ static int ocfs2_orphan_add(struct ocfs2
 		goto leave;
 	}
 
+	/*
+	 * We're going to journal the change of i_flags and i_orphaned_slot.
+	 * It's safe anyway, though some callers may duplicate the journaling.
+	 * Journaling within the func just make the logic look more
+	 * straightforward.
+	 */
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(inode),
+					 fe_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	/* we're a cluster, and nlink can change on disk from
 	 * underneath us... */
 	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
@@ -2026,22 +2041,7 @@ static int ocfs2_orphan_add(struct ocfs2
 				   orphan_dir_bh, lookup);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
-	}
-
-	/*
-	 * We're going to journal the change of i_flags and i_orphaned_slot.
-	 * It's safe anyway, though some callers may duplicate the journaling.
-	 * Journaling within the func just make the logic look more
-	 * straightforward.
-	 */
-	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(inode),
-					 fe_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
+		goto rollback;
 	}
 
 	fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
@@ -2057,11 +2057,16 @@ static int ocfs2_orphan_add(struct ocfs2
 	trace_ocfs2_orphan_add_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
 				   osb->slot_num);
 
+rollback:
+	if (status < 0) {
+		if (S_ISDIR(inode->i_mode))
+			ocfs2_add_links_count(orphan_fe, -1);
+		set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
+	}
+
 leave:
 	brelse(orphan_dir_bh);
 
-	if (status)
-		mlog_errno(status);
 	return status;
 }
 
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

