From: akpm@linux-foundation.org
Subject: + ocfs2-fix-null-dereference-for-moving-extents.patch added to -mm tree
Date: Tue, 09 Apr 2013 13:08:42 -0700
Message-ID: <20130409200842.E332831C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:50111 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935712Ab3DIUIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:08:44 -0400
Received: by mail-ia0-f201.google.com with SMTP id k25so752192iah.4
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:08:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, jeff.liu@oracle.com, jlbec@evilplan.org, mfasheh@suse.com


The patch titled
     Subject: ocfs2: fix NULL dereference for moving extents
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-dereference-for-moving-extents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix NULL dereference for moving extents

We can't dereference "bg" before it has been assigned.  GCC should have
warned about this but "bg" was initialized to NULL.  I've fixed that as
well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-null-dereference-for-moving-extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-null-dereference-for-moving-extents
+++ a/fs/ocfs2/move_extents.c
@@ -471,7 +471,7 @@ static int ocfs2_validate_and_adjust_mov
 	int ret, goal_bit = 0;
 
 	struct buffer_head *gd_bh = NULL;
-	struct ocfs2_group_desc *bg = NULL;
+	struct ocfs2_group_desc *bg;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int c_to_b = 1 << (osb->s_clustersize_bits -
 					inode->i_sb->s_blocksize_bits);
@@ -482,13 +482,6 @@ static int ocfs2_validate_and_adjust_mov
 	range->me_goal = ocfs2_block_to_cluster_start(inode->i_sb,
 						      range->me_goal);
 	/*
-	 * moving goal is not allowd to start with a group desc blok(#0 blk)
-	 * let's compromise to the latter cluster.
-	 */
-	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
-		range->me_goal += c_to_b;
-
-	/*
 	 * validate goal sits within global_bitmap, and return the victim
 	 * group desc
 	 */
@@ -502,6 +495,13 @@ static int ocfs2_validate_and_adjust_mov
 	bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 	/*
+	 * moving goal is not allowd to start with a group desc blok(#0 blk)
+	 * let's compromise to the latter cluster.
+	 */
+	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
+		range->me_goal += c_to_b;
+
+	/*
 	 * movement is not gonna cross two groups.
 	 */
 	if ((le16_to_cpu(bg->bg_bits) - goal_bit) * osb->s_clustersize <
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
ocfs2-fix-error-handling-in-ocfs2_ioctl_move_extents.patch
ocfs2-fix-null-dereference-for-moving-extents.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch
i2o-check-copy_from_user-size-parameter.patch

