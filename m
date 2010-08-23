From: akpm@linux-foundation.org
Subject: + oom-add-per-mm-oom-disable-count.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:16:29 -0700
Message-ID: <201008232316.o7NNGUc9020390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab0HWXQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rientjes@google.com


The patch titled
     oom: add per-mm oom disable count
has been added to the -mm tree.  Its filename is
     oom-add-per-mm-oom-disable-count.patch

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
Subject: oom: add per-mm oom disable count
From: Ying Han <yinghan@google.com>

It's pointless to kill a task if another thread sharing its mm cannot be
killed to allow future memory freeing.  A subsequent patch will prevent
kills in such cases, but first it's necessary to have a way to flag a task
that shares memory with an OOM_DISABLE task that doesn't incur an
additional tasklist scan, which would make select_bad_process() an O(n^2)
function.

This patch adds an atomic counter to struct mm_struct that follows how
many threads attached to it have an oom_score_adj of OOM_SCORE_ADJ_MIN. 
They cannot be killed by the kernel, so their memory cannot be freed in
oom conditions.

This only requires task_lock() on the task that we're operating on, it
does not require mm->mmap_sem since task_lock() pins the mm and the
operation is atomic.

[rientjes@google.com: changelog and sys_unshare() code]
Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    5 +++++
 fs/proc/base.c           |   30 ++++++++++++++++++++++++++++++
 include/linux/mm_types.h |    2 ++
 kernel/exit.c            |    3 +++
 kernel/fork.c            |   13 ++++++++++++-
 5 files changed, 52 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~oom-add-per-mm-oom-disable-count fs/exec.c
--- a/fs/exec.c~oom-add-per-mm-oom-disable-count
+++ a/fs/exec.c
@@ -54,6 +54,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -745,6 +746,10 @@ static int exec_mmap(struct mm_struct *m
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
+	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+		atomic_dec(&active_mm->oom_disable_count);
+		atomic_inc(&tsk->mm->oom_disable_count);
+	}
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
diff -puN fs/proc/base.c~oom-add-per-mm-oom-disable-count fs/proc/base.c
--- a/fs/proc/base.c~oom-add-per-mm-oom-disable-count
+++ a/fs/proc/base.c
@@ -1049,6 +1049,21 @@ static ssize_t oom_adjust_write(struct f
 		return -EACCES;
 	}
 
+	task_lock(task);
+	if (!task->mm) {
+		task_unlock(task);
+		unlock_task_sighand(task, &flags);
+		put_task_struct(task);
+		return -EINVAL;
+	}
+
+	if (oom_adjust != task->signal->oom_adj) {
+		if (oom_adjust == OOM_DISABLE)
+			atomic_inc(&task->mm->oom_disable_count);
+		if (task->signal->oom_adj == OOM_DISABLE)
+			atomic_dec(&task->mm->oom_disable_count);
+	}
+
 	/*
 	 * Warn that /proc/pid/oom_adj is deprecated, see
 	 * Documentation/feature-removal-schedule.txt.
@@ -1067,6 +1082,7 @@ static ssize_t oom_adjust_write(struct f
 	else
 		task->signal->oom_score_adj = (oom_adjust * OOM_SCORE_ADJ_MAX) /
 								-OOM_DISABLE;
+	task_unlock(task);
 	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
 
@@ -1135,6 +1151,19 @@ static ssize_t oom_score_adj_write(struc
 		return -EACCES;
 	}
 
+	task_lock(task);
+	if (!task->mm) {
+		task_unlock(task);
+		unlock_task_sighand(task, &flags);
+		put_task_struct(task);
+		return -EINVAL;
+	}
+	if (oom_score_adj != task->signal->oom_score_adj) {
+		if (oom_score_adj == OOM_SCORE_ADJ_MIN)
+			atomic_inc(&task->mm->oom_disable_count);
+		if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+			atomic_dec(&task->mm->oom_disable_count);
+	}
 	task->signal->oom_score_adj = oom_score_adj;
 	/*
 	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
@@ -1145,6 +1174,7 @@ static ssize_t oom_score_adj_write(struc
 	else
 		task->signal->oom_adj = (oom_score_adj * OOM_ADJUST_MAX) /
 							OOM_SCORE_ADJ_MAX;
+	task_unlock(task);
 	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
 	return count;
diff -puN include/linux/mm_types.h~oom-add-per-mm-oom-disable-count include/linux/mm_types.h
--- a/include/linux/mm_types.h~oom-add-per-mm-oom-disable-count
+++ a/include/linux/mm_types.h
@@ -310,6 +310,8 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
+	/* How many tasks sharing this mm are OOM_DISABLE */
+	atomic_t oom_disable_count;
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
diff -puN kernel/exit.c~oom-add-per-mm-oom-disable-count kernel/exit.c
--- a/kernel/exit.c~oom-add-per-mm-oom-disable-count
+++ a/kernel/exit.c
@@ -50,6 +50,7 @@
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -689,6 +690,8 @@ static void exit_mm(struct task_struct *
 	enter_lazy_tlb(mm, current);
 	/* We don't want this task to be frozen prematurely */
 	clear_freeze_flag(tsk);
+	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+		atomic_dec(&mm->oom_disable_count);
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
diff -puN kernel/fork.c~oom-add-per-mm-oom-disable-count kernel/fork.c
--- a/kernel/fork.c~oom-add-per-mm-oom-disable-count
+++ a/kernel/fork.c
@@ -65,6 +65,7 @@
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
+#include <linux/oom.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -488,6 +489,7 @@ static struct mm_struct * mm_init(struct
 	mm->cached_hole_size = ~0UL;
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	atomic_set(&mm->oom_disable_count, 0);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
@@ -741,6 +743,8 @@ good_mm:
 	/* Initializing for Swap token stuff */
 	mm->token_priority = 0;
 	mm->last_interval = 0;
+	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+		atomic_inc(&mm->oom_disable_count);
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
@@ -1299,8 +1303,11 @@ bad_fork_cleanup_io:
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
-	if (p->mm)
+	if (p->mm) {
+		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+			atomic_dec(&p->mm->oom_disable_count);
 		mmput(p->mm);
+	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
 		free_signal_struct(p->signal);
@@ -1693,6 +1700,10 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 			active_mm = current->active_mm;
 			current->mm = new_mm;
 			current->active_mm = new_mm;
+			if (current->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+				atomic_dec(&mm->oom_disable_count);
+				atomic_inc(&new_mm->oom_disable_count);
+			}
 			activate_mm(active_mm, new_mm);
 			new_mm = mm;
 		}
_

Patches currently in -mm which might be from yinghan@google.com are

oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch

