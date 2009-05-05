From: akpm@linux-foundation.org
Subject: + ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch added to -mm tree
Date: Tue, 05 May 2009 16:41:05 -0700
Message-ID: <200905052341.n45Nf5HH003978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbZEEXnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 19:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace_get_task_struct: s/tasklist/rcu/, make it static
has been added to the -mm tree.  Its filename is
     ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch

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
Subject: ptrace_get_task_struct: s/tasklist/rcu/, make it static
From: Oleg Nesterov <oleg@redhat.com>

- Use rcu_read_lock() instead of tasklist_lock to find/get the task
  in ptrace_get_task_struct().

- Make it static, it has no callers outside of ptrace.c.

- The comment doesn't match the reality, this helper does not do
  any checks. Beacuse it is really trivial and static I removed the
  whole comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 kernel/ptrace.c        |   16 +++-------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff -puN include/linux/ptrace.h~ptrace_get_task_struct-s-tasklist-rcu-make-it-static include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace_get_task_struct-s-tasklist-rcu-make-it-static
+++ a/include/linux/ptrace.h
@@ -81,7 +81,6 @@
 
 
 extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
-extern struct task_struct *ptrace_get_task_struct(pid_t pid);
 extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
diff -puN kernel/ptrace.c~ptrace_get_task_struct-s-tasklist-rcu-make-it-static kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_get_task_struct-s-tasklist-rcu-make-it-static
+++ a/kernel/ptrace.c
@@ -587,26 +587,16 @@ int ptrace_request(struct task_struct *c
 	return ret;
 }
 
-/**
- * ptrace_get_task_struct  --  grab a task struct reference for ptrace
- * @pid:       process id to grab a task_struct reference of
- *
- * This function is a helper for ptrace implementations.  It checks
- * permissions and then grabs a task struct for use of the actual
- * ptrace implementation.
- *
- * Returns the task_struct for @pid or an ERR_PTR() on failure.
- */
-struct task_struct *ptrace_get_task_struct(pid_t pid)
+static struct task_struct *ptrace_get_task_struct(pid_t pid)
 {
 	struct task_struct *child;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	child = find_task_by_vpid(pid);
 	if (child)
 		get_task_struct(child);
+	rcu_read_unlock();
 
-	read_unlock(&tasklist_lock);
 	if (!child)
 		return ERR_PTR(-ESRCH);
 	return child;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
rcu_sched_grace_period-kill-the-bogus-flush_signals.patch
drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch
utrace-core-kill-exclude_xtrace-logic.patch

