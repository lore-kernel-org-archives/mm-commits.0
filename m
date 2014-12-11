From: akpm@linux-foundation.org
Subject: [merged]
 proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:58:11 -0800
Message-ID: <5489e943.TYfXpyhLYUf/g72A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbaLKS6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: task_state: ptrace_parent() doesn't need pid_alive() check
has been removed from the -mm tree.  Its filename was
     proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

