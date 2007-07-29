From: akpm@linux-foundation.org
Subject: - drivers-ide-pci-cs5535c-array-overrun.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:26 -0700
Message-ID: <200707290613.l6T6DQoH011199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307AbXG2GXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix an ovverun found in the 5535 IDE driver
has been removed from the -mm tree.  Its filename was
     drivers-ide-pci-cs5535c-array-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix an ovverun found in the 5535 IDE driver
From: Jordan Crouse <jordan.crouse@amd.com>

As found by the Coverity checker, and reported by Adrian Bunk, this fixes a
overrun error in the 5535 IDE driver.  Somebody got a little excited with
the if() statement - the 5535 only supports UDMA 0-4.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/cs5535.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/pci/cs5535.c~drivers-ide-pci-cs5535c-array-overrun drivers/ide/pci/cs5535.c
--- a/drivers/ide/pci/cs5535.c~drivers-ide-pci-cs5535c-array-overrun
+++ a/drivers/ide/pci/cs5535.c
@@ -120,7 +120,7 @@ static void cs5535_set_speed(ide_drive_t
 
 		reg &= 0x80000000UL;  /* Preserve the PIO format bit */
 
-		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_7)
+		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_4)
 			reg |= cs5535_udma_timings[speed - XFER_UDMA_0];
 		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
 			reg |= cs5535_mwdma_timings[speed - XFER_MW_DMA_0];
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
