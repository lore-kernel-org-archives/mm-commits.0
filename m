From: akpm@linux-foundation.org
Subject: + exit-move-check_stack_usage-to-the-end-of-do_exit.patch added
 to -mm tree
Date: Mon, 17 Mar 2014 15:30:28 -0700
Message-ID: <53277784.cCsbdUnwGq/6ZYLu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaCQWa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Mar 2014 18:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: + exit-move-check_stack_usage-to-the-end-of-do_exit.patch added to -mm tree
To: oleg@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 17 Mar 2014 15:30:28 -0700


The patch titled
     Subject: exit: move check_stack_usage() to the end of do_exit()
has been added to the -mm tree.  Its filename is
     exit-move-check_stack_usage-to-the-end-of-do_exit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-move-check_stack_usage-to-the-end-of-do_exit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-move-check_stack_usage-to-the-end-of-do_exit.patch

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
Subject: exit: move check_stack_usage() to the end of do_exit()

It is not clear why check_stack_usage() is called so early and thus it
never checks the stack usage in, say, exit_notify() or
flush_ptrace_hw_breakpoint() or other functions which are only called by
do_exit().

Move the callsite down to the last preempt_disable/schedule.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exit-move-check_stack_usage-to-the-end-of-do_exit kernel/exit.c
--- a/kernel/exit.c~exit-move-check_stack_usage-to-the-end-of-do_exit
+++ a/kernel/exit.c
@@ -788,7 +788,6 @@ void do_exit(long code)
 		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
-	check_stack_usage();
 	exit_thread();
 
 	/*
@@ -842,6 +841,7 @@ void do_exit(long code)
 
 	validate_creds_for_do_exit(tsk);
 
+	check_stack_usage();
 	preempt_disable();
 	if (tsk->nr_dirtied)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-ensure-locality-of-task_struct-allocations.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-4.patch
mm-per-thread-vma-caching-fix-6.patch
mm-per-thread-vma-caching-fix-6-fix.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
exit-call-disassociate_ctty-before-exit_task_namespaces.patch
exit-move-check_stack_usage-to-the-end-of-do_exit.patch
exitc-call-proc_exit_connector-after-exit_state-is-set.patch
wait-fix-reparent_leader-vs-exit_dead-exit_zombie-race.patch
wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch
wait-use-exit_trace-only-if-thread_group_leaderzombie.patch
wait-completely-ignore-the-exit_dead-tasks.patch
wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch
wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch
wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch
linux-next.patch

