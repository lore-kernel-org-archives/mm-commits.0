From: akpm@linux-foundation.org
Subject: + task_struct-cleanup-move-binfmt-field-to-mm_struct.patch added to -mm tree
Date: Thu, 30 Jul 2009 17:00:45 -0700
Message-ID: <200907310000.n6V00jPQ017649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbZGaABL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 20:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com, oleg@redhat.com, roland@redhat.com, rusty@rustcorp.com.au


The patch titled
     task_struct cleanup: move binfmt field to mm_struct
has been added to the -mm tree.  Its filename is
     task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

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
@@ -1386,10 +1386,12 @@ out_ret:
 
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
@@ -1759,7 +1761,7 @@ void do_coredump(long signr, int exit_co
 
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
 	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
 
 	cpumask_t cpu_vm_mask;
diff -puN include/linux/sched.h~task_struct-cleanup-move-binfmt-field-to-mm_struct include/linux/sched.h
--- a/include/linux/sched.h~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/include/linux/sched.h
@@ -1245,7 +1245,6 @@ struct task_struct {
 	struct mm_struct *mm, *active_mm;
 
 /* task state */
-	struct linux_binfmt *binfmt;
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
diff -puN kernel/exit.c~task_struct-cleanup-move-binfmt-field-to-mm_struct kernel/exit.c
--- a/kernel/exit.c~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/kernel/exit.c
@@ -977,8 +977,6 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->binfmt)
-		module_put(tsk->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff -puN kernel/fork.c~task_struct-cleanup-move-binfmt-field-to-mm_struct kernel/fork.c
--- a/kernel/fork.c~task_struct-cleanup-move-binfmt-field-to-mm_struct
+++ a/kernel/fork.c
@@ -519,6 +519,8 @@ void mmput(struct mm_struct *mm)
 			spin_unlock(&mmlist_lock);
 		}
 		put_swap_token(mm);
+		if (mm->binfmt)
+			module_put(mm->binfmt->module);
 		mmdrop(mm);
 	}
 }
@@ -644,9 +646,14 @@ struct mm_struct *dup_mm(struct task_str
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
@@ -1050,9 +1057,6 @@ static struct task_struct *copy_process(
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
-		goto bad_fork_cleanup_put_domain;
