From: akpm@linux-foundation.org
Subject: - minimize-lockdep_on-off-side-effect.patch removed from -mm tree
Date: Thu, 08 Feb 2007 15:32:28 -0800
Message-ID: <200702082332.l18NWShs030683@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161019AbXBHXco (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 18:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: compudj@krystal.dyndns.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     minimize lockdep_on/off side-effect
has been removed from the -mm tree.  Its filename was
     minimize-lockdep_on-off-side-effect.patch

This patch was dropped because it was folded into order-of-lockdep-off-on-in-vprintk-should-be-changed.patch

------------------------------------------------------
Subject: minimize lockdep_on/off side-effect
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

Minimize lockdep_on/off side-effect on irq tracing in vprintk by using
raw_local_irq_save/restore _around_ lockdep_off/on().

It has the advantage of not losing the IRQ events coming between the lockdep
disabling and the irq disabling.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk.c~minimize-lockdep_on-off-side-effect kernel/printk.c
--- a/kernel/printk.c~minimize-lockdep_on-off-side-effect
+++ a/kernel/printk.c
@@ -529,8 +529,8 @@ asmlinkage int vprintk(const char *fmt, 
 		zap_locks();
 
 	/* This stops the holder of console_sem just where we want him */
+	raw_local_irq_save(flags);
 	lockdep_off();
-	local_irq_save(flags);
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
 
@@ -617,8 +617,8 @@ asmlinkage int vprintk(const char *fmt, 
 			console_locked = 0;
 			up(&console_sem);
 		}
-		local_irq_restore(flags);
 		lockdep_on();
+		raw_local_irq_restore(flags);
 	} else {
 		/*
 		 * Someone else owns the drivers.  We drop the spinlock, which
@@ -627,8 +627,8 @@ asmlinkage int vprintk(const char *fmt, 
 		 */
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
-		local_irq_restore(flags);
 		lockdep_on();
+		raw_local_irq_restore(flags);
 	}
 
 	preempt_enable();
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

origin.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
