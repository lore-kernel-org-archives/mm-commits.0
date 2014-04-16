From: akpm@linux-foundation.org
Subject: +
 kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch added to -mm tree
Date: Wed, 16 Apr 2014 15:30:02 -0700
Message-ID: <534f046a.NvM6ewPxNtW90j1K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPWaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, fweisbec@gmail.com, oleg@redhat.com

Subject: + kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch added to -mm tree
To: oleg@redhat.com,fweisbec@gmail.com,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:30:02 -0700


The patch titled
     Subject: kthreads: kill CLONE_KERNEL, change kernel_thread(kernel_init) to avoid CLONE_SIGHAND
has been added to the -mm tree.  Its filename is
     kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch

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

mmvmacache-optimize-overflow-system-wide-flushing.patch
kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch
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

