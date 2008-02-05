From: akpm@linux-foundation.org
Subject: - oom_kill-remove-uid==0-checks.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:09 -0800
Message-ID: <200802052232.m15MWoUO012359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762424AbYBEWmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, morgan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oom_kill: remove uid==0 checks
has been removed from the -mm tree.  Its filename was
     oom_kill-remove-uid==0-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom_kill: remove uid==0 checks
From: "Serge E. Hallyn" <serue@us.ibm.com>

Root processes are considered more important when out of memory and killing
proceses.  The check for CAP_SYS_ADMIN was augmented with a check for
uid==0 or euid==0.

There are several possible ways to look at this:

	1. uid comparisons are unnecessary, trust CAP_SYS_ADMIN
	   alone.  However CAP_SYS_RESOURCE is the one that really
	   means "give me extra resources" so allow for that as
	   well.
	2. Any privileged code should be protected, but uid is not
	   an indication of privilege.  So we should check whether
	   any capabilities are raised.
	3. uid==0 makes processes on the host as well as in containers
	   more important, so we should keep the existing checks.
	4. uid==0 makes processes only on the host more important,
	   even without any capabilities.  So we should be keeping
	   the (uid==0||euid==0) check but only when
	   userns==&init_user_ns.

I'm following number 1 here.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom_kill-remove-uid==0-checks mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-remove-uid==0-checks
+++ a/mm/oom_kill.c
@@ -125,7 +125,7 @@ unsigned long badness(struct task_struct
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (__capable(p, CAP_SYS_ADMIN) || p->uid == 0 || p->euid == 0)
+	if (__capable(p, CAP_SYS_ADMIN) || __capable(p, CAP_SYS_RESOURCE))
 		points /= 4;
 
 	/*
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-unionfs.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
reiser4-replace-uid==0-check-with-capability.patch
