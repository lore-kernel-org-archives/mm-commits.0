From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-irq-managec-add-raise_threaded_irq.patch removed from -mm tree
Date: Tue, 27 Apr 2010 14:39:05 -0700
Message-ID: <201004272139.o3RLd6Wb021642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879Ab0D0Vkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 17:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/irq/manage.c: add raise_threaded_irq()
has been removed from the -mm tree.  Its filename was
     kernel-irq-managec-add-raise_threaded_irq.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/irq/manage.c: add raise_threaded_irq()
From: Christian Pellegrin <chripell@fsfe.org>

raise_threaded_irq() schedules the execution of an interrupt thread.

[akpm@linux-foundation.org: fix comment typo]
Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN include/linux/interrupt.h~kernel-irq-managec-add-raise_threaded_irq include/linux/interrupt.h
--- a/include/linux/interrupt.h~kernel-irq-managec-add-raise_threaded_irq
+++ a/include/linux/interrupt.h
@@ -168,6 +168,9 @@ request_any_context_irq(unsigned int irq
 static inline void exit_irq_thread(void) { }
 #endif
 
+extern int raise_threaded_irq(unsigned int irq);
+
+
 extern void free_irq(unsigned int, void *);
 
 struct device;
diff -puN kernel/irq/manage.c~kernel-irq-managec-add-raise_threaded_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-irq-managec-add-raise_threaded_irq
+++ a/kernel/irq/manage.c
@@ -1092,6 +1092,33 @@ int request_threaded_irq(unsigned int ir
 EXPORT_SYMBOL(request_threaded_irq);
 
 /**
+ *	raise_threaded_irq - triggers a threaded interrupt
+ *	@irq: Interrupt line to trigger
+ */
+int raise_threaded_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action;
+
+	if (!desc)
+		return -ENOENT;
+	action = desc->action;
+	if (!action)
+		return -ENOENT;
+	if (unlikely(!action->thread_fn))
+		return -EINVAL;
+	if (likely(!test_bit(IRQTF_DIED,
+			     &action->thread_flags))) {
+		set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+		wake_up_process(action->thread);
+	} else {
+		return -ECHILD;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(raise_threaded_irq);
+
+/**
  *	request_any_context_irq - allocate an interrupt line
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs.
_

Patches currently in -mm which might be from chripell@fsfe.org are

linux-next.patch
kernel-irq-managec-add-raise_threaded_irq.patch
max3100-move-to-threaded-interrupt.patch
max3100-add-console-support-for-max3100.patch
max3100-to_max3100_port-small-style-fixes.patch
max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console.patch

