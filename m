From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch added to -mm tree
Date: Tue, 02 Mar 2010 13:35:11 -0800
Message-ID: <201003022135.o22LZCcf030844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab0CBVfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 16:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, avictor.za@gmail.com, linux-mmc@vger.kernel.org, wolfgang.mues@auerswald.de


The patch titled
     mmc: at91_mci: introduce per-mci-revision conditional code
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch

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
Subject: mmc: at91_mci: introduce per-mci-revision conditional code
From: Nicolas Ferre <nicolas.ferre@atmel.com>

We used to manage features and differences on a per-cpu basis.  As several
cpus share the same mci revision, this patch aggregates cpus that have the
same IP revision in one defined constant.  We use the
at91mci_is_mci1rev2xx() funtion name not to mess with newer Atmel sd/mmc
IP called "MCI2".  _rev2 naming could have been confusing...

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Wolfgang Muees <wolfgang.mues@auerswald.de>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-introduce-per-mci-revision-conditional-code drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-introduce-per-mci-revision-conditional-code
+++ a/drivers/mmc/host/at91_mci.c
@@ -78,6 +78,17 @@
 
 #define DRIVER_NAME "at91_mci"
 
+static inline int at91mci_is_mci1rev2xx(void)
+{
+	return (   cpu_is_at91sam9260()
+		|| cpu_is_at91sam9263()
+		|| cpu_is_at91cap9()
+		|| cpu_is_at91sam9rl()
+		|| cpu_is_at91sam9g10()
+		|| cpu_is_at91sam9g20()
+		);
+}
+
 #define FL_SENT_COMMAND	(1 << 0)
 #define FL_SENT_STOP	(1 << 1)
 
@@ -204,8 +215,8 @@ static inline void at91_mci_sg_to_dma(st
 	size = data->blksz * data->blocks;
 	len = data->sg_len;
 
-	/* AT91SAM926[0/3] Data Write Operation and number of bytes erratum */
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+	/* MCI1 rev2xx Data Write Operation and number of bytes erratum */
+	if (at91mci_is_mci1rev2xx())
 		if (host->total_length == 12)
 			memset(dmabuf, 0, 12);
 
@@ -398,7 +409,7 @@ static void at91_mci_enable(struct at91m
 	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
 	mr = AT91_MCI_PDCMODE | 0x34a;
 
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+	if (at91mci_is_mci1rev2xx())
 		mr |= AT91_MCI_RDPROOF | AT91_MCI_WRPROOF;
 
 	at91_mci_write(host, AT91_MCI_MR, mr);
@@ -555,10 +566,10 @@ static void at91_mci_send_command(struct
 				 */
 				host->total_length = block_length * blocks;
 				/*
-				 * AT91SAM926[0/3] Data Write Operation and
+				 * MCI1 rev2xx Data Write Operation and
 				 * number of bytes erratum
 				 */
-				if (cpu_is_at91sam9260 () || cpu_is_at91sam9263())
+				if (at91mci_is_mci1rev2xx())
 					if (host->total_length < 12)
 						host->total_length = 12;
 
@@ -943,7 +954,7 @@ static int __init at91_mci_probe(struct 
 	host->bus_mode = 0;
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
-		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+		if (at91mci_is_mci1rev2xx())
 			mmc->caps |= MMC_CAP_4_BIT_DATA;
 		else
 			dev_warn(&pdev->dev, "4 wire bus mode not supported"
@@ -959,8 +970,8 @@ static int __init at91_mci_probe(struct 
 	}
 
 	/* Add SDIO capability when available */
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263()) {
-		/* AT91SAM9260/9263 erratum */
+	if (at91mci_is_mci1rev2xx()) {
+		/* at91mci MCI1 rev2xx sdio interrupt erratum */
 		if (host->board->wire4 || !host->board->slot_b)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch
mmc-at91_mci-fix-pointer-errors.patch
mmc-at91_mci-fix-timeout-errors.patch
mmc-at91_mci-use-one-coherent-dma-buffer.patch
mmc-at91_mci-use-dma-buffer-for-read.patch
mmc-at91_mci-enable-large-data-blocks.patch
mmc-at91_mci-enable-mmc_cap_sdio_irq-only-when-it-actually-works.patch
mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch

