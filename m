From: akpm@linux-foundation.org
Subject: + fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc.patch added to -mm tree
Date: Sun, 13 Apr 2008 02:01:19 -0700
Message-ID: <200804130901.m3D91Jbd012676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbYDMJCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Apr 2008 05:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, Nadia.Derbey@bull.net, ebiederm@xmission.com, peifferp@gmail.com, serue@us.ibm.com, sukadev@us.ibm.com, xemul@openvz.org


The patch titled
     fix sys_unshare()+SEM_UNDO: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC
has been added to the -mm tree.  Its filename is
     fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc.patch

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
Subject: fix sys_unshare()+SEM_UNDO: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC
From: Manfred Spraul <manfred@colorfullife.com>

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption.  CLONE_NEWIPC must detach from the existing
undo lists.

Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.  CLONE_NEWIPC
creates a new IPC namespace, the task cannot access the existing semaphore
arrays after the unshare syscall.  Thus the task can/must detach from the
existing undo list entries, too.

This fixes the kernel corruption, because it makes it impossible that undo
records from two different namespaces are in sysvsem.undo_list.

I'm not sure who's the right maintainer, Andrew, could you merge it?

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: "Pierre Peiffer" <peifferp@gmail.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc kernel/fork.c
--- a/kernel/fork.c~fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc
+++ a/kernel/fork.c
@@ -1735,9 +1735,13 @@ asmlinkage long sys_unshare(unsigned lon
 		goto bad_unshare_cleanup_semundo;
 
 	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
-		if (unshare_flags & CLONE_SYSVSEM) {
+		if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM)) {
 			/*
 			 * CLONE_SYSVSEM is equivalent to sys_exit().
+			 *
+			 * CLONE_NEWIPC must also detach from the undolist: after switching
+			 * to a new ipc namespace, the semaphore arrays from the old
+			 * namespace are unreachable.
 			 */
 			exit_sem(current);
 		}
_

Patches currently in -mm which might be from manfred@colorfullife.com are

fix-sys_unsharesem_undo-add-support-for-clone_sysvsem.patch
fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

