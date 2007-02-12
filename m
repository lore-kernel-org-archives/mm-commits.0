From: akpm@linux-foundation.org
Subject: - debug-shared-irqs.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:35 -0800
Message-ID: <200702122243.l1CMhZDP013514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030336AbXBLWrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, arjan@infradead.org, bunk@stusta.de, jesper.juhl@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Debug shared irqs
has been removed from the -mm tree.  Its filename was
     debug-shared-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Debug shared irqs
From: David Woodhouse <dwmw2@infradead.org>

Drivers registering IRQ handlers with SA_SHIRQ really ought to be able to
handle an interrupt happening before request_irq() returns.  They also
ought to be able to handle an interrupt happening during the start of their
call to free_irq().  Let's test that hypothesis....

[bunk@stusta.de: Kconfig fixes]
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   33 +++++++++++++++++++++++++++++++++
 lib/Kconfig.debug   |    9 +++++++++
 2 files changed, 42 insertions(+)

diff -puN kernel/irq/manage.c~debug-shared-irqs kernel/irq/manage.c
--- a/kernel/irq/manage.c~debug-shared-irqs
+++ a/kernel/irq/manage.c
@@ -357,6 +357,7 @@ void free_irq(unsigned int irq, void *de
 	struct irq_desc *desc;
 	struct irqaction **p;
 	unsigned long flags;
+	irqreturn_t (*handler)(int, void *) = NULL;
 
 	WARN_ON(in_interrupt());
 	if (irq >= NR_IRQS)
@@ -396,6 +397,8 @@ void free_irq(unsigned int irq, void *de
 
 			/* Make sure it's not being used on another CPU */
 			synchronize_irq(irq);
+			if (action->flags & IRQF_SHARED)
+				handler = action->handler;
 			kfree(action);
 			return;
 		}
@@ -403,6 +406,17 @@ void free_irq(unsigned int irq, void *de
 		spin_unlock_irqrestore(&desc->lock, flags);
 		return;
 	}
+#ifdef CONFIG_DEBUG_SHIRQ
+	if (handler) {
+		/*
+		 * It's a shared IRQ -- the driver ought to be prepared for it
+		 * to happen even now it's being freed, so let's make sure....
+		 * We do this after actually deregistering it, to make sure that
+		 * a 'real' IRQ doesn't run in parallel with our fake
+		 */
+		handler(irq, dev_id);
+	}
+#endif
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -475,6 +489,25 @@ int request_irq(unsigned int irq, irq_ha
 
 	select_smp_affinity(irq);
 
+#ifdef CONFIG_DEBUG_SHIRQ
+	if (irqflags & IRQF_SHARED) {
+		/*
+		 * It's a shared IRQ -- the driver ought to be prepared for it
+		 * to happen immediately, so let's make sure....
+		 * We do this before actually registering it, to make sure that
+		 * a 'real' IRQ doesn't run in parallel with our fake
+		 */
+		if (irqflags & IRQF_DISABLED) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			handler(irq, dev_id);
+			local_irq_restore(flags);
+		} else
+			handler(irq, dev_id);
+	}
+#endif
+
 	retval = setup_irq(irq, action);
 	if (retval)
 		kfree(action);
diff -puN lib/Kconfig.debug~debug-shared-irqs lib/Kconfig.debug
--- a/lib/Kconfig.debug~debug-shared-irqs
+++ a/lib/Kconfig.debug
@@ -77,6 +77,15 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config DEBUG_SHIRQ
+	bool "Debug shared IRQ handlers"
+	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	help
+	  Enable this to generate a spurious interrupt as soon as a shared
+	  interrupt handler is registered, and just before one is deregistered.
+	  Drivers ought to be able to handle interrupts coming in at those
+	  points; some don't and need to be caught.
+
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
 	range 12 21
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
new-toplevel-target-headers_check_all.patch
git-mtd.patch
