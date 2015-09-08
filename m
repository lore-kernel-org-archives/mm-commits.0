From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:12 -0700
Message-ID: <55ef2268.wY+rFc1qNa8K7rZJ%akpm__7062.56495691395$1441735306$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbIHSBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: direct write will call ocfs2_rw_unlock() twice when doing aio+dio
has been removed from the -mm tree.  Its filename was
     ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: direct write will call ocfs2_rw_unlock() twice when doing aio+dio

Orabug: 21612107

ocfs2_file_write_iter() is usng the wrong return value ('written').  This
will cause ocfs2_rw_unlock() be called both in write_iter & end_io,
triggering a BUG_ON.

This issue was introduced by commit 7da839c47589 ("ocfs2: use
__generic_file_write_iter()").

Fixes: 7da839c47589 ("ocfs2: use __generic_file_write_iter()")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio
+++ a/fs/ocfs2/file.c
@@ -2378,6 +2378,20 @@ relock:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(written == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
 
+	/*
+	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
+	 * function pointer which is called when o_direct io completes so that
+	 * it can unlock our rw lock.
+	 * Unfortunately there are error cases which call end_io and others
+	 * that don't.  so we don't have to unlock the rw_lock if either an
+	 * async dio is going to do it in the future or an end_io after an
+	 * error has already done it.
+	 */
+	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
+		rw_level = -1;
+		unaligned_dio = 0;
+	}
+
 	if (unlikely(written <= 0))
 		goto no_sync;
 
@@ -2402,20 +2416,6 @@ relock:
 	}
 
 no_sync:
-	/*
-	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
-	 * function pointer which is called when o_direct io completes so that
-	 * it can unlock our rw lock.
-	 * Unfortunately there are error cases which call end_io and others
-	 * that don't.  so we don't have to unlock the rw_lock if either an
-	 * async dio is going to do it in the future or an end_io after an
-	 * error has already done it.
-	 */
-	if ((ret == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
-		rw_level = -1;
-		unaligned_dio = 0;
-	}
