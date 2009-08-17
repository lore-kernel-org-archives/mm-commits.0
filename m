From: akpm@linux-foundation.org
Subject: + sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:09:04 -0700
Message-ID: <200908172309.n7HN94Cp014704__32041.6555078284$1250550825$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbZHQXNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     sdhci-of: avoid writing reserved bits into host control register
has been added to the -mm tree.  Its filename is
     sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch

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

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch

