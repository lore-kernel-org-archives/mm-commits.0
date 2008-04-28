From: akpm@linux-foundation.org
Subject: - root_plug-use-cap_task_prctl.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:19 -0700
Message-ID: <200804282154.m3SLsJHh017991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935931AbYD1Vy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     root_plug: use cap_task_prctl
has been removed from the -mm tree.  Its filename was
     root_plug-use-cap_task_prctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: root_plug: use cap_task_prctl
From: "Serge E. Hallyn" <serue@us.ibm.com>

With the introduction of per-process securebits, the capabilities-related
prctl callbacks were moved into cap_task_prctl().  Have root_plug use
cap_task_prctl() so that PR_SET_KEEPCAPS is defined.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/root_plug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN security/root_plug.c~root_plug-use-cap_task_prctl security/root_plug.c
--- a/security/root_plug.c~root_plug-use-cap_task_prctl
+++ a/security/root_plug.c
@@ -86,6 +86,7 @@ static struct security_operations rootpl
 
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
+	.task_prctl =			cap_task_prctl,
 
 	.bprm_check_security =		rootplug_bprm_check_security,
 };
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-introduce-cft-read_seq-v2.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch
ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
devpts-propagate-error-code-from-devpts_pty_new.patch
devpts-factor-out-pty-index-allocation.patch
devpts-factor-out-pty-index-allocation-fix.patch
reiser4-replace-uid==0-check-with-capability.patch

