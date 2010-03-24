From: akpm@linux-foundation.org
Subject: + kernel-irq-managec-add-raise_threaded_irq.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:39:11 -0700
Message-ID: <201003241839.o2OIdCEk018631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab0CXSjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/irq/manage.c: add raise_threaded_irq()
has been added to the -mm tree.  Its filename is
     kernel-irq-managec-add-raise_threaded_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/irq/manage.c: add raise_threaded_irq()
From: Christian Pellegrin <chripell@fsfe.org>

raise_threaded_irq() schedules the execution of an interrupt thread.

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
@@ -144,6 +144,9 @@ request_threaded_irq(unsigned int irq, i
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
@@ -1106,3 +1106,30 @@ int request_threaded_irq(unsigned int ir
 	return retval;
 }
 EXPORT_SYMBOL(request_threaded_irq);
+
+/**
+ *	raise_threaded_irq - triggers a threded interrupt
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
_

Patches currently in -mm which might be from chripell@fsfe.org are

kernel-irq-managec-add-raise_threaded_irq.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-move-to-threaded-interrupt.patch
max3100-add-console-support-for-max3100.patch
max3100-to_max3100_port-small-style-fixes.patch
max3100-to_max3100_port-small-style-fixes-fix.patch

