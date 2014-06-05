From: akpm@linux-foundation.org
Subject: [merged]
 kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch removed from -mm tree
Date: Thu, 05 Jun 2014 13:07:39 -0700
Message-ID: <5390ce0b.8dlByY/c5WS6HT+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaFEUHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, fweisbec@gmail.com, oleg@redhat.com

Subject: [merged] kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch removed from -mm tree
To: oleg@redhat.com,fweisbec@gmail.com,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:07:39 -0700


The patch titled
     Subject: kthreads: kill CLONE_KERNEL, change kernel_thread(kernel_init) to avoid CLONE_SIGHAND
has been removed from the -mm tree.  Its filename was
     kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kthreads: kill CLONE_KERNEL, change kernel_thread(kernel_init) to avoid CLONE_SIGHAND

1. Remove CLONE_KERNEL, it has no users and it is dangerous.

   The (old) comment says "List of flags we want to share for kernel
   threads" but this is not true, we do not want to share ->sighand by
   default. This flag can only be used if the caller is sure that both
   parent/child will never play with signals (say, allow_signal/etc).

2. Change rest_init() to clone kernel_init() without CLONE_SIGHAND.

   In this case CLONE_SIGHAND does not really hurt, and it looks like
   optimization because copy_sighand() can avoid kmem_cache_alloc().

   But in fact this only adds the minor pessimization. kernel_init()
   is going to exec the init process, and de_thread() will need to
   unshare ->sighand and do kmem_cache_alloc(sighand_cachep) anyway,
   but it needs to do more work and take tasklist_lock and siglock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ------
 init/main.c           |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN include/linux/sched.h~kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand include/linux/sched.h
--- a/include/linux/sched.h~kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand
+++ a/include/linux/sched.h
@@ -137,12 +137,6 @@ struct filename;
 #define VMACACHE_MASK (VMACACHE_SIZE - 1)
 
 /*
- * List of flags we want to share for kernel threads,
- * if only because they are not used by them anyway.
- */
-#define CLONE_KERNEL	(CLONE_FS | CLONE_FILES | CLONE_SIGHAND)
-
-/*
  * These are the constant used to fake the fixed-point load-average
  * counting. Some notes:
  *  - 11 bit fractions expand to 22 bits by the multiplies: this gives
diff -puN init/main.c~kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand init/main.c
--- a/init/main.c~kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand
+++ a/init/main.c
@@ -380,7 +380,7 @@ static noinline void __init_refok rest_i
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */
-	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
+	kernel_thread(kernel_init, NULL, CLONE_FS);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb.patch
signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

