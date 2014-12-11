From: akpm@linux-foundation.org
Subject: [merged] sched_show_task-fix-unsafe-usage-of-real_parent.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:14 -0800
Message-ID: <5489e946.lOUa4C8mz6oycrM7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbaLKS6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sched_show_task: fix unsafe usage of ->real_parent
has been removed from the -mm tree.  Its filename was
     sched_show_task-fix-unsafe-usage-of-real_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4527,8 +4527,10 @@ void sched_show_task(struct task_struct
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

