From: akpm@linux-foundation.org
Subject: + exit-call-disassociate_ctty-before-exit_task_namespaces.patch
 added to -mm tree
Date: Mon, 17 Mar 2014 15:30:27 -0700
Message-ID: <53277783.GGBZqjRpr9MKMb26%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaCQWa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Mar 2014 18:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, sreeharsha@totakura.in, peter@hurleysoftware.com, mingo@elte.hu, jdike@addtoit.com, ebiederm@xmission.com, avagin@openvz.org, oleg@redhat.com

Subject: + exit-call-disassociate_ctty-before-exit_task_namespaces.patch added to -mm tree
To: oleg@redhat.com,avagin@openvz.org,ebiederm@xmission.com,jdike@addtoit.com,mingo@elte.hu,peter@hurleysoftware.com,sreeharsha@totakura.in,stable@vger.kernel.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 17 Mar 2014 15:30:27 -0700


The patch titled
     Subject: exit: call disassociate_ctty() before exit_task_namespaces()
has been added to the -mm tree.  Its filename is
     exit-call-disassociate_ctty-before-exit_task_namespaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-call-disassociate_ctty-before-exit_task_namespaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-call-disassociate_ctty-before-exit_task_namespaces.patch

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
Subject: exit: call disassociate_ctty() before exit_task_namespaces()

8aac62706ada ("move exit_task_namespaces() outside of exit_notify()")
breaks pppd and the exiting service crashes the kernel:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
    IP: [<ffffffffa06985a3>] ppp_register_channel+0x13/0x20 [ppp_generic]
    ...
    Call Trace:
     [<ffffffffa06ab2ab>] ? ppp_asynctty_open+0x12b/0x170 [ppp_async]
     [<ffffffff812ec907>] ? tty_ldisc_open.isra.2+0x27/0x60
     [<ffffffff812ed1d3>] ? tty_ldisc_hangup+0x1e3/0x220
     [<ffffffff812e4614>] ? __tty_hangup+0x2c4/0x440
     [<ffffffff812e56a1>] ? disassociate_ctty+0x61/0x270
     [<ffffffff810483c2>] ? do_exit+0x7f2/0xa50

ppp_register_channel() needs ->net_ns and current->nsproxy == NULL.

Move disassociate_ctty() before exit_task_namespaces(), it doesn't make
sense to delay it after perf_event_exit_task() or cgroup_exit().

This also allows to use task_work_add() inside the (nontrivial) code
paths in disassociate_ctty().

Investigated by Peter Hurley.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[v3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~exit-call-disassociate_ctty-before-exit_task_namespaces kernel/exit.c
--- a/kernel/exit.c~exit-call-disassociate_ctty-before-exit_task_namespaces
+++ a/kernel/exit.c
@@ -784,6 +784,8 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
+	if (group_dead)
+		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	check_stack_usage();
@@ -799,13 +801,9 @@ void do_exit(long code)
 
 	cgroup_exit(tsk, 1);
 
-	if (group_dead)
-		disassociate_ctty(1);
-
 	module_put(task_thread_info(tsk)->exec_domain->module);
 
 	proc_exit_connector(tsk);
-
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
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

