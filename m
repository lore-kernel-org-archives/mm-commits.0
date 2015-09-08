From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:06 -0700
Message-ID: <55ef229e.dMrM8v3T7qvM0o4c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbIHSCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up unused local variables in ocfs2_file_write_iter
has been removed from the -mm tree.  Its filename was
     ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: clean up unused local variables in ocfs2_file_write_iter

Since commit 86b9c6f3f891 ("ocfs2: remove filesize checks for sync I/O
journal commit") removes filesize checks for sync I/O journal commit,
variables old_size and old_clusters are not actually used any more.  So
clean them up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter
+++ a/fs/ocfs2/file.c
@@ -2262,8 +2262,6 @@ static ssize_t ocfs2_file_write_iter(str
 	ssize_t written = 0;
 	ssize_t ret;
 	size_t count = iov_iter_count(from), orig_count;
-	loff_t old_size;
-	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2367,13 +2365,6 @@ relock:
 		ocfs2_iocb_set_unaligned_aio(iocb);
 	}
 
-	/*
-	 * To later detect whether a journal commit for sync writes is
-	 * necessary, we sample i_size, and cluster count here.
-	 */
-	old_size = i_size_read(inode);
-	old_clusters = OCFS2_I(inode)->ip_clusters;
