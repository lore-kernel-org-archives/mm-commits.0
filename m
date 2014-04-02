From: akpm@linux-foundation.org
Subject: +
 pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null.patch added
 to -mm tree
Date: Wed, 02 Apr 2014 14:23:06 -0700
Message-ID: <533c7fba.wMVjMC2jCTk49VmG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867AbaDBVXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2014 17:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mdempsky@chromium.org, mcgrathr@chromium.org, keescook@chromium.org, jln@chromium.org, jan.kratochvil@redhat.com, ebiederm@xmission.com, oleg@redhat.com

Subject: + pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null.patch added to -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,jan.kratochvil@redhat.com,jln@chromium.org,keescook@chromium.org,mcgrathr@chromium.org,mdempsky@chromium.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 02 Apr 2014 14:23:06 -0700


The patch titled
     Subject: pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
has been added to the -mm tree.  Its filename is
     pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null.patch

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
Subject: pid_namespace: pidns_get() should check task_active_pid_ns() != NULL

pidns_get()->get_pid_ns() can hit ns == NULL. This task_struct can't
go away, but task_active_pid_ns(task) is NULL if release_task(task)
was already called. Alternatively we could change get_pid_ns(ns) to
check ns != NULL, but it seems that other callers are fine.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Dempsky <mdempsky@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Julien Tinnes <jln@chromium.org>
Cc: Roland McGrath <mcgrathr@chromium.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null
+++ a/kernel/pid_namespace.c
@@ -318,7 +318,9 @@ static void *pidns_get(struct task_struc
 	struct pid_namespace *ns;
 
 	rcu_read_lock();
-	ns = get_pid_ns(task_active_pid_ns(task));
+	ns = task_active_pid_ns(task);
+	if (ns)
+		get_pid_ns(ns);
 	rcu_read_unlock();
 
 	return ns;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
pid_namespace-pidns_get-should-check-task_active_pid_ns-=-null.patch
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
proc-show-mnt_id-in-proc-pid-fdinfo.patch
procfs-make-proc-stacksyscallpersonality-0400.patch
procfs-make-proc-pagemap-0400.patch
exec-kill-bprm-tcomm-simplify-the-basename-logic.patch
wait-fix-reparent_leader-vs-exit_dead-exit_zombie-race.patch
wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch
wait-use-exit_trace-only-if-thread_group_leaderzombie.patch
wait-completely-ignore-the-exit_dead-tasks.patch
wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch
wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch
wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch
linux-next.patch

