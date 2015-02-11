From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-removes-mlog_errno-call-twice-in-ocfs2_find_dir_space_el.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:22 -0800
Message-ID: <54dbb9c2.dp4nF/7aO4EXmDNL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbBKUVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: removes mlog_errno() call twice in ocfs2_find_dir_space_el()
has been removed from the -mm tree.  Its filename was
     ocfs2-removes-mlog_errno-call-twice-in-ocfs2_find_dir_space_el.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: removes mlog_errno() call twice in ocfs2_find_dir_space_el()

mlog_errno() is called twice when some functions are failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-removes-mlog_errno-call-twice-in-ocfs2_find_dir_space_el fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-removes-mlog_errno-call-twice-in-ocfs2_find_dir_space_el
+++ a/fs/ocfs2/dir.c
@@ -3456,10 +3456,8 @@ static int ocfs2_find_dir_space_el(struc
 	int blocksize = dir->i_sb->s_blocksize;
 
 	status = ocfs2_read_dir_block(dir, 0, &bh, 0);
-	if (status) {
-		mlog_errno(status);
+	if (status)
 		goto bail;
-	}
 
 	rec_len = OCFS2_DIR_REC_LEN(namelen);
 	offset = 0;
@@ -3480,10 +3478,9 @@ static int ocfs2_find_dir_space_el(struc
 			status = ocfs2_read_dir_block(dir,
 					     offset >> sb->s_blocksize_bits,
 					     &bh, 0);
-			if (status) {
-				mlog_errno(status);
+			if (status)
 				goto bail;
-			}
+
 			/* move to next block */
 			de = (struct ocfs2_dir_entry *) bh->b_data;
 		}
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch
mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
linux-next.patch

