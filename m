From: akpm@linux-foundation.org
Subject: [merged] sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:41 -0700
Message-ID: <200909231955.n8NJtfkK003301__19211.7709237666$1253735856$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbZIWT5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     sdhci-of: avoid writing reserved bits into host control register
has been removed from the -mm tree.  Its filename was
     sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci-of: avoid writing reserved bits into host control register
From: Anton Vorontsov <avorontsov@ru.mvista.com>

SDHCI core tries to write HISPD bit into the host control register, but
the eSDHC controllers don't have that bit, and that causes all sorts of
misbehaviour when using 4-bit mode capable SD cards.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/mmc/host/sdhci-of.c~sdhci-of-avoid-writing-reserved-bits-into-host-control-register drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~sdhci-of-avoid-writing-reserved-bits-into-host-control-register
+++ a/drivers/mmc/host/sdhci-of.c
@@ -48,6 +48,8 @@ struct sdhci_of_host {
 #define ESDHC_CLOCK_HCKEN	0x00000002
 #define ESDHC_CLOCK_IPGEN	0x00000001
 
+#define ESDHC_HOST_CONTROL_RES	0x05
+
 static u32 esdhc_readl(struct sdhci_host *host, int reg)
 {
 	return in_be32(host->ioaddr + reg);
@@ -109,6 +111,10 @@ static void esdhc_writeb(struct sdhci_ho
 	int base = reg & ~0x3;
 	int shift = (reg & 0x3) * 8;
 
+	/* Prevent SDHCI core from writing reserved bits (e.g. HISPD). */
+	if (reg == SDHCI_HOST_CONTROL)
+		val &= ~ESDHC_HOST_CONTROL_RES;
+
 	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
 }
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

