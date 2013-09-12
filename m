From: akpm@linux-foundation.org
Subject: [merged] exec-introduce-exec_binprm-for-depth-==-0-code.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:48:37 -0700
Message-ID: <52321a95.cJr+p1eDr9m/iCiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3ILTsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: [merged] exec-introduce-exec_binprm-for-depth-==-0-code.patch removed from -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:48:37 -0700


The patch titled
     Subject: exec: introduce exec_binprm() for "depth == 0" code
has been removed from the -mm tree.  Its filename was
     exec-introduce-exec_binprm-for-depth-==-0-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

