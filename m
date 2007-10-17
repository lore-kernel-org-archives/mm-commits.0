From: akpm@linux-foundation.org
Subject: - file-capabilities-introduce-cap_setfcap.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:29 -0700
Message-ID: <200710170137.l9H1bTqe027931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760042AbXJQBnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file capabilities: introduce cap_setfcap
has been removed from the -mm tree.  Its filename was
     file-capabilities-introduce-cap_setfcap.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file capabilities: introduce cap_setfcap
From: Serge E. Hallyn <serue@us.ibm.com>

Setting file capabilities previously required the cap_sys_admin capability,
since they are stored as extended attributes in the security.* namespace.

Introduce CAP_SETFCAP (to mirror CAP_SETPCAP), and require it for setting
file capabilities instead of CAP_SYS_ADMIN.

Quoting Andrew Morgan,

"CAP_SYS_ADMIN is way too overloaded and this
functionality is special."

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    4 +++-
 security/commoncap.c       |   12 ++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN include/linux/capability.h~file-capabilities-introduce-cap_setfcap include/linux/capability.h
--- a/include/linux/capability.h~file-capabilities-introduce-cap_setfcap
+++ a/include/linux/capability.h
@@ -322,7 +322,9 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_AUDIT_CONTROL    30
 
-#define CAP_NUMCAPS	     31
+#define CAP_SETFCAP	     31
+
+#define CAP_NUMCAPS	     32
 
 #ifdef __KERNEL__
 /* 
diff -puN security/commoncap.c~file-capabilities-introduce-cap_setfcap security/commoncap.c
--- a/security/commoncap.c~file-capabilities-introduce-cap_setfcap
+++ a/security/commoncap.c
@@ -290,7 +290,11 @@ int cap_bprm_secureexec (struct linux_bi
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
 		       size_t size, int flags)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -299,7 +303,11 @@ int cap_inode_setxattr(struct dentry *de
 
 int cap_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
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
