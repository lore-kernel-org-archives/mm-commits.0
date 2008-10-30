From: akpm@linux-foundation.org
Subject: - mmc-fix-clock-off-in-pxa255-270.patch removed from -mm tree
Date: Thu, 30 Oct 2008 02:15:31 -0700
Message-ID: <200810300915.m9U9FVwg027560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbYJ3JQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 05:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rifx@o2.pl, drzeus-list@drzeus.cx, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: fix clock-off in PXA255/270
has been removed from the -mm tree.  Its filename was
     mmc-fix-clock-off-in-pxa255-270.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: fix clock-off in PXA255/270
From: rifx <rifx@o2.pl>

It solves the problems with clock-off in the PXA255/270 MMC/SD hardware.  This
solution was tested with our devices and works good.

Cc: Pierre Ossman <drzeus-list@drzeus.cx>

On Tue, 10 Jun 2008 08:42:01 +0200 Pierre Ossman <drzeus@drzeus.cx> wrote:
> 
> This version was NAK:ed. I'm waiting for a new patch that removes the
> original clock fiddling instead.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/pxamci.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/pxamci.c~mmc-fix-clock-off-in-pxa255-270 drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~mmc-fix-clock-off-in-pxa255-270
+++ a/drivers/mmc/host/pxamci.c
@@ -26,6 +26,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
 
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -69,6 +70,8 @@ struct pxamci_host {
 	unsigned int		dma_drcmrtx;
 };
 
+static int local_cmd = -1;
+
 static void pxamci_stop_clock(struct pxamci_host *host)
 {
 	if (readl(host->base + MMC_STAT) & STAT_CLK_EN) {
@@ -86,6 +89,7 @@ static void pxamci_stop_clock(struct pxa
 
 		if (v & STAT_CLK_EN)
 			dev_err(mmc_dev(host->mmc), "unable to stop clock\n");
+		local_cmd = -1;
 	}
 }
 
@@ -247,6 +251,14 @@ static int pxamci_cmd_done(struct pxamci
 		v = w2;
 	}
 
+	local_cmd = cmd->opcode;
+	if ((local_cmd == MMC_GO_IDLE_STATE) ||
+	    (local_cmd == MMC_GO_INACTIVE_STATE) ||
+	    (local_cmd == MMC_SEND_STATUS) ||
+	    (local_cmd == MMC_STOP_TRANSMISSION) ||
+	    (local_cmd == MMC_SET_BLOCKLEN)
+	    ) pxamci_stop_clock(host);
+
 	if (stat & STAT_TIME_OUT_RESPONSE) {
 		cmd->error = -ETIMEDOUT;
 	} else if (stat & STAT_RES_CRC_ERR && cmd->flags & MMC_RSP_CRC) {
@@ -305,7 +317,7 @@ static int pxamci_data_done(struct pxamc
 
 	host->data = NULL;
 	if (host->mrq->stop) {
-		pxamci_stop_clock(host);
+		//pxamci_stop_clock(host);
 		pxamci_start_cmd(host, host->mrq->stop, host->cmdat);
 	} else {
 		pxamci_finish_request(host, host->mrq);
_

Patches currently in -mm which might be from rifx@o2.pl are

mmc-fix-clock-off-in-pxa255-270.patch

