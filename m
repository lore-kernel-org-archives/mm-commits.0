From: akpm@linux-foundation.org
Subject: + serial-mpsc-remove-race-between-rx-stop-restart.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:41:20 -0700
Message-ID: <200707192141.l6JLfKlv024465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624AbXGSVmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: carlos.sanchez@gecoinc.com, mgreer@mvista.com


The patch titled
     serial: MPSC: Remove race between Rx stop & restart
has been added to the -mm tree.  Its filename is
     serial-mpsc-remove-race-between-rx-stop-restart.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: MPSC: Remove race between Rx stop & restart
From: Carlos Sanchez <carlos.sanchez@gecoinc.com>

The patch in commit ID f7232056bff5fe2d3bfeab35252a66ebaeb5bbde stops (aborts)
the MPSC's receive engine just before restarting it.  Unfortunately, it
doesn't wait for the abort to complete before restarting it which creates a
race between the abort and the restart.  If the restart occurs first, the
in-progress abort stops it again and the rx engine remains stopped.

Instead, do the abort when the SDMA engine is being stopped.  Make sure to
wait for the abort to complete before continuing.

Signed-off-by: Carlos Sanchez <carlos.sanchez@gecoinc.com>
Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/serial/mpsc.c~serial-mpsc-remove-race-between-rx-stop-restart drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-mpsc-remove-race-between-rx-stop-restart
+++ a/drivers/serial/mpsc.c
@@ -1363,8 +1363,6 @@ mpsc_start_rx(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_start_rx[%d]: Starting...\n", pi->port.line);
 
-	/* Issue a Receive Abort to clear any receive errors */
-	writel(MPSC_CHR_2_RA, pi->mpsc_base + MPSC_CHR_2);
 	if (pi->rcv_data) {
 		mpsc_enter_hunt(pi);
 		mpsc_sdma_cmd(pi, SDMA_SDCM_ERD);
@@ -1379,6 +1377,20 @@ mpsc_stop_rx(struct uart_port *port)
 
 	pr_debug("mpsc_stop_rx[%d]: Stopping...\n", port->line);
 
+	if (pi->mirror_regs) {
+		writel(pi->MPSC_CHR_2_m | MPSC_CHR_2_RA,
+				pi->mpsc_base + MPSC_CHR_2);
+		/* Erratum prevents reading CHR_2 so just delay for a while */
+		udelay(100);
+	}
+	else {
+		writel(readl(pi->mpsc_base + MPSC_CHR_2) | MPSC_CHR_2_RA,
+			pi->mpsc_base + MPSC_CHR_2);
+
+		while (readl(pi->mpsc_base + MPSC_CHR_2) & MPSC_CHR_2_RA)
+			udelay(10);
+	}
+
 	mpsc_sdma_cmd(pi, SDMA_SDCM_AR);
 	return;
 }
_

Patches currently in -mm which might be from carlos.sanchez@gecoinc.com are

serial-mpsc-remove-race-between-rx-stop-restart.patch
