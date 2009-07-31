From: akpm@linux-foundation.org
Subject: + execve-must-clear-current-clear_child_tid.patch added to -mm tree
Date: Fri, 31 Jul 2009 14:42:20 -0700
Message-ID: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbZGaVoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 17:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, drepper@redhat.com, jens@mcbone.net, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, sonnyrao@us.ibm.com, stable@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org


The patch titled
     execve: must clear current->clear_child_tid
has been added to the -mm tree.  Its filename is
     execve-must-clear-current-clear_child_tid.patch

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
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Jens Rosenboom <jens@mcbone.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    1 +
 fs/exec.c   |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/compat.c~execve-must-clear-current-clear_child_tid fs/compat.c
--- a/fs/compat.c~execve-must-clear-current-clear_child_tid
+++ a/fs/compat.c
@@ -1550,6 +1550,7 @@ int compat_do_execve(char * filename,
 	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	current->clear_child_tid = NULL;
 	if (displaced)
 		put_files_struct(displaced);
 	return retval;
diff -puN fs/exec.c~execve-must-clear-current-clear_child_tid fs/exec.c
--- a/fs/exec.c~execve-must-clear-current-clear_child_tid
+++ a/fs/exec.c
@@ -1343,6 +1343,7 @@ int do_execve(char * filename,
 	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	current->clear_child_tid = NULL;
 	if (displaced)
 		put_files_struct(displaced);
 	return retval;
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

linux-next.patch
execve-must-clear-current-clear_child_tid.patch

