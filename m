From: akpm@linux-foundation.org
Subject: + kill-my_ptrace_child.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:20:09 -0800
Message-ID: <200711270420.lAR4K95c026576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbXK0EVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:21:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, hch@lst.de, roland@redhat.com


The patch titled
     kill my_ptrace_child()
has been added to the -mm tree.  Its filename is
     kill-my_ptrace_child.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill my_ptrace_child()
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that my_ptrace_child() is trivial we can use the "p->ptrace & PT_PTRACED"
inline and simplify the corresponding logic in do_wait: we can't find the
child in TASK_TRACED state without PT_PTRACED flag set, ptrace_untrace()
either sets TASK_STOPPED or wakes up the tracee.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff -puN kernel/exit.c~kill-my_ptrace_child kernel/exit.c
--- a/kernel/exit.c~kill-my_ptrace_child
+++ a/kernel/exit.c
@@ -1508,12 +1508,6 @@ static int wait_task_continued(struct ta
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
@@ -1552,22 +1546,11 @@ repeat:
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
-					if (is_task_traced(p))
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

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
