From: akpm@linux-foundation.org
Subject: + irq_noprobe-helper-functions.patch added to -mm tree
Date: Wed, 06 Feb 2008 09:59:29 -0800
Message-ID: <200802061759.m16HxAoP023153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYBFSAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 13:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, rob@landley.net


The patch titled
     IRQ_NOPROBE helper functions
has been added to the -mm tree.  Its filename is
     irq_noprobe-helper-functions.patch

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
Subject: IRQ_NOPROBE helper functions
From: Ralf Baechle <ralf@linux-mips.org>

Probing non-ISA interrupts using the handle_percpu_irq as their handle_irq
method may crash the system because handle_percpu_irq does not check
IRQ_WAITING.  This for example hits the MIPS Qemu configuration.

This patch provides two helper functions set_irq_noprobe and set_irq_probe to
set rsp.  clear the IRQ_NOPROBE flag.  The only current caller is MIPS code
but this really belongs into generic code.

As an aside, interrupt probing these days has become a mostly obsolete if not
dangerous art.  I think Linux interrupts should be changed to default to
non-probing but that's subject of this patch.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-and-tested-by: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    3 +++
 kernel/irq/chip.c   |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff -puN include/linux/irq.h~irq_noprobe-helper-functions include/linux/irq.h
--- a/include/linux/irq.h~irq_noprobe-helper-functions
+++ a/include/linux/irq.h
@@ -367,6 +367,9 @@ set_irq_chained_handler(unsigned int irq
 	__set_irq_handler(irq, handle, 1, NULL);
 }
 
+extern void set_irq_noprobe(unsigned int irq);
+extern void set_irq_probe(unsigned int irq);
+
 /* Handle dynamic irq creation and destruction */
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
diff -puN kernel/irq/chip.c~irq_noprobe-helper-functions kernel/irq/chip.c
--- a/kernel/irq/chip.c~irq_noprobe-helper-functions
+++ a/kernel/irq/chip.c
@@ -589,3 +589,39 @@ set_irq_chip_and_handler_name(unsigned i
 	set_irq_chip(irq, chip);
 	__set_irq_handler(irq, handle, 0, name);
 }
+
+void __init set_irq_noprobe(unsigned int irq)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
+
+		return;
+	}
+
+	desc = irq_desc + irq;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->status |= IRQ_NOPROBE;
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
+
+void __init set_irq_probe(unsigned int irq)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
+
+		return;
+	}
+
+	desc = irq_desc + irq;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->status &= ~IRQ_NOPROBE;
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
remove-inclusions-of-linux-autoconfh.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
calibrate_delay-must-be-__cpuinit.patch
mips-use-find_task_by_vpid-in-system-calls.patch
git-watchdog.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
avoid-overflows-in-kernel-timec.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
