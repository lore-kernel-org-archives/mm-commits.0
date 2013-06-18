From: akpm@linux-foundation.org
Subject: + fput-turn-list_head-delayed_fput_list-into-llist_head.patch
 added to -mm tree
Date: Tue, 18 Jun 2013 14:00:42 -0700
Message-ID: <51c0ca7a.lS95BIh0G4Hjl1bB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab3FRVAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 17:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, dhowells@redhat.com, avagin@openvz.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: + fput-turn-list_head-delayed_fput_list-into-llist_head.patch added to -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,akpm@linux-foundation.org,avagin@openvz.org,dhowells@redhat.com,ebiederm@xmission.com,viro@zeniv.linux.org.uk,ying.huang@intel.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 14:00:42 -0700


The patch titled
     Subject: fput: turn "list_head delayed_fput_list" into llist_head
has been added to the -mm tree.  Its filename is
     fput-turn-list_head-delayed_fput_list-into-llist_head.patch

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
Subject: fput: turn "list_head delayed_fput_list" into llist_head

fput() and delayed_fput() can use llist and avoid the locking.

This is unlikely path, it is not that this change can improve
the performance, but this way the code looks simpler.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   25 ++++++++++---------------
 include/linux/fs.h |    2 ++
 2 files changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/file_table.c~fput-turn-list_head-delayed_fput_list-into-llist_head fs/file_table.c
--- a/fs/file_table.c~fput-turn-list_head-delayed_fput_list-into-llist_head
+++ a/fs/file_table.c
@@ -265,18 +265,15 @@ static void __fput(struct file *file)
 	mntput(mnt);
 }
 
-static DEFINE_SPINLOCK(delayed_fput_lock);
-static LIST_HEAD(delayed_fput_list);
+static LLIST_HEAD(delayed_fput_list);
 static void delayed_fput(struct work_struct *unused)
 {
-	LIST_HEAD(head);
-	spin_lock_irq(&delayed_fput_lock);
-	list_splice_init(&delayed_fput_list, &head);
-	spin_unlock_irq(&delayed_fput_lock);
-	while (!list_empty(&head)) {
-		struct file *f = list_first_entry(&head, struct file, f_u.fu_list);
-		list_del_init(&f->f_u.fu_list);
-		__fput(f);
+	struct llist_node *node = llist_del_all(&delayed_fput_list);
+	struct llist_node *next;
+
+	for (; node; node = next) {
+		next = llist_next(node);
+		__fput(llist_entry(node, struct file, f_u.fu_llist));
 	}
 }
 
@@ -306,7 +303,6 @@ void fput(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
-		unsigned long flags;
 
 		file_sb_list_del(file);
 		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
@@ -320,10 +316,9 @@ void fput(struct file *file)
 			 * fput to avoid leaking *file.
 			 */
 		}
-		spin_lock_irqsave(&delayed_fput_lock, flags);
-		list_add(&file->f_u.fu_list, &delayed_fput_list);
-		schedule_work(&delayed_fput_work);
-		spin_unlock_irqrestore(&delayed_fput_lock, flags);
+
+		if (llist_add(&file->f_u.fu_llist, &delayed_fput_list))
+			schedule_work(&delayed_fput_work);
 	}
 }
 
diff -puN include/linux/fs.h~fput-turn-list_head-delayed_fput_list-into-llist_head include/linux/fs.h
--- a/include/linux/fs.h~fput-turn-list_head-delayed_fput_list-into-llist_head
+++ a/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/stat.h>
 #include <linux/cache.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/radix-tree.h>
 #include <linux/rbtree.h>
 #include <linux/init.h>
@@ -767,6 +768,7 @@ struct file {
 	 */
 	union {
 		struct list_head	fu_list;
+		struct llist_node	fu_llist;
 		struct rcu_head 	fu_rcuhead;
 	} f_u;
 	struct path		f_path;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
kernel-sysc-do_sysinfo-use-get_monotonic_boottime.patch
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
x86-kill-tif_debug.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
usermodehelper-kill-the-sub_info-path-check.patch
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch
fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exitc-unexport-__set_special_pids.patch
fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
fs-execc-do_execve_common-use-current_user.patch
fs-execc-de_thread-mt-exec-should-update-real_start_time.patch
wait-introduce-wait_event_commonwq-condition-state-timeout.patch
wait-introduce-wait_event_commonwq-condition-state-timeout-checkpatch-fixes.patch
wait-introduce-prepare_to_wait_event.patch
wait-introduce-prepare_to_wait_event-checkpatch-fixes.patch

