From: akpm@linux-foundation.org
Subject: + exec-introduce-exec_binprm-for-depth-==-0-code.patch added to
 -mm tree
Date: Mon, 05 Aug 2013 13:45:08 -0700
Message-ID: <52000ed4.Pnz62SCfFA/jEFa0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3HEUpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: + exec-introduce-exec_binprm-for-depth-==-0-code.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:45:08 -0700


The patch titled
     Subject: exec: introduce exec_binprm() for "depth == 0" code
has been added to the -mm tree.  Its filename is
     exec-introduce-exec_binprm-for-depth-==-0-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-introduce-exec_binprm-for-depth-==-0-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-introduce-exec_binprm-for-depth-==-0-code.patch

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
Subject: exec: introduce exec_binprm() for "depth == 0" code

task_pid_nr_ns() and trace/ptrace code in the middle of the recursive
search_binary_handler() looks confusing and imho annoying.  We only need
this code if "depth == 0", lets add a simple helper which calls
search_binary_handler() and does trace_sched_process_exec() +
ptrace_event().

The patch also moves the setting of task->did_exec, we need to do this
only once.

Note: we can kill either task->did_exec or PF_FORKNOEXEC.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~exec-introduce-exec_binprm-for-depth-==-0-code fs/exec.c
--- a/fs/exec.c~exec-introduce-exec_binprm-for-depth-==-0-code
+++ a/fs/exec.c
@@ -1373,7 +1373,6 @@ int search_binary_handler(struct linux_b
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
-	pid_t old_pid, old_vpid;
 
 	/* This allows 4 levels of binfmt rewrites before failing hard. */
 	if (depth > 5)
@@ -1387,12 +1386,6 @@ int search_binary_handler(struct linux_b
 	if (retval)
 		return retval;
 
-	/* Need to fetch pid before load_binary changes it */
-	old_pid = current->pid;
-	rcu_read_lock();
-	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
-	rcu_read_unlock();
-
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
@@ -1407,16 +1400,11 @@ int search_binary_handler(struct linux_b
 			retval = fn(bprm);
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
-				if (depth == 0) {
-					trace_sched_process_exec(current, old_pid, bprm);
-					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
-				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
 					fput(bprm->file);
 				bprm->file = NULL;
-				current->did_exec = 1;
 				proc_exec_connector(current);
 				return retval;
 			}
@@ -1450,9 +1438,29 @@ int search_binary_handler(struct linux_b
 	}
 	return retval;
 }
-
 EXPORT_SYMBOL(search_binary_handler);
 
+static int exec_binprm(struct linux_binprm *bprm)
+{
+	pid_t old_pid, old_vpid;
+	int ret;
+
+	/* Need to fetch pid before load_binary changes it */
+	old_pid = current->pid;
+	rcu_read_lock();
+	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+	rcu_read_unlock();
+
+	ret = search_binary_handler(bprm);
+	if (ret >= 0) {
+		trace_sched_process_exec(current, old_pid, bprm);
+		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
+		current->did_exec = 1;
+	}
+
+	return ret;
+}
+
 /*
  * sys_execve() executes a new program.
  */
@@ -1541,7 +1549,7 @@ static int do_execve_common(const char *
 	if (retval < 0)
 		goto out;
 
-	retval = search_binary_handler(bprm);
+	retval = exec_binprm(bprm);
 	if (retval < 0)
 		goto out;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch
linux-next.patch

