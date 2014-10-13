From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-shift-left-operations-overflow.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:17:33 -0700
Message-ID: <543c173d.BjFgQ2aeP2Gdj4/j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaJMSRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix shift left operations overflow
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-shift-left-operations-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix shift left operations overflow

ocfs2_inode_info->ip_clusters and ocfs2_dinode->id1.bitmap1.i_total are
defined as type u32, so the shift left operations may overflow if volume
size is large, for example, 2TB and cluster size is 1MB.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.h        |    2 +-
 fs/ocfs2/move_extents.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/inode.h~ocfs2-fix-shift-left-operations-overflow fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-fix-shift-left-operations-overflow
+++ a/fs/ocfs2/inode.h
@@ -162,7 +162,7 @@ static inline blkcnt_t ocfs2_inode_secto
 {
 	int c_to_s_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits - 9;
 
-	return (blkcnt_t)(OCFS2_I(inode)->ip_clusters << c_to_s_bits);
+	return (blkcnt_t)OCFS2_I(inode)->ip_clusters << c_to_s_bits;
 }
 
 /* Validate that a bh contains a valid inode */
diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-shift-left-operations-overflow fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-shift-left-operations-overflow
+++ a/fs/ocfs2/move_extents.c
@@ -404,7 +404,7 @@ static int ocfs2_find_victim_alloc_group
 	 * 'vict_blkno' was out of the valid range.
 	 */
 	if ((vict_blkno < le64_to_cpu(rec->c_blkno)) ||
-	    (vict_blkno >= (le32_to_cpu(ac_dinode->id1.bitmap1.i_total) <<
+	    (vict_blkno >= ((u64)le32_to_cpu(ac_dinode->id1.bitmap1.i_total) <<
 				bits_per_unit))) {
 		ret = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

