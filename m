From: akpm@linux-foundation.org
Subject: - capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:58:45 -0800
Message-ID: <200802040358.m143wQT5012782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224AbYBDD7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     capabilities: correct logic at capset_check
has been removed from the -mm tree.  Its filename was
     capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch

This patch was dropped because it was folded into capabilities-introduce-per-process-capability-bounding-set.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capabilities: correct logic at capset_check
From: "Serge E. Hallyn" <serue@us.ibm.com>

Fix typo at capset_check introduced with capability bounding set
patch.

Signed-off-by: "Serge E. Hallyn" <serue@us.ibm.com>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/commoncap.c~capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check security/commoncap.c
--- a/security/commoncap.c~capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check
+++ a/security/commoncap.c
@@ -126,7 +126,7 @@ int cap_capset_check (struct task_struct
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
-	if (!!cap_issubset(*inheritable,
+	if (!cap_issubset(*inheritable,
 			   cap_combine(target->cap_inheritable,
 				       current->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
capabilities-introduce-per-process-capability-bounding-set.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
oom_kill-remove-uid==0-checks.patch
smack-using-capabilities-32-and-33.patch
smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
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
pid-namespaces-vs-locks-interaction.patch
reiser4-replace-uid==0-check-with-capability.patch
