From: akpm@linux-foundation.org
Subject: + printk-robustify-printk.patch added to -mm tree
Date: Fri, 08 Aug 2008 12:08:24 -0700
Message-ID: <200808081908.m78J8OYw023820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198AbYHHTIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 15:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, srostedt@redhat.com, torvalds@linux-foundation.org


The patch titled
     printk: robustify printk
has been added to the -mm tree.  Its filename is
     printk-robustify-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Avoid deadlocks against rq->lock and xtime_lock by using RCU to defer
the klogd wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
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
+DEFINE_PER_CPU(struct klogd_wakeup_state, kws);
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
mm-fix-mm_take_all_locks-locking-order.patch
printk-robustify-printk-fix.patch

