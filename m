From: akpm@linux-foundation.org
Subject: [merged] cpm_uart-fix-non-console-port-startup-bug.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:27:01 -0700
Message-ID: <200903101827.n2AIR1Vl022699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbZCJScE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Xiaotian.Feng@windriver.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, galak@gate.crashing.org, vbordug@ru.mvista.com, xiaotian.feng@windriver.com, mm-commits@vger.kernel.org


The patch titled
     cpm_uart: fix non-console port startup bug
has been removed from the -mm tree.  Its filename was
     cpm_uart-fix-non-console-port-startup-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpm_uart: fix non-console port startup bug
From: Xiaotian Feng <Xiaotian.Feng@windriver.com>

After UART interrupt handler is installed and rx is enabled, if an rx
interrupt comes before hardware init, rx->cur will be updated.  Then the
hardware init will reset BD and make rx->cur out of sync, move the
hardware init code before request_irq.

Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Vitaly Bordug <vbordug@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/cpm_uart/cpm_uart_core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/serial/cpm_uart/cpm_uart_core.c~cpm_uart-fix-non-console-port-startup-bug drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c~cpm_uart-fix-non-console-port-startup-bug
+++ a/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -406,6 +406,18 @@ static int cpm_uart_startup(struct uart_
 
 	pr_debug("CPM uart[%d]:startup\n", port->line);
 
+	/* If the port is not the console, make sure rx is disabled. */
+	if (!(pinfo->flags & FLAG_CONSOLE)) {
+		/* Disable UART rx */
+		if (IS_SMC(pinfo)) {
+			clrbits16(&pinfo->smcp->smc_smcmr, SMCMR_REN);
+			clrbits8(&pinfo->smcp->smc_smcm, SMCM_RX);
+		} else {
+			clrbits32(&pinfo->sccp->scc_gsmrl, SCC_GSMRL_ENR);
+			clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_RX);
+		}
+		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+	}
 	/* Install interrupt handler. */
 	retval = request_irq(port->irq, cpm_uart_int, 0, "cpm_uart", port);
 	if (retval)
@@ -420,8 +432,6 @@ static int cpm_uart_startup(struct uart_
 		setbits32(&pinfo->sccp->scc_gsmrl, (SCC_GSMRL_ENR | SCC_GSMRL_ENT));
 	}
 
-	if (!(pinfo->flags & FLAG_CONSOLE))
-		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
 	return 0;
 }
 
_

Patches currently in -mm which might be from Xiaotian.Feng@windriver.com are

linux-next.patch

