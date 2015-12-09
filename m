From: akpm@linux-foundation.org
Subject: + printk-nmi-use-irq-work-only-when-ready.patch added to -mm tree
Date: Wed, 09 Dec 2015 15:50:30 -0800
Message-ID: <5668be46.3v1f60WVSbYM//ZS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbbLIXub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 18:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, benh@kernel.crashing.org, daniel.thompson@linaro.org, davem@davemloft.net, jack@suse.cz, jkosina@suse.com, mingo@redhat.com, peterz@infradead.org, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, rostedt@goodmis.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/nmi: use IRQ work only when ready
has been added to the -mm tree.  Its filename is
     printk-nmi-use-irq-work-only-when-ready.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-nmi-use-irq-work-only-when-ready.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-nmi-use-irq-work-only-when-ready.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk/nmi: use IRQ work only when ready

NMIs could happen at any time.  This patch makes sure that the safe
printk() in NMI will schedule IRQ work only when the related structs are
initialized.

All pending messages are flushed when the IRQ work is being initialized.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jiri Kosina <jkosina@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN kernel/printk/nmi.c~printk-nmi-use-irq-work-only-when-ready kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-use-irq-work-only-when-ready
+++ a/kernel/printk/nmi.c
@@ -38,6 +38,7 @@
  * were handled or when IRQs are blocked.
  */
 DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
+static int printk_nmi_irq_ready;
 
 #define NMI_LOG_BUF_LEN (4096 - sizeof(atomic_t) - sizeof(struct irq_work))
 
@@ -83,8 +84,11 @@ again:
 		goto again;
 
 	/* Get flushed in a more safe context. */
-	if (add)
+	if (add && printk_nmi_irq_ready) {
+		/* Make sure that IRQ work is really initialized. */
+		smp_rmb();
 		irq_work_queue(&s->work);
+	}
 
 	return add;
 }
@@ -190,6 +194,13 @@ void __init printk_nmi_init(void)
 
 		init_irq_work(&s->work, __printk_nmi_flush);
 	}
+
+	/* Make sure that IRQ works are initialized before enabling. */
+	smp_wmb();
+	printk_nmi_irq_ready = 1;
+
+	/* Flush pending messages that did not have scheduled IRQ works. */
+	printk_nmi_flush();
 }
 
 void printk_nmi_enter(void)
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch
printk-nmi-use-irq-work-only-when-ready.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch

