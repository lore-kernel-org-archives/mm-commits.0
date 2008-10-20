From: akpm@linux-foundation.org
Subject: - drivers-scsi-sun3x_espc-convert-to.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:38:22 -0700
Message-ID: <200810202038.m9KKcM4U011870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYJTUj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, sammy@sammy.net, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/sun3x_esp.c: Convert && to ||
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sun3x_espc-convert-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/sun3x_esp.c: Convert && to ||
From: Julia Lawall <julia@diku.dk>

The pattern !E && !E->fld is nonsensical.  The patch below updates this
according to the assumption that && should be ||.  But perhaps another
solution was intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@disable and_comm@
expression E;
identifier fld;
@@

- !E && !E->fld
+ !E || !E->fld
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-By: Sam Creasey <sammy@sammy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sun3x_esp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sun3x_esp.c~drivers-scsi-sun3x_espc-convert-to drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c~drivers-scsi-sun3x_espc-convert-to
+++ a/drivers/scsi/sun3x_esp.c
@@ -213,7 +213,7 @@ static int __devinit esp_sun3x_probe(str
 	esp->ops = &sun3x_esp_ops;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res && !res->start)
+	if (!res || !res->start)
 		goto fail_unlink;
 
 	esp->regs = ioremap_nocache(res->start, 0x20);
@@ -221,7 +221,7 @@ static int __devinit esp_sun3x_probe(str
 		goto fail_unmap_regs;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res && !res->start)
+	if (!res || !res->start)
 		goto fail_unmap_regs;
 
 	esp->dma_regs = ioremap_nocache(res->start, 0x10);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch

