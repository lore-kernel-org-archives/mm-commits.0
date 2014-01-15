From: akpm@linux-foundation.org
Subject: [merged]
 mips-fix-case-mismatch-in-local_r4k_flush_icache_range.patch removed from
 -mm tree
Date: Wed, 15 Jan 2014 12:28:42 -0800
Message-ID: <52d6ef7a.wYG4JRsuyKkpCJAT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaAOU2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:28:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, blogic@openwrt.org, aurelien@aurel32.net, aaro.koskinen@iki.fi, chenhc@lemote.com

Subject: [merged] mips-fix-case-mismatch-in-local_r4k_flush_icache_range.patch removed from -mm tree
To: chenhc@lemote.com,aaro.koskinen@iki.fi,aurelien@aurel32.net,blogic@openwrt.org,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:28:42 -0800


The patch titled
     Subject: MIPS: fix case mismatch in local_r4k_flush_icache_range()
has been removed from the -mm tree.  Its filename was
     mips-fix-case-mismatch-in-local_r4k_flush_icache_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huacai Chen <chenhc@lemote.com>
Subject: MIPS: fix case mismatch in local_r4k_flush_icache_range()

Currently, Loongson-2 call protected_blast_icache_range() and others call
protected_loongson23_blast_icache_range(), but I think the correct
behavior should be the opposite.  BTW, Loongson-3's cache-ops is
compatible with MIPS64, but not compatible with Loongson-2.  So, rename
xxx_loongson23_yyy things to xxx_loongson2_yyy.

The patch fixes early boot hang with 3.13-rc1, introduced in the commit
14bd8c082016cd1f67 ("MIPS: Loongson: Get rid of Loongson 2 #ifdefery all
over arch/mips").

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Acked-by: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cacheops.h |    2 +-
 arch/mips/include/asm/r4kcache.h |    8 ++++----
 arch/mips/mm/c-r4k.c             |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/mips/include/asm/cacheops.h~mips-fix-case-mismatch-in-local_r4k_flush_icache_range arch/mips/include/asm/cacheops.h
--- a/arch/mips/include/asm/cacheops.h~mips-fix-case-mismatch-in-local_r4k_flush_icache_range
+++ a/arch/mips/include/asm/cacheops.h
@@ -83,6 +83,6 @@
 /*
  * Loongson2-specific cacheops
  */
-#define Hit_Invalidate_I_Loongson23	0x00
+#define Hit_Invalidate_I_Loongson2	0x00
 
 #endif	/* __ASM_CACHEOPS_H */
diff -puN arch/mips/include/asm/r4kcache.h~mips-fix-case-mismatch-in-local_r4k_flush_icache_range arch/mips/include/asm/r4kcache.h
--- a/arch/mips/include/asm/r4kcache.h~mips-fix-case-mismatch-in-local_r4k_flush_icache_range
+++ a/arch/mips/include/asm/r4kcache.h
@@ -165,7 +165,7 @@ static inline void flush_icache_line(uns
 	__iflush_prologue
 	switch (boot_cpu_type()) {
 	case CPU_LOONGSON2:
-		cache_op(Hit_Invalidate_I_Loongson23, addr);
+		cache_op(Hit_Invalidate_I_Loongson2, addr);
 		break;
 
 	default:
@@ -219,7 +219,7 @@ static inline void protected_flush_icach
 {
 	switch (boot_cpu_type()) {
 	case CPU_LOONGSON2:
-		protected_cache_op(Hit_Invalidate_I_Loongson23, addr);
+		protected_cache_op(Hit_Invalidate_I_Loongson2, addr);
 		break;
 
 	default:
@@ -452,8 +452,8 @@ static inline void prot##extra##blast_##
 __BUILD_BLAST_CACHE_RANGE(d, dcache, Hit_Writeback_Inv_D, protected_, )
 __BUILD_BLAST_CACHE_RANGE(s, scache, Hit_Writeback_Inv_SD, protected_, )
 __BUILD_BLAST_CACHE_RANGE(i, icache, Hit_Invalidate_I, protected_, )
-__BUILD_BLAST_CACHE_RANGE(i, icache, Hit_Invalidate_I_Loongson23, \
-	protected_, loongson23_)
+__BUILD_BLAST_CACHE_RANGE(i, icache, Hit_Invalidate_I_Loongson2, \
+	protected_, loongson2_)
 __BUILD_BLAST_CACHE_RANGE(d, dcache, Hit_Writeback_Inv_D, , )
 __BUILD_BLAST_CACHE_RANGE(s, scache, Hit_Writeback_Inv_SD, , )
 /* blast_inv_dcache_range */
diff -puN arch/mips/mm/c-r4k.c~mips-fix-case-mismatch-in-local_r4k_flush_icache_range arch/mips/mm/c-r4k.c
--- a/arch/mips/mm/c-r4k.c~mips-fix-case-mismatch-in-local_r4k_flush_icache_range
+++ a/arch/mips/mm/c-r4k.c
@@ -580,11 +580,11 @@ static inline void local_r4k_flush_icach
 	else {
 		switch (boot_cpu_type()) {
 		case CPU_LOONGSON2:
-			protected_blast_icache_range(start, end);
+			protected_loongson2_blast_icache_range(start, end);
 			break;
 
 		default:
-			protected_loongson23_blast_icache_range(start, end);
+			protected_blast_icache_range(start, end);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from chenhc@lemote.com are

origin.patch

