From: akpm@linux-foundation.org
Subject: + cgroups-fix-lock-inconsistency-in-cgroup_clone.patch added to -mm tree
Date: Tue, 27 Jan 2009 12:43:20 -0800
Message-ID: <200901272043.n0RKhKLY023241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbZA0Un5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 15:43:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: fix lock inconsistency in cgroup_clone()
has been added to the -mm tree.  Its filename is
     cgroups-fix-lock-inconsistency-in-cgroup_clone.patch

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

cgroups-use-hierarchy-mutex-in-creation-failure-path.patch
memcg-get-put-parents-at-create-free.patch
memcg-get-put-parents-at-create-free-fix.patch
memcg-fix-refcnt-handling-at-swapoff.patch
memcg-update-document-to-mention-swapoff-should-be-test.patch
memcg-null-pointer-dereference-at-rmdir-on-some-numa-systems-v2.patch
cgroups-fix-lock-inconsistency-in-cgroup_clone.patch
linux-next.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

