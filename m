From: akpm@linux-foundation.org
Subject: + sh-add-dma-slave-definitions-to-sh7724.patch added to -mm tree
Date: Wed, 12 May 2010 15:55:42 -0700
Message-ID: <201005122255.o4CMtg0b025646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0ELW4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 18:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com


The patch titled
     sh: add DMA slave definitions to sh7724
has been added to the -mm tree.  Its filename is
     sh-add-dma-slave-definitions-to-sh7724.patch

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
Subject: sh: add DMA slave definitions to sh7724
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Add a list of SCIF and SDHI DMA slave definitions to sh7724.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |   86 +++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff -puN arch/sh/kernel/cpu/sh4a/setup-sh7724.c~sh-add-dma-slave-definitions-to-sh7724 arch/sh/kernel/cpu/sh4a/setup-sh7724.c
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c~sh-add-dma-slave-definitions-to-sh7724
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -31,6 +31,90 @@
 #include <cpu/sh7724.h>
 
 /* DMA */
+static const struct sh_dmae_slave_config sh7724_dmae_slaves[] = {
+	{
+		.slave_id	= SHDMA_SLAVE_SCIF0_TX,
+		.addr		= 0xffe0000c,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x21,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF0_RX,
+		.addr		= 0xffe00014,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x22,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF1_TX,
+		.addr		= 0xffe1000c,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x25,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF1_RX,
+		.addr		= 0xffe10014,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x26,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF2_TX,
+		.addr		= 0xffe2000c,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x29,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF2_RX,
+		.addr		= 0xffe20014,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x2a,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF3_TX,
+		.addr		= 0xa4e30020,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x2d,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF3_RX,
+		.addr		= 0xa4e30024,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x2e,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF4_TX,
+		.addr		= 0xa4e40020,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x31,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF4_RX,
+		.addr		= 0xa4e40024,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x32,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF5_TX,
+		.addr		= 0xa4e50020,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x35,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SCIF5_RX,
+		.addr		= 0xa4e50024,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.mid_rid	= 0x36,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
+		.addr		= 0x04ce0030,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
+		.addr		= 0x04ce0030,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc2,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI1_TX,
+		.addr		= 0x04cf0030,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc9,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI1_RX,
+		.addr		= 0x04cf0030,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xca,
+	},
+};
+
 static const struct sh_dmae_channel sh7724_dmae_channels[] = {
 	{
 		.offset = 0,
@@ -62,6 +146,8 @@ static const struct sh_dmae_channel sh77
 static const unsigned int ts_shift[] = TS_SHIFT;
 
 static struct sh_dmae_pdata dma_platform_data = {
+	.slave		= sh7724_dmae_slaves,
+	.slave_num	= ARRAY_SIZE(sh7724_dmae_slaves),
 	.channel	= sh7724_dmae_channels,
 	.channel_num	= ARRAY_SIZE(sh7724_dmae_channels),
 	.ts_low_shift	= CHCR_TS_LOW_SHIFT,
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

