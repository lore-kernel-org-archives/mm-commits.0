From: akpm@linux-foundation.org
Subject: + mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:25:11 -0700
Message-ID: <201004281825.o3SIPBRm011939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016Ab0D1SZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: atmel-mci: remove data error interrupt after xfer
has been added to the -mm tree.  Its filename is
     mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch

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
Subject: mmc: atmel-mci: remove data error interrupt after xfer
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Disable data error interrupts while we are actually recording that there
is not such errors.  This will prevent, in some cases, the warning message
printed at new request queuing (in atmci_start_request()).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-remove-data-error-interrupt-after-xfer drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-remove-data-error-interrupt-after-xfer
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1308,6 +1308,7 @@ static void atmci_tasklet_func(unsigned 
 			} else {
 				data->bytes_xfered = data->blocks * data->blksz;
 				data->error = 0;
+				mci_writel(host, IDR, ATMCI_DATA_ERROR_FLAGS);
 			}
 
 			if (!data->stop) {
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-fix-two-parameters-swapped.patch
mmc-atmel-mci-prevent-kernel-oops-while-removing-card.patch
mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

