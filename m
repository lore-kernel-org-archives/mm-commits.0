From: akpm@linux-foundation.org
Subject: [merged] sdio-do-not-ignore-mmc_vdd_165_195.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:54:19 -0700
Message-ID: <200909231954.n8NJsJRh000435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbZIWTy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ohad@bencohen.org, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sdio: do not ignore MMC_VDD_165_195
has been removed from the -mm tree.  Its filename was
     sdio-do-not-ignore-mmc_vdd_165_195.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: do not ignore MMC_VDD_165_195
From: Ohad Ben-Cohen <ohad@bencohen.org>

This is needed for 1.8V embedded SDIO devices and supporting host controllers
(e.g. TI 127x and ZOOM2 boards)

Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/mmc/core/sdio.c~sdio-do-not-ignore-mmc_vdd_165_195 drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-do-not-ignore-mmc_vdd_165_195
+++ a/drivers/mmc/core/sdio.c
@@ -275,13 +275,6 @@ int mmc_attach_sdio(struct mmc_host *hos
 		ocr &= ~0x7F;
 	}
 
-	if (ocr & MMC_VDD_165_195) {
-		printk(KERN_WARNING "%s: SDIO card claims to support the "
-		       "incompletely defined 'low voltage range'. This "
-		       "will be ignored.\n", mmc_hostname(host));
-		ocr &= ~MMC_VDD_165_195;
-	}
