From: akpm@linux-foundation.org
Subject: [merged] remove-cpu_subtype_sh7764.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:25 -0700
Message-ID: <53e3db51.xCw04Z3UjzfiyP2D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:58344 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaHGUC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:26 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1172571pab.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: remove CPU_SUBTYPE_SH7764
has been removed from the -mm tree.  Its filename was
     remove-cpu_subtype_sh7764.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: sh: remove CPU_SUBTYPE_SH7764

The symbol is an orphan, get rid of it.

Submitted by Richard a few months ago as "[PATCH 21/28] Remove
CPU_SUBTYPE_SH7764".

[pebolle@tiscali.nl: re-added dropped ||]
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/drivers/dma/Kconfig                |    5 ++---
 arch/sh/include/cpu-sh4/cpu/dma-register.h |    1 -
 arch/sh/include/cpu-sh4a/cpu/dma.h         |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/sh/drivers/dma/Kconfig~remove-cpu_subtype_sh7764 arch/sh/drivers/dma/Kconfig
--- a/arch/sh/drivers/dma/Kconfig~remove-cpu_subtype_sh7764
+++ a/arch/sh/drivers/dma/Kconfig
@@ -12,9 +12,8 @@ config SH_DMA_IRQ_MULTI
 	default y if CPU_SUBTYPE_SH7750  || CPU_SUBTYPE_SH7751  || \
 		     CPU_SUBTYPE_SH7750S || CPU_SUBTYPE_SH7750R || \
 		     CPU_SUBTYPE_SH7751R || CPU_SUBTYPE_SH7091  || \
-		     CPU_SUBTYPE_SH7763  || CPU_SUBTYPE_SH7764  || \
-		     CPU_SUBTYPE_SH7780  || CPU_SUBTYPE_SH7785  || \
-		     CPU_SUBTYPE_SH7760
+		     CPU_SUBTYPE_SH7763  || CPU_SUBTYPE_SH7780  || \
+		     CPU_SUBTYPE_SH7785  || CPU_SUBTYPE_SH7760
 
 config SH_DMA_API
 	depends on SH_DMA
diff -puN arch/sh/include/cpu-sh4/cpu/dma-register.h~remove-cpu_subtype_sh7764 arch/sh/include/cpu-sh4/cpu/dma-register.h
--- a/arch/sh/include/cpu-sh4/cpu/dma-register.h~remove-cpu_subtype_sh7764
+++ a/arch/sh/include/cpu-sh4/cpu/dma-register.h
@@ -32,7 +32,6 @@
 #define CHCR_TS_HIGH_SHIFT	(20 - 2)	/* 2 bits for shifted low TS */
 #elif defined(CONFIG_CPU_SUBTYPE_SH7757) || \
 	defined(CONFIG_CPU_SUBTYPE_SH7763) || \
-	defined(CONFIG_CPU_SUBTYPE_SH7764) || \
 	defined(CONFIG_CPU_SUBTYPE_SH7780) || \
 	defined(CONFIG_CPU_SUBTYPE_SH7785)
 #define CHCR_TS_LOW_MASK	0x00000018
diff -puN arch/sh/include/cpu-sh4a/cpu/dma.h~remove-cpu_subtype_sh7764 arch/sh/include/cpu-sh4a/cpu/dma.h
--- a/arch/sh/include/cpu-sh4a/cpu/dma.h~remove-cpu_subtype_sh7764
+++ a/arch/sh/include/cpu-sh4a/cpu/dma.h
@@ -14,8 +14,7 @@
 #define DMTE4_IRQ	evt2irq(0xb80)
 #define DMAE0_IRQ	evt2irq(0xbc0)	/* DMA Error IRQ*/
 #define SH_DMAC_BASE0	0xFE008020
-#elif defined(CONFIG_CPU_SUBTYPE_SH7763) || \
-	defined(CONFIG_CPU_SUBTYPE_SH7764)
+#elif defined(CONFIG_CPU_SUBTYPE_SH7763)
 #define DMTE0_IRQ	evt2irq(0x640)
 #define DMTE4_IRQ	evt2irq(0x780)
 #define DMAE0_IRQ	evt2irq(0x6c0)
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch
linux-next.patch
arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch
update-roland-mcgraths-mail.patch

