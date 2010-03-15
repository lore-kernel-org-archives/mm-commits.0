From: akpm@linux-foundation.org
Subject: [merged] copy_signal-cleanup-clean-thread_group_cputime_init.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:25 -0400
Message-ID: <201003150701.o2F71wrK016827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935852Ab0COHCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vfalico@redhat.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     copy_signal() cleanup: clean thread_group_cputime_init()
has been removed from the -mm tree.  Its filename was
     copy_signal-cleanup-clean-thread_group_cputime_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_signal() cleanup: clean thread_group_cputime_init()
From: Veaceslav Falico <vfalico@redhat.com>

Remove unneeded initializations in thread_group_cputime_init() and in
posix_cpu_timers_init_group().  They are useless after kmem_cache_zalloc()
was used in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 kernel/fork.c         |   11 -----------
 2 files changed, 13 deletions(-)

diff -puN include/linux/sched.h~copy_signal-cleanup-clean-thread_group_cputime_init include/linux/sched.h
--- a/include/linux/sched.h~copy_signal-cleanup-clean-thread_group_cputime_init
+++ a/include/linux/sched.h
@@ -2391,9 +2391,7 @@ void thread_group_cputimer(struct task_s
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	sig->cputimer.cputime = INIT_CPUTIME;
 	spin_lock_init(&sig->cputimer.lock);
-	sig->cputimer.running = 0;
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
diff -puN kernel/fork.c~copy_signal-cleanup-clean-thread_group_cputime_init kernel/fork.c
--- a/kernel/fork.c~copy_signal-cleanup-clean-thread_group_cputime_init
+++ a/kernel/fork.c
@@ -833,17 +833,6 @@ static void posix_cpu_timers_init_group(
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
-	/* Expiration times and increments. */
-	sig->it[CPUCLOCK_PROF].expires = cputime_zero;
-	sig->it[CPUCLOCK_PROF].incr = cputime_zero;
-	sig->it[CPUCLOCK_VIRT].expires = cputime_zero;
-	sig->it[CPUCLOCK_VIRT].incr = cputime_zero;
-
-	/* Cached expiration times. */
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
