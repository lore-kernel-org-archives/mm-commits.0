From: akpm@linux-foundation.org
Subject: [merged] omap_hsmmc-fix-null-pointer-dereference.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:03 -0700
Message-ID: <200909231955.n8NJt3f6002051__43949.534072499$1253735793$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbZIWTzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     omap_hsmmc: fix NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-fix-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: fix NULL pointer dereference
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Do not call 'mmc_omap_xfer_done()' if the request is already done.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-fix-null-pointer-dereference drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-fix-null-pointer-dereference
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -677,7 +677,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 
 	if (end_cmd || ((status & CC) && host->cmd))
 		mmc_omap_cmd_done(host, host->cmd);
-	if (end_trans || (status & TC))
+	if ((end_trans || (status & TC)) && host->mrq)
 		mmc_omap_xfer_done(host, data);
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

origin.patch

