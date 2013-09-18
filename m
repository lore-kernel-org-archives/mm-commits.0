From: akpm@linux-foundation.org
Subject: + ocfs2-return-enomem-when-sb_getblk-fails-update.patch added to
 -mm tree
Date: Wed, 18 Sep 2013 16:14:24 -0700
Message-ID: <523a33d0.SYpCv/5B6VP6Ghh5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3IRXOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rui.xiang@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-return-enomem-when-sb_getblk-fails-update.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rui.xiang@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:14:24 -0700


The patch titled
     Subject: ocfs2-return-enomem-when-sb_getblk-fails-update
has been added to the -mm tree.  Its filename is
     ocfs2-return-enomem-when-sb_getblk-fails-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-return-enomem-when-sb_getblk-fails-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-return-enomem-when-sb_getblk-fails-update.patch

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
Subject: ocfs2-return-enomem-when-sb_getblk-fails-update

ocfs2_symlink_get_block in aops.c, and ocfs2_read_blocks_sync and
ocfs2_read_blocks in buffer_head_io.c need do the same change for
consistency.

Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c           |    1 +
 fs/ocfs2/buffer_head_io.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-return-enomem-when-sb_getblk-fails-update fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-return-enomem-when-sb_getblk-fails-update
+++ a/fs/ocfs2/aops.c
@@ -93,6 +93,7 @@ static int ocfs2_symlink_get_block(struc
 			    iblock;
 		buffer_cache_bh = sb_getblk(osb->sb, blkno);
 		if (!buffer_cache_bh) {
+			err = -ENOMEM;
 			mlog(ML_ERROR, "couldn't getblock for symlink!\n");
 			goto bail;
 		}
diff -puN fs/ocfs2/buffer_head_io.c~ocfs2-return-enomem-when-sb_getblk-fails-update fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~ocfs2-return-enomem-when-sb_getblk-fails-update
+++ a/fs/ocfs2/buffer_head_io.c
@@ -115,7 +115,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(osb->sb, block++);
 			if (bhs[i] == NULL) {
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
@@ -214,7 +214,7 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
 				ocfs2_metadata_cache_io_unlock(ci);
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-return-enomem-when-sb_getblk-fails-update.patch

