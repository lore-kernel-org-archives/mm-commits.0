From: akpm@linux-foundation.org
Subject: + fix-sys_unsharesem_undo-add-support-for-clone_sysvsem.patch added to -mm tree
Date: Sun, 13 Apr 2008 02:01:15 -0700
Message-ID: <200804130901.m3D91FjQ012670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbYDMJCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Apr 2008 05:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, Nadia.Derbey@bull.net, ebiederm@xmission.com, peifferp@gmail.com, serue@us.ibm.com, sukadev@us.ibm.com, xemul@openvz.org


The patch titled
     fix sys_unshare()+SEM_UNDO: add support for CLONE_SYSVSEM
has been added to the -mm tree.  Its filename is
     fix-sys_unsharesem_undo-add-support-for-clone_sysvsem.patch

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
Subject: fix sys_unshare()+SEM_UNDO: add support for CLONE_SYSVSEM
From: Manfred Spraul <manfred@colorfullife.com>

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption.  CLONE_NEWIPC must detach from the existing
undo lists.

Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: "Pierre Peiffer" <peifferp@gmail.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c     |    1 +
 kernel/fork.c |   18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~fix-sys_unsharesem_undo-add-support-for-clone_sysvsem ipc/sem.c
--- a/ipc/sem.c~fix-sys_unsharesem_undo-add-support-for-clone_sysvsem
+++ a/ipc/sem.c
@@ -1298,6 +1298,7 @@ void exit_sem(struct task_struct *tsk)
 	undo_list = tsk->sysvsem.undo_list;
 	if (!undo_list)
 		return;
+	tsk->sysvsem.undo_list = NULL;
 
 	if (!atomic_dec_and_test(&undo_list->refcnt))
 		return;
diff -puN kernel/fork.c~fix-sys_unsharesem_undo-add-support-for-clone_sysvsem kernel/fork.c
--- a/kernel/fork.c~fix-sys_unsharesem_undo-add-support-for-clone_sysvsem
+++ a/kernel/fork.c
@@ -1675,13 +1675,17 @@ static int unshare_fd(unsigned long unsh
 }
 
 /*
- * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
- * supported yet
+ * Unsharing of semundo for tasks created with CLONE_SYSVSEM doesn't require
+ * any allocations: it means that the task leaves the existing undo lists,
+ * just like sys_exit(). The new undo lists are allocated on demand in the
+ * ipc syscalls.
+ * new_ulistp is set to a non-NULL value, the caller expects that on success.
  */
 static int unshare_semundo(unsigned long unshare_flags, struct sem_undo_list **new_ulistp)
 {
-	if (unshare_flags & CLONE_SYSVSEM)
-		return -EINVAL;
+	if (unshare_flags & CLONE_SYSVSEM) {
+		*new_ulistp = (void*)1;
+	}
 
 	return 0;
 }
@@ -1731,6 +1735,12 @@ asmlinkage long sys_unshare(unsigned lon
 		goto bad_unshare_cleanup_semundo;
 
 	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
+		if (unshare_flags & CLONE_SYSVSEM) {
+			/*
+			 * CLONE_SYSVSEM is equivalent to sys_exit().
+			 */
+			exit_sem(current);
+		}
 
 		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

fix-sys_unsharesem_undo-add-support-for-clone_sysvsem.patch
fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

