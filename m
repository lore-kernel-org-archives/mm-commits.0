From: akpm@linux-foundation.org
Subject: + drivers-ata-use-resource_size.patch added to -mm tree
Date: Mon, 20 Jul 2009 13:42:25 -0700
Message-ID: <200907202042.n6KKgPwN009681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbZGTUn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 16:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jeff@garzik.org


The patch titled
     drivers/ata: use resource_size
has been added to the -mm tree.  Its filename is
     drivers-ata-use-resource_size.patch

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
Subject: drivers/ata: use resource_size
From: Julia Lawall <julia@diku.dk>

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_octeon_cf.c |    2 +-
 drivers/ata/pata_platform.c  |    8 ++++----
 drivers/ata/pata_rb532_cf.c  |    2 +-
 drivers/ata/sata_mv.c        |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/ata/pata_octeon_cf.c~drivers-ata-use-resource_size drivers/ata/pata_octeon_cf.c
--- a/drivers/ata/pata_octeon_cf.c~drivers-ata-use-resource_size
+++ a/drivers/ata/pata_octeon_cf.c
@@ -840,7 +840,7 @@ static int __devinit octeon_cf_probe(str
 	ocd = pdev->dev.platform_data;
 
 	cs0 = devm_ioremap_nocache(&pdev->dev, res_cs0->start,
-				   res_cs0->end - res_cs0->start + 1);
+				   resource_size(res_cs0));
 
 	if (!cs0)
 		return -ENOMEM;
diff -puN drivers/ata/pata_platform.c~drivers-ata-use-resource_size drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c~drivers-ata-use-resource_size
+++ a/drivers/ata/pata_platform.c
@@ -151,14 +151,14 @@ int __devinit __pata_platform_probe(stru
 	 */
 	if (mmio) {
 		ap->ioaddr.cmd_addr = devm_ioremap(dev, io_res->start,
-				io_res->end - io_res->start + 1);
+				resource_size(io_res));
 		ap->ioaddr.ctl_addr = devm_ioremap(dev, ctl_res->start,
-				ctl_res->end - ctl_res->start + 1);
+				resource_size(ctl_res));
 	} else {
 		ap->ioaddr.cmd_addr = devm_ioport_map(dev, io_res->start,
-				io_res->end - io_res->start + 1);
+				resource_size(io_res));
 		ap->ioaddr.ctl_addr = devm_ioport_map(dev, ctl_res->start,
-				ctl_res->end - ctl_res->start + 1);
+				resource_size(ctl_res));
 	}
 	if (!ap->ioaddr.cmd_addr || !ap->ioaddr.ctl_addr) {
 		dev_err(dev, "failed to map IO/CTL base\n");
diff -puN drivers/ata/pata_rb532_cf.c~drivers-ata-use-resource_size drivers/ata/pata_rb532_cf.c
--- a/drivers/ata/pata_rb532_cf.c~drivers-ata-use-resource_size
+++ a/drivers/ata/pata_rb532_cf.c
@@ -151,7 +151,7 @@ static __devinit int rb532_pata_driver_p
 	info->irq = irq;
 
 	info->iobase = devm_ioremap_nocache(&pdev->dev, res->start,
-				res->end - res->start + 1);
+				resource_size(res));
 	if (!info->iobase)
 		return -ENOMEM;
 
diff -puN drivers/ata/sata_mv.c~drivers-ata-use-resource_size drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~drivers-ata-use-resource_size
+++ a/drivers/ata/sata_mv.c
@@ -4013,7 +4013,7 @@ static int mv_platform_probe(struct plat
 
 	host->iomap = NULL;
 	hpriv->base = devm_ioremap(&pdev->dev, res->start,
-				   res->end - res->start + 1);
+				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
 	/*
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-ata-use-resource_size.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
edac-fix-resource-size-calculation.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

