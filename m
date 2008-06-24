From: akpm@linux-foundation.org
Subject: + cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:46:05 -0700
Message-ID: <200806242346.m5ONk5o3012459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYFXXq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nyet@mrv.com, alan@lxorguk.ukuu.org.uk, galak@kernel.crashing.org, paulus@samba.org, scottwood@freescale.com, vbordug@ru.mvista.com


The patch titled
     cpm1: don't send break on TX_STOP, don't interrupt RX/TX when adjusting termios parameters
has been added to the -mm tree.  Its filename is
     cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters.patch

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
@@ -491,10 +491,13 @@ static void cpm_uart_shutdown(struct uar
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
@@ -605,9 +608,11 @@ static void cpm_uart_set_termios(struct 
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
@@ -1417,12 +1422,14 @@ static int __init cpm_uart_console_setup
 	udbg_putc = NULL;
 #endif
 
-	cpm_line_cr_cmd(pinfo, CPM_CR_STOP_TX);
