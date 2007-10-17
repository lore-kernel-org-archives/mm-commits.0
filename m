From: akpm@linux-foundation.org
Subject: - file-caps-update-selinux-xattr-hooks.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:34 -0700
Message-ID: <200710170137.l9H1bYed027937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbXJQBi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:38:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file caps: update selinux xattr hooks
has been removed from the -mm tree.  Its filename was
     file-caps-update-selinux-xattr-hooks.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file caps: update selinux xattr hooks
From: "Serge E. Hallyn" <serue@us.ibm.com>

SELinux does not call out to its secondary module for setxattr or
removexattr mediation, as the secondary module would incorrectly prevent
writing of selinux xattrs.  This means that when selinux and capability are
both loaded, admins will be able to write file capabilities with
CAP_SYS_ADMIN as before, not with CAP_SETFCAP.

Update the selinux hooks to hardcode logic for the special consideration
for file caps.  Also consolidate the handling of non-selinux xattrs in
removexattr and setxattr.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |   50 +++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff -puN security/selinux/hooks.c~file-caps-update-selinux-xattr-hooks security/selinux/hooks.c
--- a/security/selinux/hooks.c~file-caps-update-selinux-xattr-hooks
+++ a/security/selinux/hooks.c
@@ -2297,6 +2297,25 @@ static int selinux_inode_getattr(struct 
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
+static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+{
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof XATTR_SECURITY_PREFIX - 1)) {
+		if (!strcmp(name, XATTR_NAME_CAPS)) {
+			if (!capable(CAP_SETFCAP))
+				return -EPERM;
+		} else if (!capable(CAP_SYS_ADMIN)) {
+			/* A different attribute in the security namespace.
+			   Restrict to administrator. */
+			return -EPERM;
+		}
+	}
+
+	/* Not an attribute we recognize, so just check the
+	   ordinary setattr permission. */
+	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+}
+
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
@@ -2307,19 +2326,8 @@ static int selinux_inode_setxattr(struct
 	u32 newsid;
 	int rc = 0;
 
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	sbsec = inode->i_sb->s_security;
 	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
@@ -2393,20 +2401,8 @@ static int selinux_inode_listxattr (stru
 
 static int selinux_inode_removexattr (struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. Might want a separate
-		   permission for removexattr. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	/* No one is allowed to remove a SELinux security label.
 	   You can change the label, but all data must be labeled. */
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch
security-cleanups.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
v3-file-capabilities-alter-behavior-of-cap_setpcap.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
containers-implement-namespace-tracking-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
ipc-cleanup-some-code-and-wrong-comments-about-semundo.patch
virtualization-of-sysv-msg-queues-is-incomplete.patch
