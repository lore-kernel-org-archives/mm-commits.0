From: akpm@linux-foundation.org
Subject: [merged] mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:18 -0700
Message-ID: <200910092205.n99M5Ivx021129__29989.1848968857$1255126336$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934674AbZJIWGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.vrabel@csr.com, bzhao@marvell.com, jic23@cam.ac.uk, linux-mmc@vger.kernel.org, roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mmc: sdio: don't require CISTPL_VERS_1 to contain 4 strings
has been removed from the -mm tree.  Its filename was
     mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: sdio: don't require CISTPL_VERS_1 to contain 4 strings
From: David Vrabel <david.vrabel@csr.com>

The PC Card 8.0 specification (vol.  4, section 3.2.10) says the
TPLLV1_INFO field of the CISTPL_VERS_1 tuple must contain 4 strings.  Some
cards don't have all 4 so just parse as many as we can.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Vrabel <david.vrabel@csr.com>
Tested-by: Jonathan Cameron <jic23@cam.ac.uk>
Tested-by: Bing Zhao <bzhao@marvell.com>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mmc/core/sdio_cis.c~mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings drivers/mmc/core/sdio_cis.c
--- a/drivers/mmc/core/sdio_cis.c~mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings
+++ a/drivers/mmc/core/sdio_cis.c
@@ -29,6 +29,8 @@ static int cistpl_vers_1(struct mmc_card
 	unsigned i, nr_strings;
 	char **buffer, *string;
 
+	/* Find all null-terminated (including zero length) strings in
+	   the TPLLV1_INFO field. Trailing garbage is ignored. */
 	buf += 2;
 	size -= 2;
 
@@ -39,11 +41,8 @@ static int cistpl_vers_1(struct mmc_card
 		if (buf[i] == 0)
 			nr_strings++;
 	}
