From: akpm@linux-foundation.org
Subject: - spi-fix-list-scan-success-verification-in-pxa-ssp-driver.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:48 -0700
Message-ID: <200806122037.m5CKbm8L005463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547AbYFLUiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@pengutronix.de, eric.miao@marvell.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     spi: fix list scan success verification in PXA ssp driver
has been removed from the -mm tree.  Its filename was
     spi-fix-list-scan-success-verification-in-pxa-ssp-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated.patch

