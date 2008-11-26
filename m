From: akpm@linux-foundation.org
Subject: + pps-low-level-irq-timestamps-recording.patch added to -mm tree
Date: Wed, 26 Nov 2008 15:53:37 -0800
Message-ID: <200811262353.mAQNrcF9013196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYKZXyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 18:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@gmail.com, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     PPS: low level IRQ timestamps recording
has been added to the -mm tree.  Its filename is
     pps-low-level-irq-timestamps-recording.patch

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
Subject: PPS: low level IRQ timestamps recording
From: Rodolfo Giometti <giometti@linux.it>

Add low level IRQ timestamps recording for x86 (32 and 64 bits) platforms
and enable UART clients in order to use it.

This improves PPS precision. :)

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/irq_32.c    |   16 ++++++++++++++++
 arch/x86/kernel/irq_64.c    |   21 +++++++++++++++++++--
 drivers/pps/Kconfig         |   12 ++++++++++++
 include/linux/pps.h         |    1 +
 include/linux/serial_core.h |    7 ++++++-
 5 files changed, 54 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/irq_32.c~pps-low-level-irq-timestamps-recording arch/x86/kernel/irq_32.c
--- a/arch/x86/kernel/irq_32.c~pps-low-level-irq-timestamps-recording
+++ a/arch/x86/kernel/irq_32.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/pps.h>
 
 #include <asm/apic.h>
 #include <asm/uaccess.h>
@@ -25,6 +26,11 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+struct timespec pps_irq_ts[NR_IRQS];
+EXPORT_SYMBOL(pps_irq_ts);
+#endif
+
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 /* Debugging check for stack overflow: is there less than 1KB free? */
 static int check_stack_overflow(void)
@@ -204,7 +210,12 @@ unsigned int do_IRQ(struct pt_regs *regs
 	unsigned vector = ~regs->orig_ax;
 	struct irq_desc *desc;
 	unsigned irq;
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	struct timespec ts;
 
+	/* Get IRQ timestamps as soon as possible for the PPS layer */
+	getnstimeofday(&ts);
+#endif
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
@@ -219,6 +230,11 @@ unsigned int do_IRQ(struct pt_regs *regs
 		BUG();
 	}
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	/* Then, after sanity check, store the IRQ timestamp */
+	pps_irq_ts[irq] = ts;
+#endif
+
 	if (!execute_on_irq_stack(overflow, desc, irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
diff -puN arch/x86/kernel/irq_64.c~pps-low-level-irq-timestamps-recording arch/x86/kernel/irq_64.c
--- a/arch/x86/kernel/irq_64.c~pps-low-level-irq-timestamps-recording
+++ a/arch/x86/kernel/irq_64.c
@@ -17,6 +17,12 @@
 #include <asm/io_apic.h>
 #include <asm/idle.h>
 #include <asm/smp.h>
+#include <linux/pps.h>
+
+#ifdef CONFIG_PPS_IRQ_EVENTS
+struct timespec pps_irq_ts[NR_IRQS];
+EXPORT_SYMBOL(pps_irq_ts);
+#endif
 
 /*
  * Probabilistic stack overflow check:
@@ -49,6 +55,12 @@ asmlinkage unsigned int do_IRQ(struct pt
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct irq_desc *desc;
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	struct timespec ts;
+
+	/* Get IRQ timestamps as soon as possible for the PPS layer */
+	getnstimeofday(&ts);
+#endif
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
@@ -61,9 +73,14 @@ asmlinkage unsigned int do_IRQ(struct pt
 	stack_overflow_check(regs);
 
 	desc = irq_to_desc(irq);
-	if (likely(desc))
+	if (likely(desc)) {
+#ifdef CONFIG_PPS_IRQ_EVENTS
+		/* Then, after sanity check, store the IRQ timestamp */
+		pps_irq_ts[irq] = ts;
+#endif
+
 		generic_handle_irq_desc(irq, desc);
-	else {
+	} else {
 		if (!disable_apic)
 			ack_APIC_irq();
 
diff -puN drivers/pps/Kconfig~pps-low-level-irq-timestamps-recording drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-low-level-irq-timestamps-recording
+++ a/drivers/pps/Kconfig
@@ -22,6 +22,18 @@ config PPS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
 
+config PPS_IRQ_EVENTS
+	bool "Use low level IRQ timestamps"
+	depends on PPS && (X86_32 || X86_64)
+	default yes
+	help
+	  Say Y here if you wish using low level IRQ timestamps to register
+	  PPS events.
+
+	  This should improve PPS resolution but it delays echo functions
+	  call. Note also that this function is not implemented on all
+	  platforms and PPS clients!
+
 config PPS_DEBUG
 	bool "PPS debugging messages"
 	depends on PPS
diff -puN include/linux/pps.h~pps-low-level-irq-timestamps-recording include/linux/pps.h
--- a/include/linux/pps.h~pps-low-level-irq-timestamps-recording
+++ a/include/linux/pps.h
@@ -181,6 +181,7 @@ struct pps_device {
 
 extern spinlock_t pps_idr_lock;
 extern struct idr pps_idr;
+extern struct timespec pps_irq_ts[];
 
 extern struct device_attribute pps_attrs[];
 
diff -puN include/linux/serial_core.h~pps-low-level-irq-timestamps-recording include/linux/serial_core.h
--- a/include/linux/serial_core.h~pps-low-level-irq-timestamps-recording
+++ a/include/linux/serial_core.h
@@ -175,6 +175,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/pps.h>
 
 struct uart_port;
 struct uart_info;
@@ -506,7 +507,11 @@ uart_handle_dcd_change(struct uart_port 
 	struct timespec ts;
 
 	if (ld && ld->ops->dcd_change)
+#ifdef CONFIG_PPS_IRQ_EVENTS
+		ts = pps_irq_ts[port->irq];
+#else
 		getnstimeofday(&ts);
+#endif
 
 	port->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
@@ -522,7 +527,7 @@ uart_handle_dcd_change(struct uart_port 
 	}
 
 	if (ld && ld->ops->dcd_change)
-		ld->ops->dcd_change(port, status, &ts);
+		ld->ops->dcd_change(info->port.tty, status, &ts);
 	if (ld)
 		tty_ldisc_deref(ld);
 }
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

