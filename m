From: akpm@linux-foundation.org
Subject: + spi-fix-list-scan-success-verification-in-pxa-ssp-driver.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:13:14 -0700
Message-ID: <200806082013.m58KDEnO018512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755279AbYFHUNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:13:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, eric.miao@marvell.com, rmk@arm.linux.org.uk


The patch titled
     spi: fix list scan success verification in PXA ssp driver
has been added to the -mm tree.  Its filename is
     spi-fix-list-scan-success-verification-in-pxa-ssp-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: fix list scan success verification in PXA ssp driver
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

The list search success check in arch/arm/mach-pxa/ssp.c is wrong: for
example, it didn't recognise failure for me when I requested port 0.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Acked-by: Eric Miao <eric.miao@marvell.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/ssp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-pxa/ssp.c~spi-fix-list-scan-success-verification-in-pxa-ssp-driver arch/arm/mach-pxa/ssp.c
--- a/arch/arm/mach-pxa/ssp.c~spi-fix-list-scan-success-verification-in-pxa-ssp-driver
+++ a/arch/arm/mach-pxa/ssp.c
@@ -330,7 +330,7 @@ struct ssp_device *ssp_request(int port,
 
 	mutex_unlock(&ssp_lock);
 
-	if (ssp->port_id != port)
+	if (&ssp->node == &ssp_list)
 		return NULL;
 
 	return ssp;
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

spi-fix-list-scan-success-verification-in-pxa-ssp-driver.patch

