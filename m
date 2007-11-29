From: akpm@linux-foundation.org
Subject: - file-capabilities-dont-prevent-signaling-setuid-root.patch removed from -mm tree
Date: Thu, 29 Nov 2007 11:31:56 -0800
Message-ID: <200711291931.lATJVuce003461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbXK2Tcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 14:32:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@epoch.ncsc.mil, mm-commits@vger.kernel.org


The patch titled
     file capabilities: don't prevent signaling setuid root programs
has been removed from the -mm tree.  Its filename was
     file-capabilities-dont-prevent-signaling-setuid-root.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: file capabilities: don't prevent signaling setuid root programs
From: "Serge E. Hallyn" <serue@us.ibm.com>

An unprivileged process must be able to kill a setuid root program started
by the same user.  This is legacy behavior needed for instance for xinit to
kill X when the window manager exits.

When an unprivileged user runs a setuid root program in !SECURE_NOROOT
mode, fP, fI, and fE are set full on, so pP' and pE' are full on.  Then
cap_task_kill() prevents the user from signaling the setuid root task. 
This is a change in behavior compared to when
!CONFIG_SECURITY_FILE_CAPABILITIES.

This patch introduces a special check into cap_task_kill() just to check
whether a non-root user is signaling a setuid root program started by the
same user.  If so, then signal is allowed.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN security/commoncap.c~file-capabilities-dont-prevent-signaling-setuid-root security/commoncap.c
--- a/security/commoncap.c~file-capabilities-dont-prevent-signaling-setuid-root
+++ a/security/commoncap.c
@@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p,
 	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
 		return 0;
 
+	/*
+	 * Running a setuid root program raises your capabilities.
+	 * Killing your own setuid root processes was previously
+	 * allowed.
+	 * We must preserve legacy signal behavior in this case.
+	 */
+	if (p->euid == 0 && p->uid == current->uid)
+		return 0;
+
 	/* sigcont is permitted within same session */
 	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
_

Patches currently in -mm which might be from serue@us.ibm.com are

isolate-the-uts-namespaces-domainname-and-hostname-back.patch
file-capabilities-dont-prevent-signaling-setuid-root.patch
git-unionfs.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
64bit-capability-support-legacy-support-fix.patch
capabilities-introduce-per-process-capability-bounding-set.patch
smack-using-capabilities-32-and-33.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
