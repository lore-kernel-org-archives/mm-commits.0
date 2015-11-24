From: akpm@linux-foundation.org
Subject: + ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
 added to -mm tree
Date: Mon, 23 Nov 2015 16:25:11 -0800
Message-ID: <5653ae67.eK/eoEq1l8VFEIXv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbKXAZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 19:25:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix disk file size and memory file size mismatch
has been added to the -mm tree.  Its filename is
     ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix disk file size and memory file size mismatch

When doing append direct write in an already allocated cluster, and fast
path in ocfs2_dio_get_block() is triggered, function
ocfs2_dio_end_io_write() will be skipped as there is no context allocated.
 So disk file size will not be changed as it should be.  The solution is
to skip fast path when we are about to change file size.

Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-disk-file-size-and-memory-file-size-mismatch fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-disk-file-size-and-memory-file-size-mismatch
+++ a/fs/ocfs2/aops.c
@@ -2167,19 +2167,26 @@ static int ocfs2_dio_get_block(struct in
 	mlog(0, "get block of %lu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
-	down_read(&oi->ip_alloc_sem);
-	/* This is the fast path for re-write. */
-	ret = ocfs2_get_block(inode, iblock, bh_result, create);
+	/*
+	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
+	 * we may need to add it to orphan dir. So can not fall to fast path
+	 * while file size will be changed.
+	 */
+	if (pos + total_len <= i_size_read(inode)) {
+		down_read(&oi->ip_alloc_sem);
+		/* This is the fast path for re-write. */
+		ret = ocfs2_get_block(inode, iblock, bh_result, create);
 
-	up_read(&oi->ip_alloc_sem);
+		up_read(&oi->ip_alloc_sem);
 
-	if (buffer_mapped(bh_result) &&
-	    !buffer_new(bh_result) &&
-	    ret == 0)
-		goto out;
+		if (buffer_mapped(bh_result) &&
+		    !buffer_new(bh_result) &&
+		    ret == 0)
+			goto out;
 
-	/* Clear state set by ocfs2_get_block. */
-	bh_result->b_state = 0;
+		/* Clear state set by ocfs2_get_block. */
+		bh_result->b_state = 0;
+	}
 
 	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
 	if (unlikely(dwc == NULL)) {
_

Patches currently in -mm which might be from ryan.ding@oracle.com are

ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
ocfs2-test-target-page-before-change-it.patch
ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
ocfs2-record-unwritten-extents-when-populate-write-desc.patch
ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
ocfs2-code-clean-up-for-direct-io.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch
ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

