From: akpm@linux-foundation.org
Subject: + exec-fix-set_binfmt-vs-sys_delete_module-race.patch added to -mm tree
Date: Mon, 27 Jul 2009 16:21:16 -0700
Message-ID: <200907272321.n6RNLGUw023895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbZG0XW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 19:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, h-shimamoto@ct.jp.nec.com, roland@redhat.com, rusty@rustcorp.com.au


The patch titled
     exec: fix set_binfmt() vs sys_delete_module() race
has been added to the -mm tree.  Its filename is
     exec-fix-set_binfmt-vs-sys_delete_module-race.patch

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
Subject: exec: fix set_binfmt() vs sys_delete_module() race
From: Oleg Nesterov <oleg@redhat.com>

sys_delete_module() can set MODULE_STATE_GOING after
search_binary_handler() does try_module_get().  In this case
set_binfmt()->try_module_get() fails but since none of the callers
check the returned error, the task will run with the wrong old
->binfmt.

The proper fix should change all ->load_binary() methods, but we can
rely on fact that the caller must hold a reference to binfmt->module
and use __module_get() which never fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |   17 ++++++++---------
 include/linux/binfmts.h |    2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/exec.c~exec-fix-set_binfmt-vs-sys_delete_module-race fs/exec.c
--- a/fs/exec.c~exec-fix-set_binfmt-vs-sys_delete_module-race
+++ a/fs/exec.c
@@ -1384,18 +1384,17 @@ out_ret:
 	return retval;
 }
 
-int set_binfmt(struct linux_binfmt *new)
+/*
+ * The caller, ->load_binary(), must hold a reference to ->module.
+ */
+void set_binfmt(struct linux_binfmt *new)
 {
-	struct linux_binfmt *old = current->binfmt;
+	if (current->binfmt)
+		module_put(current->binfmt->module);
 
-	if (new) {
-		if (!try_module_get(new->module))
-			return -1;
-	}
 	current->binfmt = new;
-	if (old)
-		module_put(old->module);
-	return 0;
+	if (new)
+		__module_get(new->module);
 }
 
 EXPORT_SYMBOL(set_binfmt);
diff -puN include/linux/binfmts.h~exec-fix-set_binfmt-vs-sys_delete_module-race include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-fix-set_binfmt-vs-sys_delete_module-race
+++ a/include/linux/binfmts.h
@@ -119,7 +119,7 @@ extern int bprm_mm_init(struct linux_bin
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
-extern int set_binfmt(struct linux_binfmt *new);
+extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch

