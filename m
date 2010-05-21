From: akpm@linux-foundation.org
Subject: + sh-disable-sd-card-write-protection-detection-on-kfr2r09.patch added to -mm tree
Date: Fri, 21 May 2010 12:39:15 -0700
Message-ID: <201005211939.o4LJdFGG030302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934015Ab0EUTjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, magnus.damm@gmail.com, sameo@linux.intel.com


The patch titled
     sh: disable SD-card write-protection detection on kfr2r09
has been added to the -mm tree.  Its filename is
     sh-disable-sd-card-write-protection-detection-on-kfr2r09.patch

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
Subject: sh: disable SD-card write-protection detection on kfr2r09
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

kfr2r09 board has a micro-SD card slot, therefore card write-protection
detection cannot work there, disable it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/mach-kfr2r09/setup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/sh/boards/mach-kfr2r09/setup.c~sh-disable-sd-card-write-protection-detection-on-kfr2r09 arch/sh/boards/mach-kfr2r09/setup.c
--- a/arch/sh/boards/mach-kfr2r09/setup.c~sh-disable-sd-card-write-protection-detection-on-kfr2r09
+++ a/arch/sh/boards/mach-kfr2r09/setup.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/sh_mobile_sdhi.h>
+#include <linux/mfd/tmio.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/onenand.h>
 #include <linux/delay.h>
@@ -358,8 +359,9 @@ static struct resource kfr2r09_sh_sdhi0_
 };
 
 static struct sh_mobile_sdhi_info sh7724_sdhi0_data = {
-	.dma_slave_tx = SHDMA_SLAVE_SDHI0_TX,
-	.dma_slave_rx = SHDMA_SLAVE_SDHI0_RX,
+	.dma_slave_tx	= SHDMA_SLAVE_SDHI0_TX,
+	.dma_slave_rx	= SHDMA_SLAVE_SDHI0_RX,
+	.tmio_flags	= TMIO_MMC_WRPROTECT_DISABLE,
 };
 
 static struct platform_device kfr2r09_sh_sdhi0_device = {
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

origin.patch
linux-next.patch
media-ak881x-needs-slabh.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch
tmio-add-a-platform-flag-to-disable-card-write-protection-detection.patch
mfd-pass-platform-flags-down-to-the-tmio_mmc-driver.patch
sh-disable-sd-card-write-protection-detection-on-kfr2r09.patch
mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc.patch
sh-allow-platforms-to-specify-sd-card-supported-voltages.patch

