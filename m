From: akpm@linux-foundation.org
Subject: - task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:11:23 -0700
Message-ID: <200710190411.l9J4BNUt014366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbXJSEL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     cgroups: bdi init hooks
has been removed from the -mm tree.  Its filename was
     task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch

This patch was dropped because it was folded into task-containersv11-add-procfs-interface.patch

------------------------------------------------------
Subject: cgroups: bdi init hooks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

split off from the large bdi_init patch because cgroups are not slated
for mainline any time soon.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~task-containersv11-add-procfs-interface-containers-bdi-init-hooks kernel/cgroup.c
--- a/kernel/cgroup.c~task-containersv11-add-procfs-interface-containers-bdi-init-hooks
+++ a/kernel/cgroup.c
@@ -250,12 +250,13 @@ static int cgroup_populate_dir(struct cg
 static struct inode_operations cgroup_dir_inode_operations;
 static struct file_operations proc_cgroupstats_operations;
 
+static struct backing_dev_info cgroup_backing_dev_info = {
+	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+};
+
 static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
-	static struct backing_dev_info cgroup_backing_dev_info = {
-		.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
-	};
 
 	if (inode) {
 		inode->i_mode = mode;
@@ -1604,6 +1605,10 @@ int __init cgroup_init(void)
 	int i;
 	struct proc_dir_entry *entry;
 
+	err = bdi_init(&cgroup_backing_dev_info);
+	if (err)
+		return err;
+
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		if (!ss->early_init)
@@ -1619,6 +1624,9 @@ int __init cgroup_init(void)
 		entry->proc_fops = &proc_cgroupstats_operations;
 
 out:
+	if (err)
+		bdi_destroy(&cgroup_backing_dev_info);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
