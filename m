Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207836;
	b=FXfahiX8LL7/saISAhwgXarg3YzrGQZHKzsgYteBP1hlPNEfXu7WVwbApSbZM/DG9IJ3
	 GP4Dfsfp3h1E071rh8YJaYcFmzbTZX1JpHMQh0jYHm+SJ9q1AQ54qLp/nJ5uRhPAiEUQ+
	 85MH5tpDu52SQ57pQ4DH/rC4vODbivWjr3WloX5EDNrw9/9VciuXdopyxOB0ZkE1Jw6oF
	 K2m8BytaBKlzbM4bKLA9Igg+0otqTg089Wwa1Tnh7NnxGklbjMxoiL38scW6hkXbmFgCi
	 ieR9o3k8tfozn+xWKaXx4ljGgTjXJwyoZ196jxBKIallK5fa+2EufEx/5YRzmUxLdww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207836;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yZbcDdeo3f4sM45SvGP4imzUn1BbzFmzy/HRWGFotA4=;
	b=RzPq/mFEDOtFvnxbc+Vtp4bEDKUzLbFBtVvWYD+lQ3b+7I0IeBgOb0lpRCRxtutLp2/l
	 wNo+5qfqYT5rVf36UG+KWM6RWMDQbOVrBBM5QnwRIXcIrZ6B6JwQFibyVqGfjxzSG/TVA
	 TfkHbBjRrXd7xE/SiNXahj1zTt4gDbRcwFH8BnsEt04Vb/ICeRLj1yh3m+qRbH1nZhUG3
	 gL9SPEiiFxPi9eXNIYqsaZLvqmJ/litJtF8ptIGwIxBQMlAUxkRR+BRoUErbzNk6X8hji
	 cD6hTjQfNS5WBU7cr7vQ6JIQhwt6ZiyyghmAdMZWBYcgg7mGMImDmQoH/1L3dwtRzLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1RseVI3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B11F606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1RseVI3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC31F0089F;
	Mon,  9 Nov 2026 07:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207835;
	bh=yZbcDdeo3f4sM45SvGP4imzUn1BbzFmzy/HRWGFotA4=;
	h=Date:To:From:Subject;
	b=1RseVI3IQa8qG0PI+y2LGaTclx6WZpD+xXAZxHqI1ZLs7pom/H8KR7gGMNhrdn/W1
	 FhEciwkkKRHo5uxJvFcTR7GuFiyIzwDBNzh5bH0XnRkqJdAjIB5ZXzatVcyUx+Er4r
	 oy1ONoc9nksnADthYhhHJeJeCYKMkkIaMdOlrdvY=
Date: Sun, 08 Nov 2026 23:03:55 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,dev.jain@arm.com,david@kernel.org,
	chleroy@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,jiangwen6@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch added to mm-new branch
Message-Id: <20261109070355.A0FC31F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: arm64/mm: add vmap_pte_set_huge() and vmap_pte_clear_huge()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch

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
Subject: arm64/mm: add vmap_pte_set_huge() and vmap_pte_clear_huge()
Date: Sat, 07 Nov 2026 21:49:44 +0800

Patch series "mm/vmalloc: Speed up ioremap, vmalloc and vmap with
contiguous memory", v12.

This patchset accelerates ioremap, vmalloc, and vmap when the memory is
physically fully or partially contiguous. Two techniques are used:

1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
   segments
2. Use batched mappings wherever possible in both vmalloc and ARM64
   layers

Besides accelerating the mapping path, this also enables large
mappings (PMD and cont-PTE) for vmap, which are currently not
supported.

Patches 1-4 decouple the PTE-level block mapping path from HugeTLB.
Previously vmap_pte_range() installed cont-PTE mappings by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This made the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels, and coupled mm/vmalloc.c
to HugeTLB internals. Patches 1 and 2 add the arm64 and powerpc/8xx
implementations of vmap_pte_set_huge()/vmap_pte_clear_huge().
Patch 3 adds the generic fallbacks and converts mm/vmalloc.c over.
Patch 4 then removes the now-dead init_mm special case from
arm64's clear_flush().

Patch 5 extends ARM64 arch_vmap_pte_range_map_size() to batch multiple
CONT_PTE blocks in one call instead of one at a time.

Patch 6 extracts a common helper vmap_set_ptes() that consolidates PTE
mapping logic for the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings. This prepares for the next patch.

Patch 7 extends the page table walk path to support page shifts other
than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
mappings. The function is renamed from vmap_small_pages_range_noflush()
to vmap_pages_range_noflush_walk().

Patch 8 extracts vm_shift() to consolidate vmalloc mapping shift
selection for reuse in the batching path.

Patches 9-10 add huge vmap support for contiguous pages, including
support for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
the performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53 us)
* vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Large vmap() mappings were also tested by Leo Yan with ARM trace buffer
units, including TRBE and SPE. These units use the CPU page tables for
address translation when writing trace data to DRAM, so using larger
vmap() mapping granules can reduce TLB pressure on the trace writer.

The TRBE test used a 1G CoreSight ETM AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       68.4 -> 59.4 (-13.16%)
* l1d_tlb_refill: 155.8 -> 119.6 (-23.23%)
* l2d_tlb_refill: 161435.8 -> 495.0 (-99.69%)

The SPE test used a 512M ARM SPE AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       1710.4 -> 1315.6 (-23.08%)
* l1d_tlb_refill: 16000.0 -> 15950.2 (-0.31%)
* l2d_tlb_refill: 4796.0 -> 2931.2 (-38.88%)

These results show that enabling larger vmap() mappings can materially
reduce page table walks and TLB refills for large trace buffers.

Many thanks to Leo Yan for his testing efforts on ARM trace buffers.


This patch (of 10):

vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
HugeTLB internals it does not otherwise need.

Add vmap_pte_set_huge()/vmap_pte_clear_huge() to arm64, joining the
existing pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
__set_ptes() and __get_and_clear_full_ptes() directly, so they do not
depend on CONFIG_HUGETLB_PAGE.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Link: https://lore.kernel.org/20261107134953.748622-1-jiangwenxiaomi@gmail.com
Link: https://lore.kernel.org/20261107134953.748622-2-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
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

 arch/arm64/include/asm/pgtable.h |    6 ++++++
 arch/arm64/mm/mmu.c              |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1927,6 +1927,12 @@ static inline void clear_young_dirty_pte
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+#define __HAVE_ARCH_VMAP_PTE_SET_HUGE
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size);
+#define __HAVE_ARCH_VMAP_PTE_CLEAR_HUGE
+pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_PGTABLE_H */
--- a/arch/arm64/mm/mmu.c~arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge
+++ a/arch/arm64/mm/mmu.c
@@ -1911,6 +1911,33 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size)
+{
+	unsigned long pfn = __phys_to_pfn(phys);
+	pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
+	unsigned int nr = size >> PAGE_SHIFT;
+
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
+
+	/* For vmap, there is no valid -> valid transition */
+	VM_WARN_ON(pte_valid(__ptep_get(ptep)));
+
+	__set_ptes(&init_mm, addr, ptep, pte, nr);
+}
+
+pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
+{
+	/* Kernel mappings only */
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+
+	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
+					 size >> PAGE_SHIFT, 0);
+}
+
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are

arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch
powerpc-8xx-add-vmap_pte_set_huge.patch
mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch
arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch
mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

