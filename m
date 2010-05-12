From: akpm@linux-foundation.org
Subject: + sh-add-sdhi-dma-support-to-ms7724se.patch added to -mm tree
Date: Wed, 12 May 2010 15:55:53 -0700
Message-ID: <201005122255.o4CMtrr2025663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab0ELXCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com


The patch titled
     sh: add SDHI DMA support to ms7724se
has been added to the -mm tree.  Its filename is
     sh-add-sdhi-dma-support-to-ms7724se.patch

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
Subject: sh: add SDHI DMA support to ms7724se
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/mach-se/7724/setup.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN arch/sh/boards/mach-se/7724/setup.c~sh-add-sdhi-dma-support-to-ms7724se arch/sh/boards/mach-se/7724/setup.c
--- a/arch/sh/boards/mach-se/7724/setup.c~sh-add-sdhi-dma-support-to-ms7724se
+++ a/arch/sh/boards/mach-se/7724/setup.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/sh_mobile_sdhi.h>
 #include <linux/mtd/physmap.h>
 #include <linux/delay.h>
 #include <linux/smc91x.h>
@@ -464,11 +465,19 @@ static struct resource sdhi0_cn7_resourc
 	},
 };
 
+static struct sh_mobile_sdhi_info sh7724_sdhi0_data = {
+	.dma_slave_tx	= SHDMA_SLAVE_SDHI0_TX,
+	.dma_slave_rx	= SHDMA_SLAVE_SDHI0_RX,
+};
+
 static struct platform_device sdhi0_cn7_device = {
 	.name           = "sh_mobile_sdhi",
 	.id		= 0,
 	.num_resources  = ARRAY_SIZE(sdhi0_cn7_resources),
 	.resource       = sdhi0_cn7_resources,
+	.dev = {
+		.platform_data	= &sh7724_sdhi0_data,
+	},
 	.archdata = {
 		.hwblk_id = HWBLK_SDHI0,
 	},
@@ -487,11 +496,19 @@ static struct resource sdhi1_cn8_resourc
 	},
 };
 
+static struct sh_mobile_sdhi_info sh7724_sdhi1_data = {
+	.dma_slave_tx	= SHDMA_SLAVE_SDHI1_TX,
+	.dma_slave_rx	= SHDMA_SLAVE_SDHI1_RX,
+};
+
 static struct platform_device sdhi1_cn8_device = {
 	.name           = "sh_mobile_sdhi",
 	.id		= 1,
 	.num_resources  = ARRAY_SIZE(sdhi1_cn8_resources),
 	.resource       = sdhi1_cn8_resources,
+	.dev = {
+		.platform_data	= &sh7724_sdhi1_data,
+	},
 	.archdata = {
 		.hwblk_id = HWBLK_SDHI1,
 	},
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch

