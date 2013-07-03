From: akpm@linux-foundation.org
Subject: [merged] softirq-use-_ret_ip_.patch removed from -mm tree
Date: Wed, 03 Jul 2013 12:32:25 -0700
Message-ID: <51d47c49.bsVRn2tuiri2PL3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3GCTcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 15:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, fweisbec@gmail.com, davidlohr.bueso@hp.com

Subject: [merged] softirq-use-_ret_ip_.patch removed from -mm tree
To: davidlohr.bueso@hp.com,fweisbec@gmail.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 12:32:25 -0700


The patch titled
     Subject: softirq: use _RET_IP_
has been removed from the -mm tree.  Its filename was
     softirq-use-_ret_ip_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: softirq: use _RET_IP_

Use the already defined macro to pass the function return address.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/softirq.c~softirq-use-_ret_ip_ kernel/softirq.c
--- a/kernel/softirq.c~softirq-use-_ret_ip_
+++ a/kernel/softirq.c
@@ -127,8 +127,7 @@ static inline void __local_bh_disable(un
 
 void local_bh_disable(void)
 {
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_DISABLE_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(local_bh_disable);
@@ -139,7 +138,7 @@ static void __local_bh_enable(unsigned i
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (softirq_count() == cnt)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+		trace_softirqs_on(_RET_IP_);
 	sub_preempt_count(cnt);
 }
 
@@ -184,7 +183,7 @@ static inline void _local_bh_enable_ip(u
 
 void local_bh_enable(void)
 {
-	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	_local_bh_enable_ip(_RET_IP_);
 }
 EXPORT_SYMBOL(local_bh_enable);
 
@@ -229,8 +228,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2.patch
ipc-remove-unused-functions.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
ipc-semc-cacheline-align-the-semaphore-structures.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix.patch
ipc-semc-always-use-only-one-queue-for-alter-operations.patch
ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch
ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch

