From: akpm@linux-foundation.org
Subject: [nacked] ocfs2-remove-unneeded-variable-status.patch removed from -mm tree
Date: Fri, 27 Feb 2015 12:28:12 -0800
Message-ID: <54f0d35c.jHmJkZnMPBGjLQhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbB0U2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 15:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded variable 'status'
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-variable-status.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: remove unneeded variable 'status'

Use 'retval' instead of 'status'.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-remove-unneeded-variable-status fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-remove-unneeded-variable-status
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
@@ -1695,22 +1695,22 @@ int __ocfs2_add_entry(handle_t *handle,
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
 
 				if (ocfs2_dir_indexed(dir)) {
-					status = ocfs2_dx_dir_insert(dir,
+					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (status) {
-						mlog_errno(status);
+					if (retval) {
+						mlog_errno(retval);
 						goto bail;
 					}
 				}
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

