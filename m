From: akpm@linux-foundation.org
Subject: - spi-controller-driver-for-omap-microwire-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:22:23 -0800
Message-ID: <200702120722.l1C7MNPY024695@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbXBLHWZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:22:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi-controller-driver-for-omap-microwire-tidy
has been removed from the -mm tree.  Its filename was
     spi-controller-driver-for-omap-microwire-tidy.patch

This patch was dropped because it was folded into spi-controller-driver-for-omap-microwire.patch

------------------------------------------------------
Subject: spi-controller-driver-for-omap-microwire-tidy
From: Andrew Morton <akpm@osdl.org>

EDOM??

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap_uwire.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/omap_uwire.c~spi-controller-driver-for-omap-microwire-tidy drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-controller-driver-for-omap-microwire-tidy
+++ a/drivers/spi/omap_uwire.c
@@ -403,8 +403,8 @@ static int uwire_setup_transfer(struct s
 	if (div1_idx == 4) {
 		pr_debug("%s: lowest clock %ld, need %d\n",
 			spi->dev.bus_id, rate / 10 / 8, hz);
-			status = -EDOM;
-			goto done;
+		status = -EDOM;
+		goto done;
 	}
 
 	/* we have to cache this and reset in uwire_chipselect as this is a
@@ -480,7 +480,7 @@ static int uwire_probe(struct platform_d
 
 	master = spi_alloc_master(&pdev->dev, sizeof *uwire);
 	if (!master)
-		return -ENODEV;
+		return -ENOMEM;
 
 	uwire = spi_master_get_devdata(master);
 	dev_set_drvdata(&pdev->dev, uwire);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
