From: akpm@linux-foundation.org
Subject: + sdio-do-not-ignore-mmc_vdd_165_195.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:29:54 -0700
Message-ID: <200907242229.n6OMTsgC023790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbZGXWaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ohad@bencohen.org, ian@mnementh.co.uk, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     sdio: do not ignore MMC_VDD_165_195
has been added to the -mm tree.  Its filename is
     sdio-do-not-ignore-mmc_vdd_165_195.patch

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
