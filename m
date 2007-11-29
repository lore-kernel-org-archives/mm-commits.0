From: akpm@linux-foundation.org
Subject: - file-capabilities-allow-sigcont-within-session-v2.patch removed from -mm tree
Date: Thu, 29 Nov 2007 09:52:24 -0800
Message-ID: <200711291752.lATHqOxV032172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760551AbXK2Rx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 12:53:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, rjw@sisk.pl, sds@epoch.ncsc.mil, sds@tycho.nsa.gov, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     file capabilities: allow sigcont within session
has been removed from the -mm tree.  Its filename was
     file-capabilities-allow-sigcont-within-session-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: file capabilities: allow sigcont within session
From: "Serge E. Hallyn" <serue@us.ibm.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=9247

Allow sigcont to be sent to a process with greater capabilities if it is in
the same session.  Otherwise, a shell from which I've started a root shell
and done 'suspend' can't be restarted by the parent shell.

Also don't do file-capabilities signaling checks when uids for the
processes don't match, since the standard check_kill_permission will have
done those checks.

[akpm@linux-foundation.org: coding-style cleanups]
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Tested-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN security/commoncap.c~file-capabilities-allow-sigcont-within-session-v2 security/commoncap.c
--- a/security/commoncap.c~file-capabilities-allow-sigcont-within-session-v2
+++ a/security/commoncap.c
@@ -530,6 +530,10 @@ int cap_task_kill(struct task_struct *p,
 	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
 
+	/* sigcont is permitted within same session */
+	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
+		return 0;
+
 	if (secid)
 		/*
 		 * Signal sent as a particular user.
_

Patches currently in -mm which might be from serue@us.ibm.com are

file-capabilities-allow-sigcont-within-session-v2.patch
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
