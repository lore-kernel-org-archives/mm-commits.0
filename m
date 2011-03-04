From: akpm@linux-foundation.org
Subject: + userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:48:34 -0800
Message-ID: <201103042348.p24NmY74011066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759896Ab1CDXss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge.hallyn@canonical.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org


The patch titled
     userns: remove unneeded extra argument in selinux's task_has_capability
has been added to the -mm tree.  Its filename is
     userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability.patch

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
Subject: userns: remove unneeded extra argument in selinux's task_has_capability
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

The user_namespace argument is not used by task_has_capability, so get
rid of it.  Note that it was spuriously added by the user namespace
patchset, so we're just cleaning up our own mess.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability security/selinux/hooks.c
--- a/security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability
+++ a/security/selinux/hooks.c
@@ -1419,7 +1419,6 @@ static int current_has_perm(const struct
 /* Check whether a task is allowed to use a capability. */
 static int task_has_capability(struct task_struct *tsk,
 			       const struct cred *cred,
-			       struct user_namespace *ns,
 			       int cap, int audit)
 {
 	struct common_audit_data ad;
@@ -1856,7 +1855,7 @@ static int selinux_capable(struct task_s
 	if (rc)
 		return rc;
 
-	return task_has_capability(tsk, cred, ns, cap, audit);
+	return task_has_capability(tsk, cred, cap, audit);
 }
 
 static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
@@ -2971,8 +2970,8 @@ static int selinux_file_ioctl(struct fil
 
 	case KDSKBENT:
 	case KDSKBSENT:
-		error = task_has_capability(current, cred, &init_user_ns,
-					CAP_SYS_TTY_CONFIG, SECURITY_CAP_AUDIT);
+		error = task_has_capability(current, cred, CAP_SYS_TTY_CONFIG,
+					SECURITY_CAP_AUDIT);
 		break;
 
 	/* default case assumes that the command will go
_

Patches currently in -mm which might be from serge.hallyn@canonical.com are

sys_unshare-remove-the-dead-clone_thread-sighand-vm-code.patch
cgroup-remove-the-ns_cgroup.patch
userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability.patch
userns-allow-sethostname-in-a-container.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
userns-dont-define-init_user_ns-in-ipc_namespaceh.patch
userns-make-has_capability-into-real-functions.patch

