From: akpm@linux-foundation.org
Subject: [merged] ocfs2-do-not-set-filesystem-readonly-if-link-down.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:27 -0800
Message-ID: <5489e89f.NM3OqM2gbVtT/HWI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450AbaLKSz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not set filesystem readonly if link down
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-set-filesystem-readonly-if-link-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: do not set filesystem readonly if link down

Do not set the filesystem readonly if the storage link is down.  In this
case, metadata is not corrupted and only -EIO is returned.  And if it is
indeed corrupted metadata, it has already called ocfs2_error() in
ocfs2_validate_inode_block().

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    2 +-
 fs/ocfs2/dir.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-do-not-set-filesystem-readonly-if-link-down fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-do-not-set-filesystem-readonly-if-link-down
+++ a/fs/ocfs2/aops.c
@@ -1251,7 +1251,7 @@ static int ocfs2_write_cluster(struct ad
 	ret = ocfs2_extent_map_get_blocks(inode, v_blkno, &p_blkno, NULL,
 					  NULL);
 	if (ret < 0) {
-		ocfs2_error(inode->i_sb, "Corrupting extend for inode %llu, "
+		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
 			    "at logical block %llu",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)v_blkno);
diff -puN fs/ocfs2/dir.c~ocfs2-do-not-set-filesystem-readonly-if-link-down fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-do-not-set-filesystem-readonly-if-link-down
+++ a/fs/ocfs2/dir.c
@@ -744,7 +744,7 @@ restart:
 		if (ocfs2_read_dir_block(dir, block, &bh, 0)) {
 			/* read error, skip block & hope for the best.
 			 * ocfs2_read_dir_block() has released the bh. */
-			ocfs2_error(dir->i_sb, "reading directory %llu, "
+			mlog(ML_ERROR, "reading directory %llu, "
 				    "offset %lu\n",
 				    (unsigned long long)OCFS2_I(dir)->ip_blkno,
 				    block);
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch

