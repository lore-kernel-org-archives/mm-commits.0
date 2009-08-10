From: akpm@linux-foundation.org
Subject: [merged] execve-must-clear-current-clear_child_tid-v2.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:41 -0700
Message-ID: <200908101927.n7AJRfdS026327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887AbZHJT3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, drepper@redhat.com, jens@mcbone.net, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, sonnyrao@us.ibm.com, stable@kernel.org, tglx@linutronix.de, torvalds


The patch titled
     execve: must clear current->clear_child_tid
has been removed from the -mm tree.  Its filename was
     execve-must-clear-current-clear_child_tid-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: execve: must clear current->clear_child_tid
From: Eric Dumazet <eric.dumazet@gmail.com>

While looking at Jens Rosenboom bug report
(http://lkml.org/lkml/2009/7/27/35) about strange sys_futex call done from
a dying "ps" program, we found following problem.

clone() syscall has special support for TID of created threads.  This
support includes two features.

One (CLONE_CHILD_SETTID) is to set an integer into user memory with the
TID value.

One (CLONE_CHILD_CLEARTID) is to clear this same integer once the created
thread dies.

The integer location is a user provided pointer, provided at clone()
time.

kernel keeps this pointer value into current->clear_child_tid.

At execve() time, we should make sure kernel doesnt keep this user
provided pointer, as full user memory is replaced by a new one.

As glibc fork() actually uses clone() syscall with CLONE_CHILD_SETTID and
CLONE_CHILD_CLEARTID set, chances are high that we might corrupt user
memory in forked processes.

Following sequence could happen:

1) bash (or any program) starts a new process, by a fork() call that
   glibc maps to a clone( ...  CLONE_CHILD_SETTID | CLONE_CHILD_CLEARTID
   ...) syscall

2) When new process starts, its current->clear_child_tid is set to a
   location that has a meaning only in bash (or initial program) context
   (&THREAD_SELF->tid)

3) This new process does the execve() syscall to start a new program.
   current->clear_child_tid is left unchanged (a non NULL value)

4) If this new program creates some threads, and initial thread exits,
   kernel will attempt to clear the integer pointed by
   current->clear_child_tid from mm_release() :

        if (tsk->clear_child_tid
            && !(tsk->flags & PF_SIGNALED)
            && atomic_read(&mm->mm_users) > 1) {
                u32 __user * tidptr = tsk->clear_child_tid;
                tsk->clear_child_tid = NULL;

                /*
                 * We don't check the error code - if userspace has
                 * not set up a proper pointer then tough luck.
                 */
<< here >>      put_user(0, tidptr);
                sys_futex(tidptr, FUTEX_WAKE, 1, NULL, NULL, 0);
        }

5) OR : if new program is not multi-threaded, but spied by /proc/pid
   users (ps command for example), mm_users > 1, and the exiting program
   could corrupt 4 bytes in a persistent memory area (shm or memory mapped
   file)

If current->clear_child_tid points to a writeable portion of memory of the
new program, kernel happily and silently corrupts 4 bytes of memory, with
unexpected effects.

Fix is straightforward and should not break any sane program.

Reported-by: Jens Rosenboom <jens@mcbone.net>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/fork.c~execve-must-clear-current-clear_child_tid-v2 kernel/fork.c
--- a/kernel/fork.c~execve-must-clear-current-clear_child_tid-v2
+++ a/kernel/fork.c
@@ -568,18 +568,18 @@ void mm_release(struct task_struct *tsk,
 	 * the value intact in a core dump, and to save the unnecessary
 	 * trouble otherwise.  Userland only wants this done for a sys_exit.
 	 */
-	if (tsk->clear_child_tid
-	    && !(tsk->flags & PF_SIGNALED)
-	    && atomic_read(&mm->mm_users) > 1) {
-		u32 __user * tidptr = tsk->clear_child_tid;
+	if (tsk->clear_child_tid) {
+		if (!(tsk->flags & PF_SIGNALED) &&
+		    atomic_read(&mm->mm_users) > 1) {
+			/*
+			 * We don't check the error code - if userspace has
+			 * not set up a proper pointer then tough luck.
+			 */
+			put_user(0, tsk->clear_child_tid);
+			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
+					1, NULL, NULL, 0);
+		}
 		tsk->clear_child_tid = NULL;
