From: akpm@linux-foundation.org
Subject: [merged] sdhci-support-for-adma-only-hosts.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:27 -0700
Message-ID: <200909231956.n8NJuROD004922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbZIWT45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@mocean-labs.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdhci: support for ADMA only hosts
has been removed from the -mm tree.  Its filename was
     sdhci-support-for-adma-only-hosts.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sdhci: support for ADMA only hosts
=46rom: Richard R=F6jfors <richard.rojfors@mocean-labs.com>

Add support for ADMA on SDHCI hosts, not supporting SDMA.

According to the SDHCI specifications a host can support ADMA but not S=
DMA

Signed-off-by: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |    2 -
 drivers/mmc/host/sdhci.c     |   38 +++++++++++++++------------------
 drivers/mmc/host/sdhci.h     |    4 +--
 3 files changed, 21 insertions(+), 23 deletions(-)

diff -puN drivers/mmc/host/sdhci-pci.c~sdhci-support-for-adma-only-host=
s drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~sdhci-support-for-adma-only-hosts
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -396,7 +396,7 @@ static int sdhci_pci_enable_dma(struct s
=20
 	if (((pdev->class & 0xFFFF00) =3D=3D (PCI_CLASS_SYSTEM_SDHCI << 8)) &=
&
 		((pdev->class & 0x0000FF) !=3D PCI_SDHCI_IFDMA) &&
-		(host->flags & SDHCI_USE_DMA)) {
+		(host->flags & SDHCI_USE_SDMA)) {
 		dev_warn(&pdev->dev, "Will use DMA mode even though HW "
 			"doesn't fully claim to support it.\n");
 	}
diff -puN drivers/mmc/host/sdhci.c~sdhci-support-for-adma-only-hosts dr=
ivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-support-for-adma-only-hosts
+++ a/drivers/mmc/host/sdhci.c
@@ -655,7 +655,7 @@ static void sdhci_prepare_data(struct sd
 	count =3D sdhci_calc_timeout(host, data);
 	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
=20
-	if (host->flags & SDHCI_USE_DMA)
+	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))
 		host->flags |=3D SDHCI_REQ_USE_DMA;
=20
 	/*
@@ -1600,7 +1600,7 @@ int sdhci_resume_host(struct sdhci_host=20
 {
 	int ret;
=20
-	if (host->flags & SDHCI_USE_DMA) {
+	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
 			host->ops->enable_dma(host);
 	}
@@ -1681,23 +1681,20 @@ int sdhci_add_host(struct sdhci_host *ho
 	caps =3D sdhci_readl(host, SDHCI_CAPABILITIES);
=20
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
-		host->flags |=3D SDHCI_USE_DMA;
-	else if (!(caps & SDHCI_CAN_DO_DMA))
-		DBG("Controller doesn't have DMA capability\n");
+		host->flags |=3D SDHCI_USE_SDMA;
+	else if (!(caps & SDHCI_CAN_DO_SDMA))
+		DBG("Controller doesn't have SDMA capability\n");
 	else
-		host->flags |=3D SDHCI_USE_DMA;
+		host->flags |=3D SDHCI_USE_SDMA;
=20
 	if ((host->quirks & SDHCI_QUIRK_BROKEN_DMA) &&
-		(host->flags & SDHCI_USE_DMA)) {
+		(host->flags & SDHCI_USE_SDMA)) {
 		DBG("Disabling DMA as it is marked broken\n");
-		host->flags &=3D ~SDHCI_USE_DMA;
+		host->flags &=3D ~SDHCI_USE_SDMA;
 	}
=20
-	if (host->flags & SDHCI_USE_DMA) {
-		if ((host->version >=3D SDHCI_SPEC_200) &&
-				(caps & SDHCI_CAN_DO_ADMA2))
-			host->flags |=3D SDHCI_USE_ADMA;
-	}
+	if ((host->version >=3D SDHCI_SPEC_200) && (caps & SDHCI_CAN_DO_ADMA2=
))
+		host->flags |=3D SDHCI_USE_ADMA;
=20
 	if ((host->quirks & SDHCI_QUIRK_BROKEN_ADMA) &&
 		(host->flags & SDHCI_USE_ADMA)) {
@@ -1705,13 +1702,14 @@ int sdhci_add_host(struct sdhci_host *ho
 		host->flags &=3D ~SDHCI_USE_ADMA;
 	}
=20
-	if (host->flags & SDHCI_USE_DMA) {
+	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma) {
 			if (host->ops->enable_dma(host)) {
 				printk(KERN_WARNING "%s: No suitable DMA "
 					"available. Falling back to PIO.\n",
 					mmc_hostname(mmc));
-				host->flags &=3D ~(SDHCI_USE_DMA | SDHCI_USE_ADMA);
+				host->flags &=3D
+					~(SDHCI_USE_SDMA | SDHCI_USE_ADMA);
 			}
 		}
 	}
@@ -1739,7 +1737,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	 * mask, but PIO does not need the hw shim so we set a new
 	 * mask here in that case.
 	 */
-	if (!(host->flags & SDHCI_USE_DMA)) {
+	if (!(host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))) {
 		host->dma_mask =3D DMA_BIT_MASK(64);
 		mmc_dev(host->mmc)->dma_mask =3D &host->dma_mask;
 	}
@@ -1816,7 +1814,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	 */
 	if (host->flags & SDHCI_USE_ADMA)
 		mmc->max_hw_segs =3D 128;
-	else if (host->flags & SDHCI_USE_DMA)
+	else if (host->flags & SDHCI_USE_SDMA)
 		mmc->max_hw_segs =3D 1;
 	else /* PIO */
 		mmc->max_hw_segs =3D 128;
@@ -1899,10 +1897,10 @@ int sdhci_add_host(struct sdhci_host *ho
=20
 	mmc_add_host(mmc);
=20
-	printk(KERN_INFO "%s: SDHCI controller on %s [%s] using %s%s\n",
+	printk(KERN_INFO "%s: SDHCI controller on %s [%s] using %s\n",
 		mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
-		(host->flags & SDHCI_USE_ADMA)?"A":"",
-		(host->flags & SDHCI_USE_DMA)?"DMA":"PIO");
+		(host->flags & SDHCI_USE_ADMA) ? "ADMA" :
+		(host->flags & SDHCI_USE_SDMA) ? "DMA" : "PIO");
=20
 	sdhci_enable_card_detection(host);
=20
diff -puN drivers/mmc/host/sdhci.h~sdhci-support-for-adma-only-hosts dr=
ivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-support-for-adma-only-hosts
+++ a/drivers/mmc/host/sdhci.h
@@ -143,7 +143,7 @@
 #define  SDHCI_CAN_DO_ADMA2	0x00080000
 #define  SDHCI_CAN_DO_ADMA1	0x00100000
 #define  SDHCI_CAN_DO_HISPD	0x00200000
-#define  SDHCI_CAN_DO_DMA	0x00400000
+#define  SDHCI_CAN_DO_SDMA	0x00400000
 #define  SDHCI_CAN_VDD_330	0x01000000
 #define  SDHCI_CAN_VDD_300	0x02000000
 #define  SDHCI_CAN_VDD_180	0x04000000
@@ -252,7 +252,7 @@ struct sdhci_host {
 	spinlock_t		lock;		/* Mutex */
=20
 	int			flags;		/* Host attributes */
-#define SDHCI_USE_DMA		(1<<0)		/* Host is DMA capable */
+#define SDHCI_USE_SDMA		(1<<0)		/* Host is SDMA capable */
 #define SDHCI_USE_ADMA		(1<<1)		/* Host is ADMA capable */
 #define SDHCI_REQ_USE_DMA	(1<<2)		/* Use DMA for this req. */
 #define SDHCI_DEVICE_DEAD	(1<<3)		/* Device unresponsive */
_

Patches currently in -mm which might be from richard.rojfors@mocean-lab=
s.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
