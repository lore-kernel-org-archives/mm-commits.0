From: akpm@linux-foundation.org
Subject: + rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:15 -0700
Message-ID: <201009142221.o8EMLF28021790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab0INWVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio:powerpc/85xx: modify RIO port-write interrupt handler
has been added to the -mm tree.  Its filename is
     rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch

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
Subject: rapidio:powerpc/85xx: modify RIO port-write interrupt handler
From: Alexandre Bounine <alexandre.bounine@idt.com>

- Rearrange RIO port-write interrupt handling to perform message
  buffering as soon as possible.

- Modify to disable port-write controller when clearing Transaction
  Error (TE) bit.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   68 ++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -87,6 +87,9 @@
 #define RIO_IPWSR_PWD		0x00000008
 #define RIO_IPWSR_PWB		0x00000004
 
+#define RIO_EPWISR_PINT		0x80000000
+#define RIO_EPWISR_PW		0x00000001
+
 #define RIO_MSG_DESC_SIZE	32
 #define RIO_MSG_BUFFER_SIZE	4096
 #define RIO_MIN_TX_RING_SIZE	2
@@ -1067,18 +1070,12 @@ fsl_rio_port_write_handler(int irq, void
 	struct rio_priv *priv = port->priv;
 	u32 epwisr, tmp;
 
-	ipwmr = in_be32(&priv->msg_regs->pwmr);
-	ipwsr = in_be32(&priv->msg_regs->pwsr);
-
 	epwisr = in_be32(priv->regs_win + RIO_EPWISR);
-	if (epwisr & 0x80000000) {
-		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
-		pr_info("RIO_LTLEDCSR = 0x%x\n", tmp);
-		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
-	}
+	if (!(epwisr & RIO_EPWISR_PW))
+		goto pw_done;
 
-	if (!(epwisr & 0x00000001))
-		return IRQ_HANDLED;
+	ipwmr = in_be32(&priv->msg_regs->pwmr);
+	ipwsr = in_be32(&priv->msg_regs->pwsr);
 
 #ifdef DEBUG_PW
 	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);
@@ -1094,20 +1091,6 @@ fsl_rio_port_write_handler(int irq, void
 		pr_debug(" PWB");
 	pr_debug(" )\n");
 #endif
-	out_be32(&priv->msg_regs->pwsr,
-		 ipwsr & (RIO_IPWSR_TE | RIO_IPWSR_QFI | RIO_IPWSR_PWD));
-
-	if ((ipwmr & RIO_IPWMR_EIE) && (ipwsr & RIO_IPWSR_TE)) {
-		priv->port_write_msg.err_count++;
-		pr_info("RIO: Port-Write Transaction Err (%d)\n",
-			 priv->port_write_msg.err_count);
-	}
-	if (ipwsr & RIO_IPWSR_PWD) {
-		priv->port_write_msg.discard_count++;
-		pr_info("RIO: Port Discarded Port-Write Msg(s) (%d)\n",
-			 priv->port_write_msg.discard_count);
-	}
-
 	/* Schedule deferred processing if PW was received */
 	if (ipwsr & RIO_IPWSR_QFI) {
 		/* Save PW message (if there is room in FIFO),
@@ -1119,16 +1102,43 @@ fsl_rio_port_write_handler(int irq, void
 				 RIO_PW_MSG_SIZE);
 		} else {
 			priv->port_write_msg.discard_count++;
-			pr_info("RIO: ISR Discarded Port-Write Msg(s) (%d)\n",
+			pr_debug("RIO: ISR Discarded Port-Write Msg(s) (%d)\n",
 				 priv->port_write_msg.discard_count);
 		}
+		/* Clear interrupt and issue Clear Queue command. This allows
+		 * another port-write to be received.
+		 */
+		out_be32(&priv->msg_regs->pwsr,	RIO_IPWSR_QFI);
+		out_be32(&priv->msg_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
+
 		schedule_work(&priv->pw_work);
 	}
 
-	/* Issue Clear Queue command. This allows another
-	 * port-write to be received.
-	 */
-	out_be32(&priv->msg_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
+	if ((ipwmr & RIO_IPWMR_EIE) && (ipwsr & RIO_IPWSR_TE)) {
+		priv->port_write_msg.err_count++;
+		pr_debug("RIO: Port-Write Transaction Err (%d)\n",
+			 priv->port_write_msg.err_count);
+		/* Clear Transaction Error: port-write controller should be
+		 * disabled when clearing this error
+		 */
+		out_be32(&priv->msg_regs->pwmr, ipwmr & ~RIO_IPWMR_PWE);
+		out_be32(&priv->msg_regs->pwsr,	RIO_IPWSR_TE);
+		out_be32(&priv->msg_regs->pwmr, ipwmr);
+	}
+
+	if (ipwsr & RIO_IPWSR_PWD) {
+		priv->port_write_msg.discard_count++;
+		pr_debug("RIO: Port Discarded Port-Write Msg(s) (%d)\n",
+			 priv->port_write_msg.discard_count);
+		out_be32(&priv->msg_regs->pwsr, RIO_IPWSR_PWD);
+	}
+
+pw_done:
+	if (epwisr & RIO_EPWISR_PINT) {
+		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		pr_debug("RIO_LTLEDCSR = 0x%x\n", tmp);
+		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
+	}
 
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch

