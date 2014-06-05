From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:54 -0700
Message-ID: <5390c83e.EFgzmBWIWsbTNV1K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaFETmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xuejiufei@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,xuejiufei@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:54 -0700


The patch titled
     Subject: ocfs2: cleanup unused paramters in ocfs2_calc_new_backup_super
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: cleanup unused paramters in ocfs2_calc_new_backup_super

Parameters new_clusters and first_new_cluster are not used in
ocfs2_update_last_group_and_inode, so remove them.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/ocfs2/resize.c~ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super
+++ a/fs/ocfs2/resize.c
@@ -53,8 +53,6 @@
  */
 static u16 ocfs2_calc_new_backup_super(struct inode *inode,
 				       struct ocfs2_group_desc *gd,
-				       int new_clusters,
-				       u32 first_new_cluster,
 				       u16 cl_cpg,
 				       int set)
 {
@@ -127,8 +125,6 @@ static int ocfs2_update_last_group_and_i
 				     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
 		backups = ocfs2_calc_new_backup_super(bm_inode,
 						     group,
-						     new_clusters,
-						     first_new_cluster,
 						     cl_cpg, 1);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
@@ -167,8 +163,6 @@ out_rollback:
 	if (ret < 0) {
 		ocfs2_calc_new_backup_super(bm_inode,
 					    group,
-					    new_clusters,
-					    first_new_cluster,
 					    cl_cpg, 0);
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
linux-next.patch

