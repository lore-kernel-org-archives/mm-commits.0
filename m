From: akpm@linux-foundation.org
Subject: + rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch added to -mm tree
Date: Mon, 12 Apr 2010 20:55:59 -0400
Message-ID: <201004130357.o3D3vbnS011294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab0DMD5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 23:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio, powerpc/85xx: Add MChk handler for SRIO port
has been added to the -mm tree.  Its filename is
     rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch

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
Subject: rapidio, powerpc/85xx: Add MChk handler for SRIO port
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add Machine Check exception handling into RapidIO port driver for
Freescale SoCs (MPC85xx).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   74 ++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-powerpc-85xx-add-mchk-handler-for-srio-port arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-powerpc-85xx-add-mchk-handler-for-srio-port
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -32,6 +32,8 @@
 #include <linux/kfifo.h>
 
 #include <asm/io.h>
+#include <asm/machdep.h>
+#include <asm/uaccess.h>
 
 #undef DEBUG_PW	/* Port-Write debugging */
 
@@ -47,6 +49,8 @@
 #define RIO_ESCSR		0x158
 #define RIO_CCSR		0x15c
 #define RIO_LTLEDCSR		0x0608
+#define  RIO_LTLEDCSR_IER	0x80000000
+#define  RIO_LTLEDCSR_PRT	0x01000000
 #define RIO_LTLEECSR		0x060c
 #define RIO_EPWISR		0x10010
 #define RIO_ISR_AACR		0x10120
@@ -214,6 +218,54 @@ struct rio_priv {
 	spinlock_t pw_fifo_lock;
 };
 
+#define __fsl_read_rio_config(x, addr, err, op)		\
+	__asm__ __volatile__(				\
+		"1:	"op" %1,0(%2)\n"		\
+		"	eieio\n"			\
+		"2:\n"					\
+		".section .fixup,\"ax\"\n"		\
+		"3:	li %1,-1\n"			\
+		"	li %0,%3\n"			\
+		"	b 2b\n"				\
+		".section __ex_table,\"a\"\n"		\
+		"	.align 2\n"			\
+		"	.long 1b,3b\n"			\
+		".text"					\
+		: "=r" (err), "=r" (x)			\
+		: "b" (addr), "i" (-EFAULT), "0" (err))
+
+static void __iomem *rio_regs_win;
+
+static int (*saved_mcheck_exception)(struct pt_regs *regs);
+
+static int fsl_rio_mcheck_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *entry = NULL;
+	unsigned long reason = (mfspr(SPRN_MCSR) & MCSR_MASK);
+
+	if (reason & MCSR_BUS_RBERR) {
+		reason = in_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR));
+		if (reason & (RIO_LTLEDCSR_IER | RIO_LTLEDCSR_PRT)) {
+			/* Check if we are prepared to handle this fault */
+			entry = search_exception_tables(regs->nip);
+			if (entry) {
+				pr_debug("RIO: %s - MC Exception handled\n",
+					 __func__);
+				out_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR),
+					 0);
+				regs->msr |= MSR_RI;
+				regs->nip = entry->fixup;
+				return 1;
+			}
+		}
+	}
+
+	if (saved_mcheck_exception)
+		return saved_mcheck_exception(regs);
+	else
+		return cur_cpu_spec->machine_check(regs);
+}
+
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
  * @mport: RapidIO master port info
@@ -314,6 +366,7 @@ fsl_rio_config_read(struct rio_mport *mp
 {
 	struct rio_priv *priv = mport->priv;
 	u8 *data;
+	u32 rval, err = 0;
 
 	pr_debug
 	    ("fsl_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
@@ -324,17 +377,24 @@ fsl_rio_config_read(struct rio_mport *mp
 	data = (u8 *) priv->maint_win + offset;
 	switch (len) {
 	case 1:
-		*val = in_8((u8 *) data);
+		__fsl_read_rio_config(rval, data, err, "lbz");
 		break;
 	case 2:
-		*val = in_be16((u16 *) data);
+		__fsl_read_rio_config(rval, data, err, "lhz");
 		break;
 	default:
-		*val = in_be32((u32 *) data);
+		__fsl_read_rio_config(rval, data, err, "lwz");
 		break;
 	}
 
-	return 0;
+	if (err) {
+		pr_debug("RIO: cfg_read error %d for %x:%x:%x\n",
+			 err, destid, hopcount, offset);
+	}
+
+	*val = rval;
+
+	return err;
 }
 
 /**
@@ -1365,6 +1425,7 @@ int fsl_rio_setup(struct of_device *dev)
 	rio_register_mport(port);
 
 	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
+	rio_regs_win = priv->regs_win;
 
 	/* Probe the master port phy type */
 	ccsr = in_be32(priv->regs_win + RIO_CCSR);
@@ -1433,6 +1494,11 @@ int fsl_rio_setup(struct of_device *dev)
 	fsl_rio_doorbell_init(port);
 	fsl_rio_port_write_init(port);
 
+	saved_mcheck_exception = ppc_md.machine_check_exception;
+	ppc_md.machine_check_exception = fsl_rio_mcheck_exception;
+	/* Ensure that RFXE is set */
+	mtspr(SPRN_HID1, (mfspr(SPRN_HID1) | 0x20000));
+
 	return 0;
 err:
 	iounmap(priv->regs_win);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch

