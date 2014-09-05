From: akpm@linux-foundation.org
Subject: + ocfs2-fix-shift-left-operations-overflow.patch added to -mm
 tree
Date: Fri, 05 Sep 2014 13:11:20 -0700
Message-ID: <540a18e8.IVsU6CWC7PIYxWeq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaIEULV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 16:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix shift left operations overflow
has been added to the -mm tree.  Its filename is
     ocfs2-fix-shift-left-operations-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-shift-left-operations-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-shift-left-operations-overflow.patch

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

ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch
ocfs2-fix-shift-left-operations-overflow.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq.patch

