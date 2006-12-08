From: akpm@osdl.org
Subject: - sys_unshare-remove-a-broken-clone_sighand-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:12 -0800
Message-ID: <200612082000.kB8K0C3Z001714@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426191AbWLHUAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     sys_unshare: remove a broken CLONE_SIGHAND code
has been removed from the -mm tree.  Its filename was
     sys_unshare-remove-a-broken-clone_sighand-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sys_unshare: remove a broken CLONE_SIGHAND code
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_unshare(CLONE_SIGHAND) is broken, the code under 'if (new_sigh)' is
never executed but very wrong. Just remove it to avoid a confusion,
task_lock() has nothing to do with ->sighand changing.

Also, change the comment in unshare_sighand(). Yes, CLONE_THREAD implies
CLONE_SIGHAND, but still it looks confusing. Also, we don't need to check
current->sighand != NULL.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/fork.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN kernel/fork.c~sys_unshare-remove-a-broken-clone_sighand-code kernel/fork.c
--- a/kernel/fork.c~sys_unshare-remove-a-broken-clone_sighand-code
+++ a/kernel/fork.c
@@ -1544,15 +1544,13 @@ static int unshare_namespace(unsigned lo
 }
 
 /*
- * Unsharing of sighand for tasks created with CLONE_SIGHAND is not
- * supported yet
+ * Unsharing of sighand is not supported yet
  */
 static int unshare_sighand(unsigned long unshare_flags, struct sighand_struct **new_sighp)
 {
 	struct sighand_struct *sigh = current->sighand;
 
-	if ((unshare_flags & CLONE_SIGHAND) &&
-	    (sigh && atomic_read(&sigh->count) > 1))
+	if ((unshare_flags & CLONE_SIGHAND) && atomic_read(&sigh->count) > 1)
 		return -EINVAL;
 	else
 		return 0;
@@ -1626,7 +1624,7 @@ asmlinkage long sys_unshare(unsigned lon
 	int err = 0;
 	struct fs_struct *fs, *new_fs = NULL;
 	struct namespace *ns, *new_ns = NULL;
-	struct sighand_struct *sigh, *new_sigh = NULL;
+	struct sighand_struct *new_sigh = NULL;
 	struct mm_struct *mm, *new_mm = NULL, *active_mm = NULL;
 	struct files_struct *fd, *new_fd = NULL;
 	struct sem_undo_list *new_ulist = NULL;
@@ -1671,7 +1669,7 @@ asmlinkage long sys_unshare(unsigned lon
 		}
 	}
 
-	if (new_fs || new_ns || new_sigh || new_mm || new_fd || new_ulist ||
+	if (new_fs || new_ns || new_mm || new_fd || new_ulist ||
 				new_uts || new_ipc) {
 
 		task_lock(current);
@@ -1693,12 +1691,6 @@ asmlinkage long sys_unshare(unsigned lon
 			new_ns = ns;
 		}
 
-		if (new_sigh) {
-			sigh = current->sighand;
-			rcu_assign_pointer(current->sighand, new_sigh);
-			new_sigh = sigh;
-		}
-
 		if (new_mm) {
 			mm = current->mm;
 			active_mm = current->active_mm;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
pidhash-temporary-debug-checks.patch

