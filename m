From: akpm@linux-foundation.org
Subject: + utrace-core-kill-exclude_xtrace-logic.patch added to -mm tree
Date: Mon, 04 May 2009 16:32:50 -0700
Message-ID: <200905042332.n44NWop3016746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701AbZEDXev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     utrace-core: kill exclude_xtrace logic
has been added to the -mm tree.  Its filename is
     utrace-core-kill-exclude_xtrace-logic.patch

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
Subject: utrace-core: kill exclude_xtrace logic
From: Oleg Nesterov <oleg@redhat.com>

exclude_utrace() has no callers. exclude_ptrace() is called under
tasklist_lock + task_lock() but needs utrace->lock.

Remove this logic for now. We will either add utrace-ptrace or rework
this mutual exclusion later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   18 +-----------------
 kernel/utrace.c |    8 --------
 2 files changed, 1 insertion(+), 25 deletions(-)

diff -puN kernel/ptrace.c~utrace-core-kill-exclude_xtrace-logic kernel/ptrace.c
--- a/kernel/ptrace.c~utrace-core-kill-exclude_xtrace-logic
+++ a/kernel/ptrace.c
@@ -16,7 +16,6 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/ptrace.h>
-#include <linux/utrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/audit.h>
@@ -175,14 +174,6 @@ bool ptrace_may_access(struct task_struc
 	return !err;
 }
 
-/*
- * For experimental use of utrace, exclude ptrace on the same task.
- */
-static inline bool exclude_ptrace(struct task_struct *task)
-{
-	return unlikely(!!task_utrace_flags(task));
-}
-
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -221,11 +212,6 @@ repeat:
 		goto repeat;
 	}
 
-	if (exclude_ptrace(task)) {
-		retval = -EBUSY;
-		goto bad;
-	}
-
 	if (!task->mm)
 		goto bad;
 	/* the same process cannot be attached many times */
@@ -602,9 +588,7 @@ int ptrace_traceme(void)
 	 */
 repeat:
 	task_lock(current);
-	if (exclude_ptrace(current)) {
-		ret = -EBUSY;
-	} else if (!(current->ptrace & PT_PTRACED)) {
+	if (!(current->ptrace & PT_PTRACED)) {
 		/*
 		 * See ptrace_attach() comments about the locking here.
 		 */
diff -puN kernel/utrace.c~utrace-core-kill-exclude_xtrace-logic kernel/utrace.c
--- a/kernel/utrace.c~utrace-core-kill-exclude_xtrace-logic
+++ a/kernel/utrace.c
@@ -108,14 +108,6 @@ static struct utrace_engine *matching_en
 }
 
 /*
- * For experimental use, utrace attach is mutually exclusive with ptrace.
- */
-static inline bool exclude_utrace(struct task_struct *task)
-{
-	return unlikely(!!task->ptrace);
-}
-
-/*
  * Called without locks, when we might be the first utrace engine to attach.
  * If this is a newborn thread and we are not the creator, we have to wait
  * for it.  The creator gets the first chance to attach.  The PF_STARTING
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
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

