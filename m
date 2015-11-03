From: akpm@linux-foundation.org
Subject: + proc-actually-make-proc_fd_permission-thread-friendly.patch
 added to -mm tree
Date: Tue, 03 Nov 2015 13:59:27 -0800
Message-ID: <56392e3f.rEz1TuMaLYIxAhuI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbKCV72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 16:59:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, stable@vger.kernel.org, yihua.jin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: actually make proc_fd_permission() thread-friendly
has been added to the -mm tree.  Its filename is
     proc-actually-make-proc_fd_permission-thread-friendly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-actually-make-proc_fd_permission-thread-friendly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-actually-make-proc_fd_permission-thread-friendly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: actually make proc_fd_permission() thread-friendly

The commit 96d0df79f264 ("proc: make proc_fd_permission() thread-friendly")
fixed the access to /proc/self/fd from sub-threads, but introduced another
problem: a sub-thread can't access /proc/<tid>/fd/ or /proc/thread-self/fd
if generic_permission() fails.

Change proc_fd_permission() to check same_thread_group(pid_task(), current).

Reported-by: "Jin, Yihua" <yihua.jin@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/proc/fd.c~proc-actually-make-proc_fd_permission-thread-friendly fs/proc/fd.c
--- a/fs/proc/fd.c~proc-actually-make-proc_fd_permission-thread-friendly
+++ a/fs/proc/fd.c
@@ -291,11 +291,19 @@ static struct dentry *proc_lookupfd(stru
  */
 int proc_fd_permission(struct inode *inode, int mask)
 {
-	int rv = generic_permission(inode, mask);
+	struct task_struct *p;
+	int rv;
+
+	rv = generic_permission(inode, mask);
 	if (rv == 0)
-		return 0;
-	if (task_tgid(current) == proc_pid(inode))
+		return rv;
+
+	rcu_read_lock();
+	p = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (p && same_thread_group(p, current))
 		rv = 0;
+	rcu_read_unlock();
+
 	return rv;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

mmoom-fix-potentially-killing-unrelated-process-fix.patch
mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
proc-actually-make-proc_fd_permission-thread-friendly.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

