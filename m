From: akpm@linux-foundation.org
Subject: + task_struct-cleanup-move-binfmt-field-to-signal_struct.patch added to -mm tree
Date: Wed, 22 Jul 2009 13:23:36 -0700
Message-ID: <200907222023.n6MKNafX026691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbZGVUXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 16:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com, oleg@redhat.com, roland@redhat.com


The patch titled
     task_struct cleanup: move binfmt field to signal_struct
has been added to the -mm tree.  Its filename is
     task_struct-cleanup-move-binfmt-field-to-signal_struct.patch

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
Subject: task_struct cleanup: move binfmt field to signal_struct
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Because the binfmt is not different between threads in the same process,
it can be moved from task_struct to signal_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    6 +++---
 include/linux/sched.h |    2 +-
 kernel/exit.c         |    4 ++--
 kernel/fork.c         |    7 ++++---
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/exec.c~task_struct-cleanup-move-binfmt-field-to-signal_struct fs/exec.c
--- a/fs/exec.c~task_struct-cleanup-move-binfmt-field-to-signal_struct
+++ a/fs/exec.c
@@ -1384,13 +1384,13 @@ out_ret:
 
 int set_binfmt(struct linux_binfmt *new)
 {
-	struct linux_binfmt *old = current->binfmt;
+	struct linux_binfmt *old = current->signal->binfmt;
 
 	if (new) {
 		if (!try_module_get(new->module))
 			return -1;
 	}
-	current->binfmt = new;
+	current->signal->binfmt = new;
 	if (old)
 		module_put(old->module);
 	return 0;
@@ -1737,7 +1737,7 @@ void do_coredump(long signr, int exit_co
 
 	audit_core_dumps(signr);
 
-	binfmt = current->binfmt;
+	binfmt = current->signal->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 
diff -puN include/linux/sched.h~task_struct-cleanup-move-binfmt-field-to-signal_struct include/linux/sched.h
--- a/include/linux/sched.h~task_struct-cleanup-move-binfmt-field-to-signal_struct
+++ a/include/linux/sched.h
@@ -596,6 +596,7 @@ struct signal_struct {
 	int leader;
 
 	struct tty_struct *tty; /* NULL if no tty */
+	struct linux_binfmt *binfmt;
 
 	/*
 	 * Cumulative resource counters for dead threads in the group,
@@ -1232,7 +1233,6 @@ struct task_struct {
 	struct mm_struct *mm, *active_mm;
 
 /* task state */
-	struct linux_binfmt *binfmt;
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
diff -puN kernel/exit.c~task_struct-cleanup-move-binfmt-field-to-signal_struct kernel/exit.c
--- a/kernel/exit.c~task_struct-cleanup-move-binfmt-field-to-signal_struct
+++ a/kernel/exit.c
@@ -977,8 +977,8 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->binfmt)
-		module_put(tsk->binfmt->module);
+	if (tsk->signal->binfmt)
+		module_put(tsk->signal->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff -puN kernel/fork.c~task_struct-cleanup-move-binfmt-field-to-signal_struct kernel/fork.c
--- a/kernel/fork.c~task_struct-cleanup-move-binfmt-field-to-signal_struct
+++ a/kernel/fork.c
@@ -858,6 +858,7 @@ static int copy_signal(unsigned long clo
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
 	sig->tty = NULL;
+	sig->binfmt = current->signal->binfmt;
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
@@ -1026,7 +1027,7 @@ static struct task_struct *copy_process(
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
+	if (p->signal->binfmt && !try_module_get(p->signal->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
 
 	p->did_exec = 0;
@@ -1315,8 +1316,8 @@ bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
-	if (p->binfmt)
-		module_put(p->binfmt->module);
+	if (p->signal->binfmt)
+		module_put(p->signal->binfmt->module);
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

task_struct-cleanup-move-binfmt-field-to-signal_struct.patch
task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct.patch

