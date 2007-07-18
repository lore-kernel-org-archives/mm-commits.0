From: akpm@linux-foundation.org
Subject: - zs-move-to-the-serial-subsystem.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:02 -0700
Message-ID: <200707181852.l6IIq2tc023636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762745AbXGRSxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     zs: move to the serial subsystem
has been removed from the -mm tree.  Its filename was
     zs-move-to-the-serial-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: zs: move to the serial subsystem
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a reimplementation of the zs driver for the serial subsystem.  Any
resemblance to the old driver is purely coincidential.  ;-) I do hope I got
the handling of modem lines right -- better do not tackle me about the
issue unless you feel too good...

Any users of the old driver: please note the numbers of the serial lines
have now been swapped, i.e.  ttyS0 <-> ttyS1 and ttyS2 <-> ttyS3.  It has
to do with the modem lines mentioned above; basically the port A in a given
chip has to be initialised before the port B if you want to use the latter
as the serial console (which is usually the case), as operations on modem
lines of the serial line associated with the port B access both ports (see
the comment at the top of the driver for the details of wiring used). 
Please update your scripts.

This is also the reason each SCC now requests an IRQ once only (as seen in
"/proc/interrupts") -- the handler takes care of both ports at once as the
line associated with the port B has to take status update interrupts from
both ports (and yet the line of the port A takes its own for itself too). 
The old driver never got it right...

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                   |    5 
 drivers/char/Kconfig          |   33 
 drivers/char/decserial.c      |   67 
 drivers/serial/Kconfig        |   30 
 drivers/serial/Makefile       |    1 
 drivers/serial/zs.c           | 1287 ++++++++++++++++++
 drivers/serial/zs.h           |  284 ++++
 drivers/tc/Makefile           |    1 
 drivers/tc/zs.c               | 2203 --------------------------------
 drivers/tc/zs.h               |  404 -----
 include/asm-mips/dec/serial.h |   36 
 include/linux/serial_core.h   |    5 
 12 files changed, 1610 insertions(+), 2746 deletions(-)

diff -puN MAINTAINERS~zs-move-to-the-serial-subsystem MAINTAINERS
--- a/MAINTAINERS~zs-move-to-the-serial-subsystem
+++ a/MAINTAINERS
@@ -4110,6 +4110,11 @@ W:	http://www.polyware.nl/~middelin/En/h
 W:	http://www.polyware.nl/~middelin/hobbies.html
 S:	Maintained
 
+ZS DECSTATION Z85C30 SERIAL DRIVER
+P:	Maciej W. Rozycki
+M:	macro@linux-mips.org
+S:	Maintained
+
 THE REST
 P:	Linus Torvalds
 S:	Buried alive in reporters
diff -puN drivers/char/Kconfig~zs-move-to-the-serial-subsystem drivers/char/Kconfig
--- a/drivers/char/Kconfig~zs-move-to-the-serial-subsystem
+++ a/drivers/char/Kconfig
@@ -372,39 +372,6 @@ config ISTALLION
 	  To compile this driver as a module, choose M here: the
 	  module will be called istallion.
 
-config SERIAL_DEC
-	bool "DECstation serial support"
-	depends on MACH_DECSTATION
-	default y
-	help
-	  This selects whether you want to be asked about drivers for
-	  DECstation serial ports.
-
-	  Note that the answer to this question won't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about DECstation serial ports.
-
-config SERIAL_DEC_CONSOLE
-	bool "Support for console on a DECstation serial port"
-	depends on SERIAL_DEC
-	default y
-	help
-	  If you say Y here, it will be possible to use a serial port as the
-	  system console (the system console is the device which receives all
-	  kernel messages and warnings and which allows logins in single user
-	  mode).  Note that the firmware uses ttyS0 as the serial console on
-	  the Maxine and ttyS2 on the others.
-
-	  If unsure, say Y.
-
-config ZS
-	bool "Z85C30 Serial Support"
-	depends on SERIAL_DEC
-	default y
-	help
-	  Documentation on the Zilog 85C350 serial communications controller
-	  is downloadable at <http://www.zilog.com/pdfs/serial/z85c30.pdf>
-
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
diff -puN drivers/char/decserial.c~zs-move-to-the-serial-subsystem /dev/null
--- a/drivers/char/decserial.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * sercons.c
- *      choose the right serial device at boot time
- *
- * triemer 6-SEP-1998
- *      sercons.c is designed to allow the three different kinds 
- *      of serial devices under the decstation world to co-exist
- *      in the same kernel.  The idea here is to abstract 
- *      the pieces of the drivers that are common to this file
- *      so that they do not clash at compile time and runtime.
- *
- * HK 16-SEP-1998 v0.002
- *      removed the PROM console as this is not a real serial
- *      device. Added support for PROM console in drivers/char/tty_io.c
- *      instead. Although it may work to enable more than one 
- *      console device I strongly recommend to use only one.
- */
-
-#include <linux/init.h>
-#include <asm/dec/machtype.h>
-
-#ifdef CONFIG_ZS
-extern int zs_init(void);
-#endif
-
-#ifdef CONFIG_SERIAL_CONSOLE
-
-#ifdef CONFIG_ZS
-extern void zs_serial_console_init(void);
-#endif
-
-#endif
-
-/* rs_init - starts up the serial interface -
-   handle normal case of starting up the serial interface */
-
-#ifdef CONFIG_SERIAL
-
-int __init rs_init(void)
-{
-#ifdef CONFIG_ZS
-    if (IOASIC)
-	return zs_init();
-#endif
-    return -ENXIO;
-}
-
-__initcall(rs_init);
-
-#endif
-
-#ifdef CONFIG_SERIAL_CONSOLE
-
-/* serial_console_init handles the special case of starting
- *   up the console on the serial port
- */
-static int __init decserial_console_init(void)
-{
-#ifdef CONFIG_ZS
-    if (IOASIC)
-	zs_serial_console_init();
-#endif
-    return 0;
-}
-console_initcall(decserial_console_init);
-
-#endif
diff -puN drivers/serial/Kconfig~zs-move-to-the-serial-subsystem drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~zs-move-to-the-serial-subsystem
+++ a/drivers/serial/Kconfig
@@ -486,6 +486,36 @@ config SERIAL_DZ_CONSOLE
 
 	  If unsure, say Y.
 
+config SERIAL_ZS
+	tristate "DECstation Z85C30 serial support"
+	depends on MACH_DECSTATION
+	select SERIAL_CORE
+	default y
+	---help---
+	  Support for the Zilog 85C350 serial communications controller used
+	  for serial ports in newer DECstation systems.  These include the
+	  DECsystem 5900 and all models of the DECstation and DECsystem 5000
+	  systems except from model 200.
+
+	  If unsure, say Y.  To compile this driver as a module, choose M here:
+	  the module will be called zs.
+
+config SERIAL_ZS_CONSOLE
+	bool "Support for console on a DECstation Z85C30 serial port"
+	depends on SERIAL_ZS=y
+	select SERIAL_CORE_CONSOLE
+	default y
+	---help---
+	  If you say Y here, it will be possible to use a serial port as the
+	  system console (the system console is the device which receives all
+	  kernel messages and warnings and which allows logins in single user
+	  mode).
+
+	  Note that the firmware uses ttyS1 as the serial console on the
+	  Maxine and ttyS3 on the others using this driver.
+
+	  If unsure, say Y.
+
 config SERIAL_21285
 	tristate "DC21285 serial port support"
 	depends on ARM && FOOTBRIDGE
diff -puN drivers/serial/Makefile~zs-move-to-the-serial-subsystem drivers/serial/Makefile
--- a/drivers/serial/Makefile~zs-move-to-the-serial-subsystem
+++ a/drivers/serial/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_V850E_UART) += v850e_uart.o
 obj-$(CONFIG_SERIAL_PMACZILOG) += pmac_zilog.o
 obj-$(CONFIG_SERIAL_LH7A40X) += serial_lh7a40x.o
 obj-$(CONFIG_SERIAL_DZ) += dz.o
+obj-$(CONFIG_SERIAL_ZS) += zs.o
 obj-$(CONFIG_SERIAL_SH_SCI) += sh-sci.o
 obj-$(CONFIG_SERIAL_SGI_L1_CONSOLE) += sn_console.o
 obj-$(CONFIG_SERIAL_CPM) += cpm_uart/
diff -puN /dev/null drivers/serial/zs.c
--- /dev/null
+++ a/drivers/serial/zs.c
@@ -0,0 +1,1287 @@
+/*
+ * zs.c: Serial port driver for IOASIC DECstations.
+ *
+ * Derived from drivers/sbus/char/sunserial.c by Paul Mackerras.
+ * Derived from drivers/macintosh/macserial.c by Harald Koerfgen.
+ *
+ * DECstation changes
+ * Copyright (C) 1998-2000 Harald Koerfgen
+ * Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2007  Maciej W. Rozycki
+ *
+ * For the rest of the code the original Copyright applies:
+ * Copyright (C) 1996 Paul Mackerras (Paul.Mackerras@cs.anu.edu.au)
+ * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
+ *
+ *
+ * Note: for IOASIC systems the wiring is as follows:
+ *
+ * mouse/keyboard:
+ * DIN-7 MJ-4  signal        SCC
+ * 2     1     TxD       <-  A.TxD
+ * 3     4     RxD       ->  A.RxD
+ *
+ * EIA-232/EIA-423:
+ * DB-25 MMJ-6 signal        SCC
+ * 2     2     TxD       <-  B.TxD
+ * 3     5     RxD       ->  B.RxD
+ * 4           RTS       <- ~A.RTS
+ * 5           CTS       -> ~B.CTS
+ * 6     6     DSR       -> ~A.SYNC
+ * 8           CD        -> ~B.DCD
+ * 12          DSRS(DCE) -> ~A.CTS  (*)
+ * 15          TxC       ->  B.TxC
+ * 17          RxC       ->  B.RxC
+ * 20    1     DTR       <- ~A.DTR
+ * 22          RI        -> ~A.DCD
+ * 23          DSRS(DTE) <- ~B.RTS
+ *
+ * (*) EIA-232 defines the signal at this pin to be SCD, while DSRS(DCE)
+ *     is shared with DSRS(DTE) at pin 23.
+ *
+ * As you can immediately notice the wiring of the RTS, DTR and DSR signals
+ * is a bit odd.  This makes the handling of port B unnecessarily
+ * complicated and prevents the use of some automatic modes of operation.
+ */
+
+#if defined(CONFIG_SERIAL_ZS_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
+#include <linux/bug.h>
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irqflags.h>
+#include <linux/kernel.h>
+#include <linux/major.h>
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+#include <linux/spinlock.h>
+#include <linux/sysrq.h>
+#include <linux/tty.h>
+#include <linux/types.h>
+
+#include <asm/atomic.h>
+#include <asm/system.h>
+
+#include <asm/dec/interrupts.h>
+#include <asm/dec/ioasic_addrs.h>
+#include <asm/dec/system.h>
+
+#include "zs.h"
+
+
+MODULE_AUTHOR("Maciej W. Rozycki <macro@linux-mips.org>");
+MODULE_DESCRIPTION("DECstation Z85C30 serial driver");
+MODULE_LICENSE("GPL");
+
+
+static char zs_name[] __initdata = "DECstation Z85C30 serial driver version ";
+static char zs_version[] __initdata = "0.10";
+
+/*
+ * It would be nice to dynamically allocate everything that
+ * depends on ZS_NUM_SCCS, so we could support any number of
+ * Z85C30s, but for now...
+ */
+#define ZS_NUM_SCCS	2		/* Max # of ZS chips supported.  */
+#define ZS_NUM_CHAN	2		/* 2 channels per chip.  */
+#define ZS_CHAN_A	0		/* Index of the channel A.  */
+#define ZS_CHAN_B	1		/* Index of the channel B.  */
+#define ZS_CHAN_IO_SIZE 8		/* IOMEM space size.  */
+#define ZS_CHAN_IO_STRIDE 4		/* Register alignment.  */
+#define ZS_CHAN_IO_OFFSET 1		/* The SCC resides on the high byte
+					   of the 16-bit IOBUS.  */
+#define ZS_CLOCK        7372800 	/* Z85C30 PCLK input clock rate.  */
+
+#define to_zport(uport) container_of(uport, struct zs_port, port)
+
+struct zs_parms {
+	resource_size_t scc[ZS_NUM_SCCS];
+	int irq[ZS_NUM_SCCS];
+};
+
+static struct zs_scc zs_sccs[ZS_NUM_SCCS];
+
+static u8 zs_init_regs[ZS_NUM_REGS] __initdata = {
+	0,				/* write 0 */
+	PAR_SPEC,			/* write 1 */
+	0,				/* write 2 */
+	0,				/* write 3 */
+	X16CLK | SB1,			/* write 4 */
+	0,				/* write 5 */
+	0, 0, 0,			/* write 6, 7, 8 */
+	MIE | DLC | NV,			/* write 9 */
+	NRZ,				/* write 10 */
+	TCBR | RCBR,			/* write 11 */
+	0, 0,				/* BRG time constant, write 12 + 13 */
+	BRSRC | BRENABL,		/* write 14 */
+	0,				/* write 15 */
+};
+
+/*
+ * Debugging.
+ */
+#undef ZS_DEBUG_REGS
+
+
+/*
+ * Reading and writing Z85C30 registers.
+ */
+static void recovery_delay(void)
+{
+	udelay(2);
+}
+
+static u8 read_zsreg(struct zs_port *zport, int reg)
+{
+	void __iomem *control = zport->port.membase + ZS_CHAN_IO_OFFSET;
+	u8 retval;
+
+	if (reg != 0) {
+		writeb(reg & 0xf, control);
+		fast_iob();
+		recovery_delay();
+	}
+	retval = readb(control);
+	recovery_delay();
+	return retval;
+}
+
+static void write_zsreg(struct zs_port *zport, int reg, u8 value)
+{
+	void __iomem *control = zport->port.membase + ZS_CHAN_IO_OFFSET;
+
+	if (reg != 0) {
+		writeb(reg & 0xf, control);
+		fast_iob(); recovery_delay();
+	}
+	writeb(value, control);
+	fast_iob();
+	recovery_delay();
+	return;
+}
+
+static u8 read_zsdata(struct zs_port *zport)
+{
+	void __iomem *data = zport->port.membase +
+			     ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
+	u8 retval;
+
+	retval = readb(data);
+	recovery_delay();
+	return retval;
+}
+
+static void write_zsdata(struct zs_port *zport, u8 value)
+{
+	void __iomem *data = zport->port.membase +
+			     ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
+
+	writeb(value, data);
+	fast_iob();
+	recovery_delay();
+	return;
+}
+
+#ifdef ZS_DEBUG_REGS
+void zs_dump(void)
+{
+	struct zs_port *zport;
+	int i, j;
+
+	for (i = 0; i < ZS_NUM_SCCS * ZS_NUM_CHAN; i++) {
+		zport = &zs_sccs[i / ZS_NUM_CHAN].zport[i % ZS_NUM_CHAN];
+
+		if (!zport->scc)
+			continue;
+
+		for (j = 0; j < 16; j++)
+			printk("W%-2d = 0x%02x\t", j, zport->regs[j]);
+		printk("\n");
+		for (j = 0; j < 16; j++)
+			printk("R%-2d = 0x%02x\t", j, read_zsreg(zport, j));
+		printk("\n\n");
+	}
+}
+#endif
+
+
+static void zs_spin_lock_cond_irq(spinlock_t *lock, int irq)
+{
+	if (irq)
+		spin_lock_irq(lock);
+	else
+		spin_lock(lock);
+}
+
+static void zs_spin_unlock_cond_irq(spinlock_t *lock, int irq)
+{
+	if (irq)
+		spin_unlock_irq(lock);
+	else
+		spin_unlock(lock);
+}
+
+static int zs_receive_drain(struct zs_port *zport)
+{
+	int loops = 10000;
+
+	while ((read_zsreg(zport, R0) & Rx_CH_AV) && loops--)
+		read_zsdata(zport);
+	return loops;
+}
+
+static int zs_transmit_drain(struct zs_port *zport, int irq)
+{
+	struct zs_scc *scc = zport->scc;
+	int loops = 10000;
+
+	while (!(read_zsreg(zport, R0) & Tx_BUF_EMP) && loops--) {
+		zs_spin_unlock_cond_irq(&scc->zlock, irq);
+		udelay(2);
+		zs_spin_lock_cond_irq(&scc->zlock, irq);
+	}
+	return loops;
+}
+
+static int zs_line_drain(struct zs_port *zport, int irq)
+{
+	struct zs_scc *scc = zport->scc;
+	int loops = 10000;
+
+	while (!(read_zsreg(zport, R1) & ALL_SNT) && loops--) {
+		zs_spin_unlock_cond_irq(&scc->zlock, irq);
+		udelay(2);
+		zs_spin_lock_cond_irq(&scc->zlock, irq);
+	}
+	return loops;
+}
+
+
+static void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
+{
+	/* Let the current transmission finish.  */
+	zs_line_drain(zport, irq);
+	/* Load 'em up.  */
+	write_zsreg(zport, R3, regs[3] & ~RxENABLE);
+	write_zsreg(zport, R5, regs[5] & ~TxENAB);
+	write_zsreg(zport, R4, regs[4]);
+	write_zsreg(zport, R9, regs[9]);
+	write_zsreg(zport, R1, regs[1]);
+	write_zsreg(zport, R2, regs[2]);
+	write_zsreg(zport, R10, regs[10]);
+	write_zsreg(zport, R14, regs[14] & ~BRENABL);
+	write_zsreg(zport, R11, regs[11]);
+	write_zsreg(zport, R12, regs[12]);
+	write_zsreg(zport, R13, regs[13]);
+	write_zsreg(zport, R14, regs[14]);
+	write_zsreg(zport, R15, regs[15]);
+	if (regs[3] & RxENABLE)
+		write_zsreg(zport, R3, regs[3]);
+	if (regs[5] & TxENAB)
+		write_zsreg(zport, R5, regs[5]);
+	return;
+}
+
+
+/*
+ * Status handling routines.
+ */
+
+/*
+ * zs_tx_empty() -- get the transmitter empty status
+ *
+ * Purpose: Let user call ioctl() to get info when the UART physically
+ * 	    is emptied.  On bus types like RS485, the transmitter must
+ * 	    release the bus after transmitting.  This must be done when
+ * 	    the transmit shift register is empty, not be done when the
+ * 	    transmit holding register is empty.  This functionality
+ * 	    allows an RS485 driver to be written in user space.
+ */
+static unsigned int zs_tx_empty(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	unsigned long flags;
+	u8 status;
+
+	spin_lock_irqsave(&scc->zlock, flags);
+	status = read_zsreg(zport, R1);
+	spin_unlock_irqrestore(&scc->zlock, flags);
+
+	return status & ALL_SNT ? TIOCSER_TEMT : 0;
+}
+
+static unsigned int zs_raw_get_ab_mctrl(struct zs_port *zport_a,
+					struct zs_port *zport_b)
+{
+	u8 status_a, status_b;
+	unsigned int mctrl;
+
+	status_a = read_zsreg(zport_a, R0);
+	status_b = read_zsreg(zport_b, R0);
+
+	mctrl = ((status_b & CTS) ? TIOCM_CTS : 0) |
+		((status_b & DCD) ? TIOCM_CAR : 0) |
+		((status_a & DCD) ? TIOCM_RNG : 0) |
+		((status_a & SYNC_HUNT) ? TIOCM_DSR : 0);
+
+	return mctrl;
+}
+
+static unsigned int zs_raw_get_mctrl(struct zs_port *zport)
+{
+	struct zs_port *zport_a = &zport->scc->zport[ZS_CHAN_A];
+
+	return zport != zport_a ? zs_raw_get_ab_mctrl(zport_a, zport) : 0;
+}
+
+static unsigned int zs_raw_xor_mctrl(struct zs_port *zport)
+{
+	struct zs_port *zport_a = &zport->scc->zport[ZS_CHAN_A];
+	unsigned int mmask, mctrl, delta;
+	u8 mask_a, mask_b;
+
+	if (zport == zport_a)
+		return 0;
+
+	mask_a = zport_a->regs[15];
+	mask_b = zport->regs[15];
+
+	mmask = ((mask_b & CTSIE) ? TIOCM_CTS : 0) |
+		((mask_b & DCDIE) ? TIOCM_CAR : 0) |
+		((mask_a & DCDIE) ? TIOCM_RNG : 0) |
+		((mask_a & SYNCIE) ? TIOCM_DSR : 0);
+
+	mctrl = zport->mctrl;
+	if (mmask) {
+		mctrl &= ~mmask;
+		mctrl |= zs_raw_get_ab_mctrl(zport_a, zport) & mmask;
+	}
+
+	delta = mctrl ^ zport->mctrl;
+	if (delta)
+		zport->mctrl = mctrl;
+
+	return delta;
+}
+
+static unsigned int zs_get_mctrl(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	unsigned int mctrl;
+
+	spin_lock(&scc->zlock);
+	mctrl = zs_raw_get_mctrl(zport);
+	spin_unlock(&scc->zlock);
+
+	return mctrl;
+}
+
+static void zs_set_mctrl(struct uart_port *uport, unsigned int mctrl)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	struct zs_port *zport_a = &scc->zport[ZS_CHAN_A];
+	u8 oldloop, newloop;
+
+	spin_lock(&scc->zlock);
+	if (zport != zport_a) {
+		if (mctrl & TIOCM_DTR)
+			zport_a->regs[5] |= DTR;
+		else
+			zport_a->regs[5] &= ~DTR;
+		if (mctrl & TIOCM_RTS)
+			zport_a->regs[5] |= RTS;
+		else
+			zport_a->regs[5] &= ~RTS;
+		write_zsreg(zport_a, R5, zport_a->regs[5]);
+	}
+
+	/* Rarely modified, so don't poke at hardware unless necessary. */
+	oldloop = zport->regs[14];
+	newloop = oldloop;
+	if (mctrl & TIOCM_LOOP)
+		newloop |= LOOPBAK;
+	else
+		newloop &= ~LOOPBAK;
+	if (newloop != oldloop) {
+		zport->regs[14] = newloop;
+		write_zsreg(zport, R14, zport->regs[14]);
+	}
+	spin_unlock(&scc->zlock);
+}
+
+static void zs_raw_stop_tx(struct zs_port *zport)
+{
+	write_zsreg(zport, R0, RES_Tx_P);
+	zport->tx_stopped = 1;
+}
+
+static void zs_stop_tx(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+
+	spin_lock(&scc->zlock);
+	zs_raw_stop_tx(zport);
+	spin_unlock(&scc->zlock);
+}
+
+static void zs_raw_transmit_chars(struct zs_port *);
+
+static void zs_start_tx(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+
+	spin_lock(&scc->zlock);
+	if (zport->tx_stopped) {
+		zs_transmit_drain(zport, 0);
+		zport->tx_stopped = 0;
+		zs_raw_transmit_chars(zport);
+	}
+	spin_unlock(&scc->zlock);
+}
+
+static void zs_stop_rx(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	struct zs_port *zport_a = &scc->zport[ZS_CHAN_A];
+
+	spin_lock(&scc->zlock);
+	zport->regs[15] &= ~BRKIE;
+	zport->regs[1] &= ~(RxINT_MASK | TxINT_ENAB);
+	zport->regs[1] |= RxINT_DISAB;
+
+	if (zport != zport_a) {
+		/* A-side DCD tracks RI and SYNC tracks DSR.  */
+		zport_a->regs[15] &= ~(DCDIE | SYNCIE);
+		write_zsreg(zport_a, R15, zport_a->regs[15]);
+		if (!(zport_a->regs[15] & BRKIE)) {
+			zport_a->regs[1] &= ~EXT_INT_ENAB;
+			write_zsreg(zport_a, R1, zport_a->regs[1]);
+		}
+
+		/* This-side DCD tracks DCD and CTS tracks CTS.  */
+		zport->regs[15] &= ~(DCDIE | CTSIE);
+		zport->regs[1] &= ~EXT_INT_ENAB;
+	} else {
+		/* DCD tracks RI and SYNC tracks DSR for the B side.  */
+		if (!(zport->regs[15] & (DCDIE | SYNCIE)))
+			zport->regs[1] &= ~EXT_INT_ENAB;
+	}
+
+	write_zsreg(zport, R15, zport->regs[15]);
+	write_zsreg(zport, R1, zport->regs[1]);
+	spin_unlock(&scc->zlock);
+}
+
+static void zs_enable_ms(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	struct zs_port *zport_a = &scc->zport[ZS_CHAN_A];
+
+	if (zport == zport_a)
+		return;
+
+	spin_lock(&scc->zlock);
+
+	/* Clear Ext interrupts if not being handled already.  */
+	if (!(zport_a->regs[1] & EXT_INT_ENAB))
+		write_zsreg(zport_a, R0, RES_EXT_INT);
+
+	/* A-side DCD tracks RI and SYNC tracks DSR.  */
+	zport_a->regs[1] |= EXT_INT_ENAB;
+	zport_a->regs[15] |= DCDIE | SYNCIE;
+
+	/* This-side DCD tracks DCD and CTS tracks CTS.  */
+	zport->regs[15] |= DCDIE | CTSIE;
+
+	zs_raw_xor_mctrl(zport);
+
+	write_zsreg(zport_a, R1, zport_a->regs[1]);
+	write_zsreg(zport_a, R15, zport_a->regs[15]);
+	write_zsreg(zport, R15, zport->regs[15]);
+	spin_unlock(&scc->zlock);
+}
+
+static void zs_break_ctl(struct uart_port *uport, int break_state)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&scc->zlock, flags);
+	if (break_state == -1)
+		zport->regs[5] |= SND_BRK;
+	else
+		zport->regs[5] &= ~SND_BRK;
+	write_zsreg(zport, R5, zport->regs[5]);
+	spin_unlock_irqrestore(&scc->zlock, flags);
+}
+
+
+/*
+ * Interrupt handling routines.
+ */
+#define Rx_BRK 0x0100			/* BREAK event software flag.  */
+#define Rx_SYS 0x0200			/* SysRq event software flag.  */
+
+static void zs_receive_chars(struct zs_port *zport)
+{
+	struct uart_port *uport = &zport->port;
+	struct zs_scc *scc = zport->scc;
+	struct uart_icount *icount;
+	unsigned int avail, status, ch, flag;
+	int count;
+
+	for (count = 16; count; count--) {
+		spin_lock(&scc->zlock);
+		avail = read_zsreg(zport, R0) & Rx_CH_AV;
+		spin_unlock(&scc->zlock);
+		if (!avail)
+			break;
+
+		spin_lock(&scc->zlock);
+		status = read_zsreg(zport, R1) & (Rx_OVR | FRM_ERR | PAR_ERR);
+		ch = read_zsdata(zport);
+		spin_unlock(&scc->zlock);
+
+		flag = TTY_NORMAL;
+
+		icount = &uport->icount;
+		icount->rx++;
+
+		/* Handle the null char got when BREAK is removed.  */
+		if (!ch)
+			status |= zport->tty_break;
+		if (unlikely(status &
+			     (Rx_OVR | FRM_ERR | PAR_ERR | Rx_SYS | Rx_BRK))) {
+			zport->tty_break = 0;
+
+			/* Reset the error indication.  */
+			if (status & (Rx_OVR | FRM_ERR | PAR_ERR)) {
+				spin_lock(&scc->zlock);
+				write_zsreg(zport, R0, ERR_RES);
+				spin_unlock(&scc->zlock);
+			}
+
+			if (status & (Rx_SYS | Rx_BRK)) {
+				icount->brk++;
+				/* SysRq discards the null char.  */
+				if (status & Rx_SYS)
+					continue;
+			} else if (status & FRM_ERR)
+				icount->frame++;
+			else if (status & PAR_ERR)
+				icount->parity++;
+			if (status & Rx_OVR)
+				icount->overrun++;
+
+			status &= uport->read_status_mask;
+			if (status & Rx_BRK)
+				flag = TTY_BREAK;
+			else if (status & FRM_ERR)
+				flag = TTY_FRAME;
+			else if (status & PAR_ERR)
+				flag = TTY_PARITY;
+		}
+
+		if (uart_handle_sysrq_char(uport, ch))
+			continue;
+
+		uart_insert_char(uport, status, Rx_OVR, ch, flag);
+	}
+
+	tty_flip_buffer_push(uport->info->tty);
+}
+
+static void zs_raw_transmit_chars(struct zs_port *zport)
+{
+	struct circ_buf *xmit = &zport->port.info->xmit;
+
+	/* XON/XOFF chars.  */
+	if (zport->port.x_char) {
+		write_zsdata(zport, zport->port.x_char);
+		zport->port.icount.tx++;
+		zport->port.x_char = 0;
+		return;
+	}
+
+	/* If nothing to do or stopped or hardware stopped.  */
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&zport->port)) {
+		zs_raw_stop_tx(zport);
+		return;
+	}
+
+	/* Send char.  */
+	write_zsdata(zport, xmit->buf[xmit->tail]);
+	xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+	zport->port.icount.tx++;
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&zport->port);
+
+	/* Are we are done?  */
+	if (uart_circ_empty(xmit))
+		zs_raw_stop_tx(zport);
+}
+
+static void zs_transmit_chars(struct zs_port *zport)
+{
+	struct zs_scc *scc = zport->scc;
+
+	spin_lock(&scc->zlock);
+	zs_raw_transmit_chars(zport);
+	spin_unlock(&scc->zlock);
+}
+
+static void zs_status_handle(struct zs_port *zport, struct zs_port *zport_a)
+{
+	struct uart_port *uport = &zport->port;
+	struct zs_scc *scc = zport->scc;
+	unsigned int delta;
+	u8 status, brk;
+
+	spin_lock(&scc->zlock);
+
+	/* Get status from Read Register 0.  */
+	status = read_zsreg(zport, R0);
+
+	if (zport->regs[15] & BRKIE) {
+		brk = status & BRK_ABRT;
+		if (brk && !zport->brk) {
+			spin_unlock(&scc->zlock);
+			if (uart_handle_break(uport))
+				zport->tty_break = Rx_SYS;
+			else
+				zport->tty_break = Rx_BRK;
+			spin_lock(&scc->zlock);
+		}
+		zport->brk = brk;
+	}
+
+	if (zport != zport_a) {
+		delta = zs_raw_xor_mctrl(zport);
+		spin_unlock(&scc->zlock);
+
+		if (delta & TIOCM_CTS)
+			uart_handle_cts_change(uport,
+					       zport->mctrl & TIOCM_CTS);
+		if (delta & TIOCM_CAR)
+			uart_handle_dcd_change(uport,
+					       zport->mctrl & TIOCM_CAR);
+		if (delta & TIOCM_RNG)
+			uport->icount.dsr++;
+		if (delta & TIOCM_DSR)
+			uport->icount.rng++;
+
+		if (delta)
+			wake_up_interruptible(&uport->info->delta_msr_wait);
+
+		spin_lock(&scc->zlock);
+	}
+
+	/* Clear the status condition...  */
+	write_zsreg(zport, R0, RES_EXT_INT);
+
+	spin_unlock(&scc->zlock);
+}
+
+/*
+ * This is the Z85C30 driver's generic interrupt routine.
+ */
+static irqreturn_t zs_interrupt(int irq, void *dev_id)
+{
+	struct zs_scc *scc = dev_id;
+	struct zs_port *zport_a = &scc->zport[ZS_CHAN_A];
+	struct zs_port *zport_b = &scc->zport[ZS_CHAN_B];
+	irqreturn_t status = IRQ_NONE;
+	u8 zs_intreg;
+	int count;
+
+	/*
+	 * NOTE: The read register 3, which holds the irq status,
+	 *       does so for both channels on each chip.  Although
+	 *       the status value itself must be read from the A
+	 *       channel and is only valid when read from channel A.
+	 *       Yes... broken hardware...
+	 */
+	for (count = 16; count; count--) {
+		spin_lock(&scc->zlock);
+		zs_intreg = read_zsreg(zport_a, R3);
+		spin_unlock(&scc->zlock);
+		if (!zs_intreg)
+			break;
+
+		/*
+		 * We do not like losing characters, so we prioritise
+		 * interrupt sources a little bit differently than
+		 * the SCC would, was it allowed to.
+		 */
+		if (zs_intreg & CHBRxIP)
+			zs_receive_chars(zport_b);
+		if (zs_intreg & CHARxIP)
+			zs_receive_chars(zport_a);
+		if (zs_intreg & CHBEXT)
+			zs_status_handle(zport_b, zport_a);
+		if (zs_intreg & CHAEXT)
+			zs_status_handle(zport_a, zport_a);
+		if (zs_intreg & CHBTxIP)
+			zs_transmit_chars(zport_b);
+		if (zs_intreg & CHATxIP)
+			zs_transmit_chars(zport_a);
+
+		status = IRQ_HANDLED;
+	}
+
+	return status;
+}
+
+
+/*
+ * Finally, routines used to initialize the serial port.
+ */
+static int zs_startup(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	unsigned long flags;
+	int irq_guard;
+	int ret;
+
+	irq_guard = atomic_add_return(1, &scc->irq_guard);
+	if (irq_guard == 1) {
+		ret = request_irq(zport->port.irq, zs_interrupt,
+				  IRQF_SHARED, "scc", scc);
+		if (ret) {
+			atomic_add(-1, &scc->irq_guard);
+			printk(KERN_ERR "zs: can't get irq %d\n",
+			       zport->port.irq);
+			return ret;
+		}
+	}
+
+	spin_lock_irqsave(&scc->zlock, flags);
+
+	/* Clear the receive FIFO.  */
+	zs_receive_drain(zport);
+
+	/* Clear the interrupt registers.  */
+	write_zsreg(zport, R0, ERR_RES);
+	write_zsreg(zport, R0, RES_Tx_P);
+	/* But Ext only if not being handled already.  */
+	if (!(zport->regs[1] & EXT_INT_ENAB))
+		write_zsreg(zport, R0, RES_EXT_INT);
+
+	/* Finally, enable sequencing and interrupts.  */
+	zport->regs[1] &= ~RxINT_MASK;
+	zport->regs[1] |= RxINT_ALL | TxINT_ENAB | EXT_INT_ENAB;
+	zport->regs[3] |= RxENABLE;
+	zport->regs[5] |= TxENAB;
+	zport->regs[15] |= BRKIE;
+	write_zsreg(zport, R1, zport->regs[1]);
+	write_zsreg(zport, R3, zport->regs[3]);
+	write_zsreg(zport, R5, zport->regs[5]);
+	write_zsreg(zport, R15, zport->regs[15]);
+
+	/* Record the current state of RR0.  */
+	zport->mctrl = zs_raw_get_mctrl(zport);
+	zport->brk = read_zsreg(zport, R0) & BRK_ABRT;
+
+	zport->tx_stopped = 1;
+
+	spin_unlock_irqrestore(&scc->zlock, flags);
+
+	return 0;
+}
+
+static void zs_shutdown(struct uart_port *uport)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	unsigned long flags;
+	int irq_guard;
+
+	spin_lock_irqsave(&scc->zlock, flags);
+
+	zport->regs[5] &= ~TxENAB;
+	zport->regs[3] &= ~RxENABLE;
+	write_zsreg(zport, R5, zport->regs[5]);
+	write_zsreg(zport, R3, zport->regs[3]);
+
+	spin_unlock_irqrestore(&scc->zlock, flags);
+
+	irq_guard = atomic_add_return(-1, &scc->irq_guard);
+	if (!irq_guard)
+		free_irq(zport->port.irq, scc);
+}
+
+
+static void zs_reset(struct zs_port *zport)
+{
+	struct zs_scc *scc = zport->scc;
+	int irq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&scc->zlock, flags);
+	irq = !irqs_disabled_flags(flags);
+	if (!scc->initialised) {
+		/* Reset the pointer first, just in case...  */
+		read_zsreg(zport, R0);
+		/* And let the current transmission finish.  */
+		zs_line_drain(zport, irq);
+		write_zsreg(zport, R9, FHWRES);
+		udelay(10);
+		write_zsreg(zport, R9, 0);
+		scc->initialised = 1;
+	}
+	load_zsregs(zport, zport->regs, irq);
+	spin_unlock_irqrestore(&scc->zlock, flags);
+}
+
+static void zs_set_termios(struct uart_port *uport, struct ktermios *termios,
+			   struct ktermios *old_termios)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	struct zs_port *zport_a = &scc->zport[ZS_CHAN_A];
+	int irq;
+	unsigned int baud, brg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&scc->zlock, flags);
+	irq = !irqs_disabled_flags(flags);
+
+	/* Byte size.  */
+	zport->regs[3] &= ~RxNBITS_MASK;
+	zport->regs[5] &= ~TxNBITS_MASK;
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		zport->regs[3] |= Rx5;
+		zport->regs[5] |= Tx5;
+		break;
+	case CS6:
+		zport->regs[3] |= Rx6;
+		zport->regs[5] |= Tx6;
+		break;
+	case CS7:
+		zport->regs[3] |= Rx7;
+		zport->regs[5] |= Tx7;
+		break;
+	case CS8:
+	default:
+		zport->regs[3] |= Rx8;
+		zport->regs[5] |= Tx8;
+		break;
+	}
+
+	/* Parity and stop bits.  */
+	zport->regs[4] &= ~(XCLK_MASK | SB_MASK | PAR_ENA | PAR_EVEN);
+	if (termios->c_cflag & CSTOPB)
+		zport->regs[4] |= SB2;
+	else
+		zport->regs[4] |= SB1;
+	if (termios->c_cflag & PARENB)
+		zport->regs[4] |= PAR_ENA;
+	if (!(termios->c_cflag & PARODD))
+		zport->regs[4] |= PAR_EVEN;
+	switch (zport->clk_mode) {
+	case 64:
+		zport->regs[4] |= X64CLK;
+		break;
+	case 32:
+		zport->regs[4] |= X32CLK;
+		break;
+	case 16:
+		zport->regs[4] |= X16CLK;
+		break;
+	case 1:
+		zport->regs[4] |= X1CLK;
+		break;
+	default:
+		BUG();
+	}
+
+	baud = uart_get_baud_rate(uport, termios, old_termios, 0,
+				  uport->uartclk / zport->clk_mode / 4);
+
+	brg = ZS_BPS_TO_BRG(baud, uport->uartclk / zport->clk_mode);
+	zport->regs[12] = brg & 0xff;
+	zport->regs[13] = (brg >> 8) & 0xff;
+
+	uart_update_timeout(uport, termios->c_cflag, baud);
+
+	uport->read_status_mask = Rx_OVR;
+	if (termios->c_iflag & INPCK)
+		uport->read_status_mask |= FRM_ERR | PAR_ERR;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		uport->read_status_mask |= Rx_BRK;
+
+	uport->ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		uport->ignore_status_mask |= FRM_ERR | PAR_ERR;
+	if (termios->c_iflag & IGNBRK) {
+		uport->ignore_status_mask |= Rx_BRK;
+		if (termios->c_iflag & IGNPAR)
+			uport->ignore_status_mask |= Rx_OVR;
+	}
+
+	if (termios->c_cflag & CREAD)
+		zport->regs[3] |= RxENABLE;
+	else
+		zport->regs[3] &= ~RxENABLE;
+
+	if (zport != zport_a) {
+		if (!(termios->c_cflag & CLOCAL)) {
+			zport->regs[15] |= DCDIE;
+		} else
+			zport->regs[15] &= ~DCDIE;
+		if (termios->c_cflag & CRTSCTS) {
+			zport->regs[15] |= CTSIE;
+		} else
+			zport->regs[15] &= ~CTSIE;
+		zs_raw_xor_mctrl(zport);
+	}
+
+	/* Load up the new values.  */
+	load_zsregs(zport, zport->regs, irq);
+
+	spin_unlock_irqrestore(&scc->zlock, flags);
+}
+
+
+static const char *zs_type(struct uart_port *uport)
+{
+	return "Z85C30 SCC";
+}
+
+static void zs_release_port(struct uart_port *uport)
+{
+	iounmap(uport->membase);
+	uport->membase = 0;
+	release_mem_region(uport->mapbase, ZS_CHAN_IO_SIZE);
+}
+
+static int zs_map_port(struct uart_port *uport)
+{
+	if (!uport->membase)
+		uport->membase = ioremap_nocache(uport->mapbase,
+						 ZS_CHAN_IO_SIZE);
+	if (!uport->membase) {
+		printk(KERN_ERR "zs: Cannot map MMIO\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int zs_request_port(struct uart_port *uport)
+{
+	int ret;
+
+	if (!request_mem_region(uport->mapbase, ZS_CHAN_IO_SIZE, "scc")) {
+		printk(KERN_ERR "zs: Unable to reserve MMIO resource\n");
+		return -EBUSY;
+	}
+	ret = zs_map_port(uport);
+	if (ret) {
+		release_mem_region(uport->mapbase, ZS_CHAN_IO_SIZE);
+		return ret;
+	}
+	return 0;
+}
+
+static void zs_config_port(struct uart_port *uport, int flags)
+{
+	struct zs_port *zport = to_zport(uport);
+
+	if (flags & UART_CONFIG_TYPE) {
+		if (zs_request_port(uport))
+			return;
+
+		uport->type = PORT_ZS;
+
+		zs_reset(zport);
+	}
+}
+
+static int zs_verify_port(struct uart_port *uport, struct serial_struct *ser)
+{
+	struct zs_port *zport = to_zport(uport);
+	int ret = 0;
+
+	if (ser->type != PORT_UNKNOWN && ser->type != PORT_ZS)
+		ret = -EINVAL;
+	if (ser->irq != uport->irq)
+		ret = -EINVAL;
+	if (ser->baud_base != uport->uartclk / zport->clk_mode / 4)
+		ret = -EINVAL;
+	return ret;
+}
+
+
+static struct uart_ops zs_ops = {
+	.tx_empty	= zs_tx_empty,
+	.set_mctrl	= zs_set_mctrl,
+	.get_mctrl	= zs_get_mctrl,
+	.stop_tx	= zs_stop_tx,
+	.start_tx	= zs_start_tx,
+	.stop_rx	= zs_stop_rx,
+	.enable_ms	= zs_enable_ms,
+	.break_ctl	= zs_break_ctl,
+	.startup	= zs_startup,
+	.shutdown	= zs_shutdown,
+	.set_termios	= zs_set_termios,
+	.type		= zs_type,
+	.release_port	= zs_release_port,
+	.request_port	= zs_request_port,
+	.config_port	= zs_config_port,
+	.verify_port	= zs_verify_port,
+};
+
+/*
+ * Initialize Z85C30 port structures.
+ */
+static int __init zs_probe_sccs(void)
+{
+	static int probed;
+	struct zs_parms zs_parms;
+	int chip, side, irq;
+	int n_chips = 0;
+	int i;
+
+	if (probed)
+		return 0;
+
+	irq = dec_interrupt[DEC_IRQ_SCC0];
+	if (irq >= 0) {
+		zs_parms.scc[n_chips] = IOASIC_SCC0;
+		zs_parms.irq[n_chips] = dec_interrupt[DEC_IRQ_SCC0];
+		n_chips++;
+	}
+	irq = dec_interrupt[DEC_IRQ_SCC1];
+	if (irq >= 0) {
+		zs_parms.scc[n_chips] = IOASIC_SCC1;
+		zs_parms.irq[n_chips] = dec_interrupt[DEC_IRQ_SCC1];
+		n_chips++;
+	}
+	if (!n_chips)
+		return -ENXIO;
+
+	probed = 1;
+
+	for (chip = 0; chip < n_chips; chip++) {
+		spin_lock_init(&zs_sccs[chip].zlock);
+		for (side = 0; side < ZS_NUM_CHAN; side++) {
+			struct zs_port *zport = &zs_sccs[chip].zport[side];
+			struct uart_port *uport = &zport->port;
+
+			zport->scc	= &zs_sccs[chip];
+			zport->clk_mode	= 16;
+
+			uport->irq	= zs_parms.irq[chip];
+			uport->uartclk	= ZS_CLOCK;
+			uport->fifosize	= 1;
+			uport->iotype	= UPIO_MEM;
+			uport->flags	= UPF_BOOT_AUTOCONF;
+			uport->ops	= &zs_ops;
+			uport->line	= chip * ZS_NUM_CHAN + side;
+			uport->mapbase	= dec_kn_slot_base +
+					  zs_parms.scc[chip] +
+					  (side ^ ZS_CHAN_B) * ZS_CHAN_IO_SIZE;
+
+			for (i = 0; i < ZS_NUM_REGS; i++)
+				zport->regs[i] = zs_init_regs[i];
+		}
+	}
+
+	return 0;
+}
+
+
+#ifdef CONFIG_SERIAL_ZS_CONSOLE
+static void zs_console_putchar(struct uart_port *uport, int ch)
+{
+	struct zs_port *zport = to_zport(uport);
+	struct zs_scc *scc = zport->scc;
+	int irq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&scc->zlock, flags);
+	irq = !irqs_disabled_flags(flags);
+	if (zs_transmit_drain(zport, irq))
+		write_zsdata(zport, ch);
+	spin_unlock_irqrestore(&scc->zlock, flags);
+}
+
+/*
+ * Print a string to the serial port trying not to disturb
+ * any possible real use of the port...
+ */
+static void zs_console_write(struct console *co, const char *s,
+			     unsigned int count)
+{
+	int chip = co->index / ZS_NUM_CHAN, side = co->index % ZS_NUM_CHAN;
+	struct zs_port *zport = &zs_sccs[chip].zport[side];
+	struct zs_scc *scc = zport->scc;
+	unsigned long flags;
+	u8 txint, txenb;
+	int irq;
+
+	/* Disable transmit interrupts and enable the transmitter. */
+	spin_lock_irqsave(&scc->zlock, flags);
+	txint = zport->regs[1];
+	txenb = zport->regs[5];
+	if (txint & TxINT_ENAB) {
+		zport->regs[1] = txint & ~TxINT_ENAB;
+		write_zsreg(zport, R1, zport->regs[1]);
+	}
+	if (!(txenb & TxENAB)) {
+		zport->regs[5] = txenb | TxENAB;
+		write_zsreg(zport, R5, zport->regs[5]);
+	}
+	spin_unlock_irqrestore(&scc->zlock, flags);
+
+	uart_console_write(&zport->port, s, count, zs_console_putchar);
+
+	/* Restore transmit interrupts and the transmitter enable. */
+	spin_lock_irqsave(&scc->zlock, flags);
+	irq = !irqs_disabled_flags(flags);
+	zs_line_drain(zport, irq);
+	if (!(txenb & TxENAB)) {
+		zport->regs[5] &= ~TxENAB;
+		write_zsreg(zport, R5, zport->regs[5]);
+	}
+	if (txint & TxINT_ENAB) {
+		zport->regs[1] |= TxINT_ENAB;
+		write_zsreg(zport, R1, zport->regs[1]);
+	}
+	spin_unlock_irqrestore(&scc->zlock, flags);
+}
+
+/*
+ * Setup serial console baud/bits/parity.  We do two things here:
+ * - construct a cflag setting for the first uart_open()
+ * - initialise the serial port
+ * Return non-zero if we didn't find a serial port.
+ */
+static int __init zs_console_setup(struct console *co, char *options)
+{
+	int chip = co->index / ZS_NUM_CHAN, side = co->index % ZS_NUM_CHAN;
+	struct zs_port *zport = &zs_sccs[chip].zport[side];
+	struct uart_port *uport = &zport->port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+	int ret;
+
+	ret = zs_map_port(uport);
+	if (ret)
+		return ret;
+
+	zs_reset(zport);
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+	return uart_set_options(uport, co, baud, parity, bits, flow);
+}
+
+static struct uart_driver zs_reg;
+static struct console zs_console = {
+	.name	= "ttyS",
+	.write	= zs_console_write,
+	.device	= uart_console_device,
+	.setup	= zs_console_setup,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+	.data	= &zs_reg,
+};
+
+/*
+ *	Register console.
+ */
+static int __init zs_serial_console_init(void)
+{
+	int ret;
+
+	ret = zs_probe_sccs();
+	if (ret)
+		return ret;
+	register_console(&zs_console);
+
+	return 0;
+}
+
+console_initcall(zs_serial_console_init);
+
+#define SERIAL_ZS_CONSOLE	&zs_console
+#else
+#define SERIAL_ZS_CONSOLE	NULL
+#endif /* CONFIG_SERIAL_ZS_CONSOLE */
+
+static struct uart_driver zs_reg = {
+	.owner			= THIS_MODULE,
+	.driver_name		= "serial",
+	.dev_name		= "ttyS",
+	.major			= TTY_MAJOR,
+	.minor			= 64,
+	.nr			= ZS_NUM_SCCS * ZS_NUM_CHAN,
+	.cons			= SERIAL_ZS_CONSOLE,
+};
+
+/* zs_init inits the driver. */
+static int __init zs_init(void)
+{
+	int i, ret;
+
+	pr_info("%s%s\n", zs_name, zs_version);
+
+	/* Find out how many Z85C30 SCCs we have.  */
+	ret = zs_probe_sccs();
+	if (ret)
+		return ret;
+
+	ret = uart_register_driver(&zs_reg);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ZS_NUM_SCCS * ZS_NUM_CHAN; i++) {
+		struct zs_scc *scc = &zs_sccs[i / ZS_NUM_CHAN];
+		struct zs_port *zport = &scc->zport[i % ZS_NUM_CHAN];
+		struct uart_port *uport = &zport->port;
+
+		if (zport->scc)
+			uart_add_one_port(&zs_reg, uport);
+	}
+
+	return 0;
+}
+
+static void __exit zs_exit(void)
+{
+	int i;
+
+	for (i = ZS_NUM_SCCS * ZS_NUM_CHAN - 1; i >= 0; i--) {
+		struct zs_scc *scc = &zs_sccs[i / ZS_NUM_CHAN];
+		struct zs_port *zport = &scc->zport[i % ZS_NUM_CHAN];
+		struct uart_port *uport = &zport->port;
+
+		if (zport->scc)
+			uart_remove_one_port(&zs_reg, uport);
+	}
+
+	uart_unregister_driver(&zs_reg);
+}
+
+module_init(zs_init);
+module_exit(zs_exit);
diff -puN /dev/null drivers/serial/zs.h
--- /dev/null
+++ a/drivers/serial/zs.h
@@ -0,0 +1,284 @@
+/*
+ * zs.h: Definitions for the DECstation Z85C30 serial driver.
+ *
+ * Adapted from drivers/sbus/char/sunserial.h by Paul Mackerras.
+ * Adapted from drivers/macintosh/macserial.h by Harald Koerfgen.
+ *
+ * Copyright (C) 1996 Paul Mackerras (Paul.Mackerras@cs.anu.edu.au)
+ * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
+ * Copyright (C) 2004, 2005, 2007  Maciej W. Rozycki
+ */
+#ifndef _SERIAL_ZS_H
+#define _SERIAL_ZS_H
+
+#ifdef __KERNEL__
+
+#define ZS_NUM_REGS 16
+
+/*
+ * This is our internal structure for each serial port's state.
+ */
+struct zs_port {
+	struct zs_scc	*scc;			/* Containing SCC.  */
+	struct uart_port port;			/* Underlying UART.  */
+
+	int		clk_mode;		/* May be 1, 16, 32, or 64.  */
+
+	unsigned int	tty_break;		/* Set on BREAK condition.  */
+	int		tx_stopped;		/* Output is suspended.  */
+
+	unsigned int	mctrl;			/* State of modem lines.  */
+	u8		brk;			/* BREAK state from RR0.  */
+
+	u8		regs[ZS_NUM_REGS];	/* Channel write registers.  */
+};
+
+/*
+ * Per-SCC state for locking and the interrupt handler.
+ */
+struct zs_scc {
+	struct zs_port	zport[2];
+	spinlock_t	zlock;
+	atomic_t	irq_guard;
+	int		initialised;
+};
+
+#endif /* __KERNEL__ */
+
+/*
+ * Conversion routines to/from brg time constants from/to bits per second.
+ */
+#define ZS_BRG_TO_BPS(brg, freq) ((freq) / 2 / ((brg) + 2))
+#define ZS_BPS_TO_BRG(bps, freq) ((((freq) + (bps)) / (2 * (bps))) - 2)
+
+/*
+ * The Zilog register set.
+ */
+
+/* Write Register 0 (Command) */
+#define R0		0	/* Register selects */
+#define R1		1
+#define R2		2
+#define R3		3
+#define R4		4
+#define R5		5
+#define R6		6
+#define R7		7
+#define R8		8
+#define R9		9
+#define R10		10
+#define R11		11
+#define R12		12
+#define R13		13
+#define R14		14
+#define R15		15
+
+#define NULLCODE	0	/* Null Code */
+#define POINT_HIGH	0x8	/* Select upper half of registers */
+#define RES_EXT_INT	0x10	/* Reset Ext. Status Interrupts */
+#define SEND_ABORT	0x18	/* HDLC Abort */
+#define RES_RxINT_FC	0x20	/* Reset RxINT on First Character */
+#define RES_Tx_P	0x28	/* Reset TxINT Pending */
+#define ERR_RES		0x30	/* Error Reset */
+#define RES_H_IUS	0x38	/* Reset highest IUS */
+
+#define RES_Rx_CRC	0x40	/* Reset Rx CRC Checker */
+#define RES_Tx_CRC	0x80	/* Reset Tx CRC Checker */
+#define RES_EOM_L	0xC0	/* Reset EOM latch */
+
+/* Write Register 1 (Tx/Rx/Ext Int Enable and WAIT/DMA Commands) */
+#define EXT_INT_ENAB	0x1	/* Ext Int Enable */
+#define TxINT_ENAB	0x2	/* Tx Int Enable */
+#define PAR_SPEC	0x4	/* Parity is special condition */
+
+#define RxINT_DISAB	0	/* Rx Int Disable */
+#define RxINT_FCERR	0x8	/* Rx Int on First Character Only or Error */
+#define RxINT_ALL	0x10	/* Int on all Rx Characters or error */
+#define RxINT_ERR	0x18	/* Int on error only */
+#define RxINT_MASK	0x18
+
+#define WT_RDY_RT	0x20	/* Wait/Ready on R/T */
+#define WT_FN_RDYFN	0x40	/* Wait/FN/Ready FN */
+#define WT_RDY_ENAB	0x80	/* Wait/Ready Enable */
+
+/* Write Register 2 (Interrupt Vector) */
+
+/* Write Register 3 (Receive Parameters and Control) */
+#define RxENABLE	0x1	/* Rx Enable */
+#define SYNC_L_INH	0x2	/* Sync Character Load Inhibit */
+#define ADD_SM		0x4	/* Address Search Mode (SDLC) */
+#define RxCRC_ENAB	0x8	/* Rx CRC Enable */
+#define ENT_HM		0x10	/* Enter Hunt Mode */
+#define AUTO_ENAB	0x20	/* Auto Enables */
+#define Rx5		0x0	/* Rx 5 Bits/Character */
+#define Rx7		0x40	/* Rx 7 Bits/Character */
+#define Rx6		0x80	/* Rx 6 Bits/Character */
+#define Rx8		0xc0	/* Rx 8 Bits/Character */
+#define RxNBITS_MASK	0xc0
+
+/* Write Register 4 (Transmit/Receive Miscellaneous Parameters and Modes) */
+#define PAR_ENA		0x1	/* Parity Enable */
+#define PAR_EVEN	0x2	/* Parity Even/Odd* */
+
+#define SYNC_ENAB	0	/* Sync Modes Enable */
+#define SB1		0x4	/* 1 stop bit/char */
+#define SB15		0x8	/* 1.5 stop bits/char */
+#define SB2		0xc	/* 2 stop bits/char */
+#define SB_MASK		0xc
+
+#define MONSYNC		0	/* 8 Bit Sync character */
+#define BISYNC		0x10	/* 16 bit sync character */
+#define SDLC		0x20	/* SDLC Mode (01111110 Sync Flag) */
+#define EXTSYNC		0x30	/* External Sync Mode */
+
+#define X1CLK		0x0	/* x1 clock mode */
+#define X16CLK		0x40	/* x16 clock mode */
+#define X32CLK		0x80	/* x32 clock mode */
+#define X64CLK		0xc0	/* x64 clock mode */
+#define XCLK_MASK	0xc0
+
+/* Write Register 5 (Transmit Parameters and Controls) */
+#define TxCRC_ENAB	0x1	/* Tx CRC Enable */
+#define RTS		0x2	/* RTS */
+#define SDLC_CRC	0x4	/* SDLC/CRC-16 */
+#define TxENAB		0x8	/* Tx Enable */
+#define SND_BRK		0x10	/* Send Break */
+#define Tx5		0x0	/* Tx 5 bits (or less)/character */
+#define Tx7		0x20	/* Tx 7 bits/character */
+#define Tx6		0x40	/* Tx 6 bits/character */
+#define Tx8		0x60	/* Tx 8 bits/character */
+#define TxNBITS_MASK	0x60
+#define DTR		0x80	/* DTR */
+
+/* Write Register 6 (Sync bits 0-7/SDLC Address Field) */
+
+/* Write Register 7 (Sync bits 8-15/SDLC 01111110) */
+
+/* Write Register 8 (Transmit Buffer) */
+
+/* Write Register 9 (Master Interrupt Control) */
+#define VIS		1	/* Vector Includes Status */
+#define NV		2	/* No Vector */
+#define DLC		4	/* Disable Lower Chain */
+#define MIE		8	/* Master Interrupt Enable */
+#define STATHI		0x10	/* Status high */
+#define SOFTACK		0x20	/* Software Interrupt Acknowledge */
+#define NORESET		0	/* No reset on write to R9 */
+#define CHRB		0x40	/* Reset channel B */
+#define CHRA		0x80	/* Reset channel A */
+#define FHWRES		0xc0	/* Force hardware reset */
+
+/* Write Register 10 (Miscellaneous Transmitter/Receiver Control Bits) */
+#define BIT6		1	/* 6 bit/8bit sync */
+#define LOOPMODE	2	/* SDLC Loop mode */
+#define ABUNDER		4	/* Abort/flag on SDLC xmit underrun */
+#define MARKIDLE	8	/* Mark/flag on idle */
+#define GAOP		0x10	/* Go active on poll */
+#define NRZ		0	/* NRZ mode */
+#define NRZI		0x20	/* NRZI mode */
+#define FM1		0x40	/* FM1 (transition = 1) */
+#define FM0		0x60	/* FM0 (transition = 0) */
+#define CRCPS		0x80	/* CRC Preset I/O */
+
+/* Write Register 11 (Clock Mode Control) */
+#define TRxCXT		0	/* TRxC = Xtal output */
+#define TRxCTC		1	/* TRxC = Transmit clock */
+#define TRxCBR		2	/* TRxC = BR Generator Output */
+#define TRxCDP		3	/* TRxC = DPLL output */
+#define TRxCOI		4	/* TRxC O/I */
+#define TCRTxCP		0	/* Transmit clock = RTxC pin */
+#define TCTRxCP		8	/* Transmit clock = TRxC pin */
+#define TCBR		0x10	/* Transmit clock = BR Generator output */
+#define TCDPLL		0x18	/* Transmit clock = DPLL output */
+#define RCRTxCP		0	/* Receive clock = RTxC pin */
+#define RCTRxCP		0x20	/* Receive clock = TRxC pin */
+#define RCBR		0x40	/* Receive clock = BR Generator output */
+#define RCDPLL		0x60	/* Receive clock = DPLL output */
+#define RTxCX		0x80	/* RTxC Xtal/No Xtal */
+
+/* Write Register 12 (Lower Byte of Baud Rate Generator Time Constant) */
+
+/* Write Register 13 (Upper Byte of Baud Rate Generator Time Constant) */
+
+/* Write Register 14 (Miscellaneous Control Bits) */
+#define BRENABL		1	/* Baud rate generator enable */
+#define BRSRC		2	/* Baud rate generator source */
+#define DTRREQ		4	/* DTR/Request function */
+#define AUTOECHO	8	/* Auto Echo */
+#define LOOPBAK		0x10	/* Local loopback */
+#define SEARCH		0x20	/* Enter search mode */
+#define RMC		0x40	/* Reset missing clock */
+#define DISDPLL		0x60	/* Disable DPLL */
+#define SSBR		0x80	/* Set DPLL source = BR generator */
+#define SSRTxC		0xa0	/* Set DPLL source = RTxC */
+#define SFMM		0xc0	/* Set FM mode */
+#define SNRZI		0xe0	/* Set NRZI mode */
+
+/* Write Register 15 (External/Status Interrupt Control) */
+#define WR7P_EN		1	/* WR7 Prime SDLC Feature Enable */
+#define ZCIE		2	/* Zero count IE */
+#define DCDIE		8	/* DCD IE */
+#define SYNCIE		0x10	/* Sync/hunt IE */
+#define CTSIE		0x20	/* CTS IE */
+#define TxUIE		0x40	/* Tx Underrun/EOM IE */
+#define BRKIE		0x80	/* Break/Abort IE */
+
+
+/* Read Register 0 (Transmit/Receive Buffer Status and External Status) */
+#define Rx_CH_AV	0x1	/* Rx Character Available */
+#define ZCOUNT		0x2	/* Zero count */
+#define Tx_BUF_EMP	0x4	/* Tx Buffer empty */
+#define DCD		0x8	/* DCD */
+#define SYNC_HUNT	0x10	/* Sync/hunt */
+#define CTS		0x20	/* CTS */
+#define TxEOM		0x40	/* Tx underrun */
+#define BRK_ABRT	0x80	/* Break/Abort */
+
+/* Read Register 1 (Special Receive Condition Status) */
+#define ALL_SNT		0x1	/* All sent */
+/* Residue Data for 8 Rx bits/char programmed */
+#define RES3		0x8	/* 0/3 */
+#define RES4		0x4	/* 0/4 */
+#define RES5		0xc	/* 0/5 */
+#define RES6		0x2	/* 0/6 */
+#define RES7		0xa	/* 0/7 */
+#define RES8		0x6	/* 0/8 */
+#define RES18		0xe	/* 1/8 */
+#define RES28		0x0	/* 2/8 */
+/* Special Rx Condition Interrupts */
+#define PAR_ERR		0x10	/* Parity Error */
+#define Rx_OVR		0x20	/* Rx Overrun Error */
+#define FRM_ERR		0x40	/* CRC/Framing Error */
+#define END_FR		0x80	/* End of Frame (SDLC) */
+
+/* Read Register 2 (Interrupt Vector (WR2) -- channel A).  */
+
+/* Read Register 2 (Modified Interrupt Vector -- channel B).  */
+
+/* Read Register 3 (Interrupt Pending Bits -- channel A only).  */
+#define CHBEXT		0x1	/* Channel B Ext/Stat IP */
+#define CHBTxIP		0x2	/* Channel B Tx IP */
+#define CHBRxIP		0x4	/* Channel B Rx IP */
+#define CHAEXT		0x8	/* Channel A Ext/Stat IP */
+#define CHATxIP		0x10	/* Channel A Tx IP */
+#define CHARxIP		0x20	/* Channel A Rx IP */
+
+/* Read Register 6 (SDLC FIFO Status and Byte Count LSB) */
+
+/* Read Register 7 (SDLC FIFO Status and Byte Count MSB) */
+
+/* Read Register 8 (Receive Data) */
+
+/* Read Register 10 (Miscellaneous Status Bits) */
+#define ONLOOP		2	/* On loop */
+#define LOOPSEND	0x10	/* Loop sending */
+#define CLK2MIS		0x40	/* Two clocks missing */
+#define CLK1MIS		0x80	/* One clock missing */
+
+/* Read Register 12 (Lower Byte of Baud Rate Generator Constant (WR12)) */
+
+/* Read Register 13 (Upper Byte of Baud Rate Generator Constant (WR13) */
+
+/* Read Register 15 (External/Status Interrupt Control (WR15)) */
+
+#endif /* _SERIAL_ZS_H */
diff -puN drivers/tc/Makefile~zs-move-to-the-serial-subsystem drivers/tc/Makefile
--- a/drivers/tc/Makefile~zs-move-to-the-serial-subsystem
+++ a/drivers/tc/Makefile
@@ -5,7 +5,6 @@
 # Object file lists.
 
 obj-$(CONFIG_TC) += tc.o tc-driver.o
-obj-$(CONFIG_ZS) += zs.o
 obj-$(CONFIG_VT) += lk201.o lk201-map.o lk201-remap.o
 
 $(obj)/lk201-map.o: $(obj)/lk201-map.c
diff -puN drivers/tc/zs.c~zs-move-to-the-serial-subsystem /dev/null
--- a/drivers/tc/zs.c
+++ /dev/null
@@ -1,2203 +0,0 @@
-/*
- * decserial.c: Serial port driver for IOASIC DECstations.
- *
- * Derived from drivers/sbus/char/sunserial.c by Paul Mackerras.
- * Derived from drivers/macintosh/macserial.c by Harald Koerfgen.
- *
- * DECstation changes
- * Copyright (C) 1998-2000 Harald Koerfgen
- * Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005  Maciej W. Rozycki
- *
- * For the rest of the code the original Copyright applies:
- * Copyright (C) 1996 Paul Mackerras (Paul.Mackerras@cs.anu.edu.au)
- * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
- *
- *
- * Note: for IOASIC systems the wiring is as follows:
- *
- * mouse/keyboard:
- * DIN-7 MJ-4  signal        SCC
- * 2     1     TxD       <-  A.TxD
- * 3     4     RxD       ->  A.RxD
- *
- * EIA-232/EIA-423:
- * DB-25 MMJ-6 signal        SCC
- * 2     2     TxD       <-  B.TxD
- * 3     5     RxD       ->  B.RxD
- * 4           RTS       <- ~A.RTS
- * 5           CTS       -> ~B.CTS
- * 6     6     DSR       -> ~A.SYNC
- * 8           CD        -> ~B.DCD
- * 12          DSRS(DCE) -> ~A.CTS  (*)
- * 15          TxC       ->  B.TxC
- * 17          RxC       ->  B.RxC
- * 20    1     DTR       <- ~A.DTR
- * 22          RI        -> ~A.DCD
- * 23          DSRS(DTE) <- ~B.RTS
- *
- * (*) EIA-232 defines the signal at this pin to be SCD, while DSRS(DCE)
- *     is shared with DSRS(DTE) at pin 23.
- */
-
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/interrupt.h>
-#include <linux/tty.h>
-#include <linux/tty_flip.h>
-#include <linux/major.h>
-#include <linux/string.h>
-#include <linux/fcntl.h>
-#include <linux/mm.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/ioport.h>
-#include <linux/spinlock.h>
-#ifdef CONFIG_SERIAL_DEC_CONSOLE
-#include <linux/console.h>
-#endif
-
-#include <asm/io.h>
-#include <asm/pgtable.h>
-#include <asm/irq.h>
-#include <asm/system.h>
-#include <asm/bootinfo.h>
-
-#include <asm/dec/interrupts.h>
-#include <asm/dec/ioasic_addrs.h>
-#include <asm/dec/machtype.h>
-#include <asm/dec/serial.h>
-#include <asm/dec/system.h>
-
-#ifdef CONFIG_KGDB
-#include <asm/kgdb.h>
-#endif
-#ifdef CONFIG_MAGIC_SYSRQ
-#include <linux/sysrq.h>
-#endif
-
-#include "zs.h"
-
-/*
- * It would be nice to dynamically allocate everything that
- * depends on NUM_SERIAL, so we could support any number of
- * Z8530s, but for now...
- */
-#define NUM_SERIAL	2		/* Max number of ZS chips supported */
-#define NUM_CHANNELS	(NUM_SERIAL * 2)	/* 2 channels per chip */
-#define CHANNEL_A_NR  (zs_parms->channel_a_offset > zs_parms->channel_b_offset)
-                                        /* Number of channel A in the chip */
-#define ZS_CHAN_IO_SIZE 8
-#define ZS_CLOCK        7372800 	/* Z8530 RTxC input clock rate */
-
-#define RECOVERY_DELAY  udelay(2)
-
-struct zs_parms {
-	unsigned long scc0;
-	unsigned long scc1;
-	int channel_a_offset;
-	int channel_b_offset;
-	int irq0;
-	int irq1;
-	int clock;
-};
-
-static struct zs_parms *zs_parms;
-
-#ifdef CONFIG_MACH_DECSTATION
-static struct zs_parms ds_parms = {
-	scc0 : IOASIC_SCC0,
-	scc1 : IOASIC_SCC1,
-	channel_a_offset : 1,
-	channel_b_offset : 9,
-	irq0 : -1,
-	irq1 : -1,
-	clock : ZS_CLOCK
-};
-#endif
-
-#ifdef CONFIG_MACH_DECSTATION
-#define DS_BUS_PRESENT (IOASIC)
-#else
-#define DS_BUS_PRESENT 0
-#endif
-
-#define BUS_PRESENT (DS_BUS_PRESENT)
-
-DEFINE_SPINLOCK(zs_lock);
-
-struct dec_zschannel zs_channels[NUM_CHANNELS];
-struct dec_serial zs_soft[NUM_CHANNELS];
-int zs_channels_found;
-struct dec_serial *zs_chain;	/* list of all channels */
-
-struct tty_struct zs_ttys[NUM_CHANNELS];
-
-#ifdef CONFIG_SERIAL_DEC_CONSOLE
-static struct console zs_console;
-#endif
-#if defined(CONFIG_SERIAL_DEC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ) && \
-   !defined(MODULE)
-static unsigned long break_pressed; /* break, really ... */
-#endif
-
-static unsigned char zs_init_regs[16] __initdata = {
-	0,				/* write 0 */
-	0,				/* write 1 */
-	0,				/* write 2 */
-	0,				/* write 3 */
-	(X16CLK),			/* write 4 */
-	0,				/* write 5 */
-	0, 0, 0,			/* write 6, 7, 8 */
-	(MIE | DLC | NV),		/* write 9 */
-	(NRZ),				/* write 10 */
-	(TCBR | RCBR),			/* write 11 */
-	0, 0,				/* BRG time constant, write 12 + 13 */
-	(BRSRC | BRENABL),		/* write 14 */
-	0				/* write 15 */
-};
-
-static struct tty_driver *serial_driver;
-
-/* serial subtype definitions */
-#define SERIAL_TYPE_NORMAL	1
-
-/* number of characters left in xmit buffer before we ask for more */
-#define WAKEUP_CHARS 256
-
-/*
- * Debugging.
- */
-#undef SERIAL_DEBUG_OPEN
-#undef SERIAL_DEBUG_FLOW
-#undef SERIAL_DEBUG_THROTTLE
-#undef SERIAL_PARANOIA_CHECK
-
-#undef ZS_DEBUG_REGS
-
-#ifdef SERIAL_DEBUG_THROTTLE
-#define _tty_name(tty,buf) tty_name(tty,buf)
-#endif
-
-#define RS_STROBE_TIME 10
-#define RS_ISR_PASS_LIMIT 256
-
-static void probe_sccs(void);
-static void change_speed(struct dec_serial *info);
-static void rs_wait_until_sent(struct tty_struct *tty, int timeout);
-
-static inline int serial_paranoia_check(struct dec_serial *info,
-					char *name, const char *routine)
-{
-#ifdef SERIAL_PARANOIA_CHECK
-	static const char *badmagic =
-		"Warning: bad magic number for serial struct %s in %s\n";
-	static const char *badinfo =
-		"Warning: null mac_serial for %s in %s\n";
-
-	if (!info) {
-		printk(badinfo, name, routine);
-		return 1;
-	}
-	if (info->magic != SERIAL_MAGIC) {
-		printk(badmagic, name, routine);
-		return 1;
-	}
-#endif
-	return 0;
-}
-
-/*
- * This is used to figure out the divisor speeds and the timeouts
- */
-static int baud_table[] = {
-	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
-	9600, 19200, 38400, 57600, 115200, 0 };
-
-/*
- * Reading and writing Z8530 registers.
- */
-static inline unsigned char read_zsreg(struct dec_zschannel *channel,
-				       unsigned char reg)
-{
-	unsigned char retval;
-
-	if (reg != 0) {
-		*channel->control = reg & 0xf;
-		fast_iob(); RECOVERY_DELAY;
-	}
-	retval = *channel->control;
-	RECOVERY_DELAY;
-	return retval;
-}
-
-static inline void write_zsreg(struct dec_zschannel *channel,
-			       unsigned char reg, unsigned char value)
-{
-	if (reg != 0) {
-		*channel->control = reg & 0xf;
-		fast_iob(); RECOVERY_DELAY;
-	}
-	*channel->control = value;
-	fast_iob(); RECOVERY_DELAY;
-	return;
-}
-
-static inline unsigned char read_zsdata(struct dec_zschannel *channel)
-{
-	unsigned char retval;
-
-	retval = *channel->data;
-	RECOVERY_DELAY;
-	return retval;
-}
-
-static inline void write_zsdata(struct dec_zschannel *channel,
-				unsigned char value)
-{
-	*channel->data = value;
-	fast_iob(); RECOVERY_DELAY;
-	return;
-}
-
-static inline void load_zsregs(struct dec_zschannel *channel,
-			       unsigned char *regs)
-{
-/*	ZS_CLEARERR(channel);
-	ZS_CLEARFIFO(channel); */
-	/* Load 'em up */
-	write_zsreg(channel, R3, regs[R3] & ~RxENABLE);
-	write_zsreg(channel, R5, regs[R5] & ~TxENAB);
-	write_zsreg(channel, R4, regs[R4]);
-	write_zsreg(channel, R9, regs[R9]);
-	write_zsreg(channel, R1, regs[R1]);
-	write_zsreg(channel, R2, regs[R2]);
-	write_zsreg(channel, R10, regs[R10]);
-	write_zsreg(channel, R11, regs[R11]);
-	write_zsreg(channel, R12, regs[R12]);
-	write_zsreg(channel, R13, regs[R13]);
-	write_zsreg(channel, R14, regs[R14]);
-	write_zsreg(channel, R15, regs[R15]);
-	write_zsreg(channel, R3, regs[R3]);
-	write_zsreg(channel, R5, regs[R5]);
-	return;
-}
-
-/* Sets or clears DTR/RTS on the requested line */
-static inline void zs_rtsdtr(struct dec_serial *info, int which, int set)
-{
-        unsigned long flags;
-
-	spin_lock_irqsave(&zs_lock, flags);
-	if (info->zs_channel != info->zs_chan_a) {
-		if (set) {
-			info->zs_chan_a->curregs[5] |= (which & (RTS | DTR));
-		} else {
-			info->zs_chan_a->curregs[5] &= ~(which & (RTS | DTR));
-		}
-		write_zsreg(info->zs_chan_a, 5, info->zs_chan_a->curregs[5]);
-	}
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-/* Utility routines for the Zilog */
-static inline int get_zsbaud(struct dec_serial *ss)
-{
-	struct dec_zschannel *channel = ss->zs_channel;
-	int brg;
-
-	/* The baud rate is split up between two 8-bit registers in
-	 * what is termed 'BRG time constant' format in my docs for
-	 * the chip, it is a function of the clk rate the chip is
-	 * receiving which happens to be constant.
-	 */
-	brg = (read_zsreg(channel, 13) << 8);
-	brg |= read_zsreg(channel, 12);
-	return BRG_TO_BPS(brg, (zs_parms->clock/(ss->clk_divisor)));
-}
-
-/* On receive, this clears errors and the receiver interrupts */
-static inline void rs_recv_clear(struct dec_zschannel *zsc)
-{
-	write_zsreg(zsc, 0, ERR_RES);
-	write_zsreg(zsc, 0, RES_H_IUS); /* XXX this is unnecessary */
-}
-
-/*
- * ----------------------------------------------------------------------
- *
- * Here starts the interrupt handling routines.  All of the following
- * subroutines are declared as inline and are folded into
- * rs_interrupt().  They were separated out for readability's sake.
- *
- * 				- Ted Ts'o (tytso@mit.edu), 7-Mar-93
- * -----------------------------------------------------------------------
- */
-
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver.
- */
-static void rs_sched_event(struct dec_serial *info, int event)
-{
-	info->event |= 1 << event;
-	tasklet_schedule(&info->tlet);
-}
-
-static void receive_chars(struct dec_serial *info)
-{
-	struct tty_struct *tty = info->tty;
-	unsigned char ch, stat, flag;
-
-	while ((read_zsreg(info->zs_channel, R0) & Rx_CH_AV) != 0) {
-
-		stat = read_zsreg(info->zs_channel, R1);
-		ch = read_zsdata(info->zs_channel);
-
-		if (!tty && (!info->hook || !info->hook->rx_char))
-			continue;
-
-		flag = TTY_NORMAL;
-		if (info->tty_break) {
-			info->tty_break = 0;
-			flag = TTY_BREAK;
-			if (info->flags & ZILOG_SAK)
-				do_SAK(tty);
-			/* Ignore the null char got when BREAK is removed.  */
-			if (ch == 0)
-				continue;
-		} else {
-			if (stat & Rx_OVR) {
-				flag = TTY_OVERRUN;
-			} else if (stat & FRM_ERR) {
-				flag = TTY_FRAME;
-			} else if (stat & PAR_ERR) {
-				flag = TTY_PARITY;
-			}
-			if (flag != TTY_NORMAL)
-				/* reset the error indication */
-				write_zsreg(info->zs_channel, R0, ERR_RES);
-		}
-
-#if defined(CONFIG_SERIAL_DEC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ) && \
-   !defined(MODULE)
-		if (break_pressed && info->line == zs_console.index) {
-			/* Ignore the null char got when BREAK is removed.  */
-			if (ch == 0)
-				continue;
-			if (time_before(jiffies, break_pressed + HZ * 5)) {
-				handle_sysrq(ch, NULL);
-				break_pressed = 0;
-				continue;
-			}
-			break_pressed = 0;
-		}
-#endif
-
-		if (info->hook && info->hook->rx_char) {
-			(*info->hook->rx_char)(ch, flag);
-			return;
-  		}
-
-		tty_insert_flip_char(tty, ch, flag);
-	}
-	if (tty)
-		tty_flip_buffer_push(tty);
-}
-
-static void transmit_chars(struct dec_serial *info)
-{
-	if ((read_zsreg(info->zs_channel, R0) & Tx_BUF_EMP) == 0)
-		return;
-	info->tx_active = 0;
-
-	if (info->x_char) {
-		/* Send next char */
-		write_zsdata(info->zs_channel, info->x_char);
-		info->x_char = 0;
-		info->tx_active = 1;
-		return;
-	}
-
-	if ((info->xmit_cnt <= 0) || (info->tty && info->tty->stopped)
-	    || info->tx_stopped) {
-		write_zsreg(info->zs_channel, R0, RES_Tx_P);
-		return;
-	}
-	/* Send char */
-	write_zsdata(info->zs_channel, info->xmit_buf[info->xmit_tail++]);
-	info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
-	info->xmit_cnt--;
-	info->tx_active = 1;
-
-	if (info->xmit_cnt < WAKEUP_CHARS)
-		rs_sched_event(info, RS_EVENT_WRITE_WAKEUP);
-}
-
-static void status_handle(struct dec_serial *info)
-{
-	unsigned char stat;
-
-	/* Get status from Read Register 0 */
-	stat = read_zsreg(info->zs_channel, R0);
-
-	if ((stat & BRK_ABRT) && !(info->read_reg_zero & BRK_ABRT)) {
-#if defined(CONFIG_SERIAL_DEC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ) && \
-   !defined(MODULE)
-		if (info->line == zs_console.index) {
-			if (!break_pressed)
-				break_pressed = jiffies;
-		} else
-#endif
-			info->tty_break = 1;
-	}
-
-	if (info->zs_channel != info->zs_chan_a) {
-
-		/* Check for DCD transitions */
-		if (info->tty && !C_CLOCAL(info->tty) &&
-		    ((stat ^ info->read_reg_zero) & DCD) != 0 ) {
-			if (stat & DCD) {
-				wake_up_interruptible(&info->open_wait);
-			} else {
-				tty_hangup(info->tty);
-			}
-		}
-
-		/* Check for CTS transitions */
-		if (info->tty && C_CRTSCTS(info->tty)) {
-			if ((stat & CTS) != 0) {
-				if (info->tx_stopped) {
-					info->tx_stopped = 0;
-					if (!info->tx_active)
-						transmit_chars(info);
-				}
-			} else {
-				info->tx_stopped = 1;
-			}
-		}
-
-	}
-
-	/* Clear status condition... */
-	write_zsreg(info->zs_channel, R0, RES_EXT_INT);
-	info->read_reg_zero = stat;
-}
-
-/*
- * This is the serial driver's generic interrupt routine
- */
-static irqreturn_t rs_interrupt(int irq, void *dev_id)
-{
-	struct dec_serial *info = (struct dec_serial *) dev_id;
-	irqreturn_t status = IRQ_NONE;
-	unsigned char zs_intreg;
-	int shift;
-
-	/* NOTE: The read register 3, which holds the irq status,
-	 *       does so for both channels on each chip.  Although
-	 *       the status value itself must be read from the A
-	 *       channel and is only valid when read from channel A.
-	 *       Yes... broken hardware...
-	 */
-#define CHAN_IRQMASK (CHBRxIP | CHBTxIP | CHBEXT)
-
-	if (info->zs_chan_a == info->zs_channel)
-		shift = 3;	/* Channel A */
-	else
-		shift = 0;	/* Channel B */
-
-	for (;;) {
-		zs_intreg = read_zsreg(info->zs_chan_a, R3) >> shift;
-		if ((zs_intreg & CHAN_IRQMASK) == 0)
-			break;
-
-		status = IRQ_HANDLED;
-
-		if (zs_intreg & CHBRxIP) {
-			receive_chars(info);
-		}
-		if (zs_intreg & CHBTxIP) {
-			transmit_chars(info);
-		}
-		if (zs_intreg & CHBEXT) {
-			status_handle(info);
-		}
-	}
-
-	/* Why do we need this ? */
-	write_zsreg(info->zs_channel, 0, RES_H_IUS);
-
-	return status;
-}
-
-#ifdef ZS_DEBUG_REGS
-void zs_dump (void) {
-	int i, j;
-	for (i = 0; i < zs_channels_found; i++) {
-		struct dec_zschannel *ch = &zs_channels[i];
-		if ((long)ch->control == UNI_IO_BASE+UNI_SCC1A_CTRL) {
-			for (j = 0; j < 15; j++) {
-				printk("W%d = 0x%x\t",
-				       j, (int)ch->curregs[j]);
-			}
-			for (j = 0; j < 15; j++) {
-				printk("R%d = 0x%x\t",
-				       j, (int)read_zsreg(ch,j));
-			}
-			printk("\n\n");
-		}
-	}
-}
-#endif
-
-/*
- * -------------------------------------------------------------------
- * Here ends the serial interrupt routines.
- * -------------------------------------------------------------------
- */
-
-/*
- * ------------------------------------------------------------
- * rs_stop() and rs_start()
- *
- * This routines are called before setting or resetting tty->stopped.
- * ------------------------------------------------------------
- */
-static void rs_stop(struct tty_struct *tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-	if (serial_paranoia_check(info, tty->name, "rs_stop"))
-		return;
-
-#if 1
-	spin_lock_irqsave(&zs_lock, flags);
-	if (info->zs_channel->curregs[5] & TxENAB) {
-		info->zs_channel->curregs[5] &= ~TxENAB;
-		write_zsreg(info->zs_channel, 5, info->zs_channel->curregs[5]);
-	}
-	spin_unlock_irqrestore(&zs_lock, flags);
-#endif
-}
-
-static void rs_start(struct tty_struct *tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-	if (serial_paranoia_check(info, tty->name, "rs_start"))
-		return;
-
-	spin_lock_irqsave(&zs_lock, flags);
-#if 1
-	if (info->xmit_cnt && info->xmit_buf && !(info->zs_channel->curregs[5] & TxENAB)) {
-		info->zs_channel->curregs[5] |= TxENAB;
-		write_zsreg(info->zs_channel, 5, info->zs_channel->curregs[5]);
-	}
-#else
-	if (info->xmit_cnt && info->xmit_buf && !info->tx_active) {
-		transmit_chars(info);
-	}
-#endif
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-/*
- * This routine is used to handle the "bottom half" processing for the
- * serial driver, known also the "software interrupt" processing.
- * This processing is done at the kernel interrupt level, after the
- * rs_interrupt() has returned, BUT WITH INTERRUPTS TURNED ON.  This
- * is where time-consuming activities which can not be done in the
- * interrupt driver proper are done; the interrupt driver schedules
- * them using rs_sched_event(), and they get done here.
- */
-
-static void do_softint(unsigned long private_)
-{
-	struct dec_serial	*info = (struct dec_serial *) private_;
-	struct tty_struct	*tty;
-
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(RS_EVENT_WRITE_WAKEUP, &info->event))
-		tty_wakeup(tty);
-}
-
-static int zs_startup(struct dec_serial * info)
-{
-	unsigned long flags;
-
-	if (info->flags & ZILOG_INITIALIZED)
-		return 0;
-
-	if (!info->xmit_buf) {
-		info->xmit_buf = (unsigned char *) get_zeroed_page(GFP_KERNEL);
-		if (!info->xmit_buf)
-			return -ENOMEM;
-	}
-
-	spin_lock_irqsave(&zs_lock, flags);
-
-#ifdef SERIAL_DEBUG_OPEN
-	printk("starting up ttyS%d (irq %d)...", info->line, info->irq);
-#endif
-
-	/*
-	 * Clear the receive FIFO.
-	 */
-	ZS_CLEARFIFO(info->zs_channel);
-	info->xmit_fifo_size = 1;
-
-	/*
-	 * Clear the interrupt registers.
-	 */
-	write_zsreg(info->zs_channel, R0, ERR_RES);
-	write_zsreg(info->zs_channel, R0, RES_H_IUS);
-
-	/*
-	 * Set the speed of the serial port
-	 */
-	change_speed(info);
-
-	/*
-	 * Turn on RTS and DTR.
-	 */
-	zs_rtsdtr(info, RTS | DTR, 1);
-
-	/*
-	 * Finally, enable sequencing and interrupts
-	 */
-	info->zs_channel->curregs[R1] &= ~RxINT_MASK;
-	info->zs_channel->curregs[R1] |= (RxINT_ALL | TxINT_ENAB |
-					  EXT_INT_ENAB);
-	info->zs_channel->curregs[R3] |= RxENABLE;
-	info->zs_channel->curregs[R5] |= TxENAB;
-	info->zs_channel->curregs[R15] |= (DCDIE | CTSIE | TxUIE | BRKIE);
-	write_zsreg(info->zs_channel, R1, info->zs_channel->curregs[R1]);
-	write_zsreg(info->zs_channel, R3, info->zs_channel->curregs[R3]);
-	write_zsreg(info->zs_channel, R5, info->zs_channel->curregs[R5]);
-	write_zsreg(info->zs_channel, R15, info->zs_channel->curregs[R15]);
-
-	/*
-	 * And clear the interrupt registers again for luck.
-	 */
-	write_zsreg(info->zs_channel, R0, ERR_RES);
-	write_zsreg(info->zs_channel, R0, RES_H_IUS);
-
-	/* Save the current value of RR0 */
-	info->read_reg_zero = read_zsreg(info->zs_channel, R0);
-
-	if (info->tty)
-		clear_bit(TTY_IO_ERROR, &info->tty->flags);
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-
-	info->flags |= ZILOG_INITIALIZED;
-	spin_unlock_irqrestore(&zs_lock, flags);
-	return 0;
-}
-
-/*
- * This routine will shutdown a serial port; interrupts are disabled, and
- * DTR is dropped if the hangup on close termio flag is on.
- */
-static void shutdown(struct dec_serial * info)
-{
-	unsigned long	flags;
-
-	if (!(info->flags & ZILOG_INITIALIZED))
-		return;
-
-#ifdef SERIAL_DEBUG_OPEN
-	printk("Shutting down serial port %d (irq %d)....", info->line,
-	       info->irq);
-#endif
-
-	spin_lock_irqsave(&zs_lock, flags);
-
-	if (info->xmit_buf) {
-		free_page((unsigned long) info->xmit_buf);
-		info->xmit_buf = 0;
-	}
-
-	info->zs_channel->curregs[1] = 0;
-	write_zsreg(info->zs_channel, 1, info->zs_channel->curregs[1]);	/* no interrupts */
-
-	info->zs_channel->curregs[3] &= ~RxENABLE;
-	write_zsreg(info->zs_channel, 3, info->zs_channel->curregs[3]);
-
-	info->zs_channel->curregs[5] &= ~TxENAB;
-	write_zsreg(info->zs_channel, 5, info->zs_channel->curregs[5]);
-	if (!info->tty || C_HUPCL(info->tty)) {
-		zs_rtsdtr(info, RTS | DTR, 0);
-	}
-
-	if (info->tty)
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
-
-	info->flags &= ~ZILOG_INITIALIZED;
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-/*
- * This routine is called to set the UART divisor registers to match
- * the specified baud rate for a serial port.
- */
-static void change_speed(struct dec_serial *info)
-{
-	unsigned cflag;
-	int	i;
-	int	brg, bits;
-	unsigned long flags;
-
-	if (!info->hook) {
-		if (!info->tty || !info->tty->termios)
-			return;
-		cflag = info->tty->termios->c_cflag;
-		if (!info->port)
-			return;
-	} else {
-		cflag = info->hook->cflags;
-	}
-
-	i = cflag & CBAUD;
-	if (i & CBAUDEX) {
-		i &= ~CBAUDEX;
-		if (i < 1 || i > 2) {
-			if (!info->hook)
-				info->tty->termios->c_cflag &= ~CBAUDEX;
-			else
-				info->hook->cflags &= ~CBAUDEX;
-		} else
-			i += 15;
-	}
-
-	spin_lock_irqsave(&zs_lock, flags);
-	info->zs_baud = baud_table[i];
-	if (info->zs_baud) {
-		brg = BPS_TO_BRG(info->zs_baud, zs_parms->clock/info->clk_divisor);
-		info->zs_channel->curregs[12] = (brg & 255);
-		info->zs_channel->curregs[13] = ((brg >> 8) & 255);
-		zs_rtsdtr(info, DTR, 1);
-	} else {
-		zs_rtsdtr(info, RTS | DTR, 0);
-		return;
-	}
-
-	/* byte size and parity */
-	info->zs_channel->curregs[3] &= ~RxNBITS_MASK;
-	info->zs_channel->curregs[5] &= ~TxNBITS_MASK;
-	switch (cflag & CSIZE) {
-	case CS5:
-		bits = 7;
-		info->zs_channel->curregs[3] |= Rx5;
-		info->zs_channel->curregs[5] |= Tx5;
-		break;
-	case CS6:
-		bits = 8;
-		info->zs_channel->curregs[3] |= Rx6;
-		info->zs_channel->curregs[5] |= Tx6;
-		break;
-	case CS7:
-		bits = 9;
-		info->zs_channel->curregs[3] |= Rx7;
-		info->zs_channel->curregs[5] |= Tx7;
-		break;
-	case CS8:
-	default: /* defaults to 8 bits */
-		bits = 10;
-		info->zs_channel->curregs[3] |= Rx8;
-		info->zs_channel->curregs[5] |= Tx8;
-		break;
-	}
-
-	info->timeout = ((info->xmit_fifo_size*HZ*bits) / info->zs_baud);
-        info->timeout += HZ/50;         /* Add .02 seconds of slop */
-
-	info->zs_channel->curregs[4] &= ~(SB_MASK | PAR_ENA | PAR_EVEN);
-	if (cflag & CSTOPB) {
-		info->zs_channel->curregs[4] |= SB2;
-	} else {
-		info->zs_channel->curregs[4] |= SB1;
-	}
-	if (cflag & PARENB) {
-		info->zs_channel->curregs[4] |= PAR_ENA;
-	}
-	if (!(cflag & PARODD)) {
-		info->zs_channel->curregs[4] |= PAR_EVEN;
-	}
-
-	if (!(cflag & CLOCAL)) {
-		if (!(info->zs_channel->curregs[15] & DCDIE))
-			info->read_reg_zero = read_zsreg(info->zs_channel, 0);
-		info->zs_channel->curregs[15] |= DCDIE;
-	} else
-		info->zs_channel->curregs[15] &= ~DCDIE;
-	if (cflag & CRTSCTS) {
-		info->zs_channel->curregs[15] |= CTSIE;
-		if ((read_zsreg(info->zs_channel, 0) & CTS) == 0)
-			info->tx_stopped = 1;
-	} else {
-		info->zs_channel->curregs[15] &= ~CTSIE;
-		info->tx_stopped = 0;
-	}
-
-	/* Load up the new values */
-	load_zsregs(info->zs_channel, info->zs_channel->curregs);
-
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-static void rs_flush_chars(struct tty_struct *tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-	if (serial_paranoia_check(info, tty->name, "rs_flush_chars"))
-		return;
-
-	if (info->xmit_cnt <= 0 || tty->stopped || info->tx_stopped ||
-	    !info->xmit_buf)
-		return;
-
-	/* Enable transmitter */
-	spin_lock_irqsave(&zs_lock, flags);
-	transmit_chars(info);
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-static int rs_write(struct tty_struct * tty,
-		    const unsigned char *buf, int count)
-{
-	int	c, total = 0;
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-	if (serial_paranoia_check(info, tty->name, "rs_write"))
-		return 0;
-
-	if (!tty || !info->xmit_buf)
-		return 0;
-
-	while (1) {
-		spin_lock_irqsave(&zs_lock, flags);
-		c = min(count, min(SERIAL_XMIT_SIZE - info->xmit_cnt - 1,
-				   SERIAL_XMIT_SIZE - info->xmit_head));
-		if (c <= 0)
-			break;
-
-		memcpy(info->xmit_buf + info->xmit_head, buf, c);
-		info->xmit_head = (info->xmit_head + c) & (SERIAL_XMIT_SIZE-1);
-		info->xmit_cnt += c;
-		spin_unlock_irqrestore(&zs_lock, flags);
-		buf += c;
-		count -= c;
-		total += c;
-	}
-
-	if (info->xmit_cnt && !tty->stopped && !info->tx_stopped
-	    && !info->tx_active)
-		transmit_chars(info);
-	spin_unlock_irqrestore(&zs_lock, flags);
-	return total;
-}
-
-static int rs_write_room(struct tty_struct *tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	int	ret;
-
-	if (serial_paranoia_check(info, tty->name, "rs_write_room"))
-		return 0;
-	ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
-	if (ret < 0)
-		ret = 0;
-	return ret;
-}
-
-static int rs_chars_in_buffer(struct tty_struct *tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-
-	if (serial_paranoia_check(info, tty->name, "rs_chars_in_buffer"))
-		return 0;
-	return info->xmit_cnt;
-}
-
-static void rs_flush_buffer(struct tty_struct *tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-
-	if (serial_paranoia_check(info, tty->name, "rs_flush_buffer"))
-		return;
-	spin_lock_irq(&zs_lock);
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-	spin_unlock_irq(&zs_lock);
-	tty_wakeup(tty);
-}
-
-/*
- * ------------------------------------------------------------
- * rs_throttle()
- *
- * This routine is called by the upper-layer tty layer to signal that
- * incoming characters should be throttled.
- * ------------------------------------------------------------
- */
-static void rs_throttle(struct tty_struct * tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-#ifdef SERIAL_DEBUG_THROTTLE
-	char	buf[64];
-
-	printk("throttle %s: %d....\n", _tty_name(tty, buf),
-	       tty->ldisc.chars_in_buffer(tty));
-#endif
-
-	if (serial_paranoia_check(info, tty->name, "rs_throttle"))
-		return;
-
-	if (I_IXOFF(tty)) {
-		spin_lock_irqsave(&zs_lock, flags);
-		info->x_char = STOP_CHAR(tty);
-		if (!info->tx_active)
-			transmit_chars(info);
-		spin_unlock_irqrestore(&zs_lock, flags);
-	}
-
-	if (C_CRTSCTS(tty)) {
-		zs_rtsdtr(info, RTS, 0);
-	}
-}
-
-static void rs_unthrottle(struct tty_struct * tty)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-#ifdef SERIAL_DEBUG_THROTTLE
-	char	buf[64];
-
-	printk("unthrottle %s: %d....\n", _tty_name(tty, buf),
-	       tty->ldisc.chars_in_buffer(tty));
-#endif
-
-	if (serial_paranoia_check(info, tty->name, "rs_unthrottle"))
-		return;
-
-	if (I_IXOFF(tty)) {
-		spin_lock_irqsave(&zs_lock, flags);
-		if (info->x_char)
-			info->x_char = 0;
-		else {
-			info->x_char = START_CHAR(tty);
-			if (!info->tx_active)
-				transmit_chars(info);
-		}
-		spin_unlock_irqrestore(&zs_lock, flags);
-	}
-
-	if (C_CRTSCTS(tty)) {
-		zs_rtsdtr(info, RTS, 1);
-	}
-}
-
-/*
- * ------------------------------------------------------------
- * rs_ioctl() and friends
- * ------------------------------------------------------------
- */
-
-static int get_serial_info(struct dec_serial * info,
-			   struct serial_struct * retinfo)
-{
-	struct serial_struct tmp;
-
-	if (!retinfo)
-		return -EFAULT;
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->line;
-	tmp.port = info->port;
-	tmp.irq = info->irq;
-	tmp.flags = info->flags;
-	tmp.baud_base = info->baud_base;
-	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
-	tmp.custom_divisor = info->custom_divisor;
-	return copy_to_user(retinfo,&tmp,sizeof(*retinfo)) ? -EFAULT : 0;
-}
-
-static int set_serial_info(struct dec_serial * info,
-			   struct serial_struct * new_info)
-{
-	struct serial_struct new_serial;
-	struct dec_serial old_info;
-	int 			retval = 0;
-
-	if (!new_info)
-		return -EFAULT;
-	copy_from_user(&new_serial,new_info,sizeof(new_serial));
-	old_info = *info;
-
-	if (!capable(CAP_SYS_ADMIN)) {
-		if ((new_serial.baud_base != info->baud_base) ||
-		    (new_serial.type != info->type) ||
-		    (new_serial.close_delay != info->close_delay) ||
-		    ((new_serial.flags & ~ZILOG_USR_MASK) !=
-		     (info->flags & ~ZILOG_USR_MASK)))
-			return -EPERM;
-		info->flags = ((info->flags & ~ZILOG_USR_MASK) |
-			       (new_serial.flags & ZILOG_USR_MASK));
-		info->custom_divisor = new_serial.custom_divisor;
-		goto check_and_exit;
-	}
-
-	if (info->count > 1)
-		return -EBUSY;
-
-	/*
-	 * OK, past this point, all the error checking has been done.
-	 * At this point, we start making changes.....
-	 */
-
-	info->baud_base = new_serial.baud_base;
-	info->flags = ((info->flags & ~ZILOG_FLAGS) |
-			(new_serial.flags & ZILOG_FLAGS));
-	info->type = new_serial.type;
-	info->close_delay = new_serial.close_delay;
-	info->closing_wait = new_serial.closing_wait;
-
-check_and_exit:
-	retval = zs_startup(info);
-	return retval;
-}
-
-/*
- * get_lsr_info - get line status register info
- *
- * Purpose: Let user call ioctl() to get info when the UART physically
- * 	    is emptied.  On bus types like RS485, the transmitter must
- * 	    release the bus after transmitting. This must be done when
- * 	    the transmit shift register is empty, not be done when the
- * 	    transmit holding register is empty.  This functionality
- * 	    allows an RS485 driver to be written in user space.
- */
-static int get_lsr_info(struct dec_serial * info, unsigned int *value)
-{
-	unsigned char status;
-
-	spin_lock(&zs_lock);
-	status = read_zsreg(info->zs_channel, 0);
-	spin_unlock_irq(&zs_lock);
-	put_user(status,value);
-	return 0;
-}
-
-static int rs_tiocmget(struct tty_struct *tty, struct file *file)
-{
-	struct dec_serial * info = (struct dec_serial *)tty->driver_data;
-	unsigned char control, status_a, status_b;
-	unsigned int result;
-
-	if (info->hook)
-		return -ENODEV;
-
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
-		return -ENODEV;
-
-	if (tty->flags & (1 << TTY_IO_ERROR))
-		return -EIO;
-
-	if (info->zs_channel == info->zs_chan_a)
-		result = 0;
-	else {
-		spin_lock(&zs_lock);
-		control = info->zs_chan_a->curregs[5];
-		status_a = read_zsreg(info->zs_chan_a, 0);
-		status_b = read_zsreg(info->zs_channel, 0);
-		spin_unlock_irq(&zs_lock);
-		result =  ((control  & RTS) ? TIOCM_RTS: 0)
-			| ((control  & DTR) ? TIOCM_DTR: 0)
-			| ((status_b & DCD) ? TIOCM_CAR: 0)
-			| ((status_a & DCD) ? TIOCM_RNG: 0)
-			| ((status_a & SYNC_HUNT) ? TIOCM_DSR: 0)
-			| ((status_b & CTS) ? TIOCM_CTS: 0);
-	}
-	return result;
-}
-
-static int rs_tiocmset(struct tty_struct *tty, struct file *file,
-                       unsigned int set, unsigned int clear)
-{
-	struct dec_serial * info = (struct dec_serial *)tty->driver_data;
-
-	if (info->hook)
-		return -ENODEV;
-
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
-		return -ENODEV;
-
-	if (tty->flags & (1 << TTY_IO_ERROR))
-		return -EIO;
-
-	if (info->zs_channel == info->zs_chan_a)
-		return 0;
-
-	spin_lock(&zs_lock);
-	if (set & TIOCM_RTS)
-		info->zs_chan_a->curregs[5] |= RTS;
-	if (set & TIOCM_DTR)
-		info->zs_chan_a->curregs[5] |= DTR;
-	if (clear & TIOCM_RTS)
-		info->zs_chan_a->curregs[5] &= ~RTS;
-	if (clear & TIOCM_DTR)
-		info->zs_chan_a->curregs[5] &= ~DTR;
-	write_zsreg(info->zs_chan_a, 5, info->zs_chan_a->curregs[5]);
-	spin_unlock_irq(&zs_lock);
-	return 0;
-}
-
-/*
- * rs_break - turn transmit break condition on/off
- */
-static void rs_break(struct tty_struct *tty, int break_state)
-{
-	struct dec_serial *info = (struct dec_serial *) tty->driver_data;
-	unsigned long flags;
-
-	if (serial_paranoia_check(info, tty->name, "rs_break"))
-		return;
-	if (!info->port)
-		return;
-
-	spin_lock_irqsave(&zs_lock, flags);
-	if (break_state == -1)
-		info->zs_channel->curregs[5] |= SND_BRK;
-	else
-		info->zs_channel->curregs[5] &= ~SND_BRK;
-	write_zsreg(info->zs_channel, 5, info->zs_channel->curregs[5]);
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-static int rs_ioctl(struct tty_struct *tty, struct file * file,
-		    unsigned int cmd, unsigned long arg)
-{
-	struct dec_serial * info = (struct dec_serial *)tty->driver_data;
-
-	if (info->hook)
-		return -ENODEV;
-
-	if (serial_paranoia_check(info, tty->name, "rs_ioctl"))
-		return -ENODEV;
-
-	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
-	    (cmd != TIOCSERCONFIG) && (cmd != TIOCSERGWILD)  &&
-	    (cmd != TIOCSERSWILD) && (cmd != TIOCSERGSTRUCT)) {
-		if (tty->flags & (1 << TTY_IO_ERROR))
-		    return -EIO;
-	}
-
-	switch (cmd) {
-	case TIOCGSERIAL:
-		if (!access_ok(VERIFY_WRITE, (void *)arg,
-			       sizeof(struct serial_struct)))
-			return -EFAULT;
-		return get_serial_info(info, (struct serial_struct *)arg);
-
-	case TIOCSSERIAL:
-		return set_serial_info(info, (struct serial_struct *)arg);
-
-	case TIOCSERGETLSR:			/* Get line status register */
-		if (!access_ok(VERIFY_WRITE, (void *)arg,
-			       sizeof(unsigned int)))
-			return -EFAULT;
-		return get_lsr_info(info, (unsigned int *)arg);
-
-	case TIOCSERGSTRUCT:
-		if (!access_ok(VERIFY_WRITE, (void *)arg,
-			       sizeof(struct dec_serial)))
-			return -EFAULT;
-		copy_from_user((struct dec_serial *)arg, info,
-			       sizeof(struct dec_serial));
-		return 0;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
-	return 0;
-}
-
-static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
-{
-	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
-	int was_stopped;
-
-	if (tty->termios->c_cflag == old_termios->c_cflag)
-		return;
-	was_stopped = info->tx_stopped;
-
-	change_speed(info);
-
-	if (was_stopped && !info->tx_stopped)
-		rs_start(tty);
-}
-
-/*
- * ------------------------------------------------------------
- * rs_close()
- *
- * This routine is called when the serial port gets closed.
- * Wait for the last remaining data to be sent.
- * ------------------------------------------------------------
- */
-static void rs_close(struct tty_struct *tty, struct file * filp)
-{
-	struct dec_serial * info = (struct dec_serial *)tty->driver_data;
-	unsigned long flags;
-
-	if (!info || serial_paranoia_check(info, tty->name, "rs_close"))
-		return;
-
-	spin_lock_irqsave(&zs_lock, flags);
-
-	if (tty_hung_up_p(filp)) {
-		spin_unlock_irqrestore(&zs_lock, flags);
-		return;
-	}
-
-#ifdef SERIAL_DEBUG_OPEN
-	printk("rs_close ttyS%d, count = %d\n", info->line, info->count);
-#endif
-	if ((tty->count == 1) && (info->count != 1)) {
-		/*
-		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  Info->count should always
-		 * be one in these conditions.  If it's greater than
-		 * one, we've got real problems, since it means the
-		 * serial port won't be shutdown.
-		 */
-		printk("rs_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
-		info->count = 1;
-	}
-	if (--info->count < 0) {
-		printk("rs_close: bad serial port count for ttyS%d: %d\n",
-		       info->line, info->count);
-		info->count = 0;
-	}
-	if (info->count) {
-		spin_unlock_irqrestore(&zs_lock, flags);
-		return;
-	}
-	info->flags |= ZILOG_CLOSING;
-	/*
-	 * Now we wait for the transmit buffer to clear; and we notify
-	 * the line discipline to only process XON/XOFF characters.
-	 */
-	tty->closing = 1;
-	if (info->closing_wait != ZILOG_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
-	/*
-	 * At this point we stop accepting input.  To do this, we
-	 * disable the receiver and receive interrupts.
-	 */
-	info->zs_channel->curregs[3] &= ~RxENABLE;
-	write_zsreg(info->zs_channel, 3, info->zs_channel->curregs[3]);
-	info->zs_channel->curregs[1] = 0;	/* disable any rx ints */
-	write_zsreg(info->zs_channel, 1, info->zs_channel->curregs[1]);
-	ZS_CLEARFIFO(info->zs_channel);
-	if (info->flags & ZILOG_INITIALIZED) {
-		/*
-		 * Before we drop DTR, make sure the SCC transmitter
-		 * has completely drained.
-		 */
-		rs_wait_until_sent(tty, info->timeout);
-	}
-
-	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-	tty_ldisc_flush(tty);
-	tty->closing = 0;
-	info->event = 0;
-	info->tty = 0;
-	if (info->blocked_open) {
-		if (info->close_delay) {
-			msleep_interruptible(jiffies_to_msecs(info->close_delay));
-		}
-		wake_up_interruptible(&info->open_wait);
-	}
-	info->flags &= ~(ZILOG_NORMAL_ACTIVE|ZILOG_CLOSING);
-	wake_up_interruptible(&info->close_wait);
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-/*
- * rs_wait_until_sent() --- wait until the transmitter is empty
- */
-static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
-{
-	struct dec_serial *info = (struct dec_serial *) tty->driver_data;
-	unsigned long orig_jiffies;
-	int char_time;
-
-	if (serial_paranoia_check(info, tty->name, "rs_wait_until_sent"))
-		return;
-
-	orig_jiffies = jiffies;
-	/*
-	 * Set the check interval to be 1/5 of the estimated time to
-	 * send a single character, and make it at least 1.  The check
-	 * interval should also be less than the timeout.
-	 */
-	char_time = (info->timeout - HZ/50) / info->xmit_fifo_size;
-	char_time = char_time / 5;
-	if (char_time == 0)
-		char_time = 1;
-	if (timeout)
-		char_time = min(char_time, timeout);
-	while ((read_zsreg(info->zs_channel, 1) & Tx_BUF_EMP) == 0) {
-		msleep_interruptible(jiffies_to_msecs(char_time));
-		if (signal_pending(current))
-			break;
-		if (timeout && time_after(jiffies, orig_jiffies + timeout))
-			break;
-	}
-	current->state = TASK_RUNNING;
-}
-
-/*
- * rs_hangup() --- called by tty_hangup() when a hangup is signaled.
- */
-static void rs_hangup(struct tty_struct *tty)
-{
-	struct dec_serial * info = (struct dec_serial *)tty->driver_data;
-
-	if (serial_paranoia_check(info, tty->name, "rs_hangup"))
-		return;
-
-	rs_flush_buffer(tty);
-	shutdown(info);
-	info->event = 0;
-	info->count = 0;
-	info->flags &= ~ZILOG_NORMAL_ACTIVE;
-	info->tty = 0;
-	wake_up_interruptible(&info->open_wait);
-}
-
-/*
- * ------------------------------------------------------------
- * rs_open() and friends
- * ------------------------------------------------------------
- */
-static int block_til_ready(struct tty_struct *tty, struct file * filp,
-			   struct dec_serial *info)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	int		retval;
-	int		do_clocal = 0;
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (info->flags & ZILOG_CLOSING) {
-		interruptible_sleep_on(&info->close_wait);
-#ifdef SERIAL_DO_RESTART
-		return ((info->flags & ZILOG_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
-	 * If non-blocking mode is set, or the port is not enabled,
-	 * then make the check up front and then exit.
-	 */
-	if ((filp->f_flags & O_NONBLOCK) ||
-	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ZILOG_NORMAL_ACTIVE;
-		return 0;
-	}
-
-	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
-
-	/*
-	 * Block waiting for the carrier detect and the line to become
-	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->count is dropped by one, so that
-	 * rs_close() knows when to free things.  We restore it upon
-	 * exit, either normal or abnormal.
-	 */
-	retval = 0;
-	add_wait_queue(&info->open_wait, &wait);
-#ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready before block: ttyS%d, count = %d\n",
-	       info->line, info->count);
-#endif
-	spin_lock(&zs_lock);
-	if (!tty_hung_up_p(filp))
-		info->count--;
-	spin_unlock_irq(&zs_lock);
-	info->blocked_open++;
-	while (1) {
-		spin_lock(&zs_lock);
-		if (tty->termios->c_cflag & CBAUD)
-			zs_rtsdtr(info, RTS | DTR, 1);
-		spin_unlock_irq(&zs_lock);
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ZILOG_INITIALIZED)) {
-#ifdef SERIAL_DO_RESTART
-			if (info->flags & ZILOG_HUP_NOTIFY)
-				retval = -EAGAIN;
-			else
-				retval = -ERESTARTSYS;
-#else
-			retval = -EAGAIN;
-#endif
-			break;
-		}
-		if (!(info->flags & ZILOG_CLOSING) &&
-		    (do_clocal || (read_zsreg(info->zs_channel, 0) & DCD)))
-			break;
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-#ifdef SERIAL_DEBUG_OPEN
-		printk("block_til_ready blocking: ttyS%d, count = %d\n",
-		       info->line, info->count);
-#endif
-		schedule();
-	}
-	current->state = TASK_RUNNING;
-	remove_wait_queue(&info->open_wait, &wait);
-	if (!tty_hung_up_p(filp))
-		info->count++;
-	info->blocked_open--;
-#ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready after blocking: ttyS%d, count = %d\n",
-	       info->line, info->count);
-#endif
-	if (retval)
-		return retval;
-	info->flags |= ZILOG_NORMAL_ACTIVE;
-	return 0;
-}
-
-/*
- * This routine is called whenever a serial port is opened.  It
- * enables interrupts for a serial port, linking in its ZILOG structure into
- * the IRQ chain.   It also performs the serial-specific
- * initialization for the tty structure.
- */
-static int rs_open(struct tty_struct *tty, struct file * filp)
-{
-	struct dec_serial	*info;
-	int 			retval, line;
-
-	line = tty->index;
-	if ((line < 0) || (line >= zs_channels_found))
-		return -ENODEV;
-	info = zs_soft + line;
-
-	if (info->hook)
-		return -ENODEV;
-
-	if (serial_paranoia_check(info, tty->name, "rs_open"))
-		return -ENODEV;
-#ifdef SERIAL_DEBUG_OPEN
-	printk("rs_open %s, count = %d\n", tty->name, info->count);
-#endif
-
-	info->count++;
-	tty->driver_data = info;
-	info->tty = tty;
-
-	/*
-	 * If the port is the middle of closing, bail out now
-	 */
-	if (tty_hung_up_p(filp) ||
-	    (info->flags & ZILOG_CLOSING)) {
-		if (info->flags & ZILOG_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
-#ifdef SERIAL_DO_RESTART
-		return ((info->flags & ZILOG_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
-	 * Start up serial port
-	 */
-	retval = zs_startup(info);
-	if (retval)
-		return retval;
-
-	retval = block_til_ready(tty, filp, info);
-	if (retval) {
-#ifdef SERIAL_DEBUG_OPEN
-		printk("rs_open returning after block_til_ready with %d\n",
-		       retval);
-#endif
-		return retval;
-	}
-
-#ifdef CONFIG_SERIAL_DEC_CONSOLE
-	if (zs_console.cflag && zs_console.index == line) {
-		tty->termios->c_cflag = zs_console.cflag;
-		zs_console.cflag = 0;
-		change_speed(info);
-	}
-#endif
-
-#ifdef SERIAL_DEBUG_OPEN
-	printk("rs_open %s successful...", tty->name);
-#endif
-/* tty->low_latency = 1; */
-	return 0;
-}
-
-/* Finally, routines used to initialize the serial driver. */
-
-static void __init show_serial_version(void)
-{
-	printk("DECstation Z8530 serial driver version 0.09\n");
-}
-
-/*  Initialize Z8530s zs_channels
- */
-
-static void __init probe_sccs(void)
-{
-	struct dec_serial **pp;
-	int i, n, n_chips = 0, n_channels, chip, channel;
-	unsigned long flags;
-
-	/*
-	 * did we get here by accident?
-	 */
-	if(!BUS_PRESENT) {
-		printk("Not on JUNKIO machine, skipping probe_sccs\n");
-		return;
-	}
-
-	switch(mips_machtype) {
-#ifdef CONFIG_MACH_DECSTATION
-	case MACH_DS5000_2X0:
-	case MACH_DS5900:
-		n_chips = 2;
-		zs_parms = &ds_parms;
-		zs_parms->irq0 = dec_interrupt[DEC_IRQ_SCC0];
-		zs_parms->irq1 = dec_interrupt[DEC_IRQ_SCC1];
-		break;
-	case MACH_DS5000_1XX:
-		n_chips = 2;
-		zs_parms = &ds_parms;
-		zs_parms->irq0 = dec_interrupt[DEC_IRQ_SCC0];
-		zs_parms->irq1 = dec_interrupt[DEC_IRQ_SCC1];
-		break;
-	case MACH_DS5000_XX:
-		n_chips = 1;
-		zs_parms = &ds_parms;
-		zs_parms->irq0 = dec_interrupt[DEC_IRQ_SCC0];
-		break;
-#endif
-	default:
-		panic("zs: unsupported bus");
-	}
-	if (!zs_parms)
-		panic("zs: uninitialized parms");
-
-	pp = &zs_chain;
-
-	n_channels = 0;
-
-	for (chip = 0; chip < n_chips; chip++) {
-		for (channel = 0; channel <= 1; channel++) {
-			/*
-			 * The sccs reside on the high byte of the 16 bit IOBUS
-			 */
-			zs_channels[n_channels].control =
-				(volatile void *)CKSEG1ADDR(dec_kn_slot_base +
-			  (0 == chip ? zs_parms->scc0 : zs_parms->scc1) +
-			  (0 == channel ? zs_parms->channel_a_offset :
-			                  zs_parms->channel_b_offset));
-			zs_channels[n_channels].data =
-				zs_channels[n_channels].control + 4;
-
-#ifndef CONFIG_SERIAL_DEC_CONSOLE
-			/*
-			 * We're called early and memory managment isn't up, yet.
-			 * Thus request_region would fail.
-			 */
-			if (!request_region((unsigned long)
-					 zs_channels[n_channels].control,
-					 ZS_CHAN_IO_SIZE, "SCC"))
-				panic("SCC I/O region is not free");
-#endif
-			zs_soft[n_channels].zs_channel = &zs_channels[n_channels];
-			/* HACK alert! */
-			if (!(chip & 1))
-				zs_soft[n_channels].irq = zs_parms->irq0;
-			else
-				zs_soft[n_channels].irq = zs_parms->irq1;
-
-			/*
-			 *  Identification of channel A. Location of channel A
-                         *  inside chip depends on mapping of internal address
-			 *  the chip decodes channels by.
-			 *  CHANNEL_A_NR returns either 0 (in case of
-			 *  DECstations) or 1 (in case of Baget).
-			 */
-			if (CHANNEL_A_NR == channel)
-				zs_soft[n_channels].zs_chan_a =
-				    &zs_channels[n_channels+1-2*CHANNEL_A_NR];
-			else
-				zs_soft[n_channels].zs_chan_a =
-				    &zs_channels[n_channels];
-
-			*pp = &zs_soft[n_channels];
-			pp = &zs_soft[n_channels].zs_next;
-			n_channels++;
-		}
-	}
-
-	*pp = 0;
-	zs_channels_found = n_channels;
-
-	for (n = 0; n < zs_channels_found; n++) {
-		for (i = 0; i < 16; i++) {
-			zs_soft[n].zs_channel->curregs[i] = zs_init_regs[i];
-		}
-	}
-
-	spin_lock_irqsave(&zs_lock, flags);
-	for (n = 0; n < zs_channels_found; n++) {
-		if (n % 2 == 0) {
-			write_zsreg(zs_soft[n].zs_chan_a, R9, FHWRES);
-			udelay(10);
-			write_zsreg(zs_soft[n].zs_chan_a, R9, 0);
-		}
-		load_zsregs(zs_soft[n].zs_channel,
-			    zs_soft[n].zs_channel->curregs);
-	}
-	spin_unlock_irqrestore(&zs_lock, flags);
-}
-
-static const struct tty_operations serial_ops = {
-	.open = rs_open,
-	.close = rs_close,
-	.write = rs_write,
-	.flush_chars = rs_flush_chars,
-	.write_room = rs_write_room,
-	.chars_in_buffer = rs_chars_in_buffer,
-	.flush_buffer = rs_flush_buffer,
-	.ioctl = rs_ioctl,
-	.throttle = rs_throttle,
-	.unthrottle = rs_unthrottle,
-	.set_termios = rs_set_termios,
-	.stop = rs_stop,
-	.start = rs_start,
-	.hangup = rs_hangup,
-	.break_ctl = rs_break,
-	.wait_until_sent = rs_wait_until_sent,
-	.tiocmget = rs_tiocmget,
-	.tiocmset = rs_tiocmset,
-};
-
-/* zs_init inits the driver */
-int __init zs_init(void)
-{
-	int channel, i;
-	struct dec_serial *info;
-
-	if(!BUS_PRESENT)
-		return -ENODEV;
-
-	/* Find out how many Z8530 SCCs we have */
-	if (zs_chain == 0)
-		probe_sccs();
-	serial_driver = alloc_tty_driver(zs_channels_found);
-	if (!serial_driver)
-		return -ENOMEM;
-
-	show_serial_version();
-
-	/* Initialize the tty_driver structure */
-	/* Not all of this is exactly right for us. */
-
-	serial_driver->owner = THIS_MODULE;
-	serial_driver->name = "ttyS";
-	serial_driver->major = TTY_MAJOR;
-	serial_driver->minor_start = 64;
-	serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
-	serial_driver->subtype = SERIAL_TYPE_NORMAL;
-	serial_driver->init_termios = tty_std_termios;
-	serial_driver->init_termios.c_cflag =
-		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-	serial_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
-	tty_set_operations(serial_driver, &serial_ops);
-
-	if (tty_register_driver(serial_driver))
-		panic("Couldn't register serial driver");
-
-	for (info = zs_chain, i = 0; info; info = info->zs_next, i++) {
-
-		/* Needed before interrupts are enabled. */
-		info->tty = 0;
-		info->x_char = 0;
-
-		if (info->hook && info->hook->init_info) {
-			(*info->hook->init_info)(info);
-			continue;
-		}
-
-		info->magic = SERIAL_MAGIC;
-		info->port = (int) info->zs_channel->control;
-		info->line = i;
-		info->custom_divisor = 16;
-		info->close_delay = 50;
-		info->closing_wait = 3000;
-		info->event = 0;
-		info->count = 0;
-		info->blocked_open = 0;
-		tasklet_init(&info->tlet, do_softint, (unsigned long)info);
-		init_waitqueue_head(&info->open_wait);
-		init_waitqueue_head(&info->close_wait);
-		printk("ttyS%02d at 0x%08x (irq = %d) is a Z85C30 SCC\n",
-		       info->line, info->port, info->irq);
-		tty_register_device(serial_driver, info->line, NULL);
-
-	}
-
-	for (channel = 0; channel < zs_channels_found; ++channel) {
-		zs_soft[channel].clk_divisor = 16;
-		zs_soft[channel].zs_baud = get_zsbaud(&zs_soft[channel]);
-
-		if (request_irq(zs_soft[channel].irq, rs_interrupt, IRQF_SHARED,
-				"scc", &zs_soft[channel]))
-			printk(KERN_ERR "decserial: can't get irq %d\n",
-			       zs_soft[channel].irq);
-
-		if (zs_soft[channel].hook) {
-			zs_startup(&zs_soft[channel]);
-			if (zs_soft[channel].hook->init_channel)
-				(*zs_soft[channel].hook->init_channel)
-					(&zs_soft[channel]);
-		}
-	}
-
-	return 0;
-}
-
-/*
- * polling I/O routines
- */
-static int zs_poll_tx_char(void *handle, unsigned char ch)
-{
-	struct dec_serial *info = handle;
-	struct dec_zschannel *chan = info->zs_channel;
-	int    ret;
-
-	if(chan) {
-		int loops = 10000;
-
-		while (loops && !(read_zsreg(chan, 0) & Tx_BUF_EMP))
-			loops--;
-
-		if (loops) {
-			write_zsdata(chan, ch);
-			ret = 0;
-		} else
-			ret = -EAGAIN;
-
-		return ret;
-	} else
-		return -ENODEV;
-}
-
-static int zs_poll_rx_char(void *handle)
-{
-	struct dec_serial *info = handle;
-        struct dec_zschannel *chan = info->zs_channel;
-        int    ret;
-
-	if(chan) {
-                int loops = 10000;
-
-		while (loops && !(read_zsreg(chan, 0) & Rx_CH_AV))
-			loops--;
-
-                if (loops)
-                        ret = read_zsdata(chan);
-                else
-                        ret = -EAGAIN;
-
-		return ret;
-	} else
-		return -ENODEV;
-}
-
-int register_zs_hook(unsigned int channel, struct dec_serial_hook *hook)
-{
-	struct dec_serial *info = &zs_soft[channel];
-
-	if (info->hook) {
-		printk("%s: line %d has already a hook registered\n",
-		       __FUNCTION__, channel);
-
-		return 0;
-	} else {
-		hook->poll_rx_char = zs_poll_rx_char;
-		hook->poll_tx_char = zs_poll_tx_char;
-		info->hook = hook;
-
-		return 1;
-	}
-}
-
-int unregister_zs_hook(unsigned int channel)
-{
-	struct dec_serial *info = &zs_soft[channel];
-
-        if (info->hook) {
-                info->hook = NULL;
-                return 1;
-        } else {
-                printk("%s: trying to unregister hook on line %d,"
-                       " but none is registered\n", __FUNCTION__, channel);
-                return 0;
-        }
-}
-
-/*
- * ------------------------------------------------------------
- * Serial console driver
- * ------------------------------------------------------------
- */
-#ifdef CONFIG_SERIAL_DEC_CONSOLE
-
-
-/*
- *	Print a string to the serial port trying not to disturb
- *	any possible real use of the port...
- */
-static void serial_console_write(struct console *co, const char *s,
-				 unsigned count)
-{
-	struct dec_serial *info;
-	int i;
-
-	info = zs_soft + co->index;
-
-	for (i = 0; i < count; i++, s++) {
-		if(*s == '\n')
-			zs_poll_tx_char(info, '\r');
-		zs_poll_tx_char(info, *s);
-	}
-}
-
-static struct tty_driver *serial_console_device(struct console *c, int *index)
-{
-	*index = c->index;
-	return serial_driver;
-}
-
-/*
- *	Setup initial baud/bits/parity. We do two things here:
- *	- construct a cflag setting for the first rs_open()
- *	- initialize the serial port
- *	Return non-zero if we didn't find a serial port.
- */
-static int __init serial_console_setup(struct console *co, char *options)
-{
-	struct dec_serial *info;
-	int baud = 9600;
-	int bits = 8;
-	int parity = 'n';
-	int cflag = CREAD | HUPCL | CLOCAL;
-	int clk_divisor = 16;
-	int brg;
-	char *s;
-	unsigned long flags;
-
-	if(!BUS_PRESENT)
-		return -ENODEV;
-
-	info = zs_soft + co->index;
-
-	if (zs_chain == 0)
-		probe_sccs();
-
-	info->is_cons = 1;
-
-	if (options) {
-		baud = simple_strtoul(options, NULL, 10);
-		s = options;
-		while(*s >= '0' && *s <= '9')
-			s++;
-		if (*s)
-			parity = *s++;
-		if (*s)
-			bits   = *s - '0';
-	}
-
-	/*
-	 *	Now construct a cflag setting.
-	 */
-	switch(baud) {
-	case 1200:
-		cflag |= B1200;
-		break;
-	case 2400:
-		cflag |= B2400;
-		break;
-	case 4800:
-		cflag |= B4800;
-		break;
-	case 19200:
-		cflag |= B19200;
-		break;
-	case 38400:
-		cflag |= B38400;
-		break;
-	case 57600:
-		cflag |= B57600;
-		break;
-	case 115200:
-		cflag |= B115200;
-		break;
-	case 9600:
-	default:
-		cflag |= B9600;
-		/*
-		 * Set this to a sane value to prevent a divide error.
-		 */
-		baud  = 9600;
-		break;
-	}
-	switch(bits) {
-	case 7:
-		cflag |= CS7;
-		break;
-	default:
-	case 8:
-		cflag |= CS8;
-		break;
-	}
-	switch(parity) {
-	case 'o': case 'O':
-		cflag |= PARODD;
-		break;
-	case 'e': case 'E':
-		cflag |= PARENB;
-		break;
-	}
-	co->cflag = cflag;
-
-	spin_lock_irqsave(&zs_lock, flags);
-
-	/*
-	 * Set up the baud rate generator.
-	 */
-	brg = BPS_TO_BRG(baud, zs_parms->clock / clk_divisor);
-	info->zs_channel->curregs[R12] = (brg & 255);
-	info->zs_channel->curregs[R13] = ((brg >> 8) & 255);
-
-	/*
-	 * Set byte size and parity.
-	 */
-	if (bits == 7) {
-		info->zs_channel->curregs[R3] |= Rx7;
-		info->zs_channel->curregs[R5] |= Tx7;
-	} else {
-		info->zs_channel->curregs[R3] |= Rx8;
-		info->zs_channel->curregs[R5] |= Tx8;
-	}
-	if (cflag & PARENB) {
-		info->zs_channel->curregs[R4] |= PAR_ENA;
-	}
-	if (!(cflag & PARODD)) {
-		info->zs_channel->curregs[R4] |= PAR_EVEN;
-	}
-	info->zs_channel->curregs[R4] |= SB1;
-
-	/*
-	 * Turn on RTS and DTR.
-	 */
-	zs_rtsdtr(info, RTS | DTR, 1);
-
-	/*
-	 * Finally, enable sequencing.
-	 */
-	info->zs_channel->curregs[R3] |= RxENABLE;
-	info->zs_channel->curregs[R5] |= TxENAB;
-
-	/*
-	 * Clear the interrupt registers.
-	 */
-	write_zsreg(info->zs_channel, R0, ERR_RES);
-	write_zsreg(info->zs_channel, R0, RES_H_IUS);
-
-	/*
-	 * Load up the new values.
-	 */
-	load_zsregs(info->zs_channel, info->zs_channel->curregs);
-
-	/* Save the current value of RR0 */
-	info->read_reg_zero = read_zsreg(info->zs_channel, R0);
-
-	zs_soft[co->index].clk_divisor = clk_divisor;
-	zs_soft[co->index].zs_baud = get_zsbaud(&zs_soft[co->index]);
-
-	spin_unlock_irqrestore(&zs_lock, flags);
-
-	return 0;
-}
-
-static struct console zs_console = {
-	.name		= "ttyS",
-	.write		= serial_console_write,
-	.device		= serial_console_device,
-	.setup		= serial_console_setup,
-	.flags		= CON_PRINTBUFFER,
-	.index		= -1,
-};
-
-/*
- *	Register console.
- */
-void __init zs_serial_console_init(void)
-{
-	register_console(&zs_console);
-}
-#endif /* ifdef CONFIG_SERIAL_DEC_CONSOLE */
-
-#ifdef CONFIG_KGDB
-struct dec_zschannel *zs_kgdbchan;
-static unsigned char scc_inittab[] = {
-	9,  0x80,	/* reset A side (CHRA) */
-	13, 0,		/* set baud rate divisor */
-	12, 1,
-	14, 1,		/* baud rate gen enable, src=rtxc (BRENABL) */
-	11, 0x50,	/* clocks = br gen (RCBR | TCBR) */
-	5,  0x6a,	/* tx 8 bits, assert RTS (Tx8 | TxENAB | RTS) */
-	4,  0x44,	/* x16 clock, 1 stop (SB1 | X16CLK)*/
-	3,  0xc1,	/* rx enable, 8 bits (RxENABLE | Rx8)*/
-};
-
-/* These are for receiving and sending characters under the kgdb
- * source level kernel debugger.
- */
-void putDebugChar(char kgdb_char)
-{
-	struct dec_zschannel *chan = zs_kgdbchan;
-	while ((read_zsreg(chan, 0) & Tx_BUF_EMP) == 0)
-		RECOVERY_DELAY;
-	write_zsdata(chan, kgdb_char);
-}
-char getDebugChar(void)
-{
-	struct dec_zschannel *chan = zs_kgdbchan;
-	while((read_zsreg(chan, 0) & Rx_CH_AV) == 0)
-		eieio(); /*barrier();*/
-	return read_zsdata(chan);
-}
-void kgdb_interruptible(int yes)
-{
-	struct dec_zschannel *chan = zs_kgdbchan;
-	int one, nine;
-	nine = read_zsreg(chan, 9);
-	if (yes == 1) {
-		one = EXT_INT_ENAB|RxINT_ALL;
-		nine |= MIE;
-		printk("turning serial ints on\n");
-	} else {
-		one = RxINT_DISAB;
-		nine &= ~MIE;
-		printk("turning serial ints off\n");
-	}
-	write_zsreg(chan, 1, one);
-	write_zsreg(chan, 9, nine);
-}
-
-static int kgdbhook_init_channel(void *handle)
-{
-	return 0;
-}
-
-static void kgdbhook_init_info(void *handle)
-{
-}
-
-static void kgdbhook_rx_char(void *handle, unsigned char ch, unsigned char fl)
-{
-	struct dec_serial *info = handle;
-
-	if (fl != TTY_NORMAL)
-		return;
-	if (ch == 0x03 || ch == '$')
-		breakpoint();
-}
-
-/* This sets up the serial port we're using, and turns on
- * interrupts for that channel, so kgdb is usable once we're done.
- */
-static inline void kgdb_chaninit(struct dec_zschannel *ms, int intson, int bps)
-{
-	int brg;
-	int i, x;
-	volatile char *sccc = ms->control;
-	brg = BPS_TO_BRG(bps, zs_parms->clock/16);
-	printk("setting bps on kgdb line to %d [brg=%x]\n", bps, brg);
-	for (i = 20000; i != 0; --i) {
-		x = *sccc; eieio();
-	}
-	for (i = 0; i < sizeof(scc_inittab); ++i) {
-		write_zsreg(ms, scc_inittab[i], scc_inittab[i+1]);
-		i++;
-	}
-}
-/* This is called at boot time to prime the kgdb serial debugging
- * serial line.  The 'tty_num' argument is 0 for /dev/ttya and 1
- * for /dev/ttyb which is determined in setup_arch() from the
- * boot command line flags.
- */
-struct dec_serial_hook zs_kgdbhook = {
-	.init_channel	= kgdbhook_init_channel,
-	.init_info	= kgdbhook_init_info,
-	.rx_char	= kgdbhook_rx_char,
-	.cflags		= B38400 | CS8 | CLOCAL,
-};
-
-void __init zs_kgdb_hook(int tty_num)
-{
-	/* Find out how many Z8530 SCCs we have */
-	if (zs_chain == 0)
-		probe_sccs();
-	zs_soft[tty_num].zs_channel = &zs_channels[tty_num];
-	zs_kgdbchan = zs_soft[tty_num].zs_channel;
-	zs_soft[tty_num].change_needed = 0;
-	zs_soft[tty_num].clk_divisor = 16;
-	zs_soft[tty_num].zs_baud = 38400;
- 	zs_soft[tty_num].hook = &zs_kgdbhook; /* This runs kgdb */
-	/* Turn on transmitter/receiver at 8-bits/char */
-        kgdb_chaninit(zs_soft[tty_num].zs_channel, 1, 38400);
-	printk("KGDB: on channel %d initialized\n", tty_num);
-	set_debug_traps(); /* init stub */
-}
-#endif /* ifdef CONFIG_KGDB */
diff -puN drivers/tc/zs.h~zs-move-to-the-serial-subsystem /dev/null
--- a/drivers/tc/zs.h
+++ /dev/null
@@ -1,404 +0,0 @@
-/*
- * drivers/tc/zs.h: Definitions for the DECstation Z85C30 serial driver.
- *
- * Adapted from drivers/sbus/char/sunserial.h by Paul Mackerras.
- * Adapted from drivers/macintosh/macserial.h by Harald Koerfgen.
- *
- * Copyright (C) 1996 Paul Mackerras (Paul.Mackerras@cs.anu.edu.au)
- * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
- * Copyright (C) 2004, 2005  Maciej W. Rozycki
- */
-#ifndef _DECSERIAL_H
-#define _DECSERIAL_H
-
-#include <asm/dec/serial.h>
-
-#define NUM_ZSREGS 16
-
-struct serial_struct {
-	int	type;
-	int	line;
-	int	port;
-	int	irq;
-	int	flags;
-	int	xmit_fifo_size;
-	int	custom_divisor;
-	int	baud_base;
-	unsigned short	close_delay;
-	char	reserved_char[2];
-	int	hub6;
-	unsigned short	closing_wait; /* time to wait before closing */
-	unsigned short	closing_wait2; /* no longer used... */
-	int	reserved[4];
-};
-
-/*
- * For the close wait times, 0 means wait forever for serial port to
- * flush its output.  65535 means don't wait at all.
- */
-#define ZILOG_CLOSING_WAIT_INF	0
-#define ZILOG_CLOSING_WAIT_NONE	65535
-
-/*
- * Definitions for ZILOG_struct (and serial_struct) flags field
- */
-#define ZILOG_HUP_NOTIFY 0x0001 /* Notify getty on hangups and closes
-				   on the callout port */
-#define ZILOG_FOURPORT  0x0002	/* Set OU1, OUT2 per AST Fourport settings */
-#define ZILOG_SAK	0x0004	/* Secure Attention Key (Orange book) */
-#define ZILOG_SPLIT_TERMIOS 0x0008 /* Separate termios for dialin/callout */
-
-#define ZILOG_SPD_MASK	0x0030
-#define ZILOG_SPD_HI	0x0010	/* Use 56000 instead of 38400 bps */
-
-#define ZILOG_SPD_VHI	0x0020  /* Use 115200 instead of 38400 bps */
-#define ZILOG_SPD_CUST	0x0030  /* Use user-specified divisor */
-
-#define ZILOG_SKIP_TEST	0x0040 /* Skip UART test during autoconfiguration */
-#define ZILOG_AUTO_IRQ  0x0080 /* Do automatic IRQ during autoconfiguration */
-#define ZILOG_SESSION_LOCKOUT 0x0100 /* Lock out cua opens based on session */
-#define ZILOG_PGRP_LOCKOUT    0x0200 /* Lock out cua opens based on pgrp */
-#define ZILOG_CALLOUT_NOHUP   0x0400 /* Don't do hangups for cua device */
-
-#define ZILOG_FLAGS	0x0FFF	/* Possible legal ZILOG flags */
-#define ZILOG_USR_MASK 0x0430	/* Legal flags that non-privileged
-				 * users can set or reset */
-
-/* Internal flags used only by kernel/chr_drv/serial.c */
-#define ZILOG_INITIALIZED	0x80000000 /* Serial port was initialized */
-#define ZILOG_CALLOUT_ACTIVE	0x40000000 /* Call out device is active */
-#define ZILOG_NORMAL_ACTIVE	0x20000000 /* Normal device is active */
-#define ZILOG_BOOT_AUTOCONF	0x10000000 /* Autoconfigure port on bootup */
-#define ZILOG_CLOSING		0x08000000 /* Serial port is closing */
-#define ZILOG_CTS_FLOW		0x04000000 /* Do CTS flow control */
-#define ZILOG_CHECK_CD		0x02000000 /* i.e., CLOCAL */
-
-/* Software state per channel */
-
-#ifdef __KERNEL__
-/*
- * This is our internal structure for each serial port's state.
- *
- * Many fields are paralleled by the structure used by the serial_struct
- * structure.
- *
- * For definitions of the flags field, see tty.h
- */
-
-struct dec_zschannel {
-	volatile unsigned char *control;
-	volatile unsigned char *data;
-
-	/* Current write register values */
-	unsigned char curregs[NUM_ZSREGS];
-};
-
-struct dec_serial {
-	struct dec_serial	*zs_next;	/* For IRQ servicing chain.  */
-	struct dec_zschannel	*zs_channel;	/* Channel registers.  */
-	struct dec_zschannel	*zs_chan_a;	/* A side registers.  */
-	unsigned char		read_reg_zero;
-
-	struct dec_serial_hook	*hook;		/* Hook on this channel.  */
-	int			tty_break;	/* Set on BREAK condition.  */
-	int			is_cons;	/* Is this our console.  */
-	int			tx_active;	/* Char is being xmitted.  */
-	int			tx_stopped;	/* Output is suspended.  */
-
-	/*
-	 * We need to know the current clock divisor
-	 * to read the bps rate the chip has currently loaded.
-	 */
-	int			clk_divisor;	/* May be 1, 16, 32, or 64.  */
-	int			zs_baud;
-
-	char			change_needed;
-
-	int			magic;
-	int			baud_base;
-	int			port;
-	int			irq;
-	int			flags; 		/* Defined in tty.h.  */
-	int			type; 		/* UART type.  */
-	struct tty_struct 	*tty;
-	int			read_status_mask;
-	int			ignore_status_mask;
-	int			timeout;
-	int			xmit_fifo_size;
-	int			custom_divisor;
-	int			x_char;		/* XON/XOFF character.  */
-	int			close_delay;
-	unsigned short		closing_wait;
-	unsigned short		closing_wait2;
-	unsigned long		event;
-	unsigned long		last_active;
-	int			line;
-	int			count;		/* # of fds on device.  */
-	int			blocked_open;	/* # of blocked opens.  */
-	unsigned char 		*xmit_buf;
-	int			xmit_head;
-	int			xmit_tail;
-	int			xmit_cnt;
-	struct tasklet_struct	tlet;
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
-};
-
-
-#define SERIAL_MAGIC 0x5301
-
-/*
- * The size of the serial xmit buffer is 1 page, or 4096 bytes
- */
-#define SERIAL_XMIT_SIZE 4096
-
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at rs interrupt time.
- */
-#define RS_EVENT_WRITE_WAKEUP	0
-
-#endif /* __KERNEL__ */
-
-/* Conversion routines to/from brg time constants from/to bits
- * per second.
- */
-#define BRG_TO_BPS(brg, freq) ((freq) / 2 / ((brg) + 2))
-#define BPS_TO_BRG(bps, freq) ((((freq) + (bps)) / (2 * (bps))) - 2)
-
-/* The Zilog register set */
-
-#define	FLAG	0x7e
-
-/* Write Register 0 */
-#define	R0	0		/* Register selects */
-#define	R1	1
-#define	R2	2
-#define	R3	3
-#define	R4	4
-#define	R5	5
-#define	R6	6
-#define	R7	7
-#define	R8	8
-#define	R9	9
-#define	R10	10
-#define	R11	11
-#define	R12	12
-#define	R13	13
-#define	R14	14
-#define	R15	15
-
-#define	NULLCODE	0	/* Null Code */
-#define	POINT_HIGH	0x8	/* Select upper half of registers */
-#define	RES_EXT_INT	0x10	/* Reset Ext. Status Interrupts */
-#define	SEND_ABORT	0x18	/* HDLC Abort */
-#define	RES_RxINT_FC	0x20	/* Reset RxINT on First Character */
-#define	RES_Tx_P	0x28	/* Reset TxINT Pending */
-#define	ERR_RES		0x30	/* Error Reset */
-#define	RES_H_IUS	0x38	/* Reset highest IUS */
-
-#define	RES_Rx_CRC	0x40	/* Reset Rx CRC Checker */
-#define	RES_Tx_CRC	0x80	/* Reset Tx CRC Checker */
-#define	RES_EOM_L	0xC0	/* Reset EOM latch */
-
-/* Write Register 1 */
-
-#define	EXT_INT_ENAB	0x1	/* Ext Int Enable */
-#define	TxINT_ENAB	0x2	/* Tx Int Enable */
-#define	PAR_SPEC	0x4	/* Parity is special condition */
-
-#define	RxINT_DISAB	0	/* Rx Int Disable */
-#define	RxINT_FCERR	0x8	/* Rx Int on First Character Only or Error */
-#define	RxINT_ALL	0x10	/* Int on all Rx Characters or error */
-#define	RxINT_ERR	0x18	/* Int on error only */
-#define	RxINT_MASK	0x18
-
-#define	WT_RDY_RT	0x20	/* Wait/Ready on R/T */
-#define	WT_FN_RDYFN	0x40	/* Wait/FN/Ready FN */
-#define	WT_RDY_ENAB	0x80	/* Wait/Ready Enable */
-
-/* Write Register #2 (Interrupt Vector) */
-
-/* Write Register 3 */
-
-#define	RxENABLE	0x1	/* Rx Enable */
-#define	SYNC_L_INH	0x2	/* Sync Character Load Inhibit */
-#define	ADD_SM		0x4	/* Address Search Mode (SDLC) */
-#define	RxCRC_ENAB	0x8	/* Rx CRC Enable */
-#define	ENT_HM		0x10	/* Enter Hunt Mode */
-#define	AUTO_ENAB	0x20	/* Auto Enables */
-#define	Rx5		0x0	/* Rx 5 Bits/Character */
-#define	Rx7		0x40	/* Rx 7 Bits/Character */
-#define	Rx6		0x80	/* Rx 6 Bits/Character */
-#define	Rx8		0xc0	/* Rx 8 Bits/Character */
-#define RxNBITS_MASK	0xc0
-
-/* Write Register 4 */
-
-#define	PAR_ENA		0x1	/* Parity Enable */
-#define	PAR_EVEN	0x2	/* Parity Even/Odd* */
-
-#define	SYNC_ENAB	0	/* Sync Modes Enable */
-#define	SB1		0x4	/* 1 stop bit/char */
-#define	SB15		0x8	/* 1.5 stop bits/char */
-#define	SB2		0xc	/* 2 stop bits/char */
-#define SB_MASK		0xc
-
-#define	MONSYNC		0	/* 8 Bit Sync character */
-#define	BISYNC		0x10	/* 16 bit sync character */
-#define	SDLC		0x20	/* SDLC Mode (01111110 Sync Flag) */
-#define	EXTSYNC		0x30	/* External Sync Mode */
-
-#define	X1CLK		0x0	/* x1 clock mode */
-#define	X16CLK		0x40	/* x16 clock mode */
-#define	X32CLK		0x80	/* x32 clock mode */
-#define	X64CLK		0xC0	/* x64 clock mode */
-#define XCLK_MASK	0xC0
-
-/* Write Register 5 */
-
-#define	TxCRC_ENAB	0x1	/* Tx CRC Enable */
-#define	RTS		0x2	/* RTS */
-#define	SDLC_CRC	0x4	/* SDLC/CRC-16 */
-#define	TxENAB		0x8	/* Tx Enable */
-#define	SND_BRK		0x10	/* Send Break */
-#define	Tx5		0x0	/* Tx 5 bits (or less)/character */
-#define	Tx7		0x20	/* Tx 7 bits/character */
-#define	Tx6		0x40	/* Tx 6 bits/character */
-#define	Tx8		0x60	/* Tx 8 bits/character */
-#define TxNBITS_MASK	0x60
-#define	DTR		0x80	/* DTR */
-
-/* Write Register 6 (Sync bits 0-7/SDLC Address Field) */
-
-/* Write Register 7 (Sync bits 8-15/SDLC 01111110) */
-
-/* Write Register 8 (transmit buffer) */
-
-/* Write Register 9 (Master interrupt control) */
-#define	VIS	1	/* Vector Includes Status */
-#define	NV	2	/* No Vector */
-#define	DLC	4	/* Disable Lower Chain */
-#define	MIE	8	/* Master Interrupt Enable */
-#define	STATHI	0x10	/* Status high */
-#define	SOFTACK	0x20	/* Software Interrupt Acknowledge */
-#define	NORESET	0	/* No reset on write to R9 */
-#define	CHRB	0x40	/* Reset channel B */
-#define	CHRA	0x80	/* Reset channel A */
-#define	FHWRES	0xc0	/* Force hardware reset */
-
-/* Write Register 10 (misc control bits) */
-#define	BIT6	1	/* 6 bit/8bit sync */
-#define	LOOPMODE 2	/* SDLC Loop mode */
-#define	ABUNDER	4	/* Abort/flag on SDLC xmit underrun */
-#define	MARKIDLE 8	/* Mark/flag on idle */
-#define	GAOP	0x10	/* Go active on poll */
-#define	NRZ	0	/* NRZ mode */
-#define	NRZI	0x20	/* NRZI mode */
-#define	FM1	0x40	/* FM1 (transition = 1) */
-#define	FM0	0x60	/* FM0 (transition = 0) */
-#define	CRCPS	0x80	/* CRC Preset I/O */
-
-/* Write Register 11 (Clock Mode control) */
-#define	TRxCXT	0	/* TRxC = Xtal output */
-#define	TRxCTC	1	/* TRxC = Transmit clock */
-#define	TRxCBR	2	/* TRxC = BR Generator Output */
-#define	TRxCDP	3	/* TRxC = DPLL output */
-#define	TRxCOI	4	/* TRxC O/I */
-#define	TCRTxCP	0	/* Transmit clock = RTxC pin */
-#define	TCTRxCP	8	/* Transmit clock = TRxC pin */
-#define	TCBR	0x10	/* Transmit clock = BR Generator output */
-#define	TCDPLL	0x18	/* Transmit clock = DPLL output */
-#define	RCRTxCP	0	/* Receive clock = RTxC pin */
-#define	RCTRxCP	0x20	/* Receive clock = TRxC pin */
-#define	RCBR	0x40	/* Receive clock = BR Generator output */
-#define	RCDPLL	0x60	/* Receive clock = DPLL output */
-#define	RTxCX	0x80	/* RTxC Xtal/No Xtal */
-
-/* Write Register 12 (lower byte of baud rate generator time constant) */
-
-/* Write Register 13 (upper byte of baud rate generator time constant) */
-
-/* Write Register 14 (Misc control bits) */
-#define	BRENABL	1	/* Baud rate generator enable */
-#define	BRSRC	2	/* Baud rate generator source */
-#define	DTRREQ	4	/* DTR/Request function */
-#define	AUTOECHO 8	/* Auto Echo */
-#define	LOOPBAK	0x10	/* Local loopback */
-#define	SEARCH	0x20	/* Enter search mode */
-#define	RMC	0x40	/* Reset missing clock */
-#define	DISDPLL	0x60	/* Disable DPLL */
-#define	SSBR	0x80	/* Set DPLL source = BR generator */
-#define	SSRTxC	0xa0	/* Set DPLL source = RTxC */
-#define	SFMM	0xc0	/* Set FM mode */
-#define	SNRZI	0xe0	/* Set NRZI mode */
-
-/* Write Register 15 (external/status interrupt control) */
-#define	ZCIE	2	/* Zero count IE */
-#define	DCDIE	8	/* DCD IE */
-#define	SYNCIE	0x10	/* Sync/hunt IE */
-#define	CTSIE	0x20	/* CTS IE */
-#define	TxUIE	0x40	/* Tx Underrun/EOM IE */
-#define	BRKIE	0x80	/* Break/Abort IE */
-
-
-/* Read Register 0 */
-#define	Rx_CH_AV	0x1	/* Rx Character Available */
-#define	ZCOUNT		0x2	/* Zero count */
-#define	Tx_BUF_EMP	0x4	/* Tx Buffer empty */
-#define	DCD		0x8	/* DCD */
-#define	SYNC_HUNT	0x10	/* Sync/hunt */
-#define	CTS		0x20	/* CTS */
-#define	TxEOM		0x40	/* Tx underrun */
-#define	BRK_ABRT	0x80	/* Break/Abort */
-
-/* Read Register 1 */
-#define	ALL_SNT		0x1	/* All sent */
-/* Residue Data for 8 Rx bits/char programmed */
-#define	RES3		0x8	/* 0/3 */
-#define	RES4		0x4	/* 0/4 */
-#define	RES5		0xc	/* 0/5 */
-#define	RES6		0x2	/* 0/6 */
-#define	RES7		0xa	/* 0/7 */
-#define	RES8		0x6	/* 0/8 */
-#define	RES18		0xe	/* 1/8 */
-#define	RES28		0x0	/* 2/8 */
-/* Special Rx Condition Interrupts */
-#define	PAR_ERR		0x10	/* Parity error */
-#define	Rx_OVR		0x20	/* Rx Overrun Error */
-#define	FRM_ERR		0x40	/* CRC/Framing Error */
-#define	END_FR		0x80	/* End of Frame (SDLC) */
-
-/* Read Register 2 (channel b only) - Interrupt vector */
-
-/* Read Register 3 (interrupt pending register) ch a only */
-#define	CHBEXT	0x1		/* Channel B Ext/Stat IP */
-#define	CHBTxIP	0x2		/* Channel B Tx IP */
-#define	CHBRxIP	0x4		/* Channel B Rx IP */
-#define	CHAEXT	0x8		/* Channel A Ext/Stat IP */
-#define	CHATxIP	0x10		/* Channel A Tx IP */
-#define	CHARxIP	0x20		/* Channel A Rx IP */
-
-/* Read Register 8 (receive data register) */
-
-/* Read Register 10  (misc status bits) */
-#define	ONLOOP	2		/* On loop */
-#define	LOOPSEND 0x10		/* Loop sending */
-#define	CLK2MIS	0x40		/* Two clocks missing */
-#define	CLK1MIS	0x80		/* One clock missing */
-
-/* Read Register 12 (lower byte of baud rate generator constant) */
-
-/* Read Register 13 (upper byte of baud rate generator constant) */
-
-/* Read Register 15 (value of WR 15) */
-
-/* Misc macros */
-#define ZS_CLEARERR(channel)	(write_zsreg(channel, 0, ERR_RES))
-#define ZS_CLEARFIFO(channel)	do { volatile unsigned char garbage; \
-				     garbage = read_zsdata(channel); \
-				     garbage = read_zsdata(channel); \
-				     garbage = read_zsdata(channel); \
-				} while(0)
-
-#endif /* !(_DECSERIAL_H) */
diff -puN include/asm-mips/dec/serial.h~zs-move-to-the-serial-subsystem /dev/null
--- a/include/asm-mips/dec/serial.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- *	include/asm-mips/dec/serial.h
- *
- *	Definitions common to all DECstation serial devices.
- *
- *	Copyright (C) 2004  Maciej W. Rozycki
- *
- *	Based on bits extracted from drivers/tc/zs.h for which
- *	the following copyrights apply:
- *
- *	Copyright (C) 1995  David S. Miller (davem@caip.rutgers.edu)
- *	Copyright (C) 1996  Paul Mackerras (Paul.Mackerras@cs.anu.edu.au)
- *	Copyright (C)       Harald Koerfgen
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- */
-#ifndef __ASM_MIPS_DEC_SERIAL_H
-#define __ASM_MIPS_DEC_SERIAL_H
-
-struct dec_serial_hook {
-	int (*init_channel)(void *handle);
-	void (*init_info)(void *handle);
-	void (*rx_char)(unsigned char ch, unsigned char fl);
-	int (*poll_rx_char)(void *handle);
-	int (*poll_tx_char)(void *handle, unsigned char ch);
-	unsigned int cflags;
-};
-
-extern int register_dec_serial_hook(unsigned int channel,
-				    struct dec_serial_hook *hook);
-extern int unregister_dec_serial_hook(unsigned int channel);
-
-#endif /* __ASM_MIPS_DEC_SERIAL_H */
diff -puN include/linux/serial_core.h~zs-move-to-the-serial-subsystem include/linux/serial_core.h
--- a/include/linux/serial_core.h~zs-move-to-the-serial-subsystem
+++ a/include/linux/serial_core.h
@@ -62,8 +62,9 @@
 /* NEC v850.  */
 #define PORT_V850E_UART	40
 
-/* DZ */
-#define PORT_DZ		47
+/* DEC */
+#define PORT_DZ		46
+#define PORT_ZS		47
 
 /* Parisc type numbers. */
 #define PORT_MUX	48
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
