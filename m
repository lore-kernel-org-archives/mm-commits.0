From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unneeded-variable-status.patch added to -mm tree
Date: Thu, 26 Feb 2015 13:34:43 -0800
Message-ID: <54ef9173.OxLSGv0iyVbsNWQ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbbBZVeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 16:34:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded variable 'status'
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unneeded-variable-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unneeded-variable-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unneeded-variable-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-remove-unneeded-rc-for-kfree.patch
ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
ocfs2-remove-unneeded-variable-status.patch
ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

