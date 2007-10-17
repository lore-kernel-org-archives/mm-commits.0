From: akpm@linux-foundation.org
Subject: - file-capabilities-change-fe-to-a-bool.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:45 -0700
Message-ID: <200710170137.l9H1bjJ2027949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbXJQBnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file capabilities: change fE to a bool
has been removed from the -mm tree.  Its filename was
     file-capabilities-change-fe-to-a-bool.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file capabilities: change fE to a bool
From: Serge E. Hallyn <serue@us.ibm.com>

The fE was previously a full capset which was masked with the calculated
new_permitted to get the process' new effective set.  It is now a single
bit in the xattr.  This patch changes bprm->cap_effective to a boolean. 
When that boolean is false, then P'e is the empty set.  When the boolean is
true, then P'e is set equal to P'p (new_permitted).  The rationale for this
is that either the application does not know about capabilities, and needs
to start with all permitted caps in its effective set, or it does know
about capabilities, and can start with an empty effective set and enable
the caps it wants when it wants.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    3 ++-
 security/commoncap.c    |   16 +++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/binfmts.h~file-capabilities-change-fe-to-a-bool include/linux/binfmts.h
--- a/include/linux/binfmts.h~file-capabilities-change-fe-to-a-bool
+++ a/include/linux/binfmts.h
@@ -37,7 +37,8 @@ struct linux_binprm{
 	int sh_bang;
 	struct file * file;
 	int e_uid, e_gid;
-	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
+	kernel_cap_t cap_inheritable, cap_permitted;
+	bool cap_effective;
 	void *security;
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
diff -puN security/commoncap.c~file-capabilities-change-fe-to-a-bool security/commoncap.c
--- a/security/commoncap.c~file-capabilities-change-fe-to-a-bool
+++ a/security/commoncap.c
@@ -113,7 +113,7 @@ static inline void bprm_clear_caps(struc
 {
 	cap_clear(bprm->cap_inheritable);
 	cap_clear(bprm->cap_permitted);
-	cap_clear(bprm->cap_effective);
+	bprm->cap_effective = false;
 }
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
@@ -130,8 +130,10 @@ static inline int cap_from_disk(__le32 *
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION:
-		bprm->cap_effective = (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
-					? CAP_FULL_SET : CAP_EMPTY_SET;
+		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+			bprm->cap_effective = true;
+		else
+			bprm->cap_effective = false;
 		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
 		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
 		return 0;
@@ -212,7 +214,7 @@ int cap_bprm_set_security (struct linux_
 			cap_set_full (bprm->cap_permitted);
 		}
 		if (bprm->e_uid == 0)
-			cap_set_full (bprm->cap_effective);
+			bprm->cap_effective = true;
 	}
 
 	return ret;
@@ -252,8 +254,8 @@ void cap_bprm_apply_creds (struct linux_
 	 * capability rules */
 	if (!is_init(current)) {
 		current->cap_permitted = new_permitted;
-		current->cap_effective =
-		    cap_intersect (new_permitted, bprm->cap_effective);
+		current->cap_effective = bprm->cap_effective ?
+				new_permitted : 0;
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
@@ -264,7 +266,7 @@ void cap_bprm_apply_creds (struct linux_
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
 	if (current->uid != 0) {
-		if (!cap_isclear(bprm->cap_effective))
+		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_permitted))
 			return 1;
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
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
