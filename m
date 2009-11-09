From: akpm@linux-foundation.org
Subject: + mmci-omap-remove-bogus-check-for-host-iclk.patch added to -mm tree
Date: Mon, 09 Nov 2009 14:33:19 -0800
Message-ID: <200911092233.nA9MXJRM007469__21709.2954939746$1257806020$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbZKIWdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 17:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ladis@linux-mips.org, linux-mmc@vger.kernel.org, tony@atomide.com


The patch titled
     mmci-omap: remove bogus check for host->iclk
has been added to the -mm tree.  Its filename is
     mmci-omap-remove-bogus-check-for-host-iclk.patch

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
Subject: mmci-omap: remove bogus check for host->iclk
From: Ladislav Michl <ladis@linux-mips.org>

Remove check for host->iclk being NULL from error path since we already
know it is non-null and use return value from clk_get.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mmc/host/omap.c~mmci-omap-remove-bogus-check-for-host-iclk drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmci-omap-remove-bogus-check-for-host-iclk
+++ a/drivers/mmc/host/omap.c
@@ -1459,8 +1459,10 @@ static int __init mmc_omap_probe(struct 
 		goto err_ioremap;
 
 	host->iclk = clk_get(&pdev->dev, "ick");
-	if (IS_ERR(host->iclk))
+	if (IS_ERR(host->iclk)) {
+		ret = PTR_ERR(host->iclk);
 		goto err_free_mmc_host;
+	}
 	clk_enable(host->iclk);
 
 	host->fclk = clk_get(&pdev->dev, "fck");
@@ -1500,10 +1502,8 @@ err_free_irq:
 err_free_fclk:
 	clk_put(host->fclk);
 err_free_iclk:
-	if (host->iclk != NULL) {
-		clk_disable(host->iclk);
-		clk_put(host->iclk);
-	}
+	clk_disable(host->iclk);
+	clk_put(host->iclk);
 err_free_mmc_host:
 	iounmap(host->virt_base);
 err_ioremap:
_

Patches currently in -mm which might be from ladis@linux-mips.org are

mmci-omap-free-irq-resource.patch
linux-next.patch
mmci-omap-remove-bogus-check-for-host-iclk.patch

