From: akpm@linux-foundation.org
Subject: [merged] adx_wdtc-use-resource_size.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:32 -0800
Message-ID: <200912292133.nBTLXWIc008713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbZL2Vdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, thierry.reding@avionic-design.de, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     adx_wdt.c: use resource_size()
has been removed from the -mm tree.  Its filename was
     adx_wdtc-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adx_wdt.c: use resource_size()
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/adx_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/adx_wdt.c~adx_wdtc-use-resource_size drivers/watchdog/adx_wdt.c
--- a/drivers/watchdog/adx_wdt.c~adx_wdtc-use-resource_size
+++ a/drivers/watchdog/adx_wdt.c
@@ -242,14 +242,14 @@ static int __devinit adx_wdt_probe(struc
 	}
 
 	res = devm_request_mem_region(&pdev->dev, res->start,
-			res->end - res->start + 1, res->name);
+			resource_size(res), res->name);
 	if (!res) {
 		dev_err(&pdev->dev, "cannot request I/O memory region\n");
 		return -ENXIO;
 	}
 
 	wdt->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			res->end - res->start + 1);
+			resource_size(res));
 	if (!wdt->base) {
 		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
 		return -ENXIO;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch

