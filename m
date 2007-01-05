From: akpm@osdl.org
Subject: + user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch added to -mm tree
Date: Fri, 05 Jan 2007 00:31:26 -0800
Message-ID: <200701050831.l058VQuv014113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030365AbXAEIoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 03:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com


The patch titled
     user ns fixes
has been added to the -mm tree.  Its filename is
     user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user ns fixes
From: "Serge E. Hallyn" <serue@us.ibm.com>

Don't do user_ns permission checks when !CONFIG_USER_NS.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/sched.h~user-ns-add-user_namespace-ptr-to-vfsmount-fixes include/linux/sched.h
--- a/include/linux/sched.h~user-ns-add-user_namespace-ptr-to-vfsmount-fixes
+++ a/include/linux/sched.h
@@ -1584,6 +1584,7 @@ extern int cond_resched(void);
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 
+#ifdef CONFIG_USER_NS
 /*
  * Check whether a task and a vfsmnt belong to the same uidns.
  * Since the initial namespace is exempt from these checks,
@@ -1600,6 +1601,13 @@ static inline int task_mnt_same_uidns(st
 		return 1;
 	return 0;
 }
+#else
+static inline int task_mnt_same_uidns(struct task_struct *tsk,
+					struct vfsmount *mnt)
+{
+	return 1;
+}
+#endif
 
 
 /*
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-namespace-add-the-framework-fixes.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user-ns-implement-shared-mounts-fixes.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-always-on.patch
integrity-service-api-and-dummy-provider-fix.patch
