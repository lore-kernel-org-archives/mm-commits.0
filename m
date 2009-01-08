From: akpm@linux-foundation.org
Subject: - cgroups-remove-some-redundant-null-checks.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:22 -0800
Message-ID: <200901082247.n08MlMAt026832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763526AbZAHWsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: remove some redundant NULL checks
has been removed from the -mm tree.  Its filename was
     cgroups-remove-some-redundant-null-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: remove some redundant NULL checks
From: Li Zefan <lizf@cn.fujitsu.com>

- In cgroup_clone(), if vfs_mkdir() returns successfully,
  dentry->d_fsdata will be the pointer to the newly created
  cgroup and won't be NULL.

- a cgroup file's dentry->d_fsdata won't be NULL, guaranteed
  by cgroup_add_file().

- When walking through the subsystems of a cgroup_fs (using
  for_each_subsys), cgrp->subsys[ss->subsys_id] won't be NULL,
  guaranteed by cgroup_create().

(Also remove 2 unused variables in cgroup_rmdir().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff -puN kernel/cgroup.c~cgroups-remove-some-redundant-null-checks kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-remove-some-redundant-null-checks
+++ a/kernel/cgroup.c
@@ -586,7 +586,7 @@ static void cgroup_call_pre_destroy(stru
 {
 	struct cgroup_subsys *ss;
 	for_each_subsys(cgrp->root, ss)
-		if (ss->pre_destroy && cgrp->subsys[ss->subsys_id])
+		if (ss->pre_destroy)
 			ss->pre_destroy(ss, cgrp);
 	return;
 }
@@ -610,10 +610,8 @@ static void cgroup_diput(struct dentry *
 		/*
 		 * Release the subsystem state objects.
 		 */
-		for_each_subsys(cgrp->root, ss) {
-			if (cgrp->subsys[ss->subsys_id])
-				ss->destroy(ss, cgrp);
-		}
+		for_each_subsys(cgrp->root, ss)
+			ss->destroy(ss, cgrp);
 
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);
@@ -1445,7 +1443,7 @@ static ssize_t cgroup_file_write(struct 
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
-	if (!cft || cgroup_is_removed(cgrp))
+	if (cgroup_is_removed(cgrp))
 		return -ENODEV;
 	if (cft->write)
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
@@ -1490,7 +1488,7 @@ static ssize_t cgroup_file_read(struct f
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
-	if (!cft || cgroup_is_removed(cgrp))
+	if (cgroup_is_removed(cgrp))
 		return -ENODEV;
 
 	if (cft->read)
@@ -1554,10 +1552,8 @@ static int cgroup_file_open(struct inode
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
-
 	cft = __d_cft(file->f_dentry);
-	if (!cft)
-		return -ENODEV;
+
 	if (cft->read_map || cft->read_seq_string) {
 		struct cgroup_seqfile_state *state =
 			kzalloc(sizeof(*state), GFP_USER);
@@ -2463,8 +2459,6 @@ static int cgroup_rmdir(struct inode *un
 	struct cgroup *cgrp = dentry->d_fsdata;
 	struct dentry *d;
 	struct cgroup *parent;
-	struct super_block *sb;
-	struct cgroupfs_root *root;
 
 	/* the vfs holds both inode->i_mutex already */
 
@@ -2487,8 +2481,6 @@ static int cgroup_rmdir(struct inode *un
 
 	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
-	root = cgrp->root;
-	sb = root->sb;
 
 	if (atomic_read(&cgrp->count)
 	    || !list_empty(&cgrp->children)
@@ -2937,7 +2929,7 @@ int cgroup_clone(struct task_struct *tsk
 	}
 
 	/* Create the cgroup directory, which also creates the cgroup */
-	ret = vfs_mkdir(inode, dentry, S_IFDIR | 0755);
+	ret = vfs_mkdir(inode, dentry, 0755);
 	child = __d_cgrp(dentry);
 	dput(dentry);
 	if (ret) {
@@ -2947,13 +2939,6 @@ int cgroup_clone(struct task_struct *tsk
 		goto out_release;
 	}
 
-	if (!child) {
-		printk(KERN_INFO
-		       "Couldn't find new cgroup %s\n", nodename);
-		ret = -ENOMEM;
-		goto out_release;
-	}
