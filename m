From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-kill-the-sub_info-path-check.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:43 -0700
Message-ID: <51db148f.ZYIXGTS5Ji7GG6U6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3GHTfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, lucas.de.marchi@gmail.com, oleg@redhat.com

Subject: [merged] usermodehelper-kill-the-sub_info-path-check.patch removed from -mm tree
To: oleg@redhat.com,lucas.de.marchi@gmail.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:43 -0700


The patch titled
     Subject: usermodehelper: kill the sub_info->path[0] check
has been removed from the -mm tree.  Its filename was
     usermodehelper-kill-the-sub_info-path-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: kill the sub_info->path[0] check

call_usermodehelper_exec() does nothing but returns success if path[0] ==
0.  The only user which needs this strange feature is request_module(), it
can check modprobe_path[0] itself like other users do if they want to
detect the "disabled by admin" case.

Kill it.  Not only it looks strange, it can confuse other callers.  And
this allows us to revert 264b83c0 ("usermodehelper: check
subprocess_info->path != NULL"), do_execve(NULL) is safe.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/kmod.c~usermodehelper-kill-the-sub_info-path-check kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-kill-the-sub_info-path-check
+++ a/kernel/kmod.c
@@ -147,6 +147,9 @@ int __request_module(bool wait, const ch
 	 */
 	WARN_ON_ONCE(wait && current_is_async());
 
+	if (!modprobe_path[0])
+		return 0;
+
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
@@ -569,14 +572,6 @@ int call_usermodehelper_exec(struct subp
 	int retval = 0;
 
 	helper_lock();
-	if (!sub_info->path) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	if (sub_info->path[0] == '\0')
-		goto out;
-
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

