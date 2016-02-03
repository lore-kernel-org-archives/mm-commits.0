From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cluster-fix-memory-leak-in-o2hb_region_release.patch removed from -mm tree
Date: Wed, 03 Feb 2016 13:53:02 -0800
Message-ID: <56b276be.b6jcKwp2byx/cBZ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbcBCVxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: fix memory leak in o2hb_region_release
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-fix-memory-leak-in-o2hb_region_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/cluster: fix memory leak in o2hb_region_release

o2hb_region_release currently doesn't free o2hb_debug_buf
hr_db_elapsed_time and hr_db_pinned malloced in o2hb_debug_create.  Also
we should call debugfs_remove before freeing its data, to prevent the risk
accessing debugfs rightly after its data has been freed.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-fix-memory-leak-in-o2hb_region_release fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-fix-memory-leak-in-o2hb_region_release
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1254,15 +1254,15 @@ static const struct file_operations o2hb
 
 void o2hb_exit(void)
 {
-	kfree(o2hb_db_livenodes);
-	kfree(o2hb_db_liveregions);
-	kfree(o2hb_db_quorumregions);
-	kfree(o2hb_db_failedregions);
 	debugfs_remove(o2hb_debug_failedregions);
 	debugfs_remove(o2hb_debug_quorumregions);
 	debugfs_remove(o2hb_debug_liveregions);
 	debugfs_remove(o2hb_debug_livenodes);
 	debugfs_remove(o2hb_debug_dir);
+	kfree(o2hb_db_livenodes);
+	kfree(o2hb_db_liveregions);
+	kfree(o2hb_db_quorumregions);
+	kfree(o2hb_db_failedregions);
 }
 
 static struct dentry *o2hb_debug_create(const char *name, struct dentry *dir,
@@ -1438,13 +1438,15 @@ static void o2hb_region_release(struct c
 
 	kfree(reg->hr_slots);
 
-	kfree(reg->hr_db_regnum);
-	kfree(reg->hr_db_livenodes);
 	debugfs_remove(reg->hr_debug_livenodes);
 	debugfs_remove(reg->hr_debug_regnum);
 	debugfs_remove(reg->hr_debug_elapsed_time);
 	debugfs_remove(reg->hr_debug_pinned);
 	debugfs_remove(reg->hr_debug_dir);
+	kfree(reg->hr_db_livenodes);
+	kfree(reg->hr_db_regnum);
+	kfree(reg->hr_debug_elapsed_time);
+	kfree(reg->hr_debug_pinned);
 
 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-a-typo-in-dlmcommonh.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

