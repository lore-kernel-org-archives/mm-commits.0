From: akpm@linux-foundation.org
Subject: +
 ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 15:50:01 -0700
Message-ID: <59e68919.5qoviAXsm4GzzHrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbdJQWuC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashish.samant@oracle.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fstrim: Fix start offset of first cluster group during fstrim
has been added to the -mm tree.  Its filename is
     ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ashish Samant <ashish.samant@oracle.com>
Subject: ocfs2: fstrim: Fix start offset of first cluster group during fstrim

The first cluster group descriptor is not stored at the start of the group
but at an offset from the start.  We need to take this into account while
doing fstrim on the first cluster group.  Otherwise we will wrongly start
fstrim a few blocks after the desired start block and the range can cross
over into the next cluster group and zero out the group descriptor there. 
This can cause filesytem corruption that cannot be fixed by fsck.

Link: http://lkml.kernel.org/r/1507835579-7308-1-git-send-email-ashish.samant@oracle.com
Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim
+++ a/fs/ocfs2/alloc.c
@@ -7304,13 +7304,24 @@ out:
 
 static int ocfs2_trim_extent(struct super_block *sb,
 			     struct ocfs2_group_desc *gd,
-			     u32 start, u32 count)
+			     u64 group, u32 start, u32 count)
 {
 	u64 discard, bcount;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	bcount = ocfs2_clusters_to_blocks(sb, count);
-	discard = le64_to_cpu(gd->bg_blkno) +
-			ocfs2_clusters_to_blocks(sb, start);
+	discard = ocfs2_clusters_to_blocks(sb, start);
+
+	/*
+	 * For the first cluster group, the gd->bg_blkno is not at the start
+	 * of the group, but at an offset from the start. If we add it while
+	 * calculating discard for first group, we will wrongly start fstrim a
+	 * few blocks after the desried start block and the range can cross
+	 * over into the next cluster group. So, add it only if this is not
+	 * the first cluster group.
+	 */
+	if (group != osb->first_cluster_group_blkno)
+		discard += le64_to_cpu(gd->bg_blkno);
 
 	trace_ocfs2_trim_extent(sb, (unsigned long long)discard, bcount);
 
@@ -7318,7 +7329,7 @@ static int ocfs2_trim_extent(struct supe
 }
 
 static int ocfs2_trim_group(struct super_block *sb,
-			    struct ocfs2_group_desc *gd,
+			    struct ocfs2_group_desc *gd, u64 group,
 			    u32 start, u32 max, u32 minbits)
 {
 	int ret = 0, count = 0, next;
@@ -7337,7 +7348,7 @@ static int ocfs2_trim_group(struct super
 		next = ocfs2_find_next_bit(bitmap, max, start);
 
 		if ((next - start) >= minbits) {
-			ret = ocfs2_trim_extent(sb, gd,
+			ret = ocfs2_trim_extent(sb, gd, group,
 						start, next - start);
 			if (ret < 0) {
 				mlog_errno(ret);
@@ -7435,7 +7446,8 @@ int ocfs2_trim_fs(struct super_block *sb
 		}
 
 		gd = (struct ocfs2_group_desc *)gd_bh->b_data;
-		cnt = ocfs2_trim_group(sb, gd, first_bit, last_bit, minlen);
+		cnt = ocfs2_trim_group(sb, gd, group,
+				       first_bit, last_bit, minlen);
 		brelse(gd_bh);
 		gd_bh = NULL;
 		if (cnt < 0) {
_

Patches currently in -mm which might be from ashish.samant@oracle.com are

ocfs2-fstrim-fix-start-offset-of-first-cluster-group-during-fstrim.patch

