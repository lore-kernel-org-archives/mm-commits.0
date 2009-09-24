From: akpm@linux-foundation.org
Subject: [merged] task_struct-cleanup-move-binfmt-field-to-mm_struct.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:28 -0700
Message-ID: <200909241937.n8OJbSYr004629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbZIXTiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, oleg@redhat.com, roland@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     task_struct cleanup: move binfmt field to mm_struct
has been removed from the -mm tree.  Its filename was
     task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: task_struct cleanup: move binfmt field to mm_struct
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Because the binfmt is not different between threads in the same process,
it can be moved from task_struct to mm_struct.  And binfmt moudle is
handled per mm_struct instead of task_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |   10 ++++++----
 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    1 -
 kernel/exit.c            |    2 --
 kernel/fork.c            |   13 +++++++------
 5 files changed, 15 insertions(+), 13 deletions(-)

diff -puN fs/exec.c~task_struct-cleanup-move-binfmt-field-to-mm_struct fs/exec.c
--- a/fs/exec.c~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/fs/exec.c
@@ -1397,10 +1397,12 @@ out_ret:
 
 void set_binfmt(struct linux_binfmt *new)
 {
-	if (current->binfmt)
-		module_put(current->binfmt->module);
+	struct mm_struct *mm = current->mm;
+
+	if (mm->binfmt)
+		module_put(mm->binfmt->module);
 
-	current->binfmt = new;
+	mm->binfmt = new;
 	if (new)
 		__module_get(new->module);
 }
@@ -1770,7 +1772,7 @@ void do_coredump(long signr, int exit_co
 
 	audit_core_dumps(signr);
 
-	binfmt = current->binfmt;
+	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 
diff -puN include/linux/mm_types.h~task_struct-cleanup-move-binfmt-field-to-mm_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/include/linux/mm_types.h
@@ -240,6 +240,8 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+	struct linux_binfmt *binfmt;
+
 	cpumask_t cpu_vm_mask;
 
 	/* Architecture-specific MM context */
diff -puN include/linux/sched.h~task_struct-cleanup-move-binfmt-field-to-mm_struct include/linux/sched.h
--- a/include/linux/sched.h~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/include/linux/sched.h
@@ -1271,7 +1271,6 @@ struct task_struct {
 	struct mm_struct *mm, *active_mm;
 
 /* task state */
-	struct linux_binfmt *binfmt;
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
diff -puN kernel/exit.c~task_struct-cleanup-move-binfmt-field-to-mm_struct kernel/exit.c
--- a/kernel/exit.c~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/kernel/exit.c
@@ -976,8 +976,6 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->binfmt)
-		module_put(tsk->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff -puN kernel/fork.c~task_struct-cleanup-move-binfmt-field-to-mm_struct kernel/fork.c
--- a/kernel/fork.c~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/kernel/fork.c
@@ -518,6 +518,8 @@ void mmput(struct mm_struct *mm)
 			spin_unlock(&mmlist_lock);
 		}
 		put_swap_token(mm);
+		if (mm->binfmt)
+			module_put(mm->binfmt->module);
 		mmdrop(mm);
 	}
 }
@@ -643,9 +645,14 @@ struct mm_struct *dup_mm(struct task_str
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
 
+	if (mm->binfmt && !try_module_get(mm->binfmt->module))
+		goto free_pt;
+
 	return mm;
 
 free_pt:
+	/* don't put binfmt in mmput, we haven't got module yet */
+	mm->binfmt = NULL;
 	mmput(mm);
 
 fail_nomem:
@@ -1037,9 +1044,6 @@ static struct task_struct *copy_process(
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
-		goto bad_fork_cleanup_put_domain;
