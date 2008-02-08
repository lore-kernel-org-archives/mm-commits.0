From: akpm@linux-foundation.org
Subject: - kill-my_ptrace_child.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:24 -0800
Message-ID: <200802082013.m18KD5DH010260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbYBHU5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:57:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, hch@lst.de, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kill my_ptrace_child()
has been removed from the -mm tree.  Its filename was
     kill-my_ptrace_child.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill my_ptrace_child()
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that my_ptrace_child() is trivial we can use the "p->ptrace & PT_PTRACED"
inline and simplify the corresponding logic in do_wait: we can't find the
child in TASK_TRACED state without PT_PTRACED flag set, ptrace_untrace()
either sets TASK_STOPPED or wakes up the tracee.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff -puN kernel/exit.c~kill-my_ptrace_child kernel/exit.c
--- a/kernel/exit.c~kill-my_ptrace_child
+++ a/kernel/exit.c
@@ -1511,12 +1511,6 @@ static int wait_task_continued(struct ta
 	return retval;
 }
 
-
-static inline int my_ptrace_child(struct task_struct *p)
-{
-	return p->ptrace & PT_PTRACED;
-}
-
 static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
 		    int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1555,22 +1549,11 @@ repeat:
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
-				 *
-				 * When we hit the race with PTRACE_ATTACH, we
-				 * will not report this child.  But the race
-				 * means it has not yet been moved to our
-				 * ptrace_children list, so we need to set the
-				 * flag here to avoid a spurious ECHILD when
-				 * the race happens with the only child.
 				 */
 				flag = 1;
-
-				if (!my_ptrace_child(p)) {
-					if (task_is_traced(p))
-						continue;
-					if (!(options & WUNTRACED))
-						continue;
-				}
+				if (!(p->ptrace & PT_PTRACED) &&
+				    !(options & WUNTRACED))
+					continue;
 
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
