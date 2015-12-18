From: akpm@linux-foundation.org
Subject: + ocfs2-fix-bug-when-calculate-new-backup-super.patch added to
 -mm tree
Date: Fri, 18 Dec 2015 13:28:40 -0800
Message-ID: <56747a88.UzKZ7Pav7P4884Zd%akpm__25200.8901363753$1450474139$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992AbbLRV2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 16:28:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, stable@vger.kernel.org, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG when calculate new backup super
has been added to the -mm tree.  Its filename is
     ocfs2-fix-bug-when-calculate-new-backup-super.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-bug-when-calculate-new-backup-super.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-bug-when-calculate-new-backup-super.patch

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
Subject: ocfs2: fix BUG when calculate new backup super

When resizing, it firstly extends the last gd.  Once it should backup
super in the gd, it calculates new backup super and update the
corresponding value.  But it currently doesn't consider the situation that
the backup super is already done.  And in this case, it still sets the bit
in gd bitmap and then decrease from bg_free_bits_count, which leads to a
corrupted gd and trigger the BUG in ocfs2_block_group_set_bits:
BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits); So check whether
the backup super is done and then do the updates.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/resize.c~ocfs2-fix-bug-when-calculate-new-backup-super fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-fix-bug-when-calculate-new-backup-super
+++ a/fs/ocfs2/resize.c
@@ -54,11 +54,12 @@
 static u16 ocfs2_calc_new_backup_super(struct inode *inode,
 				       struct ocfs2_group_desc *gd,
 				       u16 cl_cpg,
+				       u16 old_bg_clusters,
 				       int set)
 {
 	int i;
 	u16 backups = 0;
-	u32 cluster;
+	u32 cluster, lgd_cluster;
 	u64 blkno, gd_blkno, lgd_blkno = le64_to_cpu(gd->bg_blkno);
 
 	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
@@ -71,6 +72,12 @@ static u16 ocfs2_calc_new_backup_super(s
 		else if (gd_blkno > lgd_blkno)
 			break;
 
+		/* check if already done backup super */
+		lgd_cluster = ocfs2_blocks_to_clusters(inode->i_sb, lgd_blkno);
+		lgd_cluster += old_bg_clusters;
+		if (lgd_cluster >= cluster)
+			continue;
+
 		if (set)
 			ocfs2_set_bit(cluster % cl_cpg,
 				      (unsigned long *)gd->bg_bitmap);
@@ -99,6 +106,7 @@ static int ocfs2_update_last_group_and_i
 	u16 chain, num_bits, backups = 0;
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
+	u16 old_bg_clusters;
 
 	trace_ocfs2_update_last_group_and_inode(new_clusters,
 						first_new_cluster);
@@ -112,6 +120,7 @@ static int ocfs2_update_last_group_and_i
 
 	group = (struct ocfs2_group_desc *)group_bh->b_data;
 
+	old_bg_clusters = le16_to_cpu(group->bg_bits) / cl_bpc;
 	/* update the group first. */
 	num_bits = new_clusters * cl_bpc;
 	le16_add_cpu(&group->bg_bits, num_bits);
@@ -125,7 +134,7 @@ static int ocfs2_update_last_group_and_i
 				     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
 		backups = ocfs2_calc_new_backup_super(bm_inode,
 						     group,
-						     cl_cpg, 1);
+						     cl_cpg, old_bg_clusters, 1);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
 
@@ -163,7 +172,7 @@ out_rollback:
 	if (ret < 0) {
 		ocfs2_calc_new_backup_super(bm_inode,
 					    group,
-					    cl_cpg, 0);
+					    cl_cpg, old_bg_clusters, 0);
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-when-calculate-new-backup-super.patch
ocfs2-clean-up-redundant-null-check-before-iput.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

