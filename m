From: akpm@linux-foundation.org
Subject: + dmaengine-correct-invalid-assumptions-in-the-kconfig-text.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:11:28 -0800
Message-ID: <200711270711.lAR7BSLl032532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbXK0HLn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:11:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, dan.j.williams@intel.com, dbrownell@users.sourceforge.net


The patch titled
     dmaengine: correct invalid assumptions in the Kconfig text
has been added to the -mm tree.  Its filename is
     dmaengine-correct-invalid-assumptions-in-the-kconfig-text.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dmaengine: correct invalid assumptions in the Kconfig text
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

This patch corrects recently changed (and now invalid) Kconfig descriptions
for the DMA engine framework:

 - Non-Intel(R) hardware also has DMA engines;
 - DMA is used for more than memcpy and RAID offloading.

In fact, on most platforms memcpy and RAID aren't factors, and DMA
exists so that peripherals can transfer data to/from memory while
the CPU does other work.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/dma/Kconfig~dmaengine-correct-invalid-assumptions-in-the-kconfig-text drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~dmaengine-correct-invalid-assumptions-in-the-kconfig-text
+++ a/drivers/dma/Kconfig
@@ -3,11 +3,13 @@
 #
 
 menuconfig DMADEVICES
-	bool "DMA Offload Engine support"
+	bool "DMA Engine support"
 	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
 	help
-	  Intel(R) offload engines enable offloading memory copies in the
-	  network stack and RAID operations in the MD driver.
+	  DMA engines can do asynchronous data transfers without
+	  involving the host CPU.  Currently, this framework can be
+	  used to offload memory copies in the network stack and
+	  RAID operations in the MD driver.
 
 if DMADEVICES
 
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

atmel_spi-labels-gpios-better.patch
atmel_lcdfb-lcdc-startup-fix.patch
dmaengine-correct-invalid-assumptions-in-the-kconfig-text.patch
git-avr32.patch
git-mtd.patch
mmc-add-missing-sg_init_table-call.patch
read_current_time-cleanups.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
