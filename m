From: akpm@linux-foundation.org
Subject: - ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:25 -0700
Message-ID: <200804300544.m3U5iPrj029413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758411AbYD3FpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, ebiederm@xmission.com, mtk.manpages@googlemail.com, peifferp@gmail.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     ipc: sysvsem: implement sys_unshare(CLONE_SYSVSEM)
has been removed from the -mm tree.  Its filename was
     ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: sysvsem: implement sys_unshare(CLONE_SYSVSEM)
From: Manfred Spraul <manfred@colorfullife.com>

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption.  CLONE_NEWIPC must detach from the existing
undo lists.

Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)

The original reason to not support it was the potential (inevitable?)
confusion due to the fact that sys_unshare(CLONE_SYSVSEM) has the
inverse meaning of clone(CLONE_SYSVSEM).

Our two most reasonable options then appear to be (1) fully support
CLONE_SYSVSEM, or (2) continue to refuse explicit CLONE_SYSVSEM,
but always do it anyway on unshare(CLONE_SYSVSEM).  This patch does
(1).

Changelog:
	Apr 16: SEH: switch to Manfred's alternative patch which
		removes the unshare_semundo() function which
		always refused CLONE_SYSVSEM.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c     |    1 +
 kernel/fork.c |   29 +++++++++++------------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff -puN ipc/sem.c~ipc-sysvsem-implement-sys_unshareclone_sysvsem ipc/sem.c
--- a/ipc/sem.c~ipc-sysvsem-implement-sys_unshareclone_sysvsem
+++ a/ipc/sem.c
@@ -1250,6 +1250,7 @@ void exit_sem(struct task_struct *tsk)
 	undo_list = tsk->sysvsem.undo_list;
 	if (!undo_list)
 		return;
+	tsk->sysvsem.undo_list = NULL;
 
 	if (!atomic_dec_and_test(&undo_list->refcnt))
 		return;
diff -puN kernel/fork.c~ipc-sysvsem-implement-sys_unshareclone_sysvsem kernel/fork.c
--- a/kernel/fork.c~ipc-sysvsem-implement-sys_unshareclone_sysvsem
+++ a/kernel/fork.c
@@ -1669,18 +1669,6 @@ static int unshare_fd(unsigned long unsh
 }
 
 /*
- * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
- * supported yet
- */
-static int unshare_semundo(unsigned long unshare_flags, struct sem_undo_list **new_ulistp)
-{
-	if (unshare_flags & CLONE_SYSVSEM)
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
  * unshare allows a process to 'unshare' part of the process
  * context which was originally shared using clone.  copy_*
  * functions used by do_fork() cannot be used here directly
@@ -1695,8 +1683,8 @@ asmlinkage long sys_unshare(unsigned lon
 	struct sighand_struct *new_sigh = NULL;
 	struct mm_struct *mm, *new_mm = NULL, *active_mm = NULL;
 	struct files_struct *fd, *new_fd = NULL;
-	struct sem_undo_list *new_ulist = NULL;
 	struct nsproxy *new_nsproxy = NULL;
+	int do_sysvsem = 0;
 
 	check_unshare_flags(&unshare_flags);
 
@@ -1708,6 +1696,8 @@ asmlinkage long sys_unshare(unsigned lon
 				CLONE_NEWNET))
 		goto bad_unshare_out;
 
+	if (unshare_flags & CLONE_SYSVSEM)
+		do_sysvsem = 1;
 	if ((err = unshare_thread(unshare_flags)))
 		goto bad_unshare_out;
 	if ((err = unshare_fs(unshare_flags, &new_fs)))
@@ -1718,13 +1708,17 @@ asmlinkage long sys_unshare(unsigned lon
 		goto bad_unshare_cleanup_sigh;
 	if ((err = unshare_fd(unshare_flags, &new_fd)))
 		goto bad_unshare_cleanup_vm;
-	if ((err = unshare_semundo(unshare_flags, &new_ulist)))
-		goto bad_unshare_cleanup_fd;
 	if ((err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
 			new_fs)))
-		goto bad_unshare_cleanup_semundo;
+		goto bad_unshare_cleanup_fd;
 
-	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
+	if (new_fs ||  new_mm || new_fd || do_sysvsem || new_nsproxy) {
+		if (do_sysvsem) {
+			/*
+			 * CLONE_SYSVSEM is equivalent to sys_exit().
+			 */
+			exit_sem(current);
+		}
 
 		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
@@ -1760,7 +1754,6 @@ asmlinkage long sys_unshare(unsigned lon
 	if (new_nsproxy)
 		put_nsproxy(new_nsproxy);
 
-bad_unshare_cleanup_semundo:
 bad_unshare_cleanup_fd:
 	if (new_fd)
 		put_files_struct(new_fd);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
idr-fix-idr_remove.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

