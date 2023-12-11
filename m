Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CB17493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kK++CMX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3893FC433C8;
	Mon, 11 Dec 2023 01:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257824;
	bh=9H6YitfU1DVABTMruMnnHxof3zdfOY2c13y/igbsloQ=;
	h=Date:To:From:Subject:From;
	b=kK++CMX5FHSYrdT9R/IGml+l4yBzj5dPuLIAESk3GEJD+ikqSdJpjpSzXhwvNFvZ8
	 gbvfbEEOEzEwNDTtLX+1QgI0NAiEEM4pAcR2K4GpoOoGkOzzEhxsF4XyAdLYC3j+Fe
	 0C6RQQtm1a/sZ8vLe1uERInTWLt2ZG3jSV9WMx8o=
Date: Sun, 10 Dec 2023 17:23:43 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-move-cache-declarations-into-header.patch removed from -mm tree
Message-Id: <20231211012344.3893FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: move cache declarations into header
has been removed from the -mm tree.  Its filename was
     mips-move-cache-declarations-into-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: move cache declarations into header
Date: Mon, 4 Dec 2023 12:57:02 +0100

Some of the cache functions are declared only for their callers, e.g.

arch/mips/mm/c-r3k.c:28:15: error: no previous prototype for 'r3k_cache_size' [-Werror=missing-prototypes]
arch/mips/mm/c-r3k.c:63:15: error: no previous prototype for 'r3k_cache_lsize' [-Werror=missing-prototypes]
arch/mips/mm/c-r4k.c:1703:6: error: no previous prototype for 'r4k_cache_init' [-Werror=missing-prototypes]
arch/mips/mm/sc-mips.c:255:5: error: no previous prototype for 'mips_sc_init' [-Werror=missing-prototypes]

Move all the declarations to asm/cache.h and asm/r4kcache.h where they
can be seen by the function definitions.

Link: https://lkml.kernel.org/r/20231204115710.2247097-13-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cache.h    |    6 ++++++
 arch/mips/include/asm/r4kcache.h |    4 ++++
 arch/mips/kernel/cpu-probe.c     |    1 -
 arch/mips/kernel/cpu-r3k-probe.c |    1 -
 arch/mips/mm/c-r4k.c             |    4 ----
 arch/mips/mm/cache.c             |    6 ------
 6 files changed, 10 insertions(+), 12 deletions(-)

--- a/arch/mips/include/asm/cache.h~mips-move-cache-declarations-into-header
+++ a/arch/mips/include/asm/cache.h
@@ -17,5 +17,11 @@
 #define __read_mostly __section(".data..read_mostly")
 
 extern void cache_noop(void);
+extern void r3k_cache_init(void);
+extern unsigned long r3k_cache_size(unsigned long);
+extern unsigned long r3k_cache_lsize(unsigned long);
+extern void r4k_cache_init(void);
+extern void octeon_cache_init(void);
+extern void au1x00_fixup_config_od(void);
 
 #endif /* _ASM_CACHE_H */
--- a/arch/mips/include/asm/r4kcache.h~mips-move-cache-declarations-into-header
+++ a/arch/mips/include/asm/r4kcache.h
@@ -24,6 +24,10 @@
 #include <asm/mmzone.h>
 #include <asm/unroll.h>
 
+extern void r5k_sc_init(void);
+extern void rm7k_sc_init(void);
+extern int mips_sc_init(void);
+
 extern void (*r4k_blast_dcache)(void);
 extern void (*r4k_blast_icache)(void);
 
--- a/arch/mips/kernel/cpu-probe.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/kernel/cpu-probe.c
@@ -179,7 +179,6 @@ void __init check_bugs32(void)
 static inline int cpu_has_confreg(void)
 {
 #ifdef CONFIG_CPU_R3000
-	extern unsigned long r3k_cache_size(unsigned long);
 	unsigned long size1, size2;
 	unsigned long cfg = read_c0_conf();
 
--- a/arch/mips/kernel/cpu-r3k-probe.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/kernel/cpu-r3k-probe.c
@@ -42,7 +42,6 @@ void __init check_bugs32(void)
 static inline int cpu_has_confreg(void)
 {
 #ifdef CONFIG_CPU_R3000
-	extern unsigned long r3k_cache_size(unsigned long);
 	unsigned long size1, size2;
 	unsigned long cfg = read_c0_conf();
 
--- a/arch/mips/mm/cache.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/mm/cache.c
@@ -206,19 +206,13 @@ static inline void setup_protection_map(
 void cpu_cache_init(void)
 {
 	if (cpu_has_3k_cache) {
-		extern void __weak r3k_cache_init(void);
-
 		r3k_cache_init();
 	}
 	if (cpu_has_4k_cache) {
-		extern void __weak r4k_cache_init(void);
-
 		r4k_cache_init();
 	}
 
 	if (cpu_has_octeon_cache) {
-		extern void __weak octeon_cache_init(void);
-
 		octeon_cache_init();
 	}
 
--- a/arch/mips/mm/c-r4k.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/mm/c-r4k.c
@@ -1485,10 +1485,6 @@ static void loongson3_sc_init(void)
 	return;
 }
 
-extern int r5k_sc_init(void);
-extern int rm7k_sc_init(void);
-extern int mips_sc_init(void);
-
 static void setup_scache(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

