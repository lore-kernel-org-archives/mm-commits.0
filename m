From: akpm@linux-foundation.org
Subject: + mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:43:10 -0700
Message-ID: <200910062143.n96LhAn7020840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933339AbZJFVoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.vrabel@csr.com, jic23@cam.ac.uk, linux-mmc@vger.kernel.org, roel.kluin@gmail.com


The patch titled
     mmc: sdio: don't require CISTPL_VERS_1 to contain 4 strings
has been added to the -mm tree.  Its filename is
     mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch

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
Subject: mmc: sdio: don't require CISTPL_VERS_1 to contain 4 strings
From: David Vrabel <david.vrabel@csr.com>

The PC Card 8.0 specification (vol.  4, section 3.2.10) says the
TPLLV1_INFO field of the CISTPL_VERS_1 tuple must contain 4 strings.  Some
cards don't have all 4 so just parse as many as we can.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
Tested-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_cis.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 
@@ -39,9 +41,7 @@ static int cistpl_vers_1(struct mmc_card
 		if (buf[i] == 0)
 			nr_strings++;
 	}
