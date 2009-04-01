From: akpm@linux-foundation.org
Subject: [merged] get_mm_hiwater_xxx-trivial-s-define-inline.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:16 -0700
Message-ID: <200904011834.n31IYGow007103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765336AbZDAShm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     get_mm_hiwater_xxx: trivial, s/define/inline/
has been removed from the -mm tree.  Its filename was
     get_mm_hiwater_xxx-trivial-s-define-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_mm_hiwater_xxx: trivial, s/define/inline/
From: Oleg Nesterov <oleg@redhat.com>

Andrew pointed out get_mm_hiwater_xxx() evaluate "mm" argument thrice/twice,
make them inline.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~get_mm_hiwater_xxx-trivial-s-define-inline include/linux/sched.h
--- a/include/linux/sched.h~get_mm_hiwater_xxx-trivial-s-define-inline
+++ a/include/linux/sched.h
@@ -391,8 +391,15 @@ extern void arch_unmap_area_topdown(stru
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
-#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
-#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
+static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
+{
+	return max(mm->hiwater_rss, get_mm_rss(mm));
+}
+
+static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
+{
+	return max(mm->hiwater_vm, mm->total_vm);
+}
 
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

