Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A008C747F
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398840; cv=none; b=VQY9FegzI7SpkNpMKGGc9NUvK8tlSRpXfU3XhQ31NfaftZCTFOIXqtLZK48ciJ925DSN375pj05NqBM5/smo8DmZ3Jzdu6JzBQlSoL0RvGSEJZ3gLQe3cfk2Og2bFqxMACADOeBS4ALZeNWr4fInVbe6cdRi9CugQalr7jqTQyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398840; c=relaxed/simple;
	bh=WOGV6GrzzQzX2ujsyvFQAjQLs88bT8hUrQFThRgqeo4=;
	h=Date:To:From:Subject:Message-Id; b=HIjoq3+8crn+oJ6Z8manp81jEUrzLfNTO7QfY2b1lqK3PGE+blgleF9KDgbJL4HQWFL+lKV0Ye0ZOEL5ecLht78wqT5b14/nDd49B87Scjdi5avGsnbyLO+rq6zrngfiDm09cCUcKSczNsgNzTQQIwYY9O/U6rCBVR0loLBlnF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J6l5NGaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J6l5NGaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213AAC4CED2;
	Thu,  9 Jan 2025 05:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736398840;
	bh=WOGV6GrzzQzX2ujsyvFQAjQLs88bT8hUrQFThRgqeo4=;
	h=Date:To:From:Subject:From;
	b=J6l5NGaIUXa6crvyqlTQByYVtWBBQiIw9xjtDR4dQi93dOSIIwqJlQW4wjBSTDwsv
	 9RoaACSaj0djyN01maJNN0jXcTTc2wtzUtbftEwJ8za+XGgjKnogeiiC0tEb5e1b1s
	 2CKYd4afentPN1dBIQRGR2MhuOH3VcIkD9UzHjaA=
Date: Wed, 08 Jan 2025 21:00:39 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch added to mm-unstable branch
Message-Id: <20250109050040.213AAC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: asm-generic: pgalloc: provide generic p4d_{alloc_one,free}
has been added to the -mm mm-unstable branch.  Its filename is
     asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: asm-generic: pgalloc: provide generic p4d_{alloc_one,free}
Date: Wed, 8 Jan 2025 14:57:19 +0800

Four architectures currently implement 5-level pgtables: arm64, riscv, x86
and s390.  The first three have essentially the same implementation for
p4d_alloc_one() and p4d_free(), so we've got an opportunity to reduce
duplication like at the lower levels.

Provide a generic version of p4d_alloc_one() and p4d_free(), and make use
of it on those architectures.

Their implementation is the same as at PUD level, except that p4d_free()
performs a runtime check by calling mm_p4d_folded().  5-level pgtables
depend on a runtime-detected hardware feature on all supported
architectures, so we might as well include this check in the generic
implementation.  No runtime check is required in p4d_alloc_one() as the
top-level p4d_alloc() already does the required check.

Link: https://lkml.kernel.org/r/26d69c74a29183ecc335b9b407040d8e4cd70c6a.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>		[asm-generic]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgalloc.h |   17 ----------
 arch/riscv/include/asm/pgalloc.h |   23 --------------
 arch/x86/include/asm/pgalloc.h   |   18 -----------
 include/asm-generic/pgalloc.h    |   45 +++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 58 deletions(-)

--- a/arch/arm64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-p4d_alloc_onefree
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -85,23 +85,6 @@ static inline void pgd_populate(struct m
 	__pgd_populate(pgdp, __pa(p4dp), pgdval);
 }
 
-static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	gfp_t gfp = GFP_PGTABLE_USER;
-
-	if (mm == &init_mm)
-		gfp = GFP_PGTABLE_KERNEL;
-	return (p4d_t *)get_zeroed_page(gfp);
-}
-
-static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
-{
-	if (!pgtable_l5_enabled())
-		return;
-	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	free_page((unsigned long)p4d);
-}
-
 #define __p4d_free_tlb(tlb, p4d, addr)  p4d_free((tlb)->mm, p4d)
 #else
 static inline void __pgd_populate(pgd_t *pgdp, phys_addr_t p4dp, pgdval_t prot)
--- a/arch/riscv/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-p4d_alloc_onefree
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -105,29 +105,6 @@ static inline void __pud_free_tlb(struct
 	}
 }
 
-#define p4d_alloc_one p4d_alloc_one
-static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	gfp_t gfp = GFP_PGTABLE_USER;
-
-	if (mm == &init_mm)
-		gfp = GFP_PGTABLE_KERNEL;
-	return (p4d_t *)get_zeroed_page(gfp);
-}
-
-static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
-{
-	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	free_page((unsigned long)p4d);
-}
-
-#define p4d_free p4d_free
-static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
-{
-	if (pgtable_l5_enabled)
-		__p4d_free(mm, p4d);
-}
-
 static inline void __p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d,
 				  unsigned long addr)
 {
--- a/arch/x86/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-p4d_alloc_onefree
+++ a/arch/x86/include/asm/pgalloc.h
@@ -147,24 +147,6 @@ static inline void pgd_populate_safe(str
 	set_pgd_safe(pgd, __pgd(_PAGE_TABLE | __pa(p4d)));
 }
 
-static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	gfp_t gfp = GFP_KERNEL_ACCOUNT;
-
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
-	return (p4d_t *)get_zeroed_page(gfp);
-}
-
-static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
-{
-	if (!pgtable_l5_enabled())
-		return;
-
-	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	free_page((unsigned long)p4d);
-}
-
 extern void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d);
 
 static inline void __p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d,
--- a/include/asm-generic/pgalloc.h~asm-generic-pgalloc-provide-generic-p4d_alloc_onefree
+++ a/include/asm-generic/pgalloc.h
@@ -215,6 +215,51 @@ static inline void pud_free(struct mm_st
 
 #endif /* CONFIG_PGTABLE_LEVELS > 3 */
 
+#if CONFIG_PGTABLE_LEVELS > 4
+
+static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
+{
+	gfp_t gfp = GFP_PGTABLE_USER;
+	struct ptdesc *ptdesc;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	gfp &= ~__GFP_HIGHMEM;
+
+	ptdesc = pagetable_alloc_noprof(gfp, 0);
+	if (!ptdesc)
+		return NULL;
+
+	return ptdesc_address(ptdesc);
+}
+#define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
+
+#ifndef __HAVE_ARCH_P4D_ALLOC_ONE
+static inline p4d_t *p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
+{
+	return __p4d_alloc_one_noprof(mm, addr);
+}
+#define p4d_alloc_one(...)	alloc_hooks(p4d_alloc_one_noprof(__VA_ARGS__))
+#endif
+
+static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
+
+	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
+	pagetable_free(ptdesc);
+}
+
+#ifndef __HAVE_ARCH_P4D_FREE
+static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
+{
+	if (!mm_p4d_folded(mm))
+		__p4d_free(mm, p4d);
+}
+#endif
+
+#endif /* CONFIG_PGTABLE_LEVELS > 4 */
+
 #ifndef __HAVE_ARCH_PGD_FREE
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch
selftests-mm-build-with-o2.patch
selftests-mm-build-with-o2-fix.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

