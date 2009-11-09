From: akpm@linux-foundation.org
Subject: + mmci-omap-free-irq-resource.patch added to -mm tree
Date: Mon, 09 Nov 2009 14:28:10 -0800
Message-ID: <200911092228.nA9MSA1m027766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbZKIW2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 17:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ladis@linux-mips.org, linux-mmc@vger.kernel.org, tony@atomide.com


The patch titled
     mmci-omap: free irq resource
has been added to the -mm tree.  Its filename is
     mmci-omap-free-irq-resource.patch

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
Subject: mmci-omap: free irq resource
From: Ladislav Michl <ladis@linux-mips.org>

Free IRQ on remove.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mmc/host/omap.c~mmci-omap-free-irq-resource drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmci-omap-free-irq-resource
+++ a/drivers/mmc/host/omap.c
@@ -1529,6 +1529,7 @@ static int mmc_omap_remove(struct platfo
 		host->pdata->cleanup(&pdev->dev);
 
 	mmc_omap_fclk_enable(host, 0);
+	free_irq(host->irq, host);
 	clk_put(host->fclk);
 	clk_disable(host->iclk);
 	clk_put(host->iclk);
_

Patches currently in -mm which might be from ladis@linux-mips.org are

mmci-omap-free-irq-resource.patch
linux-next.patch

