From: akpm@linux-foundation.org
Subject: + sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch added to -mm tree
Date: Wed, 12 May 2010 15:55:38 -0700
Message-ID: <201005122255.o4CMtcYO025640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab0ELW4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 18:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com


The patch titled
     sh: define DMA slaves per CPU type, remove now redundant header
has been added to the -mm tree.  Its filename is
     sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch

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
Subject: sh: define DMA slaves per CPU type, remove now redundant header
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Now that DMA slave IDs are only used used in platform specific code and
have become opaque cookies for the rest of the code, we can make the, CPU
specific too.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/dmaengine.h        |   34 -----------------------
 arch/sh/include/asm/siu.h              |    2 -
 arch/sh/include/cpu-sh4/cpu/sh7722.h   |   15 ++++++++++
 arch/sh/include/cpu-sh4/cpu/sh7724.h   |   19 ++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |    2 -
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c |    3 --
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    2 -
 sound/soc/sh/siu.h                     |    3 --
 sound/soc/sh/siu_pcm.c                 |    9 ++----
 10 files changed, 42 insertions(+), 48 deletions(-)

diff -puN arch/sh/include/asm/dmaengine.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header /dev/null
--- a/arch/sh/include/asm/dmaengine.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Header for the new SH dmaengine driver
- *
- * Copyright (C) 2010 Guennadi Liakhovetski <g.liakhovetski@gmx.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef ASM_DMAENGINE_H
-#define ASM_DMAENGINE_H
-
-#include <linux/sh_dma.h>
-
-enum {
-	SHDMA_SLAVE_SCIF0_TX,
-	SHDMA_SLAVE_SCIF0_RX,
-	SHDMA_SLAVE_SCIF1_TX,
-	SHDMA_SLAVE_SCIF1_RX,
-	SHDMA_SLAVE_SCIF2_TX,
-	SHDMA_SLAVE_SCIF2_RX,
-	SHDMA_SLAVE_SCIF3_TX,
-	SHDMA_SLAVE_SCIF3_RX,
-	SHDMA_SLAVE_SCIF4_TX,
-	SHDMA_SLAVE_SCIF4_RX,
-	SHDMA_SLAVE_SCIF5_TX,
-	SHDMA_SLAVE_SCIF5_RX,
-	SHDMA_SLAVE_SIUA_TX,
-	SHDMA_SLAVE_SIUA_RX,
-	SHDMA_SLAVE_SIUB_TX,
-	SHDMA_SLAVE_SIUB_RX,
-};
-
-#endif
diff -puN arch/sh/include/asm/siu.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/include/asm/siu.h
--- a/arch/sh/include/asm/siu.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/include/asm/siu.h
@@ -11,8 +11,6 @@
 #ifndef ASM_SIU_H
 #define ASM_SIU_H
 
-#include <asm/dmaengine.h>
-
 struct device;
 
 struct siu_platform {
diff -puN arch/sh/include/cpu-sh4/cpu/sh7722.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/include/cpu-sh4/cpu/sh7722.h
--- a/arch/sh/include/cpu-sh4/cpu/sh7722.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/include/cpu-sh4/cpu/sh7722.h
@@ -235,4 +235,19 @@ enum {
 	HWBLK_NR,
 };
 
+enum {
+	SHDMA_SLAVE_SCIF0_TX,
+	SHDMA_SLAVE_SCIF0_RX,
+	SHDMA_SLAVE_SCIF1_TX,
+	SHDMA_SLAVE_SCIF1_RX,
+	SHDMA_SLAVE_SCIF2_TX,
+	SHDMA_SLAVE_SCIF2_RX,
+	SHDMA_SLAVE_SIUA_TX,
+	SHDMA_SLAVE_SIUA_RX,
+	SHDMA_SLAVE_SIUB_TX,
+	SHDMA_SLAVE_SIUB_RX,
+	SHDMA_SLAVE_SDHI0_TX,
+	SHDMA_SLAVE_SDHI0_RX,
+};
+
 #endif /* __ASM_SH7722_H__ */
diff -puN arch/sh/include/cpu-sh4/cpu/sh7724.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/include/cpu-sh4/cpu/sh7724.h
--- a/arch/sh/include/cpu-sh4/cpu/sh7724.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/include/cpu-sh4/cpu/sh7724.h
@@ -283,4 +283,23 @@ enum {
 	HWBLK_NR,
 };
 
+enum {
+	SHDMA_SLAVE_SCIF0_TX,
+	SHDMA_SLAVE_SCIF0_RX,
+	SHDMA_SLAVE_SCIF1_TX,
+	SHDMA_SLAVE_SCIF1_RX,
+	SHDMA_SLAVE_SCIF2_TX,
+	SHDMA_SLAVE_SCIF2_RX,
+	SHDMA_SLAVE_SCIF3_TX,
+	SHDMA_SLAVE_SCIF3_RX,
+	SHDMA_SLAVE_SCIF4_TX,
+	SHDMA_SLAVE_SCIF4_RX,
+	SHDMA_SLAVE_SCIF5_TX,
+	SHDMA_SLAVE_SCIF5_RX,
+	SHDMA_SLAVE_SDHI0_TX,
+	SHDMA_SLAVE_SDHI0_RX,
+	SHDMA_SLAVE_SDHI1_TX,
+	SHDMA_SLAVE_SDHI1_RX,
+};
+
 #endif /* __ASM_SH7724_H__ */
diff -puN arch/sh/kernel/cpu/sh4a/setup-sh7722.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/kernel/cpu/sh4a/setup-sh7722.c
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -17,7 +17,6 @@
 #include <linux/usb/m66592.h>
 
 #include <asm/clock.h>
-#include <asm/dmaengine.h>
 #include <asm/mmzone.h>
 #include <asm/siu.h>
 
diff -puN arch/sh/kernel/cpu/sh4a/setup-sh7724.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/kernel/cpu/sh4a/setup-sh7724.c
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -18,13 +18,13 @@
 #include <linux/mm.h>
 #include <linux/serial_sci.h>
 #include <linux/uio_driver.h>
+#include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 #include <linux/io.h>
 #include <linux/notifier.h>
 
 #include <asm/suspend.h>
 #include <asm/clock.h>
-#include <asm/dmaengine.h>
 #include <asm/mmzone.h>
 
 #include <cpu/dma-register.h>
diff -puN arch/sh/kernel/cpu/sh4a/setup-sh7780.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/kernel/cpu/sh4a/setup-sh7780.c
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7780.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7780.c
@@ -12,10 +12,9 @@
 #include <linux/serial.h>
 #include <linux/io.h>
 #include <linux/serial_sci.h>
+#include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 
-#include <asm/dmaengine.h>
-
 #include <cpu/dma-register.h>
 
 static struct plat_sci_port scif0_platform_data = {
diff -puN arch/sh/kernel/cpu/sh4a/setup-sh7785.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header arch/sh/kernel/cpu/sh4a/setup-sh7785.c
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -13,9 +13,9 @@
 #include <linux/serial_sci.h>
 #include <linux/io.h>
 #include <linux/mm.h>
+#include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 
-#include <asm/dmaengine.h>
 #include <asm/mmzone.h>
 
 #include <cpu/dma-register.h>
diff -puN sound/soc/sh/siu.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header sound/soc/sh/siu.h
--- a/sound/soc/sh/siu.h~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/sound/soc/sh/siu.h
@@ -71,8 +71,7 @@ struct siu_firmware {
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-
-#include <asm/dmaengine.h>
+#include <linux/sh_dma.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
diff -puN sound/soc/sh/siu_pcm.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header sound/soc/sh/siu_pcm.c
--- a/sound/soc/sh/siu_pcm.c~sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header
+++ a/sound/soc/sh/siu_pcm.c
@@ -31,7 +31,6 @@
 #include <sound/pcm_params.h>
 #include <sound/soc-dai.h>
 
-#include <asm/dmaengine.h>
 #include <asm/siu.h>
 
 #include "siu.h"
@@ -358,13 +357,13 @@ static int siu_pcm_open(struct snd_pcm_s
 	if (ss->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		siu_stream = &port_info->playback;
 		param = &siu_stream->param;
-		param->slave_id = port ? SHDMA_SLAVE_SIUB_TX :
-			SHDMA_SLAVE_SIUA_TX;
+		param->slave_id = port ? pdata->dma_slave_tx_b :
+			pdata->dma_slave_tx_a;
 	} else {
 		siu_stream = &port_info->capture;
 		param = &siu_stream->param;
-		param->slave_id = port ? SHDMA_SLAVE_SIUB_RX :
-			SHDMA_SLAVE_SIUA_RX;
+		param->slave_id = port ? pdata->dma_slave_rx_b :
+			pdata->dma_slave_rx_a;
 	}
 
 	param->dma_dev = pdata->dma_dev;
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

