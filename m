From: akpm@linux-foundation.org
Subject: [merged] mips-fix-blast_icache32-on-loongson2.patch removed from
 -mm tree
Date: Wed, 15 Jan 2014 12:28:44 -0800
Message-ID: <52d6ef7c.5hrpdRrT9uRutnz+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAOU2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:28:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, blogic@openwrt.org, aurelien@aurel32.net, aaro.koskinen@iki.fi

Subject: [merged] mips-fix-blast_icache32-on-loongson2.patch removed from -mm tree
To: aaro.koskinen@iki.fi,aurelien@aurel32.net,blogic@openwrt.org,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:28:44 -0800


The patch titled
     Subject: MIPS: fix blast_icache32 on loongson2
has been removed from the -mm tree.  Its filename was
     mips-fix-blast_icache32-on-loongson2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: MIPS: fix blast_icache32 on loongson2

Commit 14bd8c082016cd1f6 ("MIPS: Loongson: Get rid of Loongson 2 #ifdefery
all over arch/mips") failed to add Loongson2 specific blast_icache32
functions.  Fix that.

The patch fixes the following crash seen with 3.13-rc1:

[    3.652000] Reserved instruction in kernel code[#1]:
[...]
[    3.652000] Call Trace:
[    3.652000] [<ffffffff802223c8>] blast_icache32_page+0x8/0xb0
[    3.652000] [<ffffffff80222c34>] r4k_flush_cache_page+0x19c/0x200
[    3.652000] [<ffffffff802d17e4>] do_wp_page.isra.97+0x47c/0xe08
[    3.652000] [<ffffffff802d51b0>] handle_mm_fault+0x938/0x1118
[    3.652000] [<ffffffff8021bd40>] __do_page_fault+0x140/0x540
[    3.652000] [<ffffffff80206be4>] resume_userspace_check+0x0/0x10
[    3.652000]
[    3.652000] Code: 00200825  64834000  00200825 <bc900000> bc900020  bc900040  bc900060  bc900080  bc9000a0
[    3.656000] ---[ end trace cd8a48f722f5c5f7 ]---

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Acked-by: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/r4kcache.h |   41 ++++++++++++++---------------
 arch/mips/mm/c-r4k.c             |    7 ++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff -puN arch/mips/include/asm/r4kcache.h~mips-fix-blast_icache32-on-loongson2 arch/mips/include/asm/r4kcache.h
--- a/arch/mips/include/asm/r4kcache.h~mips-fix-blast_icache32-on-loongson2
+++ a/arch/mips/include/asm/r4kcache.h
@@ -357,8 +357,8 @@ static inline void invalidate_tcache_pag
 		  "i" (op));
 
 /* build blast_xxx, blast_xxx_page, blast_xxx_page_indexed */
-#define __BUILD_BLAST_CACHE(pfx, desc, indexop, hitop, lsize) \
-static inline void blast_##pfx##cache##lsize(void)			\
+#define __BUILD_BLAST_CACHE(pfx, desc, indexop, hitop, lsize, extra)	\
+static inline void extra##blast_##pfx##cache##lsize(void)		\
 {									\
 	unsigned long start = INDEX_BASE;				\
 	unsigned long end = start + current_cpu_data.desc.waysize;	\
@@ -376,7 +376,7 @@ static inline void blast_##pfx##cache##l
 	__##pfx##flush_epilogue						\
 }									\
 									\
-static inline void blast_##pfx##cache##lsize##_page(unsigned long page) \
+static inline void extra##blast_##pfx##cache##lsize##_page(unsigned long page) \
 {									\
 	unsigned long start = page;					\
 	unsigned long end = page + PAGE_SIZE;				\
@@ -391,7 +391,7 @@ static inline void blast_##pfx##cache##l
 	__##pfx##flush_epilogue						\
 }									\
 									\
-static inline void blast_##pfx##cache##lsize##_page_indexed(unsigned long page) \
+static inline void extra##blast_##pfx##cache##lsize##_page_indexed(unsigned long page) \
 {									\
 	unsigned long indexmask = current_cpu_data.desc.waysize - 1;	\
 	unsigned long start = INDEX_BASE + (page & indexmask);		\
@@ -410,23 +410,24 @@ static inline void blast_##pfx##cache##l
 	__##pfx##flush_epilogue						\
 }
 
-__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 16)
-__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 16)
-__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 16)
-__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 32)
-__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 32)
-__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 32)
-__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 64)
-__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 64)
-__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 64)
-__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 128)
+__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 16, )
+__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 16, )
+__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 16, )
+__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 32, )
+__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 32, )
+__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I_Loongson2, 32, loongson2_)
+__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 32, )
+__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 64, )
+__BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 64, )
+__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 64, )
+__BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 128, )
 
-__BUILD_BLAST_CACHE(inv_d, dcache, Index_Writeback_Inv_D, Hit_Invalidate_D, 16)
-__BUILD_BLAST_CACHE(inv_d, dcache, Index_Writeback_Inv_D, Hit_Invalidate_D, 32)
-__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 16)
-__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 32)
-__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 64)
-__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 128)
+__BUILD_BLAST_CACHE(inv_d, dcache, Index_Writeback_Inv_D, Hit_Invalidate_D, 16, )
+__BUILD_BLAST_CACHE(inv_d, dcache, Index_Writeback_Inv_D, Hit_Invalidate_D, 32, )
+__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 16, )
+__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 32, )
+__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 64, )
+__BUILD_BLAST_CACHE(inv_s, scache, Index_Writeback_Inv_SD, Hit_Invalidate_SD, 128, )
 
 /* build blast_xxx_range, protected_blast_xxx_range */
 #define __BUILD_BLAST_CACHE_RANGE(pfx, desc, hitop, prot, extra)	\
diff -puN arch/mips/mm/c-r4k.c~mips-fix-blast_icache32-on-loongson2 arch/mips/mm/c-r4k.c
--- a/arch/mips/mm/c-r4k.c~mips-fix-blast_icache32-on-loongson2
+++ a/arch/mips/mm/c-r4k.c
@@ -237,6 +237,8 @@ static void r4k_blast_icache_page_setup(
 		r4k_blast_icache_page = (void *)cache_noop;
 	else if (ic_lsize == 16)
 		r4k_blast_icache_page = blast_icache16_page;
+	else if (ic_lsize == 32 && current_cpu_type() == CPU_LOONGSON2)
+		r4k_blast_icache_page = loongson2_blast_icache32_page;
 	else if (ic_lsize == 32)
 		r4k_blast_icache_page = blast_icache32_page;
 	else if (ic_lsize == 64)
@@ -261,6 +263,9 @@ static void r4k_blast_icache_page_indexe
 		else if (TX49XX_ICACHE_INDEX_INV_WAR)
 			r4k_blast_icache_page_indexed =
 				tx49_blast_icache32_page_indexed;
+		else if (current_cpu_type() == CPU_LOONGSON2)
+			r4k_blast_icache_page_indexed =
+				loongson2_blast_icache32_page_indexed;
 		else
 			r4k_blast_icache_page_indexed =
 				blast_icache32_page_indexed;
@@ -284,6 +289,8 @@ static void r4k_blast_icache_setup(void)
 			r4k_blast_icache = blast_r4600_v1_icache32;
 		else if (TX49XX_ICACHE_INDEX_INV_WAR)
 			r4k_blast_icache = tx49_blast_icache32;
+		else if (current_cpu_type() == CPU_LOONGSON2)
+			r4k_blast_icache = loongson2_blast_icache32;
 		else
 			r4k_blast_icache = blast_icache32;
 	} else if (ic_lsize == 64)
_

Patches currently in -mm which might be from aaro.koskinen@iki.fi are

origin.patch
linux-next.patch

