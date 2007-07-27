From: akpm@linux-foundation.org
Subject: + drivers-ide-pci-cs5535c-array-overrun.patch added to -mm tree
Date: Thu, 26 Jul 2007 18:36:40 -0700
Message-ID: <200707270136.l6R1aeeJ032145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760948AbXG0Bgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 21:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jordan.crouse@amd.com, bzolnier@gmail.com


The patch titled
     Fix an ovverun found in the 5535 IDE driver
has been added to the -mm tree.  Its filename is
     drivers-ide-pci-cs5535c-array-overrun.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
drivers-ide-pci-cs5535c-array-overrun.patch
lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx.patch
