From: akpm@linux-foundation.org
Subject: + pi-futex-set-pf_exiting-without-taking-pi_lock.patch added to -mm tree
Date: Thu, 02 Aug 2007 14:46:01 -0700
Message-ID: <200708022146.l72Lk1nR010842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbXHBVq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 17:46:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu


The patch titled
     pi-futex: set PF_EXITING without taking ->pi_lock
has been added to the -mm tree.  Its filename is
     pi-futex-set-pf_exiting-without-taking-pi_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pi-futex: set PF_EXITING without taking ->pi_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

It is a bit annoying that do_exit() takes ->pi_lock to set PF_EXITING.  All
we need is to synchronize with lookup_pi_state() which saw this task
without PF_EXITING under ->pi_lock.

Change do_exit() to use spin_unlock_wait().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~pi-futex-set-pf_exiting-without-taking-pi_lock kernel/exit.c
--- a/kernel/exit.c~pi-futex-set-pf_exiting-without-taking-pi_lock
+++ a/kernel/exit.c
@@ -944,13 +944,13 @@ fastcall NORET_TYPE void do_exit(long co
 		schedule();
 	}
 
+	tsk->flags |= PF_EXITING;
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.
 	 */
-	spin_lock_irq(&tsk->pi_lock);
-	tsk->flags |= PF_EXITING;
-	spin_unlock_irq(&tsk->pi_lock);
+	smp_mb();
+	spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
