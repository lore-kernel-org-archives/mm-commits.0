From: akpm@linux-foundation.org
Subject: - ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:29 -0700
Message-ID: <200804300550.m3U5oTgK030118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758998AbYD3Fum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, ebiederm@xmission.com, manfred@colorfullife.com, mtk.manpages@googlemail.com, peifferp@gmail.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     ipc: sysvsem: refuse clone(CLONE_SYSVSEM|CLONE_NEWIPC)
has been removed from the -mm tree.  Its filename was
     ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: cleanups]
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
+	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	new_ns = create_new_namespaces(flags, tsk, tsk->fs);
 	if (IS_ERR(new_ns)) {
 		err = PTR_ERR(new_ns);
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-unionfs.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
devpts-propagate-error-code-from-devpts_pty_new.patch
devpts-factor-out-pty-index-allocation.patch
devpts-factor-out-pty-index-allocation-fix.patch
reiser4-replace-uid==0-check-with-capability.patch

