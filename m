From: akpm@linux-foundation.org
Subject: + generic-irqs-enable-polling-for-disabled-screaming-irqs.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:41:25 -0700
Message-ID: <200807111847.m6BIl5A2031048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbYGKSr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de


The patch titled
     generic irqs: enable polling for disabled screaming irqs
has been added to the -mm tree.  Its filename is
     generic-irqs-enable-polling-for-disabled-screaming-irqs.patch

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
Subject: generic irqs: enable polling for disabled screaming irqs
From: Eric W. Biederman <ebiederm@xmission.com>

When we disable a screaming irq we never see it again.  If the irq line is
shared or if the driver half works this is a real pain.  So periodically poll
the handlers for screaming interrupts.

I use a timer instead of the classic irq poll technique of working off the
timer interrupt because when we use the local apic timers note_interrupt is
never called (bug?).  Further on a system with dynamic ticks the timer
interrupt might not even fire unless there is a timer telling it it needs to.

I forced this case on my test system with an e1000 nic and my ssh session
remained responsive despite the interrupt handler only being called every 10th
of a second.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/spurious.c |  147 +++++++++++++++++++++++++---------------
 1 file changed, 92 insertions(+), 55 deletions(-)

diff -puN kernel/irq/spurious.c~generic-irqs-enable-polling-for-disabled-screaming-irqs kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~generic-irqs-enable-polling-for-disabled-screaming-irqs
+++ a/kernel/irq/spurious.c
@@ -12,83 +12,118 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/timer.h>
 
 static int irqfixup __read_mostly;
 
+#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
+static void poll_spurious_irqs(unsigned long dummy);
+static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
+
 /*
  * Recovery handler for misrouted interrupts.
  */
-static int misrouted_irq(int irq)
+static int try_one_irq(int irq, struct irq_desc *desc)
 {
-	int i;
+	struct irqaction *action;
 	int ok = 0;
 	int work = 0;	/* Did we do work for a real IRQ */
 
-	for (i = 1; i < NR_IRQS; i++) {
-		struct irq_desc *desc = irq_desc + i;
-		struct irqaction *action;
-
-		if (i == irq)	/* Already tried */
-			continue;
-
-		spin_lock(&desc->lock);
-		/* Already running on another processor */
-		if (desc->status & IRQ_INPROGRESS) {
-			/*
-			 * Already running: If it is shared get the other
-			 * CPU to go looking for our mystery interrupt too
-			 */
-			if (desc->action && (desc->action->flags & IRQF_SHARED))
-				desc->status |= IRQ_PENDING;
-			spin_unlock(&desc->lock);
-			continue;
-		}
-		/* Honour the normal IRQ locking */
-		desc->status |= IRQ_INPROGRESS;
-		action = desc->action;
+	spin_lock(&desc->lock);
+	/* Already running on another processor */
+	if (desc->status & IRQ_INPROGRESS) {
+		/*
+		 * Already running: If it is shared get the other
+		 * CPU to go looking for our mystery interrupt too
+		 */
+		if (desc->action && (desc->action->flags & IRQF_SHARED))
+			desc->status |= IRQ_PENDING;
 		spin_unlock(&desc->lock);
+		return ok;
+	}
+	/* Honour the normal IRQ locking */
+	desc->status |= IRQ_INPROGRESS;
+	action = desc->action;
+	spin_unlock(&desc->lock);
 
-		while (action) {
-			/* Only shared IRQ handlers are safe to call */
-			if (action->flags & IRQF_SHARED) {
-				if (action->handler(i, action->dev_id) ==
-						IRQ_HANDLED)
-					ok = 1;
-			}
-			action = action->next;
+	while (action) {
+		/* Only shared IRQ handlers are safe to call */
+		if (action->flags & IRQF_SHARED) {
+			if (action->handler(irq, action->dev_id) ==
+				IRQ_HANDLED)
+				ok = 1;
 		}
-		local_irq_disable();
-		/* Now clean up the flags */
-		spin_lock(&desc->lock);
-		action = desc->action;
+		action = action->next;
+	}
+	local_irq_disable();
+	/* Now clean up the flags */
+	spin_lock(&desc->lock);
+	action = desc->action;
 
+	/*
+	 * While we were looking for a fixup someone queued a real
+	 * IRQ clashing with our walk:
+	 */
+	while ((desc->status & IRQ_PENDING) && action) {
 		/*
-		 * While we were looking for a fixup someone queued a real
-		 * IRQ clashing with our walk:
-		 */
-		while ((desc->status & IRQ_PENDING) && action) {
-			/*
-			 * Perform real IRQ processing for the IRQ we deferred
-			 */
-			work = 1;
-			spin_unlock(&desc->lock);
-			handle_IRQ_event(i, action);
-			spin_lock(&desc->lock);
-			desc->status &= ~IRQ_PENDING;
-		}
-		desc->status &= ~IRQ_INPROGRESS;
-		/*
-		 * If we did actual work for the real IRQ line we must let the
-		 * IRQ controller clean up too
+		 * Perform real IRQ processing for the IRQ we deferred
 		 */
-		if (work && desc->chip && desc->chip->end)
-			desc->chip->end(i);
+		work = 1;
 		spin_unlock(&desc->lock);
+		handle_IRQ_event(irq, action);
+		spin_lock(&desc->lock);
+		desc->status &= ~IRQ_PENDING;
+	}
+	desc->status &= ~IRQ_INPROGRESS;
+	/*
+	 * If we did actual work for the real IRQ line we must let the
+	 * IRQ controller clean up too
+	 */
+	if (work && desc->chip && desc->chip->end)
+		desc->chip->end(irq);
+	spin_unlock(&desc->lock);
+
+	return ok;
+
+}
+
+static int misrouted_irq(int irq)
+{
+	int i;
+	int ok = 0;
+
+ 	for (i = 1; i < NR_IRQS; i++) {
+		struct irq_desc *desc = irq_desc + i;
+
+		if (i == irq)	/* Already tried */
+			continue;
+
+		if (try_one_irq(i, desc))
+			ok = 1;
 	}
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
 
+static void poll_spurious_irqs(unsigned long dummy)
+{
+	int i;
+	for (i = 1; i < NR_IRQS; i++) {
+		struct irq_desc *desc = irq_desc + i;
+		unsigned int status;
+
+		/* Racy but it doesn't matter */
+		status = desc->status;
+		barrier();
+		if (!(status & IRQ_SPURIOUS_DISABLED))
+			continue;
+
+		try_one_irq(i, desc);
+	}
+
+	mod_timer(&poll_spurious_irq_timer, jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
+}
+
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
@@ -212,6 +247,8 @@ void note_interrupt(unsigned int irq, st
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
 		desc->chip->disable(irq);
+
+		mod_timer(&poll_spurious_irq_timer, jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 	}
 	desc->irqs_unhandled = 0;
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
generic-irqs-enable-polling-for-disabled-screaming-irqs.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
sysctl-check-for-bogus-modes.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
kernel-kexecc-make-kimage_terminate-void.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

