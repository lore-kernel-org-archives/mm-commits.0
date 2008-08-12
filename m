From: akpm@linux-foundation.org
Subject: - printk-robustify-printk.patch removed from -mm tree
Date: Tue, 12 Aug 2008 01:07:00 -0700
Message-ID: <200808120807.m7C870xK014377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYHLIHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 04:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com, srostedt@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     printk: robustify printk
has been removed from the -mm tree.  Its filename was
     printk-robustify-printk.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Avoid deadlocks against rq->lock and xtime_lock by using RCU to defer
the klogd wakeup.

[akpm@linux-foundation.org: make klogd_wakeup_state static]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-robustify-printk kernel/printk.c
--- a/kernel/printk.c~printk-robustify-printk
+++ a/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 
@@ -982,10 +983,37 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+struct klogd_wakeup_state {
+	struct rcu_head head;
+	int pending;
+};
+
+static DEFINE_PER_CPU(struct klogd_wakeup_state, kws);
+
+void __wake_up_klogd(struct rcu_head *head)
+{
+	struct klogd_wakeup_state *kws =
+		container_of(head, struct klogd_wakeup_state, head);
+
+	wake_up_interruptible(&log_wait);
+	kws->pending = 0;
+}
+
 void wake_up_klogd(void)
 {
-	if (!oops_in_progress && waitqueue_active(&log_wait))
-		wake_up_interruptible(&log_wait);
+	unsigned long flags;
+	struct klogd_wakeup_state *kws;
+
+	if (!waitqueue_active(&log_wait))
+		return;
+
+	local_irq_save(flags);
+	kws = &__get_cpu_var(kws);
+	if (!kws->pending) {
+		kws->pending = 1;
+		call_rcu(&kws->head, __wake_up_klogd);
+	}
+	local_irq_restore(flags);
 }
 
 /**
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
printk-robustify-printk.patch
linux-next.patch
sched-type-fix.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
lockdep-shrink-held_lock-structure.patch
lockdep-shrink-held_lock-structure-fix.patch
lockdep-shrink-held_lock-structure-fix-2.patch
lockdep-map_acquire.patch
lockdep-lock-protection-locks.patch
lockdep-spin_lock_nest_lock.patch
lockdep-spin_lock_nest_lock-fix.patch
lockdep-spin_lock_nest_lock-fix-checkpatch-fixes.patch
lockdep-annotate-mm_take_all_locks.patch
lockdep-handle-chains-involving-classes-defined-in-modules.patch
mm-fix-mm_take_all_locks-locking-order.patch
irq-warn-about-irqf_disabledirqf_shared.patch

