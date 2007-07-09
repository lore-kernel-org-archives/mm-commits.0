From: akpm@linux-foundation.org
Subject: - zs-move-to-the-serial-subsystem-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:51:08 -0700
Message-ID: <200707092151.l69Lp8wg014314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654AbXGIVvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     zs: updates to fix issues raised
has been removed from the -mm tree.  Its filename was
     zs-move-to-the-serial-subsystem-update.patch

This patch was dropped because it was folded into zs-move-to-the-serial-subsystem.patch

------------------------------------------------------
Subject: zs: updates to fix issues raised
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a set of fixes to the initial revision of the zs driver port to the
serial subsystem.  They include an update to the recovery delay, and the
race on interrupt handler registration.  As well as a number of style fixes
throughout.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/zs.c |   75 +++++++++++++++++++++++-------------------
 drivers/serial/zs.h |    2 -
 2 files changed, 43 insertions(+), 34 deletions(-)

diff -puN drivers/serial/zs.c~zs-move-to-the-serial-subsystem-update drivers/serial/zs.c
--- a/drivers/serial/zs.c~zs-move-to-the-serial-subsystem-update
+++ a/drivers/serial/zs.c
@@ -47,11 +47,13 @@
 #define SUPPORT_SYSRQ
 #endif
 
+#include <linux/bug.h>
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irqflags.h>
 #include <linux/kernel.h>
@@ -62,8 +64,7 @@
 #include <linux/sysrq.h>
 #include <linux/tty.h>
 
-#include <asm/bug.h>
-#include <asm/io.h>
+#include <asm/atomic.h>
 #include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
@@ -86,11 +87,10 @@ static char zs_version[] __initdata = "0
 #define ZS_CHAN_B	1		/* Index of the channel B.  */
 #define ZS_CHAN_IO_SIZE 8		/* IOMEM space size.  */
 #define ZS_CHAN_IO_STRIDE 4		/* Register alignment.  */
-#define ZS_CHAN_IO_OFFSET 1		/* The SCC resides on the high byte						   of the 16-bit IOBUS.  */
+#define ZS_CHAN_IO_OFFSET 1		/* The SCC resides on the high byte
+					   of the 16-bit IOBUS.  */
 #define ZS_CLOCK        7372800 	/* Z85C30 PCLK input clock rate.  */
 
-#define RECOVERY_DELAY  udelay(2)
-
 #define to_zport(uport) container_of(uport, struct zs_port, port)
 
 struct zs_parms {
@@ -126,53 +126,59 @@ static u8 zs_init_regs[ZS_NUM_REGS] __in
 /*
  * Reading and writing Z85C30 registers.
  */
-static inline u8 read_zsreg(struct zs_port *zport, int reg)
+static void recovery_delay(void)
+{
+	udelay(2);
+}
+
+static u8 read_zsreg(struct zs_port *zport, int reg)
 {
-	volatile void __iomem *control = zport->port.membase +
-					 ZS_CHAN_IO_OFFSET;
+	void __iomem *control = zport->port.membase + ZS_CHAN_IO_OFFSET;
 	u8 retval;
 
 	if (reg != 0) {
 		writeb(reg & 0xf, control);
-		fast_iob(); RECOVERY_DELAY;
+		fast_iob();
+		recovery_delay();
 	}
 	retval = readb(control);
-	RECOVERY_DELAY;
+	recovery_delay();
 	return retval;
 }
 
-static inline void write_zsreg(struct zs_port *zport, int reg, u8 value)
+static void write_zsreg(struct zs_port *zport, int reg, u8 value)
 {
-	volatile void __iomem *control = zport->port.membase +
-					 ZS_CHAN_IO_OFFSET;
+	void __iomem *control = zport->port.membase + ZS_CHAN_IO_OFFSET;
 
 	if (reg != 0) {
 		writeb(reg & 0xf, control);
-		fast_iob(); RECOVERY_DELAY;
+		fast_iob(); recovery_delay();
 	}
 	writeb(value, control);
-	fast_iob(); RECOVERY_DELAY;
+	fast_iob();
+	recovery_delay();
 	return;
 }
 
-static inline u8 read_zsdata(struct zs_port *zport)
+static u8 read_zsdata(struct zs_port *zport)
 {
-	volatile void __iomem *data = zport->port.membase +
-				      ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
+	void __iomem *data = zport->port.membase +
+			     ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
 	u8 retval;
 
 	retval = readb(data);
-	RECOVERY_DELAY;
+	recovery_delay();
 	return retval;
 }
 
-static inline void write_zsdata(struct zs_port *zport, u8 value)
+static void write_zsdata(struct zs_port *zport, u8 value)
 {
-	volatile void __iomem *data = zport->port.membase +
-				      ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
+	void __iomem *data = zport->port.membase +
+			     ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
 
 	writeb(value, data);
-	fast_iob(); RECOVERY_DELAY;
+	fast_iob();
+	recovery_delay();
 	return;
 }
 
@@ -196,7 +202,7 @@ void zs_dump(void)
 #endif
 
 
-static inline void zs_spin_lock_cond_irq(spinlock_t* lock, int irq)
+static void zs_spin_lock_cond_irq(spinlock_t *lock, int irq)
 {
 	if (irq)
 		spin_lock_irq(lock);
@@ -204,7 +210,7 @@ static inline void zs_spin_lock_cond_irq
 		spin_lock(lock);
 }
 
-static inline void zs_spin_unlock_cond_irq(spinlock_t* lock, int irq)
+static void zs_spin_unlock_cond_irq(spinlock_t *lock, int irq)
 {
 	if (irq)
 		spin_unlock_irq(lock);
@@ -235,7 +241,7 @@ static int zs_transmit_drain(struct zs_p
 }
 
 
-static inline void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
+static void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
 {
 	zs_transmit_drain(zport, irq);
 	/* Load 'em up.  */
@@ -288,8 +294,8 @@ static unsigned int zs_tx_empty(struct u
 	return status & ALL_SNT ? TIOCSER_TEMT : 0;
 }
 
-static inline unsigned int zs_raw_get_ab_mctrl(struct zs_port *zport_a,
-					       struct zs_port *zport_b)
+static unsigned int zs_raw_get_ab_mctrl(struct zs_port *zport_a,
+					struct zs_port *zport_b)
 {
 	u8 status_a, status_b;
 	unsigned int mctrl;
@@ -728,18 +734,20 @@ static int zs_startup(struct uart_port *
 	struct zs_port *zport = to_zport(uport);
 	struct zs_scc *scc = zport->scc;
 	unsigned long flags;
+	int irq_guard;
 	int ret;
 
-	if (!scc->irq_guard) {
+	irq_guard = atomic_add_return(1, &scc->irq_guard);
+	if (irq_guard == 1) {
 		ret = request_irq(zport->port.irq, zs_interrupt,
 				  IRQF_SHARED, "scc", scc);
 		if (ret) {
+			atomic_add(-1, &scc->irq_guard);
 			printk(KERN_ERR "zs: can't get irq %d\n",
 			       zport->port.irq);
 			return ret;
 		}
 	}
-	scc->irq_guard++;
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
@@ -780,6 +788,7 @@ static void zs_shutdown(struct uart_port
 	struct zs_port *zport = to_zport(uport);
 	struct zs_scc *scc = zport->scc;
 	unsigned long flags;
+	int irq_guard;
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
@@ -790,8 +799,8 @@ static void zs_shutdown(struct uart_port
 
 	spin_unlock_irqrestore(&scc->zlock, flags);
 
-	scc->irq_guard--;
-	if (!scc->irq_guard)
+	irq_guard = atomic_add_return(-1, &scc->irq_guard);
+	if (!irq_guard)
 		free_irq(zport->port.irq, scc);
 }
 
@@ -1203,7 +1212,7 @@ static int __init zs_init(void)
 {
 	int i, ret;
 
-	printk("%s%s\n", zs_name, zs_version);
+	pr_info("%s%s\n", zs_name, zs_version);
 
 	/* Find out how many Z85C30 SCCs we have.  */
 	ret = zs_probe_sccs();
diff -puN drivers/serial/zs.h~zs-move-to-the-serial-subsystem-update drivers/serial/zs.h
--- a/drivers/serial/zs.h~zs-move-to-the-serial-subsystem-update
+++ a/drivers/serial/zs.h
@@ -39,7 +39,7 @@ struct zs_port {
 struct zs_scc {
 	struct zs_port	zport[2];
 	spinlock_t	zlock;
-	int		irq_guard;
+	atomic_t	irq_guard;
 	int		initialised;
 };
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

zs-move-to-the-serial-subsystem.patch
zs-move-to-the-serial-subsystem-update.patch
zsc-drain-the-transmission-line.patch
tgafb-actually-allocate-memory-for-the-pseudo_palette.patch
