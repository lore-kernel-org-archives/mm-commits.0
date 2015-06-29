From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-use-retval-instead-of-status-for-checking-error.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:36:31 -0700
Message-ID: <5591ac4f.oHEcHYrkpoawzSUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbF2Ugc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use retval instead of status for checking error
has been removed from the -mm tree.  Its filename was
     ocfs2-use-retval-instead-of-status-for-checking-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: use retval instead of status for checking error

The use of 'status' in __ocfs2_add_entry() can return wrong value.  Some
functions' return value in __ocfs2_add_entry(), i.e
ocfs2_journal_access_di() is saved to 'status'.  But 'status' is not used
in 'bail' label for returning result of __ocfs2_add_entry().

So use retval instead of status.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-use-retval-instead-of-status-for-checking-error fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-use-retval-instead-of-status-for-checking-error
+++ a/fs/ocfs2/dir.c
@@ -1617,7 +1617,7 @@ int __ocfs2_add_entry(handle_t *handle,
 	struct ocfs2_dir_entry *de, *de1;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)parent_fe_bh->b_data;
 	struct super_block *sb = dir->i_sb;
-	int retval, status;
+	int retval;
 	unsigned int size = sb->s_blocksize;
 	struct buffer_head *insert_bh = lookup->dl_leaf_bh;
 	char *data_start = insert_bh->b_data;
@@ -1695,25 +1695,25 @@ int __ocfs2_add_entry(handle_t *handle,
 			}
 
 			if (insert_bh == parent_fe_bh)
-				status = ocfs2_journal_access_di(handle,
+				retval = ocfs2_journal_access_di(handle,
 								 INODE_CACHE(dir),
 								 insert_bh,
 								 OCFS2_JOURNAL_ACCESS_WRITE);
 			else {
-				status = ocfs2_journal_access_db(handle,
+				retval = ocfs2_journal_access_db(handle,
 								 INODE_CACHE(dir),
 								 insert_bh,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 
-				if (ocfs2_dir_indexed(dir)) {
-					status = ocfs2_dx_dir_insert(dir,
+				if (!retval && ocfs2_dir_indexed(dir))
+					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (status) {
-						mlog_errno(status);
-						goto bail;
-					}
-				}
+			}
+
+			if (retval) {
+				mlog_errno(retval);
+				goto bail;
 			}
 
 			/* By now the buffer is marked for journaling */
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch

