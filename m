From: akpm@google.com
Subject: + include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled.patch added to -mm tree
Date: Mon, 17 Oct 2011 14:59:37 -0700
Message-ID: <201110172159.p9HLxc9G027743@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:20268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1JQV7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 17:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de


The patch titled
     Subject: include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled
has been added to the -mm tree.  Its filename is
     include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled

For the sysvsem undo, each task struct contains a sysv_sem structure with
a pointer to the undo information.

This pointer is only necessary if sysvipc is enabled - thus the pointer
can be made conditional on CONFIG_SYSVIPC.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/sem.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/sem.h~include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled include/linux/sem.h
--- a/include/linux/sem.h~include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled
+++ a/include/linux/sem.h
@@ -96,16 +96,21 @@ struct sem_array {
 	int			complex_count;	/* pending complex operations */
 };
 
+#ifdef CONFIG_SYSVIPC
+
 struct sysv_sem {
 	struct sem_undo_list *undo_list;
 };
 
-#ifdef CONFIG_SYSVIPC
-
 extern int copy_semundo(unsigned long clone_flags, struct task_struct *tsk);
 extern void exit_sem(struct task_struct *tsk);
 
 #else
+
+struct sysv_sem {
+	/* empty */
+};
+
 static inline int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
 {
 	return 0;
_
Subject: Subject: include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch
ipc-semc-handle-spurious-wakeups.patch
ipc-semc-remove-private-structures-from-public-header-file.patch
include-linux-semh-make-sysv_sem-empty-if-sysvipc-is-disabled.patch
ipc-semc-alternatives-to-preempt_disable.patch
slab-leaks3-default-y.patch

