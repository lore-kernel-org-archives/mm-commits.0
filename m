From: akpm@linux-foundation.org
Subject: [merged] exit-wait-cleanup-the-ptrace_reparented-checks.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:08 -0800
Message-ID: <5489eb98.3MwkBFY1ERoCJJbm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbaLKTIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: wait: cleanup the ptrace_reparented() checks
has been removed from the -mm tree.  Its filename was
     exit-wait-cleanup-the-ptrace_reparented-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: wait: cleanup the ptrace_reparented() checks

Now that EXIT_DEAD is the terminal state we can kill "int traced" variable
and check "state == EXIT_DEAD" instead to cleanup the code.  In
particular, this way it is clear that the check obviously doesn't need
tasklist_lock.

Also fix the type of "unsigned long state", "long" was always wrong
although this doesn't matter because cmpxchg/xchg uses typeof(*ptr).

[akpm@linux-foundation.org: don't make me google the C Operator Precedence table]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~exit-wait-cleanup-the-ptrace_reparented-checks kernel/exit.c
--- a/kernel/exit.c~exit-wait-cleanup-the-ptrace_reparented-checks
+++ a/kernel/exit.c
@@ -973,8 +973,7 @@ static int wait_noreap_copyout(struct wa
  */
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
-	unsigned long state;
-	int retval, status, traced;
+	int state, retval, status;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
 	struct siginfo __user *infop;
@@ -999,19 +998,18 @@ static int wait_task_zombie(struct wait_
 		}
 		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
-
-	traced = ptrace_reparented(p);
 	/*
 	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = traced && thread_group_leader(p) ? EXIT_TRACE : EXIT_DEAD;
+	state = (ptrace_reparented(p) && thread_group_leader(p)) ?
+		EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
+
 	/*
-	 * It can be ptraced but not reparented, check
-	 * thread_group_leader() to filter out sub-threads.
+	 * Check thread_group_leader() to exclude the traced sub-threads.
 	 */
-	if (likely(!traced) && thread_group_leader(p)) {
+	if (state == EXIT_DEAD && thread_group_leader(p)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

