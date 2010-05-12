From: akpm@linux-foundation.org
Subject: [merged] mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:17 -0400
Message-ID: <201005121759.o4CHxjef011529__24838.7510343038$1273687219$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab0ELSAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: atmel-mci: remove data error interrupt after xfer
has been removed from the -mm tree.  Its filename was
     mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: atmel-mci: remove data error interrupt after xfer
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Disable data error interrupts while we are actually recording that there
is not such errors.  This will prevent, in some cases, the warning message
printed at new request queuing (in atmci_start_request()).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-remove-data-error-interrupt-after-xfer drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-remove-data-error-interrupt-after-xfer
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1294,6 +1294,7 @@ static void atmci_tasklet_func(unsigned 
 			} else {
 				data->bytes_xfered = data->blocks * data->blksz;
 				data->error = 0;
+				mci_writel(host, IDR, ATMCI_DATA_ERROR_FLAGS);
 			}
 
 			if (!data->stop) {
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

