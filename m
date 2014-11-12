From: akpm@linux-foundation.org
Subject: + proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch added to -mm tree
Date: Wed, 12 Nov 2014 14:56:22 -0800
Message-ID: <5463e596.NHtpchTvpnu3bBYq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLW4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: task_state: ptrace_parent() doesn't need pid_alive() check
has been added to the -mm tree.  Its filename is
     proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch

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
Subject: proc: task_state: ptrace_parent() doesn't need pid_alive() check

p->ptrace != 0 means that release_task(p) was not called, so pid_alive()
buys nothing and we can remove this check.  Other callers already use it
directly without additional checks.

Note: with or without this patch ptrace_parent() can return the pointer to
the freed task, this will be explained/fixed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/proc/array.c~proc-task_state-ptrace_parent-doesnt-need-pid_alive-check fs/proc/array.c
--- a/fs/proc/array.c~proc-task_state-ptrace_parent-doesnt-need-pid_alive-check
+++ a/fs/proc/array.c
@@ -157,19 +157,18 @@ static inline void task_state(struct seq
 	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
 	int g;
+	struct task_struct *tracer;
 	const struct cred *cred;
-	pid_t ppid, tpid, tgid, ngid;
+	pid_t ppid, tpid = 0, tgid, ngid;
 	unsigned int max_fds = 0;
 
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
-	tpid = 0;
-	if (pid_alive(p)) {
-		struct task_struct *tracer = ptrace_parent(p);
-		if (tracer)
-			tpid = task_pid_nr_ns(tracer, ns);
-	}
+
+	tracer = ptrace_parent(p);
+	if (tracer)
+		tpid = task_pid_nr_ns(tracer, ns);
 
 	tgid = task_tgid_nr_ns(p, ns);
 	ngid = task_numa_group_id(p);
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

