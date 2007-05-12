From: akpm@linux-foundation.org
Subject: - pata_scc-fix-compilation.patch removed from -mm tree
Date: Fri, 11 May 2007 22:14:23 -0700
Message-ID: <200705120514.l4C5ENFL001669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbXELFO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pata_scc: fix compilation
has been removed from the -mm tree.  Its filename was
     pata_scc-fix-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_scc: fix compilation
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_scc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_scc.c~pata_scc-fix-compilation drivers/ata/pata_scc.c
--- a/drivers/ata/pata_scc.c~pata_scc-fix-compilation
+++ a/drivers/ata/pata_scc.c
@@ -1142,14 +1142,14 @@ static int scc_init_one (struct pci_dev 
 	static int printed_version;
 	unsigned int board_idx = (unsigned int) ent->driver_data;
 	const struct ata_port_info *ppi[] = { &scc_port_info[board_idx], NULL };
-	struct device *dev = &pdev->dev;
+	struct ata_host *host;
 	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	host = ata_port_alloc_pinfo(&pdev->dev, ppi, 1);
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 1);
 	if (!host)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
git-parisc.patch
