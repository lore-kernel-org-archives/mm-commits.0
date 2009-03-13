From: akpm@linux-foundation.org
Subject: [merged] pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:25 -0700
Message-ID: <200903131819.n2DIJPvt008583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759399AbZCMSXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, corbet@lwn.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pipe_rdwr_fasync: fix the error handling to prevent the leak/crash
has been removed from the -mm tree.  Its filename was
     pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pipe_rdwr_fasync: fix the error handling to prevent the leak/crash
From: Oleg Nesterov <oleg@redhat.com>

If the second fasync_helper() fails, pipe_rdwr_fasync() returns the error
but leaves the file on ->fasync_readers.

This was always wrong, but since 233e70f4228e78eb2f80dc6650f65d3ae3dbf17c
"saner FASYNC handling on file close" we have the new problem.  Because in
this case setfl() doesn't set FASYNC bit, __fput() will not do
->fasync(0), and we leak fasync_struct with ->fa_file pointing to the
freed file.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/pipe.c~pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash fs/pipe.c
--- a/fs/pipe.c~pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash
+++ a/fs/pipe.c
@@ -699,12 +699,12 @@ pipe_rdwr_fasync(int fd, struct file *fi
 	int retval;
 
 	mutex_lock(&inode->i_mutex);
-
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
-
-	if (retval >= 0)
+	if (retval >= 0) {
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
-
+		if (retval < 0) /* this can happen only if on == T */
+			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
+	}
 	mutex_unlock(&inode->i_mutex);
 
 	if (retval < 0)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

