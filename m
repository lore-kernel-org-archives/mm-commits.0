From: akpm@linux-foundation.org
Subject: + sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch added to -mm
 tree
Date: Mon, 24 Feb 2014 16:15:31 -0800
Message-ID: <530be0a3.ZrbtEunO6PI/BiCi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaBYAPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 19:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 16:15:31 -0800


The patch titled
     Subject: sh: prefix sh-specific "CCR" and "CCR2" by "SH_"
has been added to the -mm tree.  Its filename is
     sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: sh: prefix sh-specific "CCR" and "CCR2" by "SH_"

bcf24e1daa94f ("mmc: omap_hsmmc: use the generic config for omap2plus
devices"), enabled the build for other platforms for compile testing.

sh-allmodconfig now fails with:

    include/linux/omap-dma.h:171:8: error: expected identifier before numeric constant
    make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1

This happens because SuperH #defines "CCR", which is one of the enum
values in include/linux/omap-dma.h.  There's a similar issue with "CCR2"
on sh2a.

As "CCR" and "CCR2" are too generic names for global #defines, prefix them
with "SH_" to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/cpu-sh2/cpu/cache.h  |    2 +-
 arch/sh/include/cpu-sh2a/cpu/cache.h |    4 ++--
 arch/sh/include/cpu-sh3/cpu/cache.h  |    2 +-
 arch/sh/include/cpu-sh4/cpu/cache.h  |    2 +-
 arch/sh/kernel/cpu/init.c            |    4 ++--
 arch/sh/mm/cache-debugfs.c           |    2 +-
 arch/sh/mm/cache-sh2.c               |    4 ++--
 arch/sh/mm/cache-sh2a.c              |    6 ++++--
 arch/sh/mm/cache-sh4.c               |    4 ++--
 arch/sh/mm/cache-shx3.c              |    4 ++--
 arch/sh/mm/cache.c                   |    4 ++--
 11 files changed, 20 insertions(+), 18 deletions(-)

diff -puN arch/sh/include/cpu-sh2/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/include/cpu-sh2/cpu/cache.h
--- a/arch/sh/include/cpu-sh2/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/include/cpu-sh2/cpu/cache.h
@@ -18,7 +18,7 @@
 #define SH_CACHE_ASSOC		8
 
 #if defined(CONFIG_CPU_SUBTYPE_SH7619)
-#define CCR		0xffffffec
+#define SH_CCR		0xffffffec
 
 #define CCR_CACHE_CE	0x01	/* Cache enable */
 #define CCR_CACHE_WT	0x02    /* CCR[bit1=1,bit2=1] */
diff -puN arch/sh/include/cpu-sh2a/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/include/cpu-sh2a/cpu/cache.h
--- a/arch/sh/include/cpu-sh2a/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/include/cpu-sh2a/cpu/cache.h
@@ -17,8 +17,8 @@
 #define SH_CACHE_COMBINED	4
 #define SH_CACHE_ASSOC		8
 
-#define CCR		0xfffc1000 /* CCR1 */
-#define CCR2		0xfffc1004
+#define SH_CCR		0xfffc1000 /* CCR1 */
+#define SH_CCR2		0xfffc1004
 
 /*
  * Most of the SH-2A CCR1 definitions resemble the SH-4 ones. All others not
diff -puN arch/sh/include/cpu-sh3/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/include/cpu-sh3/cpu/cache.h
--- a/arch/sh/include/cpu-sh3/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/include/cpu-sh3/cpu/cache.h
@@ -17,7 +17,7 @@
 #define SH_CACHE_COMBINED	4
 #define SH_CACHE_ASSOC		8
 
-#define CCR		0xffffffec	/* Address of Cache Control Register */
+#define SH_CCR		0xffffffec	/* Address of Cache Control Register */
 
 #define CCR_CACHE_CE	0x01	/* Cache Enable */
 #define CCR_CACHE_WT	0x02	/* Write-Through (for P0,U0,P3) (else writeback) */
diff -puN arch/sh/include/cpu-sh4/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/include/cpu-sh4/cpu/cache.h
--- a/arch/sh/include/cpu-sh4/cpu/cache.h~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/include/cpu-sh4/cpu/cache.h
@@ -17,7 +17,7 @@
 #define SH_CACHE_COMBINED	4
 #define SH_CACHE_ASSOC		8
 
-#define CCR		0xff00001c	/* Address of Cache Control Register */
+#define SH_CCR		0xff00001c	/* Address of Cache Control Register */
 #define CCR_CACHE_OCE	0x0001	/* Operand Cache Enable */
 #define CCR_CACHE_WT	0x0002	/* Write-Through (for P0,U0,P3) (else writeback)*/
 #define CCR_CACHE_CB	0x0004	/* Copy-Back (for P1) (else writethrough) */
diff -puN arch/sh/kernel/cpu/init.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/kernel/cpu/init.c
--- a/arch/sh/kernel/cpu/init.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/kernel/cpu/init.c
@@ -112,7 +112,7 @@ static void cache_init(void)
 	unsigned long ccr, flags;
 
 	jump_to_uncached();
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 
 	/*
 	 * At this point we don't know whether the cache is enabled or not - a
@@ -189,7 +189,7 @@ static void cache_init(void)
 
 	l2_cache_init();
 
-	__raw_writel(flags, CCR);
+	__raw_writel(flags, SH_CCR);
 	back_to_cached();
 }
 #else
diff -puN arch/sh/mm/cache-debugfs.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/mm/cache-debugfs.c
--- a/arch/sh/mm/cache-debugfs.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/mm/cache-debugfs.c
@@ -36,7 +36,7 @@ static int cache_seq_show(struct seq_fil
 	 */
 	jump_to_uncached();
 
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 	if ((ccr & CCR_CACHE_ENABLE) == 0) {
 		back_to_cached();
 
diff -puN arch/sh/mm/cache-sh2.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/mm/cache-sh2.c
--- a/arch/sh/mm/cache-sh2.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/mm/cache-sh2.c
@@ -63,9 +63,9 @@ static void sh2__flush_invalidate_region
 	local_irq_save(flags);
 	jump_to_uncached();
 
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 	ccr |= CCR_CACHE_INVALIDATE;
-	__raw_writel(ccr, CCR);
+	__raw_writel(ccr, SH_CCR);
 
 	back_to_cached();
 	local_irq_restore(flags);
diff -puN arch/sh/mm/cache-sh2a.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/mm/cache-sh2a.c
--- a/arch/sh/mm/cache-sh2a.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/mm/cache-sh2a.c
@@ -134,7 +134,8 @@ static void sh2a__flush_invalidate_regio
 
 	/* If there are too many pages then just blow the cache */
 	if (((end - begin) >> PAGE_SHIFT) >= MAX_OCACHE_PAGES) {
-		__raw_writel(__raw_readl(CCR) | CCR_OCACHE_INVALIDATE, CCR);
+		__raw_writel(__raw_readl(SH_CCR) | CCR_OCACHE_INVALIDATE,
+			     SH_CCR);
 	} else {
 		for (v = begin; v < end; v += L1_CACHE_BYTES)
 			sh2a_invalidate_line(CACHE_OC_ADDRESS_ARRAY, v);
@@ -167,7 +168,8 @@ static void sh2a_flush_icache_range(void
 	/* I-Cache invalidate */
 	/* If there are too many pages then just blow the cache */
 	if (((end - start) >> PAGE_SHIFT) >= MAX_ICACHE_PAGES) {
-		__raw_writel(__raw_readl(CCR) | CCR_ICACHE_INVALIDATE, CCR);
+		__raw_writel(__raw_readl(SH_CCR) | CCR_ICACHE_INVALIDATE,
+			     SH_CCR);
 	} else {
 		for (v = start; v < end; v += L1_CACHE_BYTES)
 			sh2a_invalidate_line(CACHE_IC_ADDRESS_ARRAY, v);
diff -puN arch/sh/mm/cache-sh4.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/mm/cache-sh4.c
--- a/arch/sh/mm/cache-sh4.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/mm/cache-sh4.c
@@ -133,9 +133,9 @@ static void flush_icache_all(void)
 	jump_to_uncached();
 
 	/* Flush I-cache */
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 	ccr |= CCR_CACHE_ICI;
-	__raw_writel(ccr, CCR);
+	__raw_writel(ccr, SH_CCR);
 
 	/*
 	 * back_to_cached() will take care of the barrier for us, don't add
diff -puN arch/sh/mm/cache-shx3.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/mm/cache-shx3.c
--- a/arch/sh/mm/cache-shx3.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/mm/cache-shx3.c
@@ -19,7 +19,7 @@ void __init shx3_cache_init(void)
 {
 	unsigned int ccr;
 
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 
 	/*
 	 * If we've got cache aliases, resolve them in hardware.
@@ -40,5 +40,5 @@ void __init shx3_cache_init(void)
 	ccr |= CCR_CACHE_IBE;
 #endif
 
-	writel_uncached(ccr, CCR);
+	writel_uncached(ccr, SH_CCR);
 }
diff -puN arch/sh/mm/cache.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_ arch/sh/mm/cache.c
--- a/arch/sh/mm/cache.c~sh-prefix-sh-specific-ccr-and-ccr2-by-sh_
+++ a/arch/sh/mm/cache.c
@@ -285,8 +285,8 @@ void __init cpu_cache_init(void)
 {
 	unsigned int cache_disabled = 0;
 
-#ifdef CCR
-	cache_disabled = !(__raw_readl(CCR) & CCR_CACHE_ENABLE);
+#ifdef SH_CCR
+	cache_disabled = !(__raw_readl(SH_CCR) & CCR_CACHE_ENABLE);
 #endif
 
 	compute_alias(&boot_cpu_data.icache);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch
arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch
linux-next.patch

