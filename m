From: akpm@linux-foundation.org
Subject: + pata_scc-fix-compilation.patch added to -mm tree
Date: Thu, 03 May 2007 18:05:56 -0700
Message-ID: <200705040105.l4415urO026346@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbXEDBGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com


The patch titled
     pata_scc: fix compilation
has been added to the -mm tree.  Its filename is
     pata_scc-fix-compilation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
pata_scc-fix-compilation.patch
git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
i386-schedh-inclusion-from-moduleh-is-baack.patch
