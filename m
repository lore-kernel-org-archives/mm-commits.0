From: akpm@linux-foundation.org
Subject: + ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:57:22 -0700
Message-ID: <200804172157.m3HLvMWV029837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbYDQV5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, ebiederm@xmission.com, manfred@colorfullife.com, mtk.manpages@googlemail.com, peifferp@gmail.com, xemul@openvz.org


The patch titled
     ipc: sysvsem: refuse clone(CLONE_SYSVSEM|CLONE_NEWIPC)
has been added to the -mm tree.  Its filename is
     ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: sysvsem: refuse clone(CLONE_SYSVSEM|CLONE_NEWIPC)
From: "Serge E. Hallyn" <serue@us.ibm.com>

CLONE_NEWIPC|CLONE_SYSVSEM interaction isn't handled properly.  This can cause
a kernel memory corruption.  CLONE_NEWIPC must detach from the existing undo
lists.

Fix, part 3: refuse clone(CLONE_SYSVSEM|CLONE_NEWIPC).

With unshare, specifying CLONE_SYSVSEM means unshare the sysvsem.  So it seems
reasonable that CLONE_NEWIPC without CLONE_SYSVSEM would just imply
CLONE_SYSVSEM.

However with clone, specifying CLONE_SYSVSEM means *share* the sysvsem.  So
calling clone(CLONE_SYSVSEM|CLONE_NEWIPC) is explicitly asking for something
we can't allow.  So return -EINVAL in that case.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/nsproxy.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/nsproxy.c~ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc kernel/nsproxy.c
--- a/kernel/nsproxy.c~ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc
+++ a/kernel/nsproxy.c
@@ -139,6 +139,18 @@ int copy_namespaces(unsigned long flags,
 		goto out;
 	}
 
+	/*
+	 * CLONE_NEWIPC must detach from the undolist: after switching
+	 * to a new ipc namespace, the semaphore arrays from the old
+	 * namespace are unreachable.  In clone parlance, CLONE_SYSVSEM
+	 * means share undolist with parent, so we must forbid using
+	 * it along with CLONE_NEWIPC.
+	 */
+	if ((flags&CLONE_NEWIPC) && (flags&CLONE_SYSVSEM)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	new_ns = create_new_namespaces(flags, tsk, tsk->fs);
 	if (IS_ERR(new_ns)) {
 		err = PTR_ERR(new_ns);
_

Patches currently in -mm which might be from serue@us.ibm.com are

git-unionfs.patch
git-vfs.patch
capabilities-implement-per-process-securebits.patch
capabilities-implement-per-process-securebits-warning-fix.patch
capabilities-implement-per-process-securebits-fix.patch
root_plug-use-cap_task_prctl.patch
smack-use-cap_task_prctl.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch
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

