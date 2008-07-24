From: akpm@linux-foundation.org
Subject: - cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:18 -0700
Message-ID: <200807242328.m6ONSIva011250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057AbYGXXeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:34:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nyet@mrv.com, alan@lxorguk.ukuu.org.uk, galak@kernel.crashing.org, paulus@samba.org, scottwood@freescale.com, vbordug@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     cpm1: don't send break on TX_STOP, don't interrupt RX/TX when adjusting termios parameters
has been removed from the -mm tree.  Its filename was
     cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpm1: don't send break on TX_STOP, don't interrupt RX/TX when adjusting termios parameters
From: Nye Liu <nyet@mrv.com>

Before setting STOP_TX, set _brkcr to 0 so the SMC does not send a break
character.  The driver appears to properly re-initialize _brkcr when the
SMC is restarted.

Do not interrupt RX/TX when the termios is being adjusted; it results in
corrupted characters appearing on the line.

Cc: Vitaly Bordug <vbordug@ru.mvista.com>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/cpm_uart/cpm_uart_core.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN drivers/serial/cpm_uart/cpm_uart_core.c~cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c~cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters
+++ a/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -435,10 +435,13 @@ static void cpm_uart_shutdown(struct uar
 		}
 
 		/* Shut them really down and reinit buffer descriptors */
-		if (IS_SMC(pinfo))
+		if (IS_SMC(pinfo)) {
+			out_be16(&pinfo->smcup->smc_brkcr, 0);
 			cpm_line_cr_cmd(pinfo, CPM_CR_STOP_TX);
-		else
+		} else {
+			out_be16(&pinfo->sccup->scc_brkcr, 0);
 			cpm_line_cr_cmd(pinfo, CPM_CR_GRA_STOP_TX);
+		}
 
 		cpm_uart_initbd(pinfo);
 	}
@@ -554,9 +557,11 @@ static void cpm_uart_set_termios(struct 
 		 * enables, because we want to put them back if they were
 		 * present.
 		 */
-		prev_mode = in_be16(&smcp->smc_smcmr);
-		out_be16(&smcp->smc_smcmr, smcr_mk_clen(bits) | cval | SMCMR_SM_UART);
-		setbits16(&smcp->smc_smcmr, (prev_mode & (SMCMR_REN | SMCMR_TEN)));
+		prev_mode = in_be16(&smcp->smc_smcmr) & (SMCMR_REN | SMCMR_TEN);
+		/* Output in *one* operation, so we don't interrupt RX/TX if they
+		 * were already enabled. */
+		out_be16(&smcp->smc_smcmr, smcr_mk_clen(bits) | cval |
+		    SMCMR_SM_UART | prev_mode);
 	} else {
 		out_be16(&sccp->scc_psmr, (sbits << 12) | scval);
 	}
@@ -1198,12 +1203,14 @@ static int __init cpm_uart_console_setup
 	udbg_putc = NULL;
 #endif
 
-	cpm_line_cr_cmd(pinfo, CPM_CR_STOP_TX);
