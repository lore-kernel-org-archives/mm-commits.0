From: akpm@linux-foundation.org
Subject: +
 ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch added
 to -mm tree
Date: Wed, 22 Jul 2015 13:16:17 -0700
Message-ID: <55affa11.IiWg+0nWYNXJeo2Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbbGVUQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 16:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up unused local variables in ocfs2_file_write_iter
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch

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
@@ -2256,8 +2256,6 @@ static ssize_t ocfs2_file_write_iter(str
 	ssize_t written = 0;
 	ssize_t ret;
 	size_t count = iov_iter_count(from), orig_count;
-	loff_t old_size;
-	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2361,13 +2359,6 @@ relock:
 		ocfs2_iocb_set_unaligned_aio(iocb);
 	}
 
-	/*
-	 * To later detect whether a journal commit for sync writes is
-	 * necessary, we sample i_size, and cluster count here.
-	 */
-	old_size = i_size_read(inode);
-	old_clusters = OCFS2_I(inode)->ip_clusters;
