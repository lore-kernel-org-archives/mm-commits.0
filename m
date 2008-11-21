From: akpm@linux-foundation.org
Subject: + cgroups-remove-some-redundant-null-checks.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:12:44 -0800
Message-ID: <200811212312.mALNCixH016146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361AbYKUXNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:13:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: remove some redundant NULL checks
has been added to the -mm tree.  Its filename is
     cgroups-remove-some-redundant-null-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -587,7 +587,7 @@ static void cgroup_call_pre_destroy(stru
 {
 	struct cgroup_subsys *ss;
 	for_each_subsys(cgrp->root, ss)
-		if (ss->pre_destroy && cgrp->subsys[ss->subsys_id])
+		if (ss->pre_destroy)
 			ss->pre_destroy(ss, cgrp);
 	return;
 }
@@ -611,10 +611,8 @@ static void cgroup_diput(struct dentry *
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
@@ -2936,7 +2928,7 @@ int cgroup_clone(struct task_struct *tsk
 	}
 
 	/* Create the cgroup directory, which also creates the cgroup */
-	ret = vfs_mkdir(inode, dentry, S_IFDIR | 0755);
+	ret = vfs_mkdir(inode, dentry, 0755);
 	child = __d_cgrp(dentry);
 	dput(dentry);
 	if (ret) {
@@ -2946,13 +2938,6 @@ int cgroup_clone(struct task_struct *tsk
 		goto out_release;
 	}
 
-	if (!child) {
-		printk(KERN_INFO
-		       "Couldn't find new cgroup %s\n", nodename);
-		ret = -ENOMEM;
-		goto out_release;
-	}
-
 	/* The cgroup now exists. Retake cgroup_mutex and check
 	 * that we're still in the same state that we thought we
 	 * were. */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
linux-next.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

