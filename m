From: akpm@linux-foundation.org
Subject: + sched_show_task-fix-unsafe-usage-of-real_parent.patch added to
 -mm tree
Date: Wed, 12 Nov 2014 14:56:24 -0800
Message-ID: <5463e598.9N41HT/q+BAl2vOu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLW4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sched_show_task: fix unsafe usage of ->real_parent
has been added to the -mm tree.  Its filename is
     sched_show_task-fix-unsafe-usage-of-real_parent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched_show_task-fix-unsafe-usage-of-real_parent.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/sched_show_task-fix-unsafe-usage-of-real_parent.patch

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
Subject: sched_show_task: fix unsafe usage of ->real_parent

rcu_read_lock() can not protect p->real_parent if release_task(p) was
already called, change sched_show_task() to check pis_alive() like other
users do.

Note: we need some helpers to cleanup the code like this.  And it seems
that that the usage of cpu_curr(cpu) in dump_cpu_task() is not safe too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/sched/core.c~sched_show_task-fix-unsafe-usage-of-real_parent kernel/sched/core.c
--- a/kernel/sched/core.c~sched_show_task-fix-unsafe-usage-of-real_parent
+++ a/kernel/sched/core.c
@@ -4572,8 +4572,10 @@ void sched_show_task(struct task_struct
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
+	ppid = 0;
 	rcu_read_lock();
-	ppid = task_pid_nr(rcu_dereference(p->real_parent));
+	if (pid_alive(p))
+		ppid = task_pid_nr(rcu_dereference(p->real_parent));
 	rcu_read_unlock();
 	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
 		task_pid_nr(p), ppid,
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
linux-next.patch

