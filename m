From: akpm@osdl.org
Subject: - disable-clone_child_cleartid-for-abnormal-exit.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:49 -0800
Message-ID: <200612072302.kB7N2nBG029892@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51794 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163699AbWLGXDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, drepper@redhat.com, jakub@redhat.com, mingo@elte.hu, petrides@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Disable CLONE_CHILD_CLEARTID for abnormal exit
has been removed from the -mm tree.  Its filename was
     disable-clone_child_cleartid-for-abnormal-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Disable CLONE_CHILD_CLEARTID for abnormal exit
From: Roland McGrath <roland@redhat.com>

The CLONE_CHILD_CLEARTID flag is used by NPTL to have its threads
communicate via memory/futex when they exit, so pthread_join can
synchronize using a simple futex wait.  The word of user memory where NPTL
stores a thread's own TID is what it passes; this gets reset to zero at
thread exit.

It is not desireable to touch this user memory when threads are dying due
to a fatal signal.  A core dump is more usefully representative of the
dying program state if the threads live at the time of the crash have their
NPTL data structures unperturbed.  The userland expectation of
CLONE_CHILD_CLEARTID has only ever been that it works for a thread making
an _exit system call.

This problem was identified by Ernie Petrides <petrides@redhat.com>.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ernie Petrides <petrides@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/fork.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~disable-clone_child_cleartid-for-abnormal-exit kernel/fork.c
--- a/kernel/fork.c~disable-clone_child_cleartid-for-abnormal-exit
+++ a/kernel/fork.c
@@ -448,7 +448,16 @@ void mm_release(struct task_struct *tsk,
 		tsk->vfork_done = NULL;
 		complete(vfork_done);
 	}
-	if (tsk->clear_child_tid && atomic_read(&mm->mm_users) > 1) {
+
+	/*
+	 * If we're exiting normally, clear a user-space tid field if
+	 * requested.  We leave this alone when dying by signal, to leave
+	 * the value intact in a core dump, and to save the unnecessary
+	 * trouble otherwise.  Userland only wants this done for a sys_exit.
+	 */
+	if (tsk->clear_child_tid
+	    && !(tsk->flags & PF_SIGNALED)
+	    && atomic_read(&mm->mm_users) > 1) {
 		u32 __user * tidptr = tsk->clear_child_tid;
 		tsk->clear_child_tid = NULL;
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tty-signal-tty-locking.patch

