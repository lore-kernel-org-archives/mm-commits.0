From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-lock-inconsistency-in-cgroup_clone.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:12 -0800
Message-ID: <200901301914.n0UJEC7r027042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbZA3TOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix lock inconsistency in cgroup_clone()
has been removed from the -mm tree.  Its filename was
     cgroups-fix-lock-inconsistency-in-cgroup_clone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix lock inconsistency in cgroup_clone()
From: Li Zefan <lizf@cn.fujitsu.com>

I fixed a bug in cgroup_clone() in Linus' tree ni commit 7b574b7
("cgroups: fix a race between cgroup_clone and umount") without noticing
there was a cleanup patch in -mm tree that should be rebased (now commit
104cbd5, "cgroups: use task_lock() for access tsk->cgroups safe in
cgroup_clone()"), thus resulted in lock inconsistency.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-lock-inconsistency-in-cgroup_clone kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-lock-inconsistency-in-cgroup_clone
+++ a/kernel/cgroup.c
@@ -2993,20 +2993,21 @@ int cgroup_clone(struct task_struct *tsk
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
-	task_lock(tsk);
-	cg = tsk->cgroups;
-	parent = task_cgroup(tsk, subsys->subsys_id);
 
 	/* Pin the hierarchy */
-	if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
+	if (!atomic_inc_not_zero(&root->sb->s_active)) {
 		/* We race with the final deactivate_super() */
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
 
 	/* Keep the cgroup alive */
+	task_lock(tsk);
+	parent = task_cgroup(tsk, subsys->subsys_id);
+	cg = tsk->cgroups;
 	get_css_set(cg);
 	task_unlock(tsk);
+
 	mutex_unlock(&cgroup_mutex);
 
 	/* Now do the VFS work to create a cgroup */
@@ -3045,7 +3046,7 @@ int cgroup_clone(struct task_struct *tsk
 		mutex_unlock(&inode->i_mutex);
 		put_css_set(cg);
 
-		deactivate_super(parent->root->sb);
+		deactivate_super(root->sb);
 		/* The cgroup is still accessible in the VFS, but
 		 * we're not going to try to rmdir() it at this
 		 * point. */
@@ -3071,7 +3072,7 @@ int cgroup_clone(struct task_struct *tsk
 	mutex_lock(&cgroup_mutex);
 	put_css_set(cg);
 	mutex_unlock(&cgroup_mutex);
-	deactivate_super(parent->root->sb);
+	deactivate_super(root->sb);
 	return ret;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

