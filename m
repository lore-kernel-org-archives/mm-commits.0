From: akpm@linux-foundation.org
Subject: [merged] mmci-omap-free-irq-resource.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:57 -0800
Message-ID: <200911131926.nADJQvUB029431__48879.0459618487$1258140449$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932208AbZKMT1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ladis@linux-mips.org, linux-mmc@vger.kernel.org, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmci-omap: free irq resource
has been removed from the -mm tree.  Its filename was
     mmci-omap-free-irq-resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
mmci-omap-remove-bogus-check-for-host-iclk.patch

