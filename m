From: akpm@linux-foundation.org
Subject: + ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:57:19 -0700
Message-ID: <200804172157.m3HLvKCB029832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYDQV53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, ebiederm@xmission.com, mtk.manpages@googlemail.com, peifferp@gmail.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     ipc: sysvsem: force unshare(CLONE_SYSVSEM) when CLONE_NEWIPC
has been added to the -mm tree.  Its filename is
     ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch

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
Subject: ipc: sysvsem: force unshare(CLONE_SYSVSEM) when CLONE_NEWIPC
From: Manfred Spraul <manfred@colorfullife.com>

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption.  CLONE_NEWIPC must detach from the existing
undo lists.

Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.  CLONE_NEWIPC
creates a new IPC namespace, the task cannot access the existing semaphore
arrays after the unshare syscall.  Thus the task can/must detach from the
existing undo list entries, too.

This fixes the kernel corruption, because it makes it impossible that
undo records from two different namespaces are in sysvsem.undo_list.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc kernel/fork.c
--- a/kernel/fork.c~ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc
+++ a/kernel/fork.c
@@ -1707,7 +1707,12 @@ asmlinkage long sys_unshare(unsigned lon
 				CLONE_NEWNET))
 		goto bad_unshare_out;
 
-	if (unshare_flags & CLONE_SYSVSEM)
+	/*
+	 * CLONE_NEWIPC must also detach from the undolist: after switching
+	 * to a new ipc namespace, the semaphore arrays from the old
+	 * namespace are unreachable.
+	 */
+	if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM))
 		do_sysvsem = 1;
 	if ((err = unshare_thread(unshare_flags)))
 		goto bad_unshare_out;
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch
ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

