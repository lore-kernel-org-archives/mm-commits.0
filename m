From: akpm@linux-foundation.org
Subject: - use-slab_panic-flag-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:40 -0700
Message-ID: <200705090243.l492heJA008500@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970024AbXEICoC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, benh@kernel.crashing.org, dhowells@redhat.com, lethal@linux-sh.org, paulus@samba.org, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     use SLAB_PANIC flag cleanup
has been removed from the -mm tree.  Its filename was
     use-slab_panic-flag-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use SLAB_PANIC flag cleanup
From: Akinobu Mita <akinobu.mita@gmail.com>

Use SLAB_PANIC and delete duplicated panic().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/mm/memc.c          |    8 ++------
 arch/frv/mm/pgalloc.c         |    4 +---
 arch/i386/mm/init.c           |    9 ++-------
 arch/ia64/ia32/ia32_support.c |    6 ++----
 arch/powerpc/mm/init_64.c     |    5 +----
 arch/sh/mm/pmb.c              |    6 +++---
 6 files changed, 11 insertions(+), 27 deletions(-)

diff -puN arch/arm26/mm/memc.c~use-slab_panic-flag-cleanup arch/arm26/mm/memc.c
--- a/arch/arm26/mm/memc.c~use-slab_panic-flag-cleanup
+++ a/arch/arm26/mm/memc.c
@@ -176,13 +176,9 @@ void __init pgtable_cache_init(void)
 {
 	pte_cache = kmem_cache_create("pte-cache",
 				sizeof(pte_t) * PTRS_PER_PTE,
-				0, 0, pte_cache_ctor, NULL);
-	if (!pte_cache)
-		BUG();
+				0, SLAB_PANIC, pte_cache_ctor, NULL);
 
 	pgd_cache = kmem_cache_create("pgd-cache", MEMC_TABLE_SIZE +
 				sizeof(pgd_t) * PTRS_PER_PGD,
-				0, 0, pgd_cache_ctor, NULL);
-	if (!pgd_cache)
-		BUG();
+				0, SLAB_PANIC, pgd_cache_ctor, NULL);
 }
diff -puN arch/frv/mm/pgalloc.c~use-slab_panic-flag-cleanup arch/frv/mm/pgalloc.c
--- a/arch/frv/mm/pgalloc.c~use-slab_panic-flag-cleanup
+++ a/arch/frv/mm/pgalloc.c
@@ -151,9 +151,7 @@ void __init pgtable_cache_init(void)
 	pgd_cache = kmem_cache_create("pgd",
 				      PTRS_PER_PGD * sizeof(pgd_t),
 				      PTRS_PER_PGD * sizeof(pgd_t),
-				      0,
+				      SLAB_PANIC,
 				      pgd_ctor,
 				      pgd_dtor);
-	if (!pgd_cache)
-		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
diff -puN arch/i386/mm/init.c~use-slab_panic-flag-cleanup arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~use-slab_panic-flag-cleanup
+++ a/arch/i386/mm/init.c
@@ -751,12 +751,9 @@ void __init pgtable_cache_init(void)
 		pmd_cache = kmem_cache_create("pmd",
 					PTRS_PER_PMD*sizeof(pmd_t),
 					PTRS_PER_PMD*sizeof(pmd_t),
-					0,
+					SLAB_PANIC,
 					pmd_ctor,
 					NULL);
-		if (!pmd_cache)
-			panic("pgtable_cache_init(): cannot create pmd cache");
-
 		if (!SHARED_KERNEL_PMD) {
 			/* If we're in PAE mode and have a non-shared
 			   kernel pmd, then the pgd size must be a
@@ -770,11 +767,9 @@ void __init pgtable_cache_init(void)
 	pgd_cache = kmem_cache_create("pgd",
 				pgd_size,
 				pgd_size,
-				0,
+				SLAB_PANIC,
 				pgd_ctor,
 				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
-	if (!pgd_cache)
-		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
 
 /*
diff -puN arch/ia64/ia32/ia32_support.c~use-slab_panic-flag-cleanup arch/ia64/ia32/ia32_support.c
--- a/arch/ia64/ia32/ia32_support.c~use-slab_panic-flag-cleanup
+++ a/arch/ia64/ia32/ia32_support.c
@@ -252,10 +252,8 @@ ia32_init (void)
 		extern struct kmem_cache *partial_page_cachep;
 
 		partial_page_cachep = kmem_cache_create("partial_page_cache",
-							sizeof(struct partial_page), 0, 0,
-							NULL, NULL);
-		if (!partial_page_cachep)
-			panic("Cannot create partial page SLAB cache");
+						sizeof(struct partial_page),
+						0, SLAB_PANIC, NULL, NULL);
 	}
 #endif
 	return 0;
diff -puN arch/powerpc/mm/init_64.c~use-slab_panic-flag-cleanup arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~use-slab_panic-flag-cleanup
+++ a/arch/powerpc/mm/init_64.c
@@ -183,11 +183,8 @@ void pgtable_cache_init(void)
 		    "for size: %08x...\n", name, i, size);
 		pgtable_cache[i] = kmem_cache_create(name,
 						     size, size,
-						     0,
+						     SLAB_PANIC,
 						     zero_ctor,
 						     NULL);
-		if (! pgtable_cache[i])
-			panic("pgtable_cache_init(): could not create %s!\n",
-			      name);
 	}
 }
diff -puN arch/sh/mm/pmb.c~use-slab_panic-flag-cleanup arch/sh/mm/pmb.c
--- a/arch/sh/mm/pmb.c~use-slab_panic-flag-cleanup
+++ a/arch/sh/mm/pmb.c
@@ -311,9 +311,9 @@ static int __init pmb_init(void)
 
 	BUG_ON(unlikely(nr_entries >= NR_PMB_ENTRIES));
 
-	pmb_cache = kmem_cache_create("pmb", sizeof(struct pmb_entry),
-				      0, 0, pmb_cache_ctor, pmb_cache_dtor);
-	BUG_ON(!pmb_cache);
+	pmb_cache = kmem_cache_create("pmb", sizeof(struct pmb_entry), 0,
+				      SLAB_PANIC, pmb_cache_ctor,
+				      pmb_cache_dtor);
 
 	jump_to_P2();
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
