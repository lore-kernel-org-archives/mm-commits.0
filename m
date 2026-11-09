Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207841;
	b=0s737jls6u8dyMQgCsU/NG15aSrnp4lvbnx6yBnkEuwdHDSPC8G7HdTvRqHTbPCqQT8y
	 qIcUPnBwZF82S7rasfQibibZuO6V0KuFlJwWT6epvIO4nnYgNtrtrK9nRM5sPbRSEjE1+
	 4yzngXmaGK/OAgr06gfhFqtYFHvi+bEscmh+VmNolvTtVDkv5rLG4o2TOwX0BvjCuqc2B
	 jRF7bNG6Z48mwOyNzcaLWgJ8SgHWXOnCRNQlO3qHBi3ZSV2bmrFal24cnlkXc9+xuHvih
	 2tJ69I9E0u1Psk49oKX5fOKAhsWoLG8MX66xH2PV0NwTbfpng1rX1qnsM/AwiciGdwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207841;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qi21K/1NQZ2583tUSKSS/RuaQn061a+iGhqKzs0mXrA=;
	b=ALgp2rSYkDg/FaER9QkxvkzkxmRsOa9gRjiCNsZGBEVosL9WskLl88MVzmRRZPZZHNyb
	 1/lorDsn6DZUCJ1B43qCSQpbaqvwRfy4bDYDb9jd14zSfl2cOO1PNcyrn2PLiS0RYY38K
	 NdrGaj5dOmagL+Hma3x+ohldciA20+btK3GzssnGFMazFurtQvmd0m0vKJJ49ChmPRJTj
	 VSJvhBI/7lH52ijzVH3s8UUYKCkBFGziYFtSy7sSiFpKtdebVtuqpBVJ48pk7wzicnWa9
	 4XuT9+6fpePshglnXJ3eWPJkR0ZooKW26ZBcyIMsqr4z3eOKfuUaA/cY60tfeFikKPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nzoKnA9B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8180B606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nzoKnA9B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E9A1F0089F;
	Mon,  9 Nov 2026 07:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207841;
	bh=qi21K/1NQZ2583tUSKSS/RuaQn061a+iGhqKzs0mXrA=;
	h=Date:To:From:Subject;
	b=nzoKnA9BfiiyHWFBEvjsyF1M+7KCn+kAoBDv/Z7nrUgVaWgX3t4Upk2BDi1idK3EQ
	 GfCP29aoxo6FavNTkg8prw0TDNbm6mcwyy+UsV8RMamZ8yOhUtlsLzOzsATHKD6ZqS
	 b6dVhSxEOueSHi7+8iTpsviPid0pMLRQ/E2EbLpw=
Date: Sun, 08 Nov 2026 23:04:00 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,dev.jain@arm.com,david@kernel.org,
	chleroy@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,jiangwen6@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch added to mm-new branch
Message-Id: <20261109070401.00E9A1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmalloc: use vmap_pte_set_huge()/vmap_pte_clear_huge() for PTE-level block mappings
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wen Jiang <jiangwen6@xiaomi.com>
Subject: mm/vmalloc: use vmap_pte_set_huge()/vmap_pte_clear_huge() for PTE-level block mappings
Date: Sat, 07 Nov 2026 21:49:46 +0800

vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.

Now that arm64 and powerpc/8xx provide vmap_pte_set_huge() and
vmap_pte_clear_huge(), add the generic fallbacks next to the existing
pmd/pud_set_huge() family and convert vmap_pte_range() and
vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
around the block-mapping paths are dropped, so PTE-level block mappings
now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
longer includes <linux/hugetlb.h>.

The fallbacks exist only to keep the build working on architectures
without PTE-level block mapping support. They are unreachable there:
the callers only run when arch_vmap_pte_range_map_size() or
arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
which requires an arch implementation. BUILD_BUG() makes that
explicit rather than silently doing nothing.

Link: https://lore.kernel.org/20261107134953.748622-4-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <leo.yan@arm.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 include/linux/pgtable.h |   29 +++++++++++++++++++++++++++++
 mm/vmalloc.c            |   19 ++++++-------------
 2 files changed, 35 insertions(+), 13 deletions(-)

--- a/include/linux/pgtable.h~mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings
+++ a/include/linux/pgtable.h
@@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+/*
+ * PTE-level block mappings for vmap.
+ *
+ * vmap_pte_set_huge() only has to be implemented by architectures whose
+ * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_VMAP_PTE_SET_HUGE
+static inline void vmap_pte_set_huge(pte_t *ptep, unsigned long addr,
+				     phys_addr_t phys, pgprot_t prot,
+				     unsigned long size)
+{
+	BUILD_BUG();
+}
+#endif
+
+/*
+ * Likewise, vmap_pte_clear_huge() only has to be implemented by architectures
+ * whose arch_vmap_pte_range_unmap_size() can return a size other than
+ * PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_VMAP_PTE_CLEAR_HUGE
+static inline pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr,
+					unsigned long size)
+{
+	BUILD_BUG();
+	return __pte(0);
+}
+#endif
+
 #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
--- a/mm/vmalloc.c~mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings
+++ a/mm/vmalloc.c
@@ -38,7 +38,6 @@
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
 #include <linux/pgtable.h>
-#include <linux/hugetlb.h>
 #include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -100,7 +99,7 @@ static int vmap_pte_range(pmd_t *pmd, un
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -121,17 +120,12 @@ static int vmap_pte_range(pmd_t *pmd, un
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
 		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			vmap_pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
 			pfn += PFN_DOWN(size);
 			continue;
 		}
-#endif
 		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
@@ -391,25 +385,24 @@ static void vunmap_pte_range(pmd_t *pmd,
 {
 	pte_t *pte;
 	pte_t ptent;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	pte = pte_offset_kernel(pmd, addr);
 	lazy_mmu_mode_enable();
 
 	do {
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_unmap_size(addr, pte);
 		if (size != PAGE_SIZE) {
 			if (WARN_ON(!IS_ALIGNED(addr, size))) {
 				addr = ALIGN_DOWN(addr, size);
 				pte = PTR_ALIGN_DOWN(pte, sizeof(*pte) * (size >> PAGE_SHIFT));
 			}
-			ptent = huge_ptep_get_and_clear(&init_mm, addr, pte, size);
+			ptent = vmap_pte_clear_huge(pte, addr, size);
 			if (WARN_ON(end - addr < size))
 				size = end - addr;
-		} else
-#endif
+		} else {
 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
+		}
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
 
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are

arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch
powerpc-8xx-add-vmap_pte_set_huge.patch
mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch
arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch
mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

