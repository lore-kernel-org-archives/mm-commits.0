From: akpm@linux-foundation.org
Subject: +
 exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch added to -mm tree
Date: Wed, 12 Nov 2014 14:56:32 -0800
Message-ID: <5463e5a0.O1wiBdQUA2CW9pRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaKLW4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: ptrace: shift "reap dead" code from exit_ptrace() to forget_original_parent()
has been added to the -mm tree.  Its filename is
     exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch

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
Subject: exit: ptrace: shift "reap dead" code from exit_ptrace() to forget_original_parent()

Now that forget_original_parent() uses ->ptrace_entry for EXIT_DEAD tasks,
we can simply pass "dead_children" list to exit_ptrace() and remove
another release_task() loop.  Plus this way we do not need to drop and
reacquire tasklist_lock.

Also shift the list_empty(ptraced) check, if we want this optimization it
makes sense to eliminate the function call altogether.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    2 +-
 kernel/exit.c          |   10 ++++------
 kernel/ptrace.c        |   23 +++--------------------
 3 files changed, 8 insertions(+), 27 deletions(-)

diff -puN include/linux/ptrace.h~exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent include/linux/ptrace.h
--- a/include/linux/ptrace.h~exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent
+++ a/include/linux/ptrace.h
@@ -52,7 +52,7 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void exit_ptrace(struct task_struct *tracer);
+extern void exit_ptrace(struct task_struct *tracer, struct list_head *dead);
 #define PTRACE_MODE_READ	0x01
 #define PTRACE_MODE_ATTACH	0x02
 #define PTRACE_MODE_NOAUDIT	0x04
diff -puN kernel/exit.c~exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent kernel/exit.c
--- a/kernel/exit.c~exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent
+++ a/kernel/exit.c
@@ -553,13 +553,11 @@ static void forget_original_parent(struc
 	LIST_HEAD(dead_children);
 
 	write_lock_irq(&tasklist_lock);
-	/*
-	 * Note that exit_ptrace() and find_new_reaper() might
-	 * drop tasklist_lock and reacquire it.
-	 */
-	exit_ptrace(father);
-	reaper = find_new_reaper(father);
+	if (unlikely(!list_empty(&father->ptraced)))
+		exit_ptrace(father, &dead_children);
 
+	/* Can drop and reacquire tasklist_lock */
+	reaper = find_new_reaper(father);
 	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
diff -puN kernel/ptrace.c~exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent kernel/ptrace.c
--- a/kernel/ptrace.c~exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent
+++ a/kernel/ptrace.c
@@ -485,36 +485,19 @@ static int ptrace_detach(struct task_str
 
 /*
  * Detach all tasks we were using ptrace on. Called with tasklist held
- * for writing, and returns with it held too. But note it can release
- * and reacquire the lock.
+ * for writing.
  */
-void exit_ptrace(struct task_struct *tracer)
-	__releases(&tasklist_lock)
-	__acquires(&tasklist_lock)
+void exit_ptrace(struct task_struct *tracer, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	LIST_HEAD(ptrace_dead);
-
-	if (likely(list_empty(&tracer->ptraced)))
-		return;
 
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (unlikely(p->ptrace & PT_EXITKILL))
 			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
 
 		if (__ptrace_detach(tracer, p))
-			list_add(&p->ptrace_entry, &ptrace_dead);
+			list_add(&p->ptrace_entry, dead);
 	}
-
-	write_unlock_irq(&tasklist_lock);
-	BUG_ON(!list_empty(&tracer->ptraced));
-
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
-	}
-
-	write_lock_irq(&tasklist_lock);
 }
 
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
linux-next.patch

