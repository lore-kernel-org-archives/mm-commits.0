From: akpm@linux-foundation.org
Subject: - ppc-remove-apus-support.patch removed from -mm tree
Date: Mon, 30 Jul 2007 18:54:10 -0700
Message-ID: <200707310154.l6V1sA2j009405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758004AbXGaBys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppc: remove APUS support
has been removed from the -mm tree.  Its filename was
     ppc-remove-apus-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ppc: remove APUS support
=46rom: Adrian Bunk <bunk@stusta.de>

Current status of APUS:
- arch/powerpc/: removed in 2.6.23
- arch/ppc/: marked BROKEN since 2 years

This patch therefore removes the remaining parts of APUS support.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/chipram.c           |    2=20
 arch/powerpc/kernel/setup_32.c      |    1=20
 arch/ppc/Kconfig                    |  148 ----
 arch/ppc/Makefile                   |    1=20
 arch/ppc/amiga/Makefile             |    8=20
 arch/ppc/amiga/amiga_ksyms.c        |    1=20
 arch/ppc/amiga/amiints.c            |  322 ---------
 arch/ppc/amiga/amisound.c           |    1=20
 arch/ppc/amiga/bootinfo.c           |   78 --
 arch/ppc/amiga/chipram.c            |    1=20
 arch/ppc/amiga/cia.c                |  176 ----
 arch/ppc/amiga/ints.c               |  158 ----
 arch/ppc/amiga/pcmcia.c             |    1=20
 arch/ppc/amiga/time.c               |   57 -
 arch/ppc/configs/apus_defconfig     |  920 --------------------------
 arch/ppc/kernel/head.S              |  117 ---
 arch/ppc/kernel/ppc_ksyms.c         |    3=20
 arch/ppc/kernel/setup.c             |    1=20
 arch/ppc/mm/pgtable.c               |   38 -
 arch/ppc/platforms/Makefile         |    4=20
 arch/ppc/platforms/apus_pci.c       |  207 -----
 arch/ppc/platforms/apus_pci.h       |   34=20
 arch/ppc/platforms/apus_setup.c     |  798 ----------------------
 drivers/ide/ide-probe.c             |    8=20
 drivers/isdn/hisax/avm_pci.c        |    8=20
 drivers/scsi/a2091.c                |    3=20
 drivers/scsi/a3000.c                |    3=20
 drivers/scsi/gvp11.c                |    3=20
 drivers/scsi/oktagon_esp.c          |    2=20
 drivers/scsi/oktagon_io.S           |   72 --
 drivers/video/console/fbcon.c       |    2=20
 drivers/video/console/fonts.c       |    4=20
 include/asm-m68k/pgtable.h          |    2=20
 include/asm-powerpc/ide.h           |    2=20
 include/asm-powerpc/reg.h           |    4=20
 include/asm-ppc/amigahw.h           |   16=20
 include/asm-ppc/amigaints.h         |  133 ---
 include/asm-ppc/amigappc.h          |   85 --
 include/asm-ppc/bootinfo.h          |    5=20
 include/asm-ppc/io.h                |   48 -
 include/asm-ppc/machdep.h           |    4=20
 include/asm-ppc/page.h              |   44 -
 include/asm-ppc/pgtable.h           |    8=20
 sound/oss/dmasound/Kconfig          |    2=20
 sound/oss/dmasound/dmasound_paula.c |    4=20
 45 files changed, 24 insertions(+), 3515 deletions(-)

diff -puN arch/m68k/amiga/chipram.c~ppc-remove-apus-support arch/m68k/a=
miga/chipram.c
--- a/arch/m68k/amiga/chipram.c~ppc-remove-apus-support
+++ a/arch/m68k/amiga/chipram.c
@@ -29,12 +29,10 @@ void __init amiga_chip_init(void)
     if (!AMIGAHW_PRESENT(CHIP_RAM))
 	return;
=20
-#ifndef CONFIG_APUS_FAST_EXCEPT
     /*
      *  Remove the first 4 pages where PPC exception handlers will be =
located
      */
     amiga_chip_size -=3D 0x4000;
-#endif
     chipram_res.end =3D amiga_chip_size-1;
     request_resource(&iomem_resource, &chipram_res);
=20
diff -puN arch/powerpc/kernel/setup_32.c~ppc-remove-apus-support arch/p=
owerpc/kernel/setup_32.c
--- a/arch/powerpc/kernel/setup_32.c~ppc-remove-apus-support
+++ a/arch/powerpc/kernel/setup_32.c
@@ -24,7 +24,6 @@
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
-#include <asm/amigappc.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
diff -puN arch/ppc/Kconfig~ppc-remove-apus-support arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~ppc-remove-apus-support
+++ a/arch/ppc/Kconfig
@@ -573,24 +573,9 @@ choice
=20
 	  Select PReP if configuring for a PReP machine.
=20
-	  Select Gemini if configuring for a Synergy Microsystems' Gemini
-	  series Single Board Computer.  More information is available at:
-	  <http://www.synergymicro.com/PressRel/97_10_15.html>.
-
-	  Select APUS if configuring for a PowerUP Amiga.  More information i=
s
-	  available at: <http://linux-apus.sourceforge.net/>.
-
 config PPC_PREP
 	bool "PReP"
=20
-config APUS
-	bool "Amiga-APUS"
-	depends on BROKEN
-	help
-	  Select APUS if configuring for a PowerUP Amiga.
-	  More information is available at:
-	  <http://linux-apus.sourceforge.net/>.
-
 config KATANA
 	bool "Artesyn-Katana"
 	help
@@ -1027,132 +1012,6 @@ config CMDLINE
 	  some command-line options at build time by entering them here.  In
 	  most cases you will need to specify the root device here.
=20
-config AMIGA
-	bool
-	depends on APUS
-	default y
-	help
-	  This option enables support for the Amiga series of computers.
-
-config ZORRO
-	bool
-	depends on APUS
-	default y
-	help
-	  This enables support for the Zorro bus in the Amiga. If you have
-	  expansion cards in your Amiga that conform to the Amiga
-	  AutoConfig(tm) specification, say Y, otherwise N. Note that even
-	  expansion cards that do not fit in the Zorro slots but fit in e.g.
-	  the CPU slot may fall in this category, so you have to say Y to let
-	  Linux use these.
-
-config ABSTRACT_CONSOLE
-	bool
-	depends on APUS
-	default y
-
-config APUS_FAST_EXCEPT
-	bool
-	depends on APUS
-	default y
-
-config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support"
-	depends on APUS && EXPERIMENTAL
-	help
-	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
-	  600. If you intend to use pcmcia cards say Y; otherwise say N.
-
-config AMIGA_BUILTIN_SERIAL
-	tristate "Amiga builtin serial support"
-	depends on APUS
-	help
-	  If you want to use your Amiga's built-in serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config GVPIOEXT
-	tristate "GVP IO-Extender support"
-	depends on APUS
-	help
-	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
-	  Otherwise, say N.
-
-config GVPIOEXT_LP
-	tristate "GVP IO-Extender parallel printer support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable driving a printer from the parallel port on your
-	  GVP IO-Extender card, N otherwise.
-
-config GVPIOEXT_PLIP
-	tristate "GVP IO-Extender PLIP support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable doing IP over the parallel port on your GVP
-	  IO-Extender card, N otherwise.
-
-config MULTIFACE_III_TTY
-	tristate "Multiface Card III serial support"
-	depends on APUS
-	help
-	  If you want to use a Multiface III card's serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config A2232
-	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && APUS
-	---help---
-	  This option supports the 2232 7-port serial card shipped with the
-	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
-	  a max of 19,200 bps, the ports are served by a 6551 ACIA UART chip
-	  each, plus a 8520 CIA, and a master 6502 CPU and buffer as well. Th=
e
-	  ports were connected with 8 pin DIN connectors on the card bracket,
-	  for which 8 pin to DB25 adapters were supplied. The card also had
-	  jumpers internally to toggle various pinning configurations.
-
-	  This driver can be built as a module; but then "generic_serial"
-	  will also be built as a module. This has to be loaded before
-	  "ser_a2232". If you want to do this, answer M here.
-
-config WHIPPET_SERIAL
-	tristate "Hisoft Whippet PCMCIA serial support"
-	depends on AMIGA_PCMCIA
-	help
-	  HiSoft has a web page at <http://www.hisoft.co.uk/>, but there
-	  is no listing for the Whippet in their Amiga section.
-
-config APNE
-	tristate "PCMCIA NE2000 support"
-	depends on AMIGA_PCMCIA
-	help
-	  If you have a PCMCIA NE2000 compatible adapter, say Y.  Otherwise,
-	  say N.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called apne.
-
-config SERIAL_CONSOLE
-	bool "Support for serial port console"
-	depends on APUS && (AMIGA_BUILTIN_SERIAL=3Dy || GVPIOEXT=3Dy || MULTI=
=46ACE_III_TTY=3Dy)
-
-config HEARTBEAT
-	bool "Use power LED as a heartbeat"
-	depends on APUS
-	help
-	  Use the power-on LED on your machine as a load meter.  The exact
-	  behavior is platform-dependent, but normally the flash frequency is
-	  a hyperbolic function of the 5-minute load average.
-
-config PROC_HARDWARE
-	bool "/proc/hardware support"
-	depends on APUS
-
-source "drivers/zorro/Kconfig"
-
 if !44x || BROKEN
 source kernel/power/Kconfig
 endif
@@ -1227,8 +1086,7 @@ config MCA
=20
 config PCI
 	bool "PCI support" if 40x || CPM2 || 83xx || 85xx || PPC_MPC52xx
-	default y if !40x && !CPM2 && !8xx && !APUS && !83xx && !85xx
-	default PCI_PERMEDIA if !4xx && !CPM2 && !8xx && APUS
+	default y if !40x && !CPM2 && !8xx && !83xx && !85xx
 	default PCI_QSPAN if !4xx && !CPM2 && 8xx
 	help
 	  Find out whether your system includes a PCI bus. PCI is the name of
@@ -1284,10 +1142,6 @@ config 8260_PCI9_IDMA4
=20
 endchoice
=20
-config PCI_PERMEDIA
-	bool "PCI for Permedia2"
-	depends on !4xx && !8xx && APUS
-
 source "drivers/pci/Kconfig"
=20
 source "drivers/pcmcia/Kconfig"
diff -puN arch/ppc/Makefile~ppc-remove-apus-support arch/ppc/Makefile
--- a/arch/ppc/Makefile~ppc-remove-apus-support
+++ a/arch/ppc/Makefile
@@ -69,7 +69,6 @@ core-$(CONFIG_83xx)		+=3D arch/ppc/platfor
 core-$(CONFIG_85xx)		+=3D arch/ppc/platforms/85xx/
 core-$(CONFIG_MATH_EMULATION)	+=3D arch/powerpc/math-emu/
 core-$(CONFIG_XMON)		+=3D arch/ppc/xmon/
-core-$(CONFIG_APUS)		+=3D arch/ppc/amiga/
 drivers-$(CONFIG_8xx)		+=3D arch/ppc/8xx_io/
 drivers-$(CONFIG_4xx)		+=3D arch/ppc/4xx_io/
 drivers-$(CONFIG_CPM2)		+=3D arch/ppc/8260_io/
diff -puN arch/ppc/amiga/Makefile~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-#
-# Makefile for Linux arch/m68k/amiga source directory
-#
-
-obj-y		:=3D config.o amiints.o cia.o time.o bootinfo.o amisound.o \
-			chipram.o amiga_ksyms.o
-
-obj-$(CONFIG_AMIGA_PCMCIA) +=3D pcmcia.o
diff -puN arch/ppc/amiga/amiga_ksyms.c~ppc-remove-apus-support /dev/nul=
l
--- a/arch/ppc/amiga/amiga_ksyms.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../m68k/amiga/amiga_ksyms.c"
diff -puN arch/ppc/amiga/amiints.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/amiints.c
+++ /dev/null
@@ -1,322 +0,0 @@
-/*
- * Amiga Linux interrupt handling code
- *
- * This file is subject to the terms and conditions of the GNU General=
 Public
- * License.  See the file COPYING in the main directory of this archiv=
e
- * for more details.
- *
- * 11/07/96: rewritten interrupt handling, irq lists are exists now on=
ly for
- *           this sources where it makes sense (VERTB/PORTS/EXTER) and=
 you must
- *           be careful that dev_id for this sources is unique since t=
his the
- *           only possibility to distinguish between different handler=
s for
- *           free_irq. irq lists also have different irq flags:
- *           - IRQ_FLG_FAST: handler is inserted at top of list (after=
 other
- *                           fast handlers)
- *           - IRQ_FLG_SLOW: handler is inserted at bottom of list and=
 before
- *                           they're executed irq level is set to the =
previous
- *                           one, but handlers don't need to be reentr=
ant, if
- *                           reentrance occurred, slow handlers will b=
e just
- *                           called again.
- *           The whole interrupt handling for CIAs is moved to cia.c
- *           /Roman Zippel
- *
- * 07/08/99: rewamp of the interrupt handling - we now have two types =
of
- *           interrupts, normal and fast handlers, fast handlers being
- *           marked with SA_INTERRUPT and runs with all other interrup=
ts
- *           disabled. Normal interrupts disable their own source but
- *           run with all other interrupt sources enabled.
- *           PORTS and EXTER interrupts are always shared even if the
- *           drivers do not explicitly mark this when calling
- *           request_irq which they really should do.
- *           This is similar to the way interrupts are handled on all
- *           other architectures and makes a ton of sense besides
- *           having the advantage of making it easier to share
- *           drivers.
- *           /Jes
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/init.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amipcmcia.h>
-
-#ifdef CONFIG_APUS
-#include <asm/amigappc.h>
-#endif
-
-extern void cia_init_IRQ(struct ciabase *base);
-
-unsigned short ami_intena_vals[AMI_STD_IRQS] =3D {
-	IF_VERTB, IF_COPER, IF_AUD0, IF_AUD1, IF_AUD2, IF_AUD3, IF_BLIT,
-	IF_DSKSYN, IF_DSKBLK, IF_RBF, IF_TBE, IF_SOFT, IF_PORTS, IF_EXTER
-};
-static const unsigned char ami_servers[AMI_STD_IRQS] =3D {
-	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1
-};
-
-static short ami_ablecount[AMI_IRQS];
-
-static void ami_badint(int irq, void *dev_id, struct pt_regs *fp)
-{
-/*	num_spurious +=3D 1;*/
-}
-
-/*
- * void amiga_init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the amiga IRQ handling routines.
- */
-
-__init
-void amiga_init_IRQ(void)
-{
-	int i;
-
-	for (i =3D 0; i < AMI_IRQS; i++)
-		ami_ablecount[i] =3D 0;
-
-	/* turn off PCMCIA interrupts */
-	if (AMIGAHW_PRESENT(PCMCIA))
-		gayle.inten =3D GAYLE_IRQ_IDE;
-
-	/* turn off all interrupts... */
-	amiga_custom.intena =3D 0x7fff;
-	amiga_custom.intreq =3D 0x7fff;
-
-#ifdef CONFIG_APUS
-	/* Clear any inter-CPU interrupt requests. Circumvents bug in
-           Blizzard IPL emulation HW (or so it appears). */
-	APUS_WRITE(APUS_INT_LVL, INTLVL_SETRESET | INTLVL_MASK);
-
-	/* Init IPL emulation. */
-	APUS_WRITE(APUS_REG_INT, REGINT_INTMASTER | REGINT_ENABLEIPL);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_SETRESET | IPLEMU_IPLMASK);
-#endif
-	/* ... and enable the master interrupt bit */
-	amiga_custom.intena =3D IF_SETCLR | IF_INTEN;
-
-	cia_init_IRQ(&ciaa_base);
-	cia_init_IRQ(&ciab_base);
-}
-
-/*
- * Enable/disable a particular machine specific interrupt source.
- * Note that this may affect other interrupts in case of a shared inte=
rrupt.
- * This function should only be called for a _very_ short time to chan=
ge some
- * internal data, that may not be changed by the interrupt at the same=
 time.
- * ami_(enable|disable)_irq calls may also be nested.
- */
-
-void amiga_enable_irq(unsigned int irq)
-{
-	if (irq >=3D AMI_IRQS) {
-		printk("%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	ami_ablecount[irq]--;
-	if (ami_ablecount[irq]<0)
-		ami_ablecount[irq]=3D0;
-	else if (ami_ablecount[irq])
-		return;
-
-	/* No action for auto-vector interrupts */
-	if (irq >=3D IRQ_AMIGA_AUTO){
-		printk("%s: Trying to enable auto-vector IRQ %i\n",
-		       __FUNCTION__, irq - IRQ_AMIGA_AUTO);
-		return;
-	}
-
-	if (irq >=3D IRQ_AMIGA_CIAA) {
-		cia_set_irq(irq, 0);
-		cia_able_irq(irq, 1);
-		return;
-	}
-
-	/* enable the interrupt */
-	amiga_custom.intena =3D IF_SETCLR | ami_intena_vals[irq];
-}
-
-void amiga_disable_irq(unsigned int irq)
-{
-	if (irq >=3D AMI_IRQS) {
-		printk("%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (ami_ablecount[irq]++)
-		return;
-
-	/* No action for auto-vector interrupts */
-	if (irq >=3D IRQ_AMIGA_AUTO) {
-		printk("%s: Trying to disable auto-vector IRQ %i\n",
-		       __FUNCTION__, irq - IRQ_AMIGA_AUTO);
-		return;
-	}
-
-	if (irq >=3D IRQ_AMIGA_CIAA) {
-		cia_able_irq(irq, 0);
-		return;
-	}
-
-	/* disable the interrupt */
-	amiga_custom.intena =3D ami_intena_vals[irq];
-}
-
-inline void amiga_do_irq(int irq, struct pt_regs *fp)
-{
-	irq_desc_t *desc =3D irq_desc + irq;
-	struct irqaction *action =3D desc->action;
-
-	kstat_cpu(0).irqs[irq]++;
-	action->handler(irq, action->dev_id, fp);
-}
-
-void amiga_do_irq_list(int irq, struct pt_regs *fp)
-{
-	irq_desc_t *desc =3D irq_desc + irq;
-	struct irqaction *action;
-
-	kstat_cpu(0).irqs[irq]++;
-
-	amiga_custom.intreq =3D ami_intena_vals[irq];
-
-	for (action =3D desc->action; action; action =3D action->next)
-		action->handler(irq, action->dev_id, fp);
-}
-
-/*
- * The builtin Amiga hardware interrupt handlers.
- */
-
-static void ami_int1(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints =3D amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial transmit buffer empty, interrupt */
-	if (ints & IF_TBE) {
-		amiga_custom.intreq =3D IF_TBE;
-		amiga_do_irq(IRQ_AMIGA_TBE, fp);
-	}
-
-	/* if floppy disk transfer complete, interrupt */
-	if (ints & IF_DSKBLK) {
-		amiga_custom.intreq =3D IF_DSKBLK;
-		amiga_do_irq(IRQ_AMIGA_DSKBLK, fp);
-	}
-
-	/* if software interrupt set, interrupt */
-	if (ints & IF_SOFT) {
-		amiga_custom.intreq =3D IF_SOFT;
-		amiga_do_irq(IRQ_AMIGA_SOFT, fp);
-	}
-}
-
-static void ami_int3(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints =3D amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if a blitter interrupt */
-	if (ints & IF_BLIT) {
-		amiga_custom.intreq =3D IF_BLIT;
-		amiga_do_irq(IRQ_AMIGA_BLIT, fp);
-	}
-
-	/* if a copper interrupt */
-	if (ints & IF_COPER) {
-		amiga_custom.intreq =3D IF_COPER;
-		amiga_do_irq(IRQ_AMIGA_COPPER, fp);
-	}
-
-	/* if a vertical blank interrupt */
-	if (ints & IF_VERTB)
-		amiga_do_irq_list(IRQ_AMIGA_VERTB, fp);
-}
-
-static void ami_int4(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints =3D amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if audio 0 interrupt */
-	if (ints & IF_AUD0) {
-		amiga_custom.intreq =3D IF_AUD0;
-		amiga_do_irq(IRQ_AMIGA_AUD0, fp);
-	}
-
-	/* if audio 1 interrupt */
-	if (ints & IF_AUD1) {
-		amiga_custom.intreq =3D IF_AUD1;
-		amiga_do_irq(IRQ_AMIGA_AUD1, fp);
-	}
-
-	/* if audio 2 interrupt */
-	if (ints & IF_AUD2) {
-		amiga_custom.intreq =3D IF_AUD2;
-		amiga_do_irq(IRQ_AMIGA_AUD2, fp);
-	}
-
-	/* if audio 3 interrupt */
-	if (ints & IF_AUD3) {
-		amiga_custom.intreq =3D IF_AUD3;
-		amiga_do_irq(IRQ_AMIGA_AUD3, fp);
-	}
-}
-
-static void ami_int5(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints =3D amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial receive buffer full interrupt */
-	if (ints & IF_RBF) {
-		/* acknowledge of IF_RBF must be done by the serial interrupt */
-		amiga_do_irq(IRQ_AMIGA_RBF, fp);
-	}
-
-	/* if a disk sync interrupt */
-	if (ints & IF_DSKSYN) {
-		amiga_custom.intreq =3D IF_DSKSYN;
-		amiga_do_irq(IRQ_AMIGA_DSKSYN, fp);
-	}
-}
-
-static void ami_int7(int irq, void *dev_id, struct pt_regs *fp)
-{
-	panic ("level 7 interrupt received\n");
-}
-
-#ifdef CONFIG_APUS
-/* The PPC irq handling links all handlers requested on the same vecto=
r
-   and executes them in a loop. Having ami_badint at the end of the ch=
ain
-   is a bad idea. */
-struct irqaction amiga_sys_irqaction[AUTO_IRQS] =3D {
-	{ .handler =3D ami_badint, .name =3D "spurious int" },
-	{ .handler =3D ami_int1, .name =3D "int1 handler" },
-	{ 0, /* CIAA */ },
-	{ .handler =3D ami_int3, .name =3D "int3 handler" },
-	{ .handler =3D ami_int4, .name =3D "int4 handler" },
-	{ .handler =3D ami_int5, .name =3D "int5 handler" },
-	{ 0, /* CIAB */ },
-	{ .handler =3D ami_int7, .name =3D "int7 handler" },
-};
-#else
-void (*amiga_default_handler[SYS_IRQS])(int, void *, struct pt_regs *)=
 =3D {
-	ami_badint, ami_int1, ami_badint, ami_int3,
-	ami_int4, ami_int5, ami_badint, ami_int7
-};
-#endif
diff -puN arch/ppc/amiga/amisound.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/amisound.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../m68k/amiga/amisound.c"
diff -puN arch/ppc/amiga/bootinfo.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/bootinfo.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- *  Extracted from arch/m68k/kernel/setup.c.
- *  Should be properly generalized and put somewhere else.
- *                              Jesper
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/init.h>
-
-#include <asm/setup.h>
-#include <asm/bootinfo.h>
-
-extern char cmd_line[CL_SIZE];
-
-extern int num_memory;
-extern int m68k_realnum_memory;
-extern struct mem_info memory[NUM_MEMINFO];
-extern struct mem_info m68k_memory[NUM_MEMINFO];
-extern struct mem_info ramdisk;
-
-extern int amiga_parse_bootinfo(const struct bi_record *);
-extern int atari_parse_bootinfo(const struct bi_record *);
-extern int mac_parse_bootinfo(const struct bi_record *);
-
-void __init parse_bootinfo(const struct bi_record *record)
-{
-    while (record->tag !=3D BI_LAST) {
-	int unknown =3D 0;
-	const u_long *data =3D record->data;
-	switch (record->tag) {
-	    case BI_MACHTYPE:
-	    case BI_CPUTYPE:
-	    case BI_FPUTYPE:
-	    case BI_MMUTYPE:
-		/* Already set up by head.S */
-		break;
-
-	    case BI_MEMCHUNK:
-		if (num_memory < NUM_MEMINFO) {
-		    memory[num_memory].addr =3D data[0];
-		    memory[num_memory].size =3D data[1];
-		    num_memory++;
-
-		    /* FIXME: duplicate for m68k drivers. */
-		    m68k_memory[m68k_realnum_memory].addr =3D data[0];
-		    m68k_memory[m68k_realnum_memory].size =3D data[1];
-		    m68k_realnum_memory++;
-		} else
-		    printk("parse_bootinfo: too many memory chunks\n");
-		break;
-
-	    case BI_RAMDISK:
-		ramdisk.addr =3D data[0];
-		ramdisk.size =3D data[1];
-		break;
-
-	    case BI_COMMAND_LINE:
-		strlcpy(cmd_line, (const char *)data, sizeof(cmd_line));
-		break;
-
-	    default:
-		if (MACH_IS_AMIGA)
-		    unknown =3D amiga_parse_bootinfo(record);
-		else if (MACH_IS_ATARI)
-		    unknown =3D atari_parse_bootinfo(record);
-		else if (MACH_IS_MAC)
-		    unknown =3D mac_parse_bootinfo(record);
-		else
-		    unknown =3D 1;
-	}
-	if (unknown)
-	    printk("parse_bootinfo: unknown tag 0x%04x ignored\n",
-		   record->tag);
-	record =3D (struct bi_record *)((u_long)record+record->size);
-    }
-}
diff -puN arch/ppc/amiga/chipram.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/chipram.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../m68k/amiga/chipram.c"
diff -puN arch/ppc/amiga/cia.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/cia.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- *  Copyright (C) 1996 Roman Zippel
- *
- *  The concept of some functions bases on the original Amiga OS funct=
ion
- *
- * This file is subject to the terms and conditions of the GNU General=
 Public
- * License.  See the file COPYING in the main directory of this archiv=
e
- * for more details.
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/init.h>
-
-#include <asm/irq.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-
-struct ciabase {
-	volatile struct CIA *cia;
-	u_char icr_mask, icr_data;
-	u_short int_mask;
-	int handler_irq, cia_irq, server_irq;
-	char *name;
-} ciaa_base =3D {
-	&ciaa, 0, 0, IF_PORTS,
-	IRQ_AMIGA_AUTO_2, IRQ_AMIGA_CIAA,
-	IRQ_AMIGA_PORTS,
-	"CIAA handler"
-}, ciab_base =3D {
-	&ciab, 0, 0, IF_EXTER,
-	IRQ_AMIGA_AUTO_6, IRQ_AMIGA_CIAB,
-	IRQ_AMIGA_EXTER,
-	"CIAB handler"
-};
-
-#define CIA_SET_BASE_ADJUST_IRQ(base, irq)	\
-do {						\
-	if (irq >=3D IRQ_AMIGA_CIAB) {		\
-		base =3D &ciab_base;		\
-		irq -=3D IRQ_AMIGA_CIAB;		\
-	} else {				\
-		base =3D &ciaa_base;		\
-		irq -=3D IRQ_AMIGA_CIAA;		\
-	}					\
-} while (0)
-
-/*
- *  Cause or clear CIA interrupts, return old interrupt status.
- */
-
-static unsigned char cia_set_irq_private(struct ciabase *base,
-					 unsigned char mask)
-{
-	u_char old;
-
-	old =3D (base->icr_data |=3D base->cia->icr);
-	if (mask & CIA_ICR_SETCLR)
-		base->icr_data |=3D mask;
-	else
-		base->icr_data &=3D ~mask;
-	if (base->icr_data & base->icr_mask)
-		amiga_custom.intreq =3D IF_SETCLR | base->int_mask;
-	return old & base->icr_mask;
-}
-
-unsigned char cia_set_irq(unsigned int irq, int set)
-{
-	struct ciabase *base;
-	unsigned char mask;
-
-	if (irq >=3D IRQ_AMIGA_CIAB)
-		mask =3D (1 << (irq - IRQ_AMIGA_CIAB));
-	else
-		mask =3D (1 << (irq - IRQ_AMIGA_CIAA));
-	mask |=3D (set) ? CIA_ICR_SETCLR : 0;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return cia_set_irq_private(base, mask);
-}
-
-unsigned char cia_get_irq_mask(unsigned int irq)
-{
-	struct ciabase *base;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return base->cia->icr;
-}
-
-/*
- *  Enable or disable CIA interrupts, return old interrupt mask.
- */
-
-static unsigned char cia_able_irq_private(struct ciabase *base,
-					  unsigned char mask)
-{
-	u_char old;
-
-	old =3D base->icr_mask;
-	base->icr_data |=3D base->cia->icr;
-	base->cia->icr =3D mask;
-	if (mask & CIA_ICR_SETCLR)
-		base->icr_mask |=3D mask;
-	else
-		base->icr_mask &=3D ~mask;
-	base->icr_mask &=3D CIA_ICR_ALL;
-
-	if (base->icr_data & base->icr_mask)
-		amiga_custom.intreq =3D IF_SETCLR | base->int_mask;
-	return old;
-}
-
-unsigned char cia_able_irq(unsigned int irq, int enable)
-{
-	struct ciabase *base;
-	unsigned char mask;
-
-	if (irq >=3D IRQ_AMIGA_CIAB)
-		mask =3D (1 << (irq - IRQ_AMIGA_CIAB));
-	else
-		mask =3D (1 << (irq - IRQ_AMIGA_CIAA));
-	mask |=3D (enable) ? CIA_ICR_SETCLR : 0;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return cia_able_irq_private(base, mask);
-}
-
-static void cia_handler(int irq, void *dev_id, struct pt_regs *fp)
-{
-	struct ciabase *base =3D (struct ciabase *)dev_id;
-	irq_desc_t *desc;
-	struct irqaction *action;
-	int i;
-	unsigned char ints;
-
-	irq =3D base->cia_irq;
-	desc =3D irq_desc + irq;
-	ints =3D cia_set_irq_private(base, CIA_ICR_ALL);
-	amiga_custom.intreq =3D base->int_mask;
-	for (i =3D 0; i < CIA_IRQS; i++, irq++) {
-		if (ints & 1) {
-			kstat_cpu(0).irqs[irq]++;
-			action =3D desc->action;
-			action->handler(irq, action->dev_id, fp);
-		}
-		ints >>=3D 1;
-		desc++;
-	}
-	amiga_do_irq_list(base->server_irq, fp);
-}
-
-void __init cia_init_IRQ(struct ciabase *base)
-{
-	extern struct irqaction amiga_sys_irqaction[AUTO_IRQS];
-	struct irqaction *action;
-
-	/* clear any pending interrupt and turn off all interrupts */
-	cia_set_irq_private(base, CIA_ICR_ALL);
-	cia_able_irq_private(base, CIA_ICR_ALL);
-
-	/* install CIA handler */
-	action =3D &amiga_sys_irqaction[base->handler_irq-IRQ_AMIGA_AUTO];
-	action->handler =3D cia_handler;
-	action->dev_id =3D base;
-	action->name =3D base->name;
-	setup_irq(base->handler_irq, &amiga_sys_irqaction[base->handler_irq-I=
RQ_AMIGA_AUTO]);
-
-	amiga_custom.intena =3D IF_SETCLR | base->int_mask;
-}
diff -puN arch/ppc/amiga/config.c~ppc-remove-apus-support arch/ppc/amig=
a/config.c
diff -puN arch/ppc/amiga/ints.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/ints.c
+++ /dev/null
@@ -1,158 +0,0 @@
-/*
- *  Linux/m68k general interrupt handling code from arch/m68k/kernel/i=
nts.c
- *  Needed to drive the m68k emulating IRQ hardware on the PowerUp boa=
rds.
- */
-
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/seq_file.h>
-
-#include <asm/setup.h>
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/page.h>
-#include <asm/machdep.h>
-
-/* table for system interrupt handlers */
-static irq_handler_t irq_list[SYS_IRQS];
-
-static const char *default_names[SYS_IRQS] =3D {
-	"spurious int", "int1 handler", "int2 handler", "int3 handler",
-	"int4 handler", "int5 handler", "int6 handler", "int7 handler"
-};
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-#define NUM_IRQ_NODES 100
-static irq_node_t nodes[NUM_IRQ_NODES];
-
-
-/*
- * void init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the IRQ handling routines.
- */
-
-__init
-void m68k_init_IRQ(void)
-{
-	int i;
-
-	for (i =3D 0; i < SYS_IRQS; i++) {
-		if (mach_default_handler)
-			irq_list[i].handler =3D (*mach_default_handler)[i];
-		irq_list[i].flags   =3D 0;
-		irq_list[i].dev_id  =3D NULL;
-		irq_list[i].devname =3D default_names[i];
-	}
-
-	for (i =3D 0; i < NUM_IRQ_NODES; i++)
-		nodes[i].handler =3D NULL;
-
-	mach_init_IRQ ();
-}
-
-irq_node_t *new_irq_node(void)
-{
-	irq_node_t *node;
-	short i;
-
-	for (node =3D nodes, i =3D NUM_IRQ_NODES-1; i >=3D 0; node++, i--)
-		if (!node->handler)
-			return node;
-
-	printk ("new_irq_node: out of nodes\n");
-	return NULL;
-}
-
-int sys_request_irq(unsigned int irq,
-                    void (*handler)(int, void *, struct pt_regs *),
-                    unsigned long flags, const char *devname, void *de=
v_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, devname);
-		return -ENXIO;
-	}
-
-#if 0
-	if (!(irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk("%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (!(flags & IRQ_FLG_REPLACE)) {
-			printk("%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-#endif
-
-	irq_list[irq].handler =3D handler;
-	irq_list[irq].flags   =3D flags;
-	irq_list[irq].dev_id  =3D dev_id;
-	irq_list[irq].devname =3D devname;
-	return 0;
-}
-
-void sys_free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (irq_list[irq].dev_id !=3D dev_id)
-		printk("%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq].devname);
-
-	irq_list[irq].handler =3D (*mach_default_handler)[irq];
-	irq_list[irq].flags   =3D 0;
-	irq_list[irq].dev_id  =3D NULL;
-	irq_list[irq].devname =3D default_names[irq];
-}
-
-asmlinkage void process_int(unsigned long vec, struct pt_regs *fp)
-{
-	if (vec >=3D VEC_INT1 && vec <=3D VEC_INT7 && !MACH_IS_BVME6000) {
-		vec -=3D VEC_SPUR;
-		kstat_cpu(0).irqs[vec]++;
-		irq_list[vec].handler(vec, irq_list[vec].dev_id, fp);
-	} else {
-		if (mach_process_int)
-			mach_process_int(vec, fp);
-		else
-			panic("Can't process interrupt vector %ld\n", vec);
-		return;
-	}
-}
-
-int m68k_get_irq_list(struct seq_file *p, void *v)
-{
-	int i;
-
-	/* autovector interrupts */
-	if (mach_default_handler) {
-		for (i =3D 0; i < SYS_IRQS; i++) {
-			seq_printf(p, "auto %2d: %10u ", i,
-			               i ? kstat_cpu(0).irqs[i] : num_spurious);
-			seq_puts(p, "  ");
-			seq_printf(p, "%s\n", irq_list[i].devname);
-		}
-	}
-
-	mach_get_irq_list(p, v);
-	return 0;
-}
diff -puN arch/ppc/amiga/pcmcia.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/pcmcia.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../m68k/amiga/pcmcia.c"
diff -puN arch/ppc/amiga/time.c~ppc-remove-apus-support /dev/null
--- a/arch/ppc/amiga/time.c
+++ /dev/null
@@ -1,57 +0,0 @@
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-
-#include <asm/machdep.h>
-#include <asm/io.h>
-
-#include <linux/timex.h>
-
-unsigned long m68k_get_rtc_time(void)
-{
-	unsigned int year, mon, day, hour, min, sec;
-
-	extern void arch_gettod(int *year, int *mon, int *day, int *hour,
-				int *min, int *sec);
-
-	arch_gettod (&year, &mon, &day, &hour, &min, &sec);
-
-	if ((year +=3D 1900) < 1970)
-		year +=3D 100;
-
-	return mktime(year, mon, day, hour, min, sec);
-}
-
-int m68k_set_rtc_time(unsigned long nowtime)
-{
-  if (mach_set_clock_mmss)
-    return mach_set_clock_mmss (nowtime);
-  return -1;
-}
-
-void apus_heartbeat (void)
-{
-#ifdef CONFIG_HEARTBEAT
-	static unsigned cnt =3D 0, period =3D 0, dist =3D 0;
-
-	if (cnt =3D=3D 0 || cnt =3D=3D dist)
-                mach_heartbeat( 1 );
-	else if (cnt =3D=3D 7 || cnt =3D=3D dist+7)
-                mach_heartbeat( 0 );
-
-	if (++cnt > period) {
-                cnt =3D 0;
-                /* The hyperbolic function below modifies the heartbea=
t period
-                 * length in dependency of the current (5min) load. It=
 goes
-                 * through the points f(0)=3D126, f(1)=3D86, f(5)=3D51=
,
-                 * f(inf)->30. */
-                period =3D ((672<<FSHIFT)/(5*avenrun[0]+(7<<FSHIFT))) =
+ 30;
-                dist =3D period / 4;
-	}
-#endif
-	/* should be made smarter */
-	ppc_md.heartbeat_count =3D 1;
-}
diff -puN arch/ppc/configs/apus_defconfig~ppc-remove-apus-support /dev/=
null
--- a/arch/ppc/configs/apus_defconfig
+++ /dev/null
@@ -1,920 +0,0 @@
-#
-# Automatically generated make config: don't edit
-#
-CONFIG_MMU=3Dy
-CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
-CONFIG_HAVE_DEC_LOCK=3Dy
-
-#
-# Code maturity level options
-#
-CONFIG_EXPERIMENTAL=3Dy
-
-#
-# General setup
-#
-CONFIG_SWAP=3Dy
-CONFIG_SYSVIPC=3Dy
-# CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=3Dy
-CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_EMBEDDED is not set
-CONFIG_FUTEX=3Dy
-CONFIG_EPOLL=3Dy
-
-#
-# Loadable module support
-#
-CONFIG_MODULES=3Dy
-CONFIG_MODULE_UNLOAD=3Dy
-CONFIG_MODULE_FORCE_UNLOAD=3Dy
-CONFIG_OBSOLETE_MODPARM=3Dy
-# CONFIG_MODVERSIONS is not set
-CONFIG_KMOD=3Dy
-
-#
-# Platform support
-#
-CONFIG_PPC=3Dy
-CONFIG_PPC32=3Dy
-CONFIG_6xx=3Dy
-# CONFIG_40x is not set
-# CONFIG_POWER3 is not set
-# CONFIG_8xx is not set
-
-#
-# IBM 4xx options
-#
-# CONFIG_8260 is not set
-CONFIG_GENERIC_ISA_DMA=3Dy
-CONFIG_PPC_STD_MMU=3Dy
-CONFIG_SERIAL_CONSOLE=3Dy
-# CONFIG_PPC_MULTIPLATFORM is not set
-CONFIG_APUS=3Dy
-# CONFIG_WILLOW_2 is not set
-# CONFIG_PCORE is not set
-# CONFIG_POWERPMC250 is not set
-# CONFIG_EV64260 is not set
-# CONFIG_SPRUCE is not set
-# CONFIG_LOPEC is not set
-# CONFIG_MCPN765 is not set
-# CONFIG_MVME5100 is not set
-# CONFIG_PPLUS is not set
-# CONFIG_PRPMC750 is not set
-# CONFIG_PRPMC800 is not set
-# CONFIG_SANDPOINT is not set
-# CONFIG_ADIR is not set
-# CONFIG_K2 is not set
-# CONFIG_PAL4 is not set
-# CONFIG_GEMINI is not set
-# CONFIG_SMP is not set
-# CONFIG_PREEMPT is not set
-# CONFIG_ALTIVEC is not set
-# CONFIG_TAU is not set
-# CONFIG_CPU_FREQ is not set
-
-#
-# General setup
-#
-# CONFIG_HIGHMEM is not set
-CONFIG_PCI=3Dy
-CONFIG_PCI_DOMAINS=3Dy
-CONFIG_PCI_PERMEDIA=3Dy
-CONFIG_KCORE_ELF=3Dy
-CONFIG_BINFMT_ELF=3Dy
-CONFIG_KERNEL_ELF=3Dy
-CONFIG_BINFMT_MISC=3Dm
-CONFIG_PCI_LEGACY_PROC=3Dy
-CONFIG_PCI_NAMES=3Dy
-# CONFIG_HOTPLUG is not set
-
-#
-# Parallel port support
-#
-CONFIG_PARPORT=3Dm
-# CONFIG_PARPORT_PC is not set
-CONFIG_PARPORT_AMIGA=3Dm
-# CONFIG_PARPORT_MFC3 is not set
-# CONFIG_PARPORT_OTHER is not set
-# CONFIG_PARPORT_1284 is not set
-CONFIG_PPC601_SYNC_FIX=3Dy
-# CONFIG_CMDLINE_BOOL is not set
-CONFIG_AMIGA=3Dy
-CONFIG_ZORRO=3Dy
-CONFIG_ABSTRACT_CONSOLE=3Dy
-CONFIG_APUS_FAST_EXCEPT=3Dy
-CONFIG_AMIGA_PCMCIA=3Dy
-CONFIG_AMIGA_BUILTIN_SERIAL=3Dy
-CONFIG_GVPIOEXT=3Dy
-CONFIG_GVPIOEXT_LP=3Dm
-CONFIG_GVPIOEXT_PLIP=3Dm
-CONFIG_MULTIFACE_III_TTY=3Dy
-CONFIG_A2232=3Dy
-CONFIG_WHIPPET_SERIAL=3Dy
-CONFIG_APNE=3Dy
-CONFIG_HEARTBEAT=3Dy
-CONFIG_PROC_HARDWARE=3Dy
-CONFIG_ZORRO_NAMES=3Dy
-
-#
-# Advanced setup
-#
-# CONFIG_ADVANCED_OPTIONS is not set
-
-#
-# Default settings for advanced configuration options are used
-#
-CONFIG_HIGHMEM_START=3D0xfe000000
-CONFIG_LOWMEM_SIZE=3D0x30000000
-CONFIG_KERNEL_START=3D0xc0000000
-CONFIG_TASK_SIZE=3D0x80000000
-CONFIG_BOOT_LOAD=3D0x00800000
-
-#
-# Memory Technology Devices (MTD)
-#
-# CONFIG_MTD is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNP is not set
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_FD is not set
-CONFIG_AMIGA_FLOPPY=3Dy
-CONFIG_AMIGA_Z2RAM=3Dm
-# CONFIG_PARIDE is not set
-# CONFIG_BLK_CPQ_DA is not set
-# CONFIG_BLK_CPQ_CISS_DA is not set
-# CONFIG_BLK_DEV_DAC960 is not set
-# CONFIG_BLK_DEV_UMEM is not set
-CONFIG_BLK_DEV_LOOP=3Dy
-CONFIG_BLK_DEV_NBD=3Dm
-CONFIG_BLK_DEV_RAM=3Dy
-CONFIG_BLK_DEV_RAM_SIZE=3D4096
-CONFIG_BLK_DEV_INITRD=3Dy
-
-#
-# Multi-device support (RAID and LVM)
-#
-CONFIG_MD=3Dy
-CONFIG_BLK_DEV_MD=3Dm
-CONFIG_MD_LINEAR=3Dm
-CONFIG_MD_RAID0=3Dm
-CONFIG_MD_RAID1=3Dm
-CONFIG_MD_RAID5=3Dm
-# CONFIG_MD_MULTIPATH is not set
-CONFIG_BLK_DEV_DM=3Dm
-
-#
-# ATA/IDE/MFM/RLL support
-#
-CONFIG_IDE=3Dy
-
-#
-# IDE, ATA and ATAPI Block devices
-#
-CONFIG_BLK_DEV_IDE=3Dy
-
-#
-# Please see Documentation/ide.txt for help/info on IDE drives
-#
-# CONFIG_BLK_DEV_HD is not set
-CONFIG_BLK_DEV_IDEDISK=3Dy
-# CONFIG_IDEDISK_MULTI_MODE is not set
-# CONFIG_IDEDISK_STROKE is not set
-CONFIG_BLK_DEV_IDECD=3Dy
-CONFIG_BLK_DEV_IDEFLOPPY=3Dy
-CONFIG_BLK_DEV_IDESCSI=3Dm
-# CONFIG_IDE_TASK_IOCTL is not set
-
-#
-# IDE chipset support/bugfixes
-#
-# CONFIG_BLK_DEV_IDEPCI is not set
-CONFIG_BLK_DEV_GAYLE=3Dy
-CONFIG_BLK_DEV_IDEDOUBLER=3Dy
-CONFIG_BLK_DEV_BUDDHA=3Dy
-
-#
-# SCSI support
-#
-CONFIG_SCSI=3Dy
-
-#
-# SCSI support type (disk, tape, CD-ROM)
-#
-CONFIG_BLK_DEV_SD=3Dy
-CONFIG_CHR_DEV_ST=3Dm
-CONFIG_CHR_DEV_OSST=3Dm
-CONFIG_BLK_DEV_SR=3Dy
-CONFIG_BLK_DEV_SR_VENDOR=3Dy
-CONFIG_CHR_DEV_SG=3Dm
-
-#
-# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
-#
-# CONFIG_SCSI_MULTI_LUN is not set
-# CONFIG_SCSI_REPORT_LUNS is not set
-CONFIG_SCSI_CONSTANTS=3Dy
-CONFIG_SCSI_LOGGING=3Dy
-
-#
-# SCSI low-level drivers
-#
-# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
-# CONFIG_SCSI_ACARD is not set
-# CONFIG_SCSI_AACRAID is not set
-# CONFIG_SCSI_AIC7XXX is not set
-# CONFIG_SCSI_AIC7XXX_OLD is not set
-# CONFIG_SCSI_AIC79XX is not set
-# CONFIG_SCSI_DPT_I2O is not set
-# CONFIG_SCSI_ADVANSYS is not set
-# CONFIG_SCSI_IN2000 is not set
-# CONFIG_SCSI_AM53C974 is not set
-# CONFIG_SCSI_MEGARAID is not set
-# CONFIG_SCSI_BUSLOGIC is not set
-# CONFIG_SCSI_CPQFCTS is not set
-# CONFIG_SCSI_DMX3191D is not set
-# CONFIG_SCSI_EATA is not set
-# CONFIG_SCSI_EATA_PIO is not set
-# CONFIG_SCSI_FUTURE_DOMAIN is not set
-# CONFIG_SCSI_GDTH is not set
-# CONFIG_SCSI_GENERIC_NCR5380 is not set
-# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
-# CONFIG_SCSI_INITIO is not set
-# CONFIG_SCSI_INIA100 is not set
-# CONFIG_SCSI_PPA is not set
-# CONFIG_SCSI_IMM is not set
-# CONFIG_SCSI_NCR53C7xx is not set
-# CONFIG_SCSI_SYM53C8XX_2 is not set
-# CONFIG_SCSI_NCR53C8XX is not set
-# CONFIG_SCSI_SYM53C8XX is not set
-# CONFIG_SCSI_PCI2000 is not set
-# CONFIG_SCSI_PCI2220I is not set
-# CONFIG_SCSI_QLOGIC_ISP is not set
-# CONFIG_SCSI_QLOGIC_FC is not set
-# CONFIG_SCSI_QLOGIC_1280 is not set
-# CONFIG_SCSI_DC395x is not set
-# CONFIG_SCSI_DC390T is not set
-# CONFIG_SCSI_U14_34F is not set
-# CONFIG_SCSI_NSP32 is not set
-# CONFIG_SCSI_DEBUG is not set
-CONFIG_A3000_SCSI=3Dy
-CONFIG_A4000T_SCSI=3Dy
-CONFIG_A2091_SCSI=3Dy
-CONFIG_GVP11_SCSI=3Dy
-CONFIG_CYBERSTORM_SCSI=3Dy
-CONFIG_CYBERSTORMII_SCSI=3Dy
-CONFIG_BLZ2060_SCSI=3Dy
-CONFIG_BLZ1230_SCSI=3Dy
-CONFIG_FASTLANE_SCSI=3Dy
-CONFIG_A4091_SCSI=3Dy
-CONFIG_WARPENGINE_SCSI=3Dy
-CONFIG_BLZ603EPLUS_SCSI=3Dy
-CONFIG_OKTAGON_SCSI=3Dy
-
-#
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support (EXPERIMENTAL)
-#
-# CONFIG_IEEE1394 is not set
-
-#
-# I2O device support
-#
-# CONFIG_I2O is not set
-
-#
-# Networking support
-#
-CONFIG_NET=3Dy
-
-#
-# Networking options
-#
-CONFIG_PACKET=3Dm
-CONFIG_PACKET_MMAP=3Dy
-CONFIG_NETLINK_DEV=3Dm
-CONFIG_NETFILTER=3Dy
-# CONFIG_NETFILTER_DEBUG is not set
-CONFIG_UNIX=3Dy
-# CONFIG_NET_KEY is not set
-CONFIG_INET=3Dy
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_INET_ECN is not set
-CONFIG_SYN_COOKIES=3Dy
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-
-#
-# IP: Netfilter Configuration
-#
-CONFIG_IP_NF_CONNTRACK=3Dm
-CONFIG_IP_NF_FTP=3Dm
-CONFIG_IP_NF_IRC=3Dm
-CONFIG_IP_NF_TFTP=3Dm
-CONFIG_IP_NF_AMANDA=3Dm
-CONFIG_IP_NF_QUEUE=3Dm
-CONFIG_IP_NF_IPTABLES=3Dm
-CONFIG_IP_NF_MATCH_LIMIT=3Dm
-CONFIG_IP_NF_MATCH_MAC=3Dm
-# CONFIG_IP_NF_MATCH_PKTTYPE is not set
-CONFIG_IP_NF_MATCH_MARK=3Dm
-CONFIG_IP_NF_MATCH_MULTIPORT=3Dm
-CONFIG_IP_NF_MATCH_TOS=3Dm
-# CONFIG_IP_NF_MATCH_ECN is not set
-# CONFIG_IP_NF_MATCH_DSCP is not set
-# CONFIG_IP_NF_MATCH_AH_ESP is not set
-CONFIG_IP_NF_MATCH_LENGTH=3Dm
-CONFIG_IP_NF_MATCH_TTL=3Dm
-CONFIG_IP_NF_MATCH_TCPMSS=3Dm
-CONFIG_IP_NF_MATCH_HELPER=3Dm
-CONFIG_IP_NF_MATCH_STATE=3Dm
-CONFIG_IP_NF_MATCH_CONNTRACK=3Dm
-CONFIG_IP_NF_MATCH_UNCLEAN=3Dm
-CONFIG_IP_NF_MATCH_OWNER=3Dm
-CONFIG_IP_NF_FILTER=3Dm
-CONFIG_IP_NF_TARGET_REJECT=3Dm
-CONFIG_IP_NF_TARGET_MIRROR=3Dm
-CONFIG_IP_NF_NAT=3Dm
-CONFIG_IP_NF_NAT_NEEDED=3Dy
-CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
-CONFIG_IP_NF_TARGET_REDIRECT=3Dm
-CONFIG_IP_NF_NAT_SNMP_BASIC=3Dm
-CONFIG_IP_NF_NAT_IRC=3Dm
-CONFIG_IP_NF_NAT_FTP=3Dm
-CONFIG_IP_NF_NAT_TFTP=3Dm
-CONFIG_IP_NF_NAT_AMANDA=3Dm
-CONFIG_IP_NF_MANGLE=3Dm
-CONFIG_IP_NF_TARGET_TOS=3Dm
-CONFIG_IP_NF_TARGET_ECN=3Dm
-CONFIG_IP_NF_TARGET_DSCP=3Dm
-CONFIG_IP_NF_TARGET_MARK=3Dm
-CONFIG_IP_NF_TARGET_LOG=3Dm
-CONFIG_IP_NF_TARGET_ULOG=3Dm
-CONFIG_IP_NF_TARGET_TCPMSS=3Dm
-CONFIG_IP_NF_ARPTABLES=3Dm
-CONFIG_IP_NF_ARPFILTER=3Dm
-CONFIG_IP_NF_COMPAT_IPCHAINS=3Dm
-# CONFIG_IP_NF_COMPAT_IPFWADM is not set
-# CONFIG_IPV6 is not set
-# CONFIG_XFRM_USER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-CONFIG_IPV6_SCTP__=3Dy
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_LLC is not set
-# CONFIG_DECNET is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_HW_FLOWCONTROL is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-CONFIG_NETDEVICES=3Dy
-
-#
-# ARCnet devices
-#
-# CONFIG_ARCNET is not set
-CONFIG_DUMMY=3Dm
-# CONFIG_BONDING is not set
-# CONFIG_EQUALIZER is not set
-CONFIG_TUN=3Dm
-# CONFIG_ETHERTAP is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
-CONFIG_NET_ETHERNET=3Dy
-# CONFIG_MII is not set
-# CONFIG_OAKNET is not set
-CONFIG_ARIADNE=3Dy
-# CONFIG_ZORRO8390 is not set
-CONFIG_A2065=3Dy
-CONFIG_HYDRA=3Dy
-# CONFIG_HAPPYMEAL is not set
-# CONFIG_SUNGEM is not set
-# CONFIG_NET_VENDOR_3COM is not set
-
-#
-# Tulip family network device support
-#
-# CONFIG_NET_TULIP is not set
-# CONFIG_HP100 is not set
-# CONFIG_NET_PCI is not set
-
-#
-# Ethernet (1000 Mbit)
-#
-# CONFIG_ACENIC is not set
-# CONFIG_DL2K is not set
-# CONFIG_E1000 is not set
-# CONFIG_NS83820 is not set
-# CONFIG_HAMACHI is not set
-# CONFIG_YELLOWFIN is not set
-# CONFIG_R8169 is not set
-# CONFIG_SK98LIN is not set
-# CONFIG_TIGON3 is not set
-
-#
-# Ethernet (10000 Mbit)
-#
-# CONFIG_IXGB is not set
-# CONFIG_FDDI is not set
-# CONFIG_HIPPI is not set
-CONFIG_PLIP=3Dm
-CONFIG_PPP=3Dy
-CONFIG_PPP_MULTILINK=3Dy
-CONFIG_PPP_FILTER=3Dy
-CONFIG_PPP_ASYNC=3Dy
-CONFIG_PPP_SYNC_TTY=3Dy
-CONFIG_PPP_DEFLATE=3Dy
-CONFIG_PPP_BSDCOMP=3Dy
-CONFIG_PPPOE=3Dy
-CONFIG_SLIP=3Dy
-CONFIG_SLIP_COMPRESSED=3Dy
-CONFIG_SLIP_SMART=3Dy
-CONFIG_SLIP_MODE_SLIP6=3Dy
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Token Ring devices (depends on LLC=3Dy)
-#
-# CONFIG_NET_FC is not set
-# CONFIG_RCPCI is not set
-# CONFIG_SHAPER is not set
-
-#
-# Wan interfaces
-#
-# CONFIG_WAN is not set
-
-#
-# Amateur Radio support
-#
-# CONFIG_HAMRADIO is not set
-
-#
-# IrDA (infrared) support
-#
-# CONFIG_IRDA is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN_BOOL is not set
-
-#
-# Graphics support
-#
-CONFIG_FB=3Dy
-# CONFIG_FB_CIRRUS is not set
-CONFIG_FB_PM2=3Dy
-# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
-# CONFIG_FB_PM2_PCI is not set
-CONFIG_FB_PM2_CVPPC=3Dy
-CONFIG_FB_CYBER2000=3Dy
-CONFIG_FB_AMIGA=3Dy
-CONFIG_FB_AMIGA_OCS=3Dy
-CONFIG_FB_AMIGA_ECS=3Dy
-CONFIG_FB_AMIGA_AGA=3Dy
-CONFIG_FB_CYBER=3Dy
-CONFIG_FB_VIRGE=3Dy
-CONFIG_FB_RETINAZ3=3Dy
-CONFIG_FB_FM2=3Dy
-# CONFIG_FB_CT65550 is not set
-# CONFIG_FB_IMSTT is not set
-# CONFIG_FB_S3TRIO is not set
-# CONFIG_FB_VGA16 is not set
-# CONFIG_FB_RIVA is not set
-# CONFIG_FB_MATROX is not set
-# CONFIG_FB_RADEON is not set
-# CONFIG_FB_ATY128 is not set
-# CONFIG_FB_ATY is not set
-# CONFIG_FB_SIS is not set
-# CONFIG_FB_NEOMAGIC is not set
-# CONFIG_FB_3DFX is not set
-# CONFIG_FB_VOODOO1 is not set
-# CONFIG_FB_TRIDENT is not set
-# CONFIG_FB_PM3 is not set
-# CONFIG_FB_VIRTUAL is not set
-
-#
-# Logo configuration
-#
-CONFIG_LOGO=3Dy
-CONFIG_LOGO_LINUX_MONO=3Dy
-CONFIG_LOGO_LINUX_VGA16=3Dy
-CONFIG_LOGO_LINUX_CLUT224=3Dy
-
-#
-# Old CD-ROM drivers (not SCSI, not IDE)
-#
-# CONFIG_CD_NO_IDESCSI is not set
-
-#
-# Input device support
-#
-CONFIG_INPUT=3Dm
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=3Dm
-CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
-CONFIG_INPUT_JOYDEV=3Dm
-# CONFIG_INPUT_TSDEV is not set
-CONFIG_INPUT_EVDEV=3Dm
-CONFIG_INPUT_EVBUG=3Dm
-
-#
-# Input I/O drivers
-#
-# CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=3Dy
-CONFIG_SERIO=3Dy
-# CONFIG_SERIO_I8042 is not set
-CONFIG_SERIO_SERPORT=3Dy
-# CONFIG_SERIO_CT82C710 is not set
-# CONFIG_SERIO_PARKBD is not set
-
-#
-# Input Device Drivers
-#
-CONFIG_INPUT_KEYBOARD=3Dy
-CONFIG_KEYBOARD_ATKBD=3Dm
-# CONFIG_KEYBOARD_SUNKBD is not set
-# CONFIG_KEYBOARD_XTKBD is not set
-# CONFIG_KEYBOARD_NEWTON is not set
-CONFIG_KEYBOARD_AMIGA=3Dm
-CONFIG_INPUT_MOUSE=3Dy
-CONFIG_MOUSE_PS2=3Dm
-CONFIG_MOUSE_SERIAL=3Dm
-CONFIG_MOUSE_AMIGA=3Dm
-# CONFIG_INPUT_JOYSTICK is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
-CONFIG_INPUT_MISC=3Dy
-# CONFIG_INPUT_PCSPKR is not set
-CONFIG_INPUT_UINPUT=3Dm
-
-#
-# Macintosh device drivers
-#
-
-#
-# Character devices
-#
-# CONFIG_SERIAL_NONSTANDARD is not set
-
-#
-# Serial drivers
-#
-# CONFIG_SERIAL_8250 is not set
-
-#
-# Non-8250 serial port support
-#
-CONFIG_UNIX98_PTYS=3Dy
-CONFIG_UNIX98_PTY_COUNT=3D256
-CONFIG_PRINTER=3Dm
-# CONFIG_LP_CONSOLE is not set
-# CONFIG_PPDEV is not set
-# CONFIG_TIPAR is not set
-
-#
-# I2C support
-#
-# CONFIG_I2C is not set
-
-#
-# I2C Hardware Sensors Mainboard support
-#
-
-#
-# I2C Hardware Sensors Chip support
-#
-# CONFIG_I2C_SENSOR is not set
-
-#
-# Mice
-#
-CONFIG_BUSMOUSE=3Dy
-# CONFIG_QIC02_TAPE is not set
-
-#
-# IPMI
-#
-# CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
-# CONFIG_WATCHDOG is not set
-# CONFIG_NVRAM is not set
-CONFIG_GEN_RTC=3Dy
-# CONFIG_GEN_RTC_X is not set
-# CONFIG_DTLK is not set
-# CONFIG_R3964 is not set
-# CONFIG_APPLICOM is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_FTAPE is not set
-# CONFIG_AGP is not set
-# CONFIG_DRM is not set
-# CONFIG_RAW_DRIVER is not set
-# CONFIG_HANGCHECK_TIMER is not set
-
-#
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
-
-#
-# File systems
-#
-CONFIG_EXT2_FS=3Dy
-# CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=3Dy
-CONFIG_EXT3_FS_XATTR=3Dy
-# CONFIG_EXT3_FS_POSIX_ACL is not set
-# CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=3Dy
-# CONFIG_JBD_DEBUG is not set
-CONFIG_FS_MBCACHE=3Dy
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_XFS_FS is not set
-CONFIG_MINIX_FS=3Dy
-CONFIG_ROMFS_FS=3Dy
-# CONFIG_QUOTA is not set
-CONFIG_AUTOFS_FS=3Dm
-CONFIG_AUTOFS4_FS=3Dm
-
-#
-# CD-ROM/DVD Filesystems
-#
-CONFIG_ISO9660_FS=3Dy
-CONFIG_JOLIET=3Dy
-# CONFIG_ZISOFS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-CONFIG_FAT_FS=3Dy
-CONFIG_MSDOS_FS=3Dy
-CONFIG_VFAT_FS=3Dy
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=3Dy
-# CONFIG_DEVFS_FS is not set
-CONFIG_DEVPTS_FS=3Dy
-# CONFIG_DEVPTS_FS_XATTR is not set
-CONFIG_TMPFS=3Dy
-CONFIG_RAMFS=3Dy
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-CONFIG_AFFS_FS=3Dy
-CONFIG_HFS_FS=3Dy
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_CRAMFS=3Dy
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
-CONFIG_NFS_FS=3Dy
-CONFIG_NFS_V3=3Dy
-# CONFIG_NFS_V4 is not set
-CONFIG_NFSD=3Dm
-CONFIG_NFSD_V3=3Dy
-# CONFIG_NFSD_V4 is not set
-# CONFIG_NFSD_TCP is not set
-CONFIG_LOCKD=3Dy
-CONFIG_LOCKD_V4=3Dy
-CONFIG_EXPORTFS=3Dm
-CONFIG_SUNRPC=3Dy
-# CONFIG_SUNRPC_GSS is not set
-CONFIG_SMB_FS=3Dm
-# CONFIG_SMB_NLS_DEFAULT is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-CONFIG_CODA_FS=3Dm
-# CONFIG_INTERMEZZO_FS is not set
-# CONFIG_AFS_FS is not set
-
-#
-# Partition Types
-#
-CONFIG_PARTITION_ADVANCED=3Dy
-# CONFIG_ACORN_PARTITION is not set
-# CONFIG_OSF_PARTITION is not set
-CONFIG_AMIGA_PARTITION=3Dy
-CONFIG_ATARI_PARTITION=3Dy
-# CONFIG_MAC_PARTITION is not set
-CONFIG_MSDOS_PARTITION=3Dy
-CONFIG_BSD_DISKLABEL=3Dy
-# CONFIG_MINIX_SUBPARTITION is not set
-CONFIG_SOLARIS_X86_PARTITION=3Dy
-CONFIG_UNIXWARE_DISKLABEL=3Dy
-# CONFIG_LDM_PARTITION is not set
-# CONFIG_NEC98_PARTITION is not set
-# CONFIG_SGI_PARTITION is not set
-# CONFIG_ULTRIX_PARTITION is not set
-# CONFIG_SUN_PARTITION is not set
-# CONFIG_EFI_PARTITION is not set
-CONFIG_SMB_NLS=3Dy
-CONFIG_NLS=3Dy
-
-#
-# Native Language Support
-#
-CONFIG_NLS_DEFAULT=3D"iso8859-1"
-CONFIG_NLS_CODEPAGE_437=3Dm
-CONFIG_NLS_CODEPAGE_737=3Dm
-CONFIG_NLS_CODEPAGE_775=3Dm
-CONFIG_NLS_CODEPAGE_850=3Dm
-CONFIG_NLS_CODEPAGE_852=3Dm
-CONFIG_NLS_CODEPAGE_855=3Dm
-CONFIG_NLS_CODEPAGE_857=3Dm
-CONFIG_NLS_CODEPAGE_860=3Dm
-CONFIG_NLS_CODEPAGE_861=3Dm
-CONFIG_NLS_CODEPAGE_862=3Dm
-CONFIG_NLS_CODEPAGE_863=3Dm
-CONFIG_NLS_CODEPAGE_864=3Dm
-CONFIG_NLS_CODEPAGE_865=3Dm
-CONFIG_NLS_CODEPAGE_866=3Dm
-CONFIG_NLS_CODEPAGE_869=3Dm
-CONFIG_NLS_CODEPAGE_936=3Dm
-CONFIG_NLS_CODEPAGE_950=3Dm
-CONFIG_NLS_CODEPAGE_932=3Dm
-CONFIG_NLS_CODEPAGE_949=3Dm
-CONFIG_NLS_CODEPAGE_874=3Dm
-CONFIG_NLS_ISO8859_8=3Dm
-# CONFIG_NLS_CODEPAGE_1250 is not set
-CONFIG_NLS_CODEPAGE_1251=3Dm
-CONFIG_NLS_ISO8859_1=3Dm
-CONFIG_NLS_ISO8859_2=3Dm
-CONFIG_NLS_ISO8859_3=3Dm
-CONFIG_NLS_ISO8859_4=3Dm
-CONFIG_NLS_ISO8859_5=3Dm
-CONFIG_NLS_ISO8859_6=3Dm
-CONFIG_NLS_ISO8859_7=3Dm
-CONFIG_NLS_ISO8859_9=3Dm
-CONFIG_NLS_ISO8859_13=3Dm
-CONFIG_NLS_ISO8859_14=3Dm
-CONFIG_NLS_ISO8859_15=3Dm
-CONFIG_NLS_KOI8_R=3Dm
-CONFIG_NLS_KOI8_U=3Dm
-CONFIG_NLS_UTF8=3Dm
-
-#
-# Sound
-#
-CONFIG_SOUND=3Dy
-CONFIG_DMASOUND_PAULA=3Dm
-CONFIG_DMASOUND=3Dm
-
-#
-# Advanced Linux Sound Architecture
-#
-# CONFIG_SND is not set
-
-#
-# Open Sound System
-#
-CONFIG_SOUND_PRIME=3Dm
-# CONFIG_SOUND_BT878 is not set
-# CONFIG_SOUND_CMPCI is not set
-# CONFIG_SOUND_EMU10K1 is not set
-# CONFIG_SOUND_FUSION is not set
-# CONFIG_SOUND_CS4281 is not set
-# CONFIG_SOUND_ES1370 is not set
-# CONFIG_SOUND_ES1371 is not set
-# CONFIG_SOUND_ESSSOLO1 is not set
-# CONFIG_SOUND_MAESTRO is not set
-# CONFIG_SOUND_MAESTRO3 is not set
-# CONFIG_SOUND_ICH is not set
-# CONFIG_SOUND_RME96XX is not set
-# CONFIG_SOUND_SONICVIBES is not set
-# CONFIG_SOUND_TRIDENT is not set
-# CONFIG_SOUND_MSNDCLAS is not set
-# CONFIG_SOUND_MSNDPIN is not set
-# CONFIG_SOUND_VIA82CXXX is not set
-CONFIG_SOUND_OSS=3Dm
-CONFIG_SOUND_TRACEINIT=3Dy
-CONFIG_SOUND_DMAP=3Dy
-# CONFIG_SOUND_AD1816 is not set
-# CONFIG_SOUND_SGALAXY is not set
-# CONFIG_SOUND_ADLIB is not set
-# CONFIG_SOUND_ACI_MIXER is not set
-# CONFIG_SOUND_CS4232 is not set
-# CONFIG_SOUND_SSCAPE is not set
-# CONFIG_SOUND_GUS is not set
-CONFIG_SOUND_VMIDI=3Dm
-# CONFIG_SOUND_TRIX is not set
-# CONFIG_SOUND_MSS is not set
-# CONFIG_SOUND_MPU401 is not set
-# CONFIG_SOUND_NM256 is not set
-# CONFIG_SOUND_MAD16 is not set
-# CONFIG_SOUND_PAS is not set
-# CONFIG_SOUND_PSS is not set
-# CONFIG_SOUND_SB is not set
-# CONFIG_SOUND_AWE32_SYNTH is not set
-# CONFIG_SOUND_WAVEFRONT is not set
-# CONFIG_SOUND_MAUI is not set
-# CONFIG_SOUND_YM3812 is not set
-# CONFIG_SOUND_OPL3SA1 is not set
-# CONFIG_SOUND_OPL3SA2 is not set
-# CONFIG_SOUND_YMFPCI is not set
-# CONFIG_SOUND_UART6850 is not set
-# CONFIG_SOUND_AEDSP16 is not set
-
-#
-# USB support
-#
-# CONFIG_USB is not set
-# CONFIG_USB_GADGET is not set
-
-#
-# Bluetooth support
-#
-# CONFIG_BT is not set
-
-#
-# Library routines
-#
-# CONFIG_CRC32 is not set
-CONFIG_ZLIB_INFLATE=3Dy
-CONFIG_ZLIB_DEFLATE=3Dy
-
-#
-# Kernel hacking
-#
-# CONFIG_DEBUG_KERNEL is not set
-# CONFIG_KALLSYMS is not set
-
-#
-# Security options
-#
-# CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
-# CONFIG_CRYPTO is not set
diff -puN arch/ppc/kernel/head.S~ppc-remove-apus-support arch/ppc/kerne=
l/head.S
--- a/arch/ppc/kernel/head.S~ppc-remove-apus-support
+++ a/arch/ppc/kernel/head.S
@@ -32,10 +32,6 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
=20
-#ifdef CONFIG_APUS
-#include <asm/amigappc.h>
-#endif
-
 /* 601 only have IBAT; cr0.eq is set on 601 when using this macro */
 #define LOAD_BAT(n, reg, RA, RB)	\
 	/* see the comment for clear_bats() -- Cort */ \
@@ -128,14 +124,6 @@ __start:
  */
 	bl	early_init
=20
-#ifdef CONFIG_APUS
-/* On APUS the __va/__pa constants need to be set to the correct
- * values before continuing.
- */
-	mr	r4,r30
-	bl	fix_mem_constants
-#endif /* CONFIG_APUS */
-
 /* Switch MMU off, clear BATs and flush TLB. At this point, r3 contain=
s
  * the physical address we are running at, returned by early_init()
  */
@@ -145,7 +133,7 @@ __after_mmu_off:
 	bl	flush_tlbs
=20
 	bl	initial_bats
-#if !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT)
+#ifdef CONFIG_BOOTX_TEXT
 	bl	setup_disp_bat
 #endif
=20
@@ -161,7 +149,6 @@ __after_mmu_off:
 #endif /* CONFIG_6xx */
=20
=20
-#ifndef CONFIG_APUS
 /*
  * We need to run with _start at physical address 0.
  * If the MMU is already turned on, we copy stuff to KERNELBASE,
@@ -172,7 +159,7 @@ __after_mmu_off:
 	addis	r4,r3,KERNELBASE@h	/* current address of _start */
 	cmpwi	0,r4,0			/* are we already running at 0? */
 	bne	relocate_kernel
-#endif /* CONFIG_APUS */
+
 /*
  * we now have the 1st 16M of ram mapped with the bats.
  * prep needs the mmu to be turned on here, but pmac already has it on=
=2E
@@ -812,85 +799,6 @@ copy_and_flush:
 	addi	r6,r6,4
 	blr
=20
-#ifdef CONFIG_APUS
-/*
- * On APUS the physical base address of the kernel is not known at com=
pile
- * time, which means the __pa/__va constants used are incorrect. In th=
e
- * __init section is recorded the virtual addresses of instructions us=
ing
- * these constants, so all that has to be done is fix these before
- * continuing the kernel boot.
- *
- * r4 =3D The physical address of the kernel base.
- */
-fix_mem_constants:
-	mr	r10,r4
-	addis	r10,r10,-KERNELBASE@h    /* virt_to_phys constant */
-	neg	r11,r10	                 /* phys_to_virt constant */
-
-	lis	r12,__vtop_table_begin@h
-	ori	r12,r12,__vtop_table_begin@l
-	add	r12,r12,r10	         /* table begin phys address */
-	lis	r13,__vtop_table_end@h
-	ori	r13,r13,__vtop_table_end@l
-	add	r13,r13,r10	         /* table end phys address */
-	subi	r12,r12,4
-	subi	r13,r13,4
-1:	lwzu	r14,4(r12)               /* virt address of instruction */
-	add     r14,r14,r10              /* phys address of instruction */
-	lwz     r15,0(r14)               /* instruction, now insert top */
-	rlwimi  r15,r10,16,16,31         /* half of vp const in low half */
-	stw	r15,0(r14)               /* of instruction and restore. */
-	dcbst	r0,r14			 /* write it to memory */
-	sync
-	icbi	r0,r14			 /* flush the icache line */
-	cmpw	r12,r13
-	bne     1b
-	sync				/* additional sync needed on g4 */
-	isync
-
-/*
- * Map the memory where the exception handlers will
- * be copied to when hash constants have been patched.
- */
-#ifdef CONFIG_APUS_FAST_EXCEPT
-	lis	r8,0xfff0
-#else
-	lis	r8,0
-#endif
-	ori	r8,r8,0x2		/* 128KB, supervisor */
-	mtspr	SPRN_DBAT3U,r8
-	mtspr	SPRN_DBAT3L,r8
-
-	lis	r12,__ptov_table_begin@h
-	ori	r12,r12,__ptov_table_begin@l
-	add	r12,r12,r10	         /* table begin phys address */
-	lis	r13,__ptov_table_end@h
-	ori	r13,r13,__ptov_table_end@l
-	add	r13,r13,r10	         /* table end phys address */
-	subi	r12,r12,4
-	subi	r13,r13,4
-1:	lwzu	r14,4(r12)               /* virt address of instruction */
-	add     r14,r14,r10              /* phys address of instruction */
-	lwz     r15,0(r14)               /* instruction, now insert top */
-	rlwimi  r15,r11,16,16,31         /* half of pv const in low half*/
-	stw	r15,0(r14)               /* of instruction and restore. */
-	dcbst	r0,r14			 /* write it to memory */
-	sync
-	icbi	r0,r14			 /* flush the icache line */
-	cmpw	r12,r13
-	bne     1b
-
-	sync				/* additional sync needed on g4 */
-	isync				/* No speculative loading until now */
-	blr
-
-/*********************************************************************=
**
- *  Please note that on APUS the exception handlers are located at the
- *  physical address 0xfff0000. For this reason, the exception handler=
s
- *  cannot use relative branches to access the code below.
- *********************************************************************=
**/
-#endif /* CONFIG_APUS */
-
 #ifdef CONFIG_SMP
 	.globl	__secondary_start_pmac_0
 __secondary_start_pmac_0:
@@ -1043,19 +951,6 @@ start_here:
 	bl	machine_init
 	bl	MMU_init
=20
-#ifdef CONFIG_APUS
-	/* Copy exception code to exception vector base on APUS. */
-	lis	r4,KERNELBASE@h
-#ifdef CONFIG_APUS_FAST_EXCEPT
-	lis	r3,0xfff0		/* Copy to 0xfff00000 */
-#else
-	lis	r3,0			/* Copy to 0x00000000 */
-#endif
-	li	r5,0x4000		/* # bytes of memory to copy */
-	li	r6,0
-	bl	copy_and_flush		/* copy the first 0x4000 bytes */
-#endif  /* CONFIG_APUS */
-
 /*
  * Go back to running unmapped so we can load up new values
  * for SDR1 (hash table pointer) and the segment registers
@@ -1232,11 +1127,7 @@ initial_bats:
 #else
 	ori	r8,r8,2			/* R/W access */
 #endif /* CONFIG_SMP */
-#ifdef CONFIG_APUS
-	ori	r11,r11,BL_8M<<2|0x2	/* set up 8MB BAT registers for 604 */
-#else
 	ori	r11,r11,BL_256M<<2|0x2	/* set up BAT registers for 604 */
-#endif /* CONFIG_APUS */
=20
 	mtspr	SPRN_DBAT0L,r8		/* N.B. 6xx (not 601) have valid */
 	mtspr	SPRN_DBAT0U,r11		/* bit in upper BAT register */
@@ -1245,7 +1136,7 @@ initial_bats:
 	isync
 	blr
=20
-#if !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT)
+#ifdef CONFIG_BOOTX_TEXT
 setup_disp_bat:
 	/*
 	 * setup the display bat prepared for us in prom.c
@@ -1268,7 +1159,7 @@ setup_disp_bat:
 	mtspr	SPRN_IBAT3U,r11
 	blr
=20
-#endif /* !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT) */
+#endif /* defined(CONFIG_BOOTX_TEXT) */
=20
 #ifdef CONFIG_8260
 /* Jump into the system reset for the rom.
diff -puN arch/ppc/kernel/ppc_ksyms.c~ppc-remove-apus-support arch/ppc/=
kernel/ppc_ksyms.c
--- a/arch/ppc/kernel/ppc_ksyms.c~ppc-remove-apus-support
+++ a/arch/ppc/kernel/ppc_ksyms.c
@@ -60,8 +60,6 @@ long long __ashrdi3(long long, int);
 long long __ashldi3(long long, int);
 long long __lshrdi3(long long, int);
=20
-extern unsigned long mm_ptov (unsigned long paddr);
-
 EXPORT_SYMBOL(clear_pages);
 EXPORT_SYMBOL(clear_user_page);
 EXPORT_SYMBOL(transfer_to_handler);
@@ -118,7 +116,6 @@ EXPORT_SYMBOL(_outsw_ns);
 EXPORT_SYMBOL(_insl_ns);
 EXPORT_SYMBOL(_outsl_ns);
 EXPORT_SYMBOL(iopa);
-EXPORT_SYMBOL(mm_ptov);
 EXPORT_SYMBOL(ioremap);
 #ifdef CONFIG_44x
 EXPORT_SYMBOL(ioremap64);
diff -puN arch/ppc/kernel/setup.c~ppc-remove-apus-support arch/ppc/kern=
el/setup.c
--- a/arch/ppc/kernel/setup.c~ppc-remove-apus-support
+++ a/arch/ppc/kernel/setup.c
@@ -25,7 +25,6 @@
 #include <asm/pgtable.h>
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
-#include <asm/amigappc.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
diff -puN arch/ppc/mm/pgtable.c~ppc-remove-apus-support arch/ppc/mm/pgt=
able.c
--- a/arch/ppc/mm/pgtable.c~ppc-remove-apus-support
+++ a/arch/ppc/mm/pgtable.c
@@ -426,41 +426,3 @@ unsigned long iopa(unsigned long addr)
 	return(pa);
 }
=20
-/* This is will find the virtual address for a physical one....
- * Swiped from APUS, could be dangerous :-).
- * This is only a placeholder until I really find a way to make this
- * work.  -- Dan
- */
-unsigned long
-mm_ptov (unsigned long paddr)
-{
-	unsigned long ret;
-#if 0
-	if (paddr < 16*1024*1024)
-		ret =3D ZTWO_VADDR(paddr);
-	else {
-		int i;
-
-		for (i =3D 0; i < kmap_chunk_count;){
-			unsigned long phys =3D kmap_chunks[i++];
-			unsigned long size =3D kmap_chunks[i++];
-			unsigned long virt =3D kmap_chunks[i++];
-			if (paddr >=3D phys
-			    && paddr < (phys + size)){
-				ret =3D virt + paddr - phys;
-				goto exit;
-			}
-		}
-=09
-		ret =3D (unsigned long) __va(paddr);
-	}
-exit:
-#ifdef DEBUGPV
-	printk ("PTOV(%lx)=3D%lx\n", paddr, ret);
-#endif
-#else
-	ret =3D (unsigned long)paddr + KERNELBASE;
-#endif
-	return ret;
-}
-
diff -puN arch/ppc/platforms/Makefile~ppc-remove-apus-support arch/ppc/=
platforms/Makefile
--- a/arch/ppc/platforms/Makefile~ppc-remove-apus-support
+++ a/arch/ppc/platforms/Makefile
@@ -2,10 +2,6 @@
 # Makefile for the linux kernel.
 #
=20
-obj-$(CONFIG_APUS)		+=3D apus_setup.o
-ifeq ($(CONFIG_APUS),y)
-obj-$(CONFIG_PCI)		+=3D apus_pci.o
-endif
 obj-$(CONFIG_PPC_PREP)		+=3D prep_pci.o prep_setup.o
 obj-$(CONFIG_PREP_RESIDUAL)	+=3D residual.o
 obj-$(CONFIG_PQ2ADS)		+=3D pq2ads.o
diff -puN arch/ppc/platforms/apus_pci.c~ppc-remove-apus-support /dev/nu=
ll
--- a/arch/ppc/platforms/apus_pci.c
+++ /dev/null
@@ -1,207 +0,0 @@
-/*
- * Copyright (C) Michel D=E4nzer <michdaen@iiic.ethz.ch>
- *
- * APUS PCI routines.
- *
- * Currently, only B/CVisionPPC cards (Permedia2) are supported.
- *
- * Thanks to Geert Uytterhoeven for the idea:
- * Read values from given config space(s) for the first devices, -1 ot=
herwise
- *
- */
-
-#ifdef CONFIG_AMIGA
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-#include <asm/pci-bridge.h>
-#include <asm/machdep.h>
-
-#include "apus_pci.h"
-
-
-/* These definitions are mostly adapted from pm2fb.c */
-
-#undef APUS_PCI_MASTER_DEBUG
-#ifdef APUS_PCI_MASTER_DEBUG
-#define DPRINTK(a,b...)	printk(KERN_DEBUG "apus_pci: %s: " a, __FUNCTI=
ON__ , ## b)
-#else
-#define DPRINTK(a,b...)
-#endif
-
-/*
- * The _DEFINITIVE_ memory mapping/unmapping functions.
- * This is due to the fact that they're changing soooo often...
- */
-#define DEFW()		wmb()
-#define DEFR()		rmb()
-#define DEFRW()		mb()
-
-#define DEVNO(d)	((d)>>3)
-#define FNNO(d)		((d)&7)
-
-
-extern unsigned long powerup_PCI_present;
-
-static struct pci_controller *apus_hose;
-
-
-void *pci_io_base(unsigned int bus)
-{
-	return 0;
-}
-
-
-int
-apus_pcibios_read_config(struct pci_bus *bus, int devfn, int offset,
-			 int len, u32 *val)
-{
-	int fnno =3D FNNO(devfn);
-	int devno =3D DEVNO(devfn);
-	volatile unsigned char *cfg_data;
-
-	if (bus->number > 0 || devno !=3D 1) {
-		*val =3D ~0;
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-	/* base address + function offset + offset ^ endianness conversion */
-	/* XXX the fnno<<5 bit seems wacky  -- paulus */
-	cfg_data =3D apus_hose->cfg_data + (fnno<<5) + (offset ^ (len - 1));
-	switch (len) {
-	case 1:
-		*val =3D readb(cfg_data);
-		break;
-	case 2:
-		*val =3D readw(cfg_data);
-		break;
-	default:
-		*val =3D readl(cfg_data);
-		break;
-	}
-
-	DPRINTK("read b: 0x%x, d: 0x%x, f: 0x%x, o: 0x%x, l: %d, v: 0x%x\n",
-		bus->number, devfn>>3, devfn&7, offset, len, *val);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-int
-apus_pcibios_write_config(struct pci_bus *bus, int devfn, int offset,
-			  int len, u32 *val)
-{
-	int fnno =3D FNNO(devfn);
-	int devno =3D DEVNO(devfn);
-	volatile unsigned char *cfg_data;
-
-	if (bus->number > 0 || devno !=3D 1) {
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-	/* base address + function offset + offset ^ endianness conversion */
-	/* XXX the fnno<<5 bit seems wacky  -- paulus */
-	cfg_data =3D apus_hose->cfg_data + (fnno<<5) + (offset ^ (len - 1));
-	switch (len) {
-	case 1:
-		writeb(val, cfg_data); DEFW();
-		break;
-	case 2:
-		writew(val, cfg_data); DEFW();
-		break;
-	default:
-		writel(val, cfg_data); DEFW();
-		break;
-	}
-
-	DPRINTK("write b: 0x%x, d: 0x%x, f: 0x%x, o: 0x%x, l: %d, v: 0x%x\n",
-		bus->number, devfn>>3, devfn&7, offset, len, val);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static struct pci_ops apus_pci_ops =3D {
-	apus_pcibios_read_config,
-	apus_pcibios_write_config
-};
-
-static struct resource pci_mem =3D { "B/CVisionPPC PCI mem", CVPPC_FB_=
APERTURE_ONE, CVPPC_PCI_CONFIG, IORESOURCE_MEM };
-
-void __init
-apus_pcibios_fixup(void)
-{
-/*	struct pci_dev *dev =3D pci_find_slot(0, 1<<3);
-	unsigned int reg, val, offset;*/
-
-	/* FIXME: interrupt? */
-	/*dev->interrupt =3D xxx;*/
-
-        request_resource(&iomem_resource, &pci_mem);
-    	printk("%s: PCI mem resource requested\n", __FUNCTION__);
-}
-
-static void __init apus_pcibios_fixup_bus(struct pci_bus *bus)
-{
-        bus->resource[1] =3D &pci_mem;
-}
-
-
-/*
- * This is from pm2fb.c again
- *
- * Check if PCI (B/CVisionPPC) is available, initialize it and set up
- * the pcibios_* pointers
- */
-
-
-void __init
-apus_setup_pci_ptrs(void)
-{
-	if (!powerup_PCI_present) {
-		DPRINTK("no PCI bridge detected\n");
-		return;
-	}
-	DPRINTK("Phase5 B/CVisionPPC PCI bridge detected.\n");
-
-	apus_hose =3D pcibios_alloc_controller();
-	if (!apus_hose) {
-		printk("apus_pci: Can't allocate PCI controller structure\n");
-		return;
-	}
-
-	if (!(apus_hose->cfg_data =3D ioremap(CVPPC_PCI_CONFIG, 256))) {
-		printk("apus_pci: unable to map PCI config region\n");
-		return;
-	}
-
-	if (!(apus_hose->cfg_addr =3D ioremap(CSPPC_PCI_BRIDGE, 256))) {
-		printk("apus_pci: unable to map PCI bridge\n");
-		return;
-	}
-
-	writel(CSPPCF_BRIDGE_BIG_ENDIAN, apus_hose->cfg_addr + CSPPC_BRIDGE_E=
NDIAN);
-	DEFW();
-
-	writel(CVPPC_REGS_REGION,  apus_hose->cfg_data+ PCI_BASE_ADDRESS_0);
-	DEFW();
-	writel(CVPPC_FB_APERTURE_ONE, apus_hose->cfg_data + PCI_BASE_ADDRESS_=
1);
-	DEFW();
-	writel(CVPPC_FB_APERTURE_TWO, apus_hose->cfg_data + PCI_BASE_ADDRESS_=
2);
-	DEFW();
-	writel(CVPPC_ROM_ADDRESS, apus_hose->cfg_data + PCI_ROM_ADDRESS);
-	DEFW();
-
-	writel(0xef000000 | PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-		PCI_COMMAND_MASTER, apus_hose->cfg_data + PCI_COMMAND);
-	DEFW();
-
-	apus_hose->first_busno =3D 0;
-	apus_hose->last_busno =3D 0;
-	apus_hose->ops =3D &apus_pci_ops;
-	ppc_md.pcibios_fixup =3D apus_pcibios_fixup;
-	ppc_md.pcibios_fixup_bus =3D apus_pcibios_fixup_bus;
-
-	return;
-}
-
-#endif /* CONFIG_AMIGA */
diff -puN arch/ppc/platforms/apus_pci.h~ppc-remove-apus-support /dev/nu=
ll
--- a/arch/ppc/platforms/apus_pci.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Phase5 CybervisionPPC (TVP4020) definitions for the Permedia2 frame=
buffer
- * driver.
- *
- * Copyright (c) 1998-1999 Ilario Nardinocchi (nardinoc@CS.UniBO.IT)
- * -------------------------------------------------------------------=
-------
- * This file is subject to the terms and conditions of the GNU General=
 Public
- * License.  See the file README.legal in the main directory of this a=
rchive
- * for more details.
- */
-
-#ifndef APUS_PCI_H
-#define APUS_PCI_H
-
-
-#define CSPPC_PCI_BRIDGE		0xfffe0000
-#define CSPPC_BRIDGE_ENDIAN		0x0000
-#define CSPPC_BRIDGE_INT		0x0010
-
-#define	CVPPC_PCI_CONFIG		0xfffc0000
-#define CVPPC_ROM_ADDRESS		0xe2000001
-#define CVPPC_REGS_REGION		0xef000000
-#define CVPPC_FB_APERTURE_ONE		0xe0000000
-#define CVPPC_FB_APERTURE_TWO		0xe1000000
-#define CVPPC_FB_SIZE			0x00800000
-
-/* CVPPC_BRIDGE_ENDIAN */
-#define CSPPCF_BRIDGE_BIG_ENDIAN	0x02
-
-/* CVPPC_BRIDGE_INT */
-#define CSPPCF_BRIDGE_ACTIVE_INT2	0x01
-
-
-#endif	/* APUS_PCI_H */
diff -puN arch/ppc/platforms/apus_setup.c~ppc-remove-apus-support /dev/=
null
--- a/arch/ppc/platforms/apus_setup.c
+++ /dev/null
@@ -1,798 +0,0 @@
-/*
- *  Copyright (C) 1998, 1999  Jesper Skov
- *
- *  Basically what is needed to replace functionality found in
- *  arch/m68k allowing Amiga drivers to work under APUS.
- *  Bits of code and/or ideas from arch/m68k and arch/ppc files.
- *
- * TODO:
- *  This file needs a *really* good cleanup. Restructure and optimize.
- *  Make sure it can be compiled for non-APUS configs. Begin to move
- *  Amiga specific stuff into mach/amiga.
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/initrd.h>
-#include <linux/seq_file.h>
-
-/* Needs INITSERIAL call in head.S! */
-#undef APUS_DEBUG
-
-#include <asm/bootinfo.h>
-#include <asm/setup.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amigappc.h>
-#include <asm/pgtable.h>
-#include <asm/dma.h>
-#include <asm/machdep.h>
-#include <asm/time.h>
-
-unsigned long m68k_machtype;
-char debug_device[6] =3D "";
-
-extern void amiga_init_IRQ(void);
-
-extern void apus_setup_pci_ptrs(void);
-
-void (*mach_sched_init) (void (*handler)(int, void *, struct pt_regs *=
)) __initdata =3D NULL;
-/* machine dependent irq functions */
-void (*mach_init_IRQ) (void) __initdata =3D NULL;
-void (*(*mach_default_handler)[]) (int, void *, struct pt_regs *) =3D =
NULL;
-void (*mach_get_model) (char *model) =3D NULL;
-int (*mach_get_hardware_list) (char *buffer) =3D NULL;
-int (*mach_get_irq_list) (struct seq_file *, void *) =3D NULL;
-void (*mach_process_int) (int, struct pt_regs *) =3D NULL;
-/* machine dependent timer functions */
-unsigned long (*mach_gettimeoffset) (void);
-void (*mach_gettod) (int*, int*, int*, int*, int*, int*);
-int (*mach_hwclk) (int, struct hwclk_time*) =3D NULL;
-int (*mach_set_clock_mmss) (unsigned long) =3D NULL;
-void (*mach_reset)( void );
-long mach_max_dma_address =3D 0x00ffffff; /* default set to the lower =
16MB */
-#ifdef CONFIG_HEARTBEAT
-void (*mach_heartbeat) (int) =3D NULL;
-extern void apus_heartbeat (void);
-#endif
-
-extern unsigned long amiga_model;
-extern unsigned decrementer_count;/* count value for 1e6/HZ microsecon=
ds */
-extern unsigned count_period_num; /* 1 decrementer count equals */
-extern unsigned count_period_den; /* count_period_num / count_period_d=
en us */
-
-int num_memory =3D 0;
-struct mem_info memory[NUM_MEMINFO];/* memory description */
-/* FIXME: Duplicate memory data to avoid conflicts with m68k shared co=
de. */
-int m68k_realnum_memory =3D 0;
-struct mem_info m68k_memory[NUM_MEMINFO];/* memory description */
-
-struct mem_info ramdisk;
-
-extern void config_amiga(void);
-
-static int __60nsram =3D 0;
-
-/* for cpuinfo */
-static int __bus_speed =3D 0;
-static int __speed_test_failed =3D 0;
-
-/********************************************** COMPILE PROTECTION */
-/* Provide some stubs that links to Amiga specific functions.
- * This allows CONFIG_APUS to be removed from generic PPC files while
- * preventing link errors for other PPC targets.
- */
-unsigned long apus_get_rtc_time(void)
-{
-#ifdef CONFIG_APUS
-	extern unsigned long m68k_get_rtc_time(void);
-
-	return m68k_get_rtc_time ();
-#else
-	return 0;
-#endif
-}
-
-int apus_set_rtc_time(unsigned long nowtime)
-{
-#ifdef CONFIG_APUS
-	extern int m68k_set_rtc_time(unsigned long nowtime);
-
-	return m68k_set_rtc_time (nowtime);
-#else
-	return 0;
-#endif
-}
-
-/*********************************************************** SETUP */
-/* From arch/m68k/kernel/setup.c. */
-void __init apus_setup_arch(void)
-{
-#ifdef CONFIG_APUS
-	extern char cmd_line[];
-	int i;
-	char *p, *q;
-
-	/* Let m68k-shared code know it should do the Amiga thing. */
-	m68k_machtype =3D MACH_AMIGA;
-
-	/* Parse the command line for arch-specific options.
-	 * For the m68k, this is currently only "debug=3Dxxx" to enable print=
ing
-	 * certain kernel messages to some machine-specific device.  */
-	for( p =3D cmd_line; p && *p; ) {
-	    i =3D 0;
-	    if (!strncmp( p, "debug=3D", 6 )) {
-		    strlcpy( debug_device, p+6, sizeof(debug_device) );
-		    if ((q =3D strchr( debug_device, ' ' ))) *q =3D 0;
-		    i =3D 1;
-	    } else if (!strncmp( p, "60nsram", 7 )) {
-		    APUS_WRITE (APUS_REG_WAITSTATE,
-				REGWAITSTATE_SETRESET
-				|REGWAITSTATE_PPCR
-				|REGWAITSTATE_PPCW);
-		    __60nsram =3D 1;
-		    i =3D 1;
-	    }
-
-	    if (i) {
-		/* option processed, delete it */
-		if ((q =3D strchr( p, ' ' )))
-		    strcpy( p, q+1 );
-		else
-		    *p =3D 0;
-	    } else {
-		if ((p =3D strchr( p, ' ' ))) ++p;
-	    }
-	}
-
-	config_amiga();
-
-#if 0 /* Enable for logging - also include logging.o in Makefile rule =
*/
-	{
-#define LOG_SIZE 4096
-		void* base;
-
-		/* Throw away some memory - the P5 firmare stomps on top
-		 * of CHIP memory during bootup.
-		 */
-		amiga_chip_alloc(0x1000);
-
-		base =3D amiga_chip_alloc(LOG_SIZE+sizeof(klog_data_t));
-		LOG_INIT(base, base+sizeof(klog_data_t), LOG_SIZE);
-	}
-#endif
-#endif
-}
-
-int
-apus_show_cpuinfo(struct seq_file *m)
-{
-	extern int __map_without_bats;
-	extern unsigned long powerup_PCI_present;
-
-	seq_printf(m, "machine\t\t: Amiga\n");
-	seq_printf(m, "bus speed\t: %d%s", __bus_speed,
-		   (__speed_test_failed) ? " [failed]\n" : "\n");
-	seq_printf(m, "using BATs\t: %s\n",
-		   (__map_without_bats) ? "No" : "Yes");
-	seq_printf(m, "ram speed\t: %dns\n", (__60nsram) ? 60 : 70);
-	seq_printf(m, "PCI bridge\t: %s\n",
-		   (powerup_PCI_present) ? "Yes" : "No");
-	return 0;
-}
-
-static void get_current_tb(unsigned long long *time)
-{
-	__asm __volatile ("1:mftbu 4      \n\t"
-			  "  mftb  5      \n\t"
-			  "  mftbu 6      \n\t"
-			  "  cmpw  4,6    \n\t"
-			  "  bne   1b     \n\t"
-			  "  stw   4,0(%0)\n\t"
-			  "  stw   5,4(%0)\n\t"
-			  :
-			  : "r" (time)
-			  : "r4", "r5", "r6");
-}
-
-
-void apus_calibrate_decr(void)
-{
-#ifdef CONFIG_APUS
-	unsigned long freq;
-
-	/* This algorithm for determining the bus speed was
-           contributed by Ralph Schmidt. */
-	unsigned long long start, stop;
-	int bus_speed;
-	int speed_test_failed =3D 0;
-
-	{
-		unsigned long loop =3D amiga_eclock / 10;
-
-		get_current_tb (&start);
-		while (loop--) {
-			unsigned char tmp;
-
-			tmp =3D ciaa.pra;
-		}
-		get_current_tb (&stop);
-	}
-
-	bus_speed =3D (((unsigned long)(stop-start))*10*4) / 1000000;
-	if (AMI_1200 =3D=3D amiga_model)
-		bus_speed /=3D 2;
-
-	if ((bus_speed >=3D 47) && (bus_speed < 53)) {
-		bus_speed =3D 50;
-		freq =3D 12500000;
-	} else if ((bus_speed >=3D 57) && (bus_speed < 63)) {
-		bus_speed =3D 60;
-		freq =3D 15000000;
-	} else if ((bus_speed >=3D 63) && (bus_speed < 69)) {
-		bus_speed =3D 67;
-		freq =3D 16666667;
-	} else {
-		printk ("APUS: Unable to determine bus speed (%d). "
-			"Defaulting to 50MHz", bus_speed);
-		bus_speed =3D 50;
-		freq =3D 12500000;
-		speed_test_failed =3D 1;
-	}
-
-	/* Ease diagnostics... */
-	{
-		extern int __map_without_bats;
-		extern unsigned long powerup_PCI_present;
-
-		printk ("APUS: BATs=3D%d, BUS=3D%dMHz",
-			(__map_without_bats) ? 0 : 1,
-			bus_speed);
-		if (speed_test_failed)
-			printk ("[FAILED - please report]");
-
-		printk (", RAM=3D%dns, PCI bridge=3D%d\n",
-			(__60nsram) ? 60 : 70,
-			(powerup_PCI_present) ? 1 : 0);
-
-		/* print a bit more if asked politely... */
-		if (!(ciaa.pra & 0x40)){
-			extern unsigned int bat_addrs[4][3];
-			int b;
-			for (b =3D 0; b < 4; ++b) {
-				printk ("APUS: BAT%d ", b);
-				printk ("%08x-%08x -> %08x\n",
-					bat_addrs[b][0],
-					bat_addrs[b][1],
-					bat_addrs[b][2]);
-			}
-		}
-
-	}
-
-        printk("time_init: decrementer frequency =3D %lu.%.6lu MHz\n",
-	       freq/1000000, freq%1000000);
-	tb_ticks_per_jiffy =3D freq / HZ;
-	tb_to_us =3D mulhwu_scale_factor(freq, 1000000);
-
-	__bus_speed =3D bus_speed;
-	__speed_test_failed =3D speed_test_failed;
-#endif
-}
-
-void arch_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-#ifdef CONFIG_APUS
-	if (mach_gettod)
-		mach_gettod(year, mon, day, hour, min, sec);
-	else
-		*year =3D *mon =3D *day =3D *hour =3D *min =3D *sec =3D 0;
-#endif
-}
-
-/* for "kbd-reset" cmdline param */
-__init
-void kbd_reset_setup(char *str, int *ints)
-{
-}
-
-/*********************************************************** MEMORY */
-#define KMAP_MAX 32
-unsigned long kmap_chunks[KMAP_MAX*3];
-int kmap_chunk_count =3D 0;
-
-/* From pgtable.h */
-static __inline__ pte_t *my_find_pte(struct mm_struct *mm,unsigned lon=
g va)
-{
-	pgd_t *dir =3D 0;
-	pmd_t *pmd =3D 0;
-	pte_t *pte =3D 0;
-
-	va &=3D PAGE_MASK;
-
-	dir =3D pgd_offset( mm, va );
-	if (dir)
-	{
-		pmd =3D pmd_offset(dir, va & PAGE_MASK);
-		if (pmd && pmd_present(*pmd))
-		{
-			pte =3D pte_offset(pmd, va);
-		}
-	}
-	return pte;
-}
-
-
-/* Again simulating an m68k/mm/kmap.c function. */
-void kernel_set_cachemode( unsigned long address, unsigned long size,
-			   unsigned int cmode )
-{
-	unsigned long mask, flags;
-
-	switch (cmode)
-	{
-	case IOMAP_FULL_CACHING:
-		mask =3D ~(_PAGE_NO_CACHE | _PAGE_GUARDED);
-		flags =3D 0;
-		break;
-	case IOMAP_NOCACHE_SER:
-		mask =3D ~0;
-		flags =3D (_PAGE_NO_CACHE | _PAGE_GUARDED);
-		break;
-	default:
-		panic ("kernel_set_cachemode() doesn't support mode %d\n",
-		       cmode);
-		break;
-	}
-
-	size /=3D PAGE_SIZE;
-	address &=3D PAGE_MASK;
-	while (size--)
-	{
-		pte_t *pte;
-
-		pte =3D my_find_pte(&init_mm, address);
-		if ( !pte )
-		{
-			printk("pte NULL in kernel_set_cachemode()\n");
-			return;
-		}
-
-                pte_val (*pte) &=3D mask;
-                pte_val (*pte) |=3D flags;
-                flush_tlb_page(find_vma(&init_mm,address),address);
-
-		address +=3D PAGE_SIZE;
-	}
-}
-
-unsigned long mm_ptov (unsigned long paddr)
-{
-	unsigned long ret;
-	if (paddr < 16*1024*1024)
-		ret =3D ZTWO_VADDR(paddr);
-	else {
-		int i;
-
-		for (i =3D 0; i < kmap_chunk_count;){
-			unsigned long phys =3D kmap_chunks[i++];
-			unsigned long size =3D kmap_chunks[i++];
-			unsigned long virt =3D kmap_chunks[i++];
-			if (paddr >=3D phys
-			    && paddr < (phys + size)){
-				ret =3D virt + paddr - phys;
-				goto exit;
-			}
-		}
-
-		ret =3D (unsigned long) __va(paddr);
-	}
-exit:
-#ifdef DEBUGPV
-	printk ("PTOV(%lx)=3D%lx\n", paddr, ret);
-#endif
-	return ret;
-}
-
-int mm_end_of_chunk (unsigned long addr, int len)
-{
-	if (memory[0].addr + memory[0].size =3D=3D addr + len)
-		return 1;
-	return 0;
-}
-
-/*********************************************************** CACHE */
-
-#define L1_CACHE_BYTES 32
-#define MAX_CACHE_SIZE 8192
-void cache_push(__u32 addr, int length)
-{
-	addr =3D mm_ptov(addr);
-
-	if (MAX_CACHE_SIZE < length)
-		length =3D MAX_CACHE_SIZE;
-
-	while(length > 0){
-		__asm ("dcbf 0,%0\n\t"
-		       : : "r" (addr));
-		addr +=3D L1_CACHE_BYTES;
-		length -=3D L1_CACHE_BYTES;
-	}
-	/* Also flush trailing block */
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       : : "r" (addr));
-}
-
-void cache_clear(__u32 addr, int length)
-{
-	if (MAX_CACHE_SIZE < length)
-		length =3D MAX_CACHE_SIZE;
-
-	addr =3D mm_ptov(addr);
-
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       "icbi 0,%0 \n\t"
-	       "isync \n\t"
-	       : : "r" (addr));
-
-	addr +=3D L1_CACHE_BYTES;
-	length -=3D L1_CACHE_BYTES;
-
-	while(length > 0){
-		__asm ("dcbf 0,%0\n\t"
-		       "sync \n\t"
-		       "icbi 0,%0 \n\t"
-		       "isync \n\t"
-		       : : "r" (addr));
-		addr +=3D L1_CACHE_BYTES;
-		length -=3D L1_CACHE_BYTES;
-	}
-
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       "icbi 0,%0 \n\t"
-	       "isync \n\t"
-	       : : "r" (addr));
-}
-
-/****************************************************** from setup.c *=
/
-void
-apus_restart(char *cmd)
-{
-	local_irq_disable();
-
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK1|REGLOCK_BLACKMAGICK2);
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK1|REGLOCK_BLACKMAGICK3);
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK2|REGLOCK_BLACKMAGICK3);
-	APUS_WRITE(APUS_REG_SHADOW, REGSHADOW_SELFRESET);
-	APUS_WRITE(APUS_REG_RESET, REGRESET_AMIGARESET);
-	for(;;);
-}
-
-void
-apus_power_off(void)
-{
-	for (;;);
-}
-
-void
-apus_halt(void)
-{
-   apus_restart(NULL);
-}
-
-/****************************************************** IRQ stuff */
-
-static unsigned char last_ipl[8];
-
-int apus_get_irq(void)
-{
-	unsigned char ipl_emu, mask;
-	unsigned int level;
-
-	APUS_READ(APUS_IPL_EMU, ipl_emu);
-	level =3D (ipl_emu >> 3) & IPLEMU_IPLMASK;
-	mask =3D IPLEMU_SETRESET|IPLEMU_DISABLEINT|level;
-	level ^=3D 7;
-
-	/* Save previous IPL value */
-	if (last_ipl[level])
-		return -2;
-	last_ipl[level] =3D ipl_emu;
-
-	/* Set to current IPL value */
-	APUS_WRITE(APUS_IPL_EMU, mask);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT|level);
-
-
-#ifdef __INTERRUPT_DEBUG
-	printk("<%d:%d>", level, ~ipl_emu & IPLEMU_IPLMASK);
-#endif
-	return level + IRQ_AMIGA_AUTO;
-}
-
-void apus_end_irq(unsigned int irq)
-{
-	unsigned char ipl_emu;
-	unsigned int level =3D irq - IRQ_AMIGA_AUTO;
-#ifdef __INTERRUPT_DEBUG
-	printk("{%d}", ~last_ipl[level] & IPLEMU_IPLMASK);
-#endif
-	/* Restore IPL to the previous value */
-	ipl_emu =3D last_ipl[level] & IPLEMU_IPLMASK;
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_SETRESET|IPLEMU_DISABLEINT|ipl_emu);
-	last_ipl[level] =3D 0;
-	ipl_emu ^=3D 7;
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT|ipl_emu);
-}
-
-/****************************************************** debugging */
-
-/* some serial hardware definitions */
-#define SDR_OVRUN   (1<<15)
-#define SDR_RBF     (1<<14)
-#define SDR_TBE     (1<<13)
-#define SDR_TSRE    (1<<12)
-
-#define AC_SETCLR   (1<<15)
-#define AC_UARTBRK  (1<<11)
-
-#define SER_DTR     (1<<7)
-#define SER_RTS     (1<<6)
-#define SER_DCD     (1<<5)
-#define SER_CTS     (1<<4)
-#define SER_DSR     (1<<3)
-
-static __inline__ void ser_RTSon(void)
-{
-    ciab.pra &=3D ~SER_RTS; /* active low */
-}
-
-int __debug_ser_out( unsigned char c )
-{
-	amiga_custom.serdat =3D c | 0x100;
-	mb();
-	while (!(amiga_custom.serdatr & 0x2000))
-		barrier();
-	return 1;
-}
-
-unsigned char __debug_ser_in( void )
-{
-	unsigned char c;
-
-	/* XXX: is that ok?? derived from amiga_ser.c... */
-	while( !(amiga_custom.intreqr & IF_RBF) )
-		barrier();
-	c =3D amiga_custom.serdatr;
-	/* clear the interrupt, so that another character can be read */
-	amiga_custom.intreq =3D IF_RBF;
-	return c;
-}
-
-int __debug_serinit( void )
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	/* turn off Rx and Tx interrupts */
-	amiga_custom.intena =3D IF_RBF | IF_TBE;
-
-	/* clear any pending interrupt */
-	amiga_custom.intreq =3D IF_RBF | IF_TBE;
-
-	local_irq_restore(flags);
-
-	/*
-	 * set the appropriate directions for the modem control flags,
-	 * and clear RTS and DTR
-	 */
-	ciab.ddra |=3D (SER_DTR | SER_RTS);   /* outputs */
-	ciab.ddra &=3D ~(SER_DCD | SER_CTS | SER_DSR);  /* inputs */
-
-#ifdef CONFIG_KGDB
-	/* turn Rx interrupts on for GDB */
-	amiga_custom.intena =3D IF_SETCLR | IF_RBF;
-	ser_RTSon();
-#endif
-
-	return 0;
-}
-
-void __debug_print_hex(unsigned long x)
-{
-	int i;
-	char hexchars[] =3D "0123456789ABCDEF";
-
-	for (i =3D 0; i < 8; i++) {
-		__debug_ser_out(hexchars[(x >> 28) & 15]);
-		x <<=3D 4;
-	}
-	__debug_ser_out('\n');
-	__debug_ser_out('\r');
-}
-
-void __debug_print_string(char* s)
-{
-	unsigned char c;
-	while((c =3D *s++))
-		__debug_ser_out(c);
-	__debug_ser_out('\n');
-	__debug_ser_out('\r');
-}
-
-static void apus_progress(char *s, unsigned short value)
-{
-	__debug_print_string(s);
-}
-
-/****************************************************** init */
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-extern struct irqaction amiga_sys_irqaction[AUTO_IRQS];
-
-
-extern void amiga_enable_irq(unsigned int irq);
-extern void amiga_disable_irq(unsigned int irq);
-
-struct hw_interrupt_type amiga_sys_irqctrl =3D {
-	.typename =3D "Amiga IPL",
-	.end =3D apus_end_irq,
-};
-
-struct hw_interrupt_type amiga_irqctrl =3D {
-	.typename =3D "Amiga    ",
-	.enable =3D amiga_enable_irq,
-	.disable =3D amiga_disable_irq,
-};
-
-#define HARDWARE_MAPPED_SIZE (512*1024)
-unsigned long __init apus_find_end_of_memory(void)
-{
-	int shadow =3D 0;
-	unsigned long total;
-
-	/* The memory size reported by ADOS excludes the 512KB
-	   reserved for PPC exception registers and possibly 512KB
-	   containing a shadow of the ADOS ROM. */
-	{
-		unsigned long size =3D memory[0].size;
-
-		/* If 2MB aligned, size was probably user
-                   specified. We can't tell anything about shadowing
-                   in this case so skip shadow assignment. */
-		if (0 !=3D (size & 0x1fffff)){
-			/* Align to 512KB to ensure correct handling
-			   of both memfile and system specified
-			   sizes. */
-			size =3D ((size+0x0007ffff) & 0xfff80000);
-			/* If memory is 1MB aligned, assume
-                           shadowing. */
-			shadow =3D !(size & 0x80000);
-		}
-
-		/* Add the chunk that ADOS does not see. by aligning
-                   the size to the nearest 2MB limit upwards.  */
-		memory[0].size =3D ((size+0x001fffff) & 0xffe00000);
-	}
-
-	ppc_memstart =3D memory[0].addr;
-	ppc_memoffset =3D PAGE_OFFSET - PPC_MEMSTART;
-	total =3D memory[0].size;
-
-	/* Remove the memory chunks that are controlled by special
-           Phase5 hardware. */
-
-	/* Remove the upper 512KB if it contains a shadow of
-	   the ADOS ROM. FIXME: It might be possible to
-	   disable this shadow HW. Check the booter
-	   (ppc_boot.c) */
-	if (shadow)
-		total -=3D HARDWARE_MAPPED_SIZE;
-
-	/* Remove the upper 512KB where the PPC exception
-	   vectors are mapped. */
-	total -=3D HARDWARE_MAPPED_SIZE;
-
-	/* Linux/APUS only handles one block of memory -- the one on
-	   the PowerUP board. Other system memory is horrible slow in
-	   comparison. The user can use other memory for swapping
-	   using the z2ram device. */
-	return total;
-}
-
-static void __init
-apus_map_io(void)
-{
-	/* Map PPC exception vectors. */
-	io_block_mapping(0xfff00000, 0xfff00000, 0x00020000, _PAGE_KERNEL);
-	/* Map chip and ZorroII memory */
-	io_block_mapping(zTwoBase,   0x00000000, 0x01000000, _PAGE_IO);
-}
-
-__init
-void apus_init_IRQ(void)
-{
-	struct irqaction *action;
-	int i;
-
-#ifdef CONFIG_PCI
-        apus_setup_pci_ptrs();
-#endif
-
-	for ( i =3D 0 ; i < AMI_IRQS; i++ ) {
-		irq_desc[i].status =3D IRQ_LEVEL;
-		if (i < IRQ_AMIGA_AUTO) {
-			irq_desc[i].chip =3D &amiga_irqctrl;
-		} else {
-			irq_desc[i].chip =3D &amiga_sys_irqctrl;
-			action =3D &amiga_sys_irqaction[i-IRQ_AMIGA_AUTO];
-			if (action->name)
-				setup_irq(i, action);
-		}
-	}
-
-	amiga_init_IRQ();
-
-}
-
-__init
-void platform_init(unsigned long r3, unsigned long r4, unsigned long r=
5,
-		   unsigned long r6, unsigned long r7)
-{
-	extern int parse_bootinfo(const struct bi_record *);
-	extern char _end[];
-
-	/* Parse bootinfo. The bootinfo is located right after
-           the kernel bss */
-	parse_bootinfo((const struct bi_record *)&_end);
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Take care of initrd if we have one. Use data from
-	   bootinfo to avoid the need to initialize PPC
-	   registers when kernel is booted via a PPC reset. */
-	if ( ramdisk.addr ) {
-		initrd_start =3D (unsigned long) __va(ramdisk.addr);
-		initrd_end =3D (unsigned long)
-			__va(ramdisk.size + ramdisk.addr);
-	}
-#endif /* CONFIG_BLK_DEV_INITRD */
-
-	ISA_DMA_THRESHOLD =3D 0x00ffffff;
-
-	ppc_md.setup_arch     =3D apus_setup_arch;
-	ppc_md.show_cpuinfo   =3D apus_show_cpuinfo;
-	ppc_md.init_IRQ       =3D apus_init_IRQ;
-	ppc_md.get_irq        =3D apus_get_irq;
-
-#ifdef CONFIG_HEARTBEAT
-	ppc_md.heartbeat      =3D apus_heartbeat;
-	ppc_md.heartbeat_count =3D 1;
-#endif
-#ifdef APUS_DEBUG
-	__debug_serinit();
-	ppc_md.progress       =3D apus_progress;
-#endif
-	ppc_md.init           =3D NULL;
-
-	ppc_md.restart        =3D apus_restart;
-	ppc_md.power_off      =3D apus_power_off;
-	ppc_md.halt           =3D apus_halt;
-
-	ppc_md.time_init      =3D NULL;
-	ppc_md.set_rtc_time   =3D apus_set_rtc_time;
-	ppc_md.get_rtc_time   =3D apus_get_rtc_time;
-	ppc_md.calibrate_decr =3D apus_calibrate_decr;
-
-	ppc_md.find_end_of_memory =3D apus_find_end_of_memory;
-	ppc_md.setup_io_mappings =3D apus_map_io;
-}
diff -puN drivers/ide/ide-probe.c~ppc-remove-apus-support drivers/ide/i=
de-probe.c
--- a/drivers/ide/ide-probe.c~ppc-remove-apus-support
+++ a/drivers/ide/ide-probe.c
@@ -1096,9 +1096,9 @@ static int init_irq (ide_hwif_t *hwif)
 	 */
 	if (!match || match->irq !=3D hwif->irq) {
 		int sa =3D IRQF_DISABLED;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 		sa =3D IRQF_SHARED;
-#endif /* __mc68000__ || CONFIG_APUS */
+#endif /* __mc68000__ */
=20
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset)) {
 			sa =3D IRQF_SHARED;
@@ -1141,7 +1141,7 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_unlock_irq(&ide_lock);
 	}
=20
-#if !defined(__mc68000__) && !defined(CONFIG_APUS)
+#if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
 		hwif->io_ports[IDE_DATA_OFFSET]+7,
@@ -1149,7 +1149,7 @@ static int init_irq (ide_hwif_t *hwif)
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
-#endif /* __mc68000__ && CONFIG_APUS */
+#endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
diff -puN drivers/isdn/hisax/avm_pci.c~ppc-remove-apus-support drivers/=
isdn/hisax/avm_pci.c
--- a/drivers/isdn/hisax/avm_pci.c~ppc-remove-apus-support
+++ a/drivers/isdn/hisax/avm_pci.c
@@ -264,11 +264,7 @@ hdlc_empty_fifo(struct BCState *bcs, int
 		outl(idx, cs->hw.avm.cfg_reg + 4);
 		while (cnt < count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			*ptr++ =3D in_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#else
 			*ptr++ =3D in_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#endif /* CONFIG_APUS */
 #else
 			*ptr++ =3D inl(cs->hw.avm.isac);
 #endif /* __powerpc__ */
@@ -329,11 +325,7 @@ hdlc_fill_fifo(struct BCState *bcs)
 	if (cs->subtyp =3D=3D AVM_FRITZ_PCI) {
 		while (cnt<count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			out_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#else
 			out_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#endif /* CONFIG_APUS */
 #else
 			outl(*ptr++, cs->hw.avm.isac);
 #endif /* __powerpc__ */
diff -puN drivers/scsi/a2091.c~ppc-remove-apus-support drivers/scsi/a20=
91.c
--- a/drivers/scsi/a2091.c~ppc-remove-apus-support
+++ a/drivers/scsi/a2091.c
@@ -46,8 +46,7 @@ static int dma_setup(struct scsi_cmnd *c
     struct Scsi_Host *instance =3D cmd->device->host;
=20
     /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A2091_XFER_MASK)
     {
 	HDATA(instance)->dma_bounce_len =3D (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff -puN drivers/scsi/a3000.c~ppc-remove-apus-support drivers/scsi/a30=
00.c
--- a/drivers/scsi/a3000.c~ppc-remove-apus-support
+++ a/drivers/scsi/a3000.c
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
      * end of a physical memory chunk, then allocate a bounce
      * buffer
      */
-    if (addr & A3000_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A3000_XFER_MASK)
     {
 	HDATA(a3000_host)->dma_bounce_len =3D (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff -puN drivers/scsi/gvp11.c~ppc-remove-apus-support drivers/scsi/gvp=
11.c
--- a/drivers/scsi/gvp11.c~ppc-remove-apus-support
+++ a/drivers/scsi/gvp11.c
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
     static int scsi_alloc_out_of_range =3D 0;
=20
     /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
     {
 	HDATA(cmd->device->host)->dma_bounce_len =3D (cmd->SCp.this_residual =
+ 511)
 	    & ~0x1ff;
diff -puN drivers/scsi/oktagon_esp.c~ppc-remove-apus-support drivers/sc=
si/oktagon_esp.c
--- a/drivers/scsi/oktagon_esp.c~ppc-remove-apus-support
+++ a/drivers/scsi/oktagon_esp.c
@@ -7,7 +7,7 @@
  */
=20
=20
-#if defined(CONFIG_AMIGA) || defined(CONFIG_APUS)
+#if defined(CONFIG_AMIGA)
 #define USE_BOTTOM_HALF
 #endif
=20
diff -puN drivers/scsi/oktagon_io.S~ppc-remove-apus-support drivers/scs=
i/oktagon_io.S
--- a/drivers/scsi/oktagon_io.S~ppc-remove-apus-support
+++ a/drivers/scsi/oktagon_io.S
@@ -24,77 +24,6 @@ int oktag_from_io(long *addr,long *paddr
  */
=20
=20
-#ifdef CONFIG_APUS
-
-	.file	"oktagon_io.c"
-
-gcc2_compiled.:
-/*
-	.section ".text"
-*/
-	.align 2
-	.globl oktag_to_io
-	.type	 oktag_to_io,@function
-oktag_to_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	mr 3,4
-	addi 5,5,-1
-	bc 12,6,.L3
-.L5:
-	cmpwi 1,5,0
-	lwz 0,0(3)
-	addi 3,3,4
-	addi 5,5,-1
-exp1:	stw 0,0(9)
-	bc 4,6,.L5
-.L3:
-ret1:	subf 3,4,3
-	srawi 3,3,2
-	blr
-.Lfe1:
-	.size	 oktag_to_io,.Lfe1-oktag_to_io
-	.align 2
-	.globl oktag_from_io
-	.type	 oktag_from_io,@function
-oktag_from_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	addi 5,5,-1
-	bc 12,6,.L9
-.L11:
-	cmpwi 1,5,0
-exp2:	lwz 0,0(4)
-	addi 5,5,-1
-	stw 0,0(3)
-	addi 3,3,4
-	bc 4,6,.L11
-.L9:
-ret2:	subf 3,9,3
-	srawi 3,3,2
-	blr
-.Lfe2:
-	.size	 oktag_from_io,.Lfe2-oktag_from_io
-	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
-
-/*
- * Exception table.
- * Second longword shows where to jump when an exception at the addr t=
he first
- * longword is pointing to is caught.
- */
-
-.section __ex_table,"a"
-	.align	2
-oktagon_except:
-	.long	exp1,ret1
-	.long	exp2,ret2
-
-#else
-
 /*
 The code which follows is for 680x0 based assembler and is meant for
 Linux/m68k. It was created by cross compiling the code using the
@@ -191,4 +120,3 @@ oktagon_except:
 	.long	exp2,ret2
=20
 #endif
-#endif
diff -puN drivers/video/console/fbcon.c~ppc-remove-apus-support drivers=
/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~ppc-remove-apus-support
+++ a/drivers/video/console/fbcon.c
@@ -85,7 +85,7 @@
 #ifdef CONFIG_MAC
 #include <asm/macints.h>
 #endif
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/machdep.h>
 #include <asm/setup.h>
 #endif
diff -puN drivers/video/console/fonts.c~ppc-remove-apus-support drivers=
/video/console/fonts.c
--- a/drivers/video/console/fonts.c~ppc-remove-apus-support
+++ a/drivers/video/console/fonts.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/setup.h>
 #endif
 #include <linux/font.h>
@@ -120,7 +120,7 @@ const struct font_desc *get_default_font
     for(i=3D0; i<num_fonts; i++) {
 	f =3D fonts[i];
 	c =3D f->pref;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #ifdef CONFIG_FONT_PEARL_8x8
 	if (MACH_IS_AMIGA && f->idx =3D=3D PEARL8x8_IDX)
 	    c =3D 100;
diff -puN include/asm-m68k/pgtable.h~ppc-remove-apus-support include/as=
m-m68k/pgtable.h
--- a/include/asm-m68k/pgtable.h~ppc-remove-apus-support
+++ a/include/asm-m68k/pgtable.h
@@ -107,8 +107,6 @@ extern void *empty_zero_page;
 /* 64-bit machines, beware!  SRB. */
 #define SIZEOF_PTR_LOG2			       2
=20
-#define mm_end_of_chunk(addr, len)	0
-
 extern void kernel_set_cachemode(void *addr, unsigned long size, int c=
mode);
=20
 /*
diff -puN include/asm-powerpc/ide.h~ppc-remove-apus-support include/asm=
-powerpc/ide.h
--- a/include/asm-powerpc/ide.h~ppc-remove-apus-support
+++ a/include/asm-powerpc/ide.h
@@ -67,7 +67,7 @@ static __inline__ unsigned long ide_defa
 #define ide_init_default_irq(base)	ide_default_irq(base)
 #endif
=20
-#if (defined CONFIG_APUS || defined CONFIG_BLK_DEV_MPC8xx_IDE )
+#ifdef CONFIG_BLK_DEV_MPC8xx_IDE
 #define IDE_ARCH_ACK_INTR  1
 #define ide_ack_intr(hwif) (hwif->hw.ack_intr ? hwif->hw.ack_intr(hwif=
) : 1)
 #endif
diff -puN include/asm-powerpc/reg.h~ppc-remove-apus-support include/asm=
-powerpc/reg.h
--- a/include/asm-powerpc/reg.h~ppc-remove-apus-support
+++ a/include/asm-powerpc/reg.h
@@ -102,12 +102,8 @@
 #else /* 32-bit */
 /* Default MSR for kernel mode. */
 #ifndef MSR_KERNEL	/* reg_booke.h also defines this */
-#ifdef CONFIG_APUS_FAST_EXCEPT
-#define MSR_KERNEL	(MSR_ME|MSR_IP|MSR_RI|MSR_IR|MSR_DR)
-#else
 #define MSR_KERNEL	(MSR_ME|MSR_RI|MSR_IR|MSR_DR)
 #endif
-#endif
=20
 #define MSR_USER	(MSR_KERNEL|MSR_PR|MSR_EE)
 #endif
diff -puN include/asm-ppc/amigahw.h~ppc-remove-apus-support /dev/null
--- a/include/asm-ppc/amigahw.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifdef __KERNEL__
-#ifndef __ASMPPC_AMIGAHW_H
-#define __ASMPPC_AMIGAHW_H
-
-#include <asm-m68k/amigahw.h>
-
-#undef CHIP_PHYSADDR
-#ifdef CONFIG_APUS_FAST_EXCEPT
-#define CHIP_PHYSADDR      (0x000000)
-#else
-#define CHIP_PHYSADDR      (0x004000)
-#endif
-
-
-#endif /* __ASMPPC_AMIGAHW_H */
-#endif /* __KERNEL__ */
diff -puN include/asm-ppc/amigaints.h~ppc-remove-apus-support /dev/null
--- a/include/asm-ppc/amigaints.h
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
-** amigaints.h -- Amiga Linux interrupt handling structs and prototype=
s
-**
-** Copyright 1992 by Greg Harp
-**
-** This file is subject to the terms and conditions of the GNU General=
 Public
-** License.  See the file COPYING in the main directory of this archiv=
e
-** for more details.
-**
-** Created 10/2/92 by Greg Harp
-*/
-
-#ifdef __KERNEL__
-#ifndef _ASMm68k_AMIGAINTS_H_
-#define _ASMm68k_AMIGAINTS_H_
-
-/*
-** Amiga Interrupt sources.
-**
-*/
-
-#define AUTO_IRQS           (8)
-#define AMI_STD_IRQS        (14)
-#define CIA_IRQS            (5)
-#define AMI_IRQS            (32) /* AUTO_IRQS+AMI_STD_IRQS+2*CIA_IRQS =
*/
-
-/* vertical blanking interrupt */
-#define IRQ_AMIGA_VERTB     0
-
-/* copper interrupt */
-#define IRQ_AMIGA_COPPER    1
-
-/* Audio interrupts */
-#define IRQ_AMIGA_AUD0	    2
-#define IRQ_AMIGA_AUD1	    3
-#define IRQ_AMIGA_AUD2	    4
-#define IRQ_AMIGA_AUD3	    5
-
-/* Blitter done interrupt */
-#define IRQ_AMIGA_BLIT	    6
-
-/* floppy disk interrupts */
-#define IRQ_AMIGA_DSKSYN    7
-#define IRQ_AMIGA_DSKBLK    8
-
-/* builtin serial port interrupts */
-#define IRQ_AMIGA_RBF	    9
-#define IRQ_AMIGA_TBE	    10
-
-/* software interrupts */
-#define IRQ_AMIGA_SOFT      11
-
-/* interrupts from external hardware */
-#define IRQ_AMIGA_PORTS	    12
-#define IRQ_AMIGA_EXTER	    13
-
-/* CIA interrupt sources */
-#define IRQ_AMIGA_CIAA      14
-#define IRQ_AMIGA_CIAA_TA   14
-#define IRQ_AMIGA_CIAA_TB   15
-#define IRQ_AMIGA_CIAA_ALRM 16
-#define IRQ_AMIGA_CIAA_SP   17
-#define IRQ_AMIGA_CIAA_FLG  18
-#define IRQ_AMIGA_CIAB      19
-#define IRQ_AMIGA_CIAB_TA   19
-#define IRQ_AMIGA_CIAB_TB   20
-#define IRQ_AMIGA_CIAB_ALRM 21
-#define IRQ_AMIGA_CIAB_SP   22
-#define IRQ_AMIGA_CIAB_FLG  23
-
-/* auto-vector interrupts */
-#define IRQ_AMIGA_AUTO      24
-#define IRQ_AMIGA_AUTO_0    24 /* This is just a dummy */
-#define IRQ_AMIGA_AUTO_1    25
-#define IRQ_AMIGA_AUTO_2    26
-#define IRQ_AMIGA_AUTO_3    27
-#define IRQ_AMIGA_AUTO_4    28
-#define IRQ_AMIGA_AUTO_5    29
-#define IRQ_AMIGA_AUTO_6    30
-#define IRQ_AMIGA_AUTO_7    31
-
-#define IRQ_FLOPPY	    IRQ_AMIGA_DSKBLK
-
-/* INTREQR masks */
-#define IRQ1_MASK   0x0007	/* INTREQR mask for IRQ 1 */
-#define IRQ2_MASK   0x0008	/* INTREQR mask for IRQ 2 */
-#define IRQ3_MASK   0x0070	/* INTREQR mask for IRQ 3 */
-#define IRQ4_MASK   0x0780	/* INTREQR mask for IRQ 4 */
-#define IRQ5_MASK   0x1800	/* INTREQR mask for IRQ 5 */
-#define IRQ6_MASK   0x2000	/* INTREQR mask for IRQ 6 */
-#define IRQ7_MASK   0x4000	/* INTREQR mask for IRQ 7 */
-
-#define IF_SETCLR   0x8000      /* set/clr bit */
-#define IF_INTEN    0x4000	/* master interrupt bit in INT* registers *=
/
-#define IF_EXTER    0x2000	/* external level 6 and CIA B interrupt */
-#define IF_DSKSYN   0x1000	/* disk sync interrupt */
-#define IF_RBF	    0x0800	/* serial receive buffer full interrupt */
-#define IF_AUD3     0x0400	/* audio channel 3 done interrupt */
-#define IF_AUD2     0x0200	/* audio channel 2 done interrupt */
-#define IF_AUD1     0x0100	/* audio channel 1 done interrupt */
-#define IF_AUD0     0x0080	/* audio channel 0 done interrupt */
-#define IF_BLIT     0x0040	/* blitter done interrupt */
-#define IF_VERTB    0x0020	/* vertical blanking interrupt */
-#define IF_COPER    0x0010	/* copper interrupt */
-#define IF_PORTS    0x0008	/* external level 2 and CIA A interrupt */
-#define IF_SOFT     0x0004	/* software initiated interrupt */
-#define IF_DSKBLK   0x0002	/* diskblock DMA finished */
-#define IF_TBE	    0x0001	/* serial transmit buffer empty interrupt */
-
-extern void amiga_do_irq(int irq, struct pt_regs *fp);
-extern void amiga_do_irq_list(int irq, struct pt_regs *fp);
-
-/* CIA interrupt control register bits */
-
-#define CIA_ICR_TA	0x01
-#define CIA_ICR_TB	0x02
-#define CIA_ICR_ALRM	0x04
-#define CIA_ICR_SP	0x08
-#define CIA_ICR_FLG	0x10
-#define CIA_ICR_ALL	0x1f
-#define CIA_ICR_SETCLR	0x80
-
-/* to access the interrupt control registers of CIA's use only
-** these functions, they behave exactly like the amiga os routines
-*/
-
-extern struct ciabase ciaa_base, ciab_base;
-
-extern unsigned char cia_set_irq(unsigned int irq, int set);
-extern unsigned char cia_able_irq(unsigned int irq, int enable);
-
-#endif /* asm-m68k/amigaints.h */
-#endif /* __KERNEL__ */
diff -puN include/asm-ppc/amigappc.h~ppc-remove-apus-support /dev/null
--- a/include/asm-ppc/amigappc.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
-** asm-ppc/amigappc.h -- This header defines some values and pointers =
for
-**                        the Phase 5 PowerUp card.
-**
-** Copyright 1997, 1998 by Phase5, Germany.
-**
-** This file is subject to the terms and conditions of the GNU General=
 Public
-** License.  See the file COPYING in the main directory of this archiv=
e
-** for more details.
-**
-** Created: 7/22/97 by Jesper Skov
-*/
-
-#ifdef __KERNEL__
-#ifndef _M68K_AMIGAPPC_H
-#define _M68K_AMIGAPPC_H
-
-#ifndef __ASSEMBLY__
-
-/* #include <asm/system.h> */
-#define mb()  __asm__ __volatile__ ("sync" : : : "memory")
-
-#define APUS_WRITE(_a_, _v_)				\
-do {							\
-	(*((volatile unsigned char *)(_a_)) =3D (_v_));	\
-	mb();						\
-} while (0)
-
-#define APUS_READ(_a_, _v_)				\
-do {							\
-	(_v_) =3D (*((volatile unsigned char *)(_a_)));	\
-	mb();						\
-} while (0)
-#endif /* ndef __ASSEMBLY__ */
-
-/* Maybe add a [#ifdef WANT_ZTWOBASE] condition to amigahw.h? */
-#define zTwoBase (0x80000000)
-
-#define APUS_IPL_BASE   	(zTwoBase + 0x00f60000)
-#define APUS_REG_RESET    	(APUS_IPL_BASE + 0x00)
-#define APUS_REG_WAITSTATE    	(APUS_IPL_BASE + 0x10)
-#define APUS_REG_SHADOW    	(APUS_IPL_BASE + 0x18)
-#define APUS_REG_LOCK		(APUS_IPL_BASE + 0x20)
-#define APUS_REG_INT    	(APUS_IPL_BASE + 0x28)
-#define APUS_IPL_EMU		(APUS_IPL_BASE + 0x30)
-#define APUS_INT_LVL		(APUS_IPL_BASE + 0x38)
-
-#define REGSHADOW_SETRESET	(0x80)
-#define REGSHADOW_SELFRESET	(0x40)
-
-#define REGLOCK_SETRESET	(0x80)
-#define REGLOCK_BLACKMAGICK1	(0x40)
-#define REGLOCK_BLACKMAGICK2	(0x20)
-#define REGLOCK_BLACKMAGICK3	(0x10)
-
-#define REGWAITSTATE_SETRESET	(0x80)
-#define REGWAITSTATE_PPCW	(0x08)
-#define REGWAITSTATE_PPCR	(0x04)
-
-#define REGRESET_SETRESET	(0x80)
-#define REGRESET_PPCRESET	(0x10)
-#define REGRESET_M68KRESET	(0x08)
-#define REGRESET_AMIGARESET	(0x04)
-#define REGRESET_AUXRESET	(0x02)
-#define REGRESET_SCSIRESET	(0x01)
-
-#define REGINT_SETRESET		(0x80)
-#define REGINT_ENABLEIPL	(0x02)
-#define REGINT_INTMASTER	(0x01)
-
-#define IPLEMU_SETRESET		(0x80)
-#define IPLEMU_DISABLEINT	(0x40)
-#define IPLEMU_IPL2		(0x20)
-#define IPLEMU_IPL1		(0x10)
-#define IPLEMU_IPL0		(0x08)
-#define IPLEMU_PPCIPL2		(0x04)
-#define IPLEMU_PPCIPL1		(0x02)
-#define IPLEMU_PPCIPL0		(0x01)
-#define IPLEMU_IPLMASK		(IPLEMU_PPCIPL2|IPLEMU_PPCIPL1|IPLEMU_PPCIPL0)
-
-#define INTLVL_SETRESET         (0x80)
-#define INTLVL_MASK             (0x7f)
-
-#endif /* _M68k_AMIGAPPC_H */
-#endif /* __KERNEL__ */
diff -puN include/asm-ppc/bootinfo.h~ppc-remove-apus-support include/as=
m-ppc/bootinfo.h
--- a/include/asm-ppc/bootinfo.h~ppc-remove-apus-support
+++ a/include/asm-ppc/bootinfo.h
@@ -11,10 +11,6 @@
=20
 #include <asm/page.h>
=20
-#if defined(CONFIG_APUS) && !defined(__BOOTER__)
-#include <asm-m68k/bootinfo.h>
-#else
-
 struct bi_record {
 	unsigned long tag;		/* tag ID */
 	unsigned long size;		/* size of record (in bytes) */
@@ -44,7 +40,6 @@ bootinfo_addr(unsigned long offset)
 	return (struct bi_record *)_ALIGN((offset) + (1 << 20) - 1,
 					  (1 << 20));
 }
-#endif /* CONFIG_APUS */
=20
=20
 #endif /* _PPC_BOOTINFO_H */
diff -puN include/asm-ppc/io.h~ppc-remove-apus-support include/asm-ppc/=
io.h
--- a/include/asm-ppc/io.h~ppc-remove-apus-support
+++ a/include/asm-ppc/io.h
@@ -30,7 +30,7 @@
 #include <asm/mpc8xx.h>
 #elif defined(CONFIG_8260)
 #include <asm/mpc8260.h>
-#elif defined(CONFIG_APUS) || !defined(CONFIG_PCI)
+#elif !defined(CONFIG_PCI)
 #define _IO_BASE	0
 #define _ISA_MEM_BASE	0
 #define PCI_DRAM_OFFSET 0
@@ -145,24 +145,7 @@ static inline void writeb(__u8 b, volati
 }
 #endif
=20
-#if defined(CONFIG_APUS)
-static inline __u16 readw(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u16 *)(addr);
-}
-static inline __u32 readl(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u32 *)(addr);
-}
-static inline void writew(__u16 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u16 *)(addr) =3D b;
-}
-static inline void writel(__u32 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u32 *)(addr) =3D b;
-}
-#elif defined (CONFIG_8260_PCI9)
+#if defined (CONFIG_8260_PCI9)
 /* Use macros if PCI9 workaround enabled */
 #define readw(addr) in_le16((volatile u16 *)(addr))
 #define readl(addr) in_le32((volatile u32 *)(addr))
@@ -185,7 +168,7 @@ static inline void writel(__u32 b, volat
 {
 	out_le32(addr, b);
 }
-#endif /* CONFIG_APUS */
+#endif /* CONFIG_8260_PCI9 */
=20
 #define readb_relaxed(addr) readb(addr)
 #define readw_relaxed(addr) readw(addr)
@@ -300,13 +283,7 @@ extern __inline__ void name(unsigned int
 }
=20
 __do_out_asm(outb, "stbx")
-#ifdef CONFIG_APUS
-__do_in_asm(inb, "lbzx")
-__do_in_asm(inw, "lhz%U1%X1")
-__do_in_asm(inl, "lwz%U1%X1")
-__do_out_asm(outl,"stw%U0%X0")
-__do_out_asm(outw, "sth%U0%X0")
-#elif defined (CONFIG_8260_PCI9)
+#if defined (CONFIG_8260_PCI9)
 /* in asm cannot be defined if PCI9 workaround is used */
 #define inb(port)		in_8((port)+___IO_BASE)
 #define inw(port)		in_le16((port)+___IO_BASE)
@@ -371,7 +348,6 @@ extern void __iomem *ioremap64(unsigned=20
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
 extern void iounmap(volatile void __iomem *addr);
 extern unsigned long iopa(unsigned long addr);
-extern unsigned long mm_ptov(unsigned long addr) __attribute_const__;
 extern void io_block_mapping(unsigned long virt, phys_addr_t phys,
 			     unsigned int size, int flags);
=20
@@ -384,24 +360,16 @@ extern void io_block_mapping(unsigned lo
  */
 extern inline unsigned long virt_to_bus(volatile void * address)
 {
-#ifndef CONFIG_APUS
         if (address =3D=3D (void *)0)
 		return 0;
         return (unsigned long)address - KERNELBASE + PCI_DRAM_OFFSET;
-#else
-	return iopa ((unsigned long) address);
-#endif
 }
=20
 extern inline void * bus_to_virt(unsigned long address)
 {
-#ifndef CONFIG_APUS
         if (address =3D=3D 0)
 		return NULL;
         return (void *)(address - PCI_DRAM_OFFSET + KERNELBASE);
-#else
-	return (void*) mm_ptov (address);
-#endif
 }
=20
 /*
@@ -410,20 +378,12 @@ extern inline void * bus_to_virt(unsigne
  */
 extern inline unsigned long virt_to_phys(volatile void * address)
 {
-#ifndef CONFIG_APUS
 	return (unsigned long) address - KERNELBASE;
-#else
-	return iopa ((unsigned long) address);
-#endif
 }
=20
 extern inline void * phys_to_virt(unsigned long address)
 {
-#ifndef CONFIG_APUS
 	return (void *) (address + KERNELBASE);
-#else
-	return (void*) mm_ptov (address);
-#endif
 }
=20
 /*
diff -puN include/asm-ppc/machdep.h~ppc-remove-apus-support include/asm=
-ppc/machdep.h
--- a/include/asm-ppc/machdep.h~ppc-remove-apus-support
+++ a/include/asm-ppc/machdep.h
@@ -8,10 +8,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
=20
-#ifdef CONFIG_APUS
-#include <asm-m68k/machdep.h>
-#endif
-
 struct pt_regs;
 struct pci_bus;=09
 struct pci_dev;
diff -puN include/asm-ppc/page.h~ppc-remove-apus-support include/asm-pp=
c/page.h
--- a/include/asm-ppc/page.h~ppc-remove-apus-support
+++ a/include/asm-ppc/page.h
@@ -97,62 +97,22 @@ extern void clear_user_page(void *page,=20
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 			   struct page *pg);
=20
-#ifndef CONFIG_APUS
 #define PPC_MEMSTART	0
-#define PPC_PGSTART	0
 #define PPC_MEMOFFSET	PAGE_OFFSET
-#else
-extern unsigned long ppc_memstart;
-extern unsigned long ppc_pgstart;
-extern unsigned long ppc_memoffset;
-#define PPC_MEMSTART	ppc_memstart
-#define PPC_PGSTART	ppc_pgstart
-#define PPC_MEMOFFSET	ppc_memoffset
-#endif
-
-#if defined(CONFIG_APUS) && !defined(MODULE)
-/* map phys->virtual and virtual->phys for RAM pages */
-static inline unsigned long ___pa(unsigned long v)
-{
-	unsigned long p;
-	asm volatile ("1: addis %0, %1, %2;"
-		      ".section \".vtop_fixup\",\"aw\";"
-		      ".align  1;"
-		      ".long   1b;"
-		      ".previous;"
-		      : "=3Dr" (p)
-		      : "b" (v), "K" (((-PAGE_OFFSET) >> 16) & 0xffff));
=20
-	return p;
-}
-static inline void* ___va(unsigned long p)
-{
-	unsigned long v;
-	asm volatile ("1: addis %0, %1, %2;"
-		      ".section \".ptov_fixup\",\"aw\";"
-		      ".align  1;"
-		      ".long   1b;"
-		      ".previous;"
-		      : "=3Dr" (v)
-		      : "b" (p), "K" (((PAGE_OFFSET) >> 16) & 0xffff));
-
-	return (void*) v;
-}
-#else
 #define ___pa(vaddr) ((vaddr)-PPC_MEMOFFSET)
 #define ___va(paddr) ((paddr)+PPC_MEMOFFSET)
-#endif
=20
 extern int page_is_ram(unsigned long pfn);
=20
 #define __pa(x) ___pa((unsigned long)(x))
 #define __va(x) ((void *)(___va((unsigned long)(x))))
=20
-#define ARCH_PFN_OFFSET		(PPC_PGSTART)
+#define ARCH_PFN_OFFSET		0
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_virt(page)	__va(page_to_pfn(page) << PAGE_SHIFT)
=20
-#define pfn_valid(pfn)		(((pfn) - PPC_PGSTART) < max_mapnr)
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
=20
 /* Pure 2^n version of get_order */
diff -puN include/asm-ppc/pgtable.h~ppc-remove-apus-support include/asm=
-ppc/pgtable.h
--- a/include/asm-ppc/pgtable.h~ppc-remove-apus-support
+++ a/include/asm-ppc/pgtable.h
@@ -765,14 +765,6 @@ extern void paging_init(void);
 #define pte_to_pgoff(pte)	(pte_val(pte) >> 3)
 #define pgoff_to_pte(off)	((pte_t) { ((off) << 3) | _PAGE_FILE })
=20
-/* CONFIG_APUS */
-/* For virtual address to physical address conversion */
-extern void cache_clear(__u32 addr, int length);
-extern void cache_push(__u32 addr, int length);
-extern int mm_end_of_chunk (unsigned long addr, int len);
-extern unsigned long iopa(unsigned long addr);
-extern unsigned long mm_ptov(unsigned long addr) __attribute_const__;
-
 /* Values for nocacheflag and cmode */
 /* These are not used by the APUS kernel_map, but prevents
    compilation errors. */
diff -puN sound/oss/dmasound/Kconfig~ppc-remove-apus-support sound/oss/=
dmasound/Kconfig
--- a/sound/oss/dmasound/Kconfig~ppc-remove-apus-support
+++ a/sound/oss/dmasound/Kconfig
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
=20
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
-	depends on (AMIGA || APUS) && SOUND
+	depends on AMIGA && SOUND
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Amiga in Linux, answe=
r
diff -puN sound/oss/dmasound/dmasound_paula.c~ppc-remove-apus-support s=
ound/oss/dmasound/dmasound_paula.c
--- a/sound/oss/dmasound/dmasound_paula.c~ppc-remove-apus-support
+++ a/sound/oss/dmasound/dmasound_paula.c
@@ -91,10 +91,6 @@ static irqreturn_t AmiInterrupt(int irq,
      *  power LED are controlled by the same line.
      */
=20
-#ifdef CONFIG_APUS
-#define mach_heartbeat	ppc_md.heartbeat
-#endif
-
 static void (*saved_heartbeat)(int) =3D NULL;
=20
 static inline void disable_heartbeat(void)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-the-arm26-port.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
ppc-remove-apus-support.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-=
dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-host=
s.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.pat=
ch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-=
remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
