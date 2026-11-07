Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794034439;
	b=KyNb9xcasoh4oQm53ZehUFcG0A1hT1HaZIQeCKTAkXQjk9f5X4xxkEEAukvb16A6BX4N
	 mdRgNIvdEq7ZSd6GXlgD7WWWRObF7idA8e1phLpw9qvN3deOsRjxgX0ynreGIB3pKU70q
	 UUfrrXwnJhr5y9TCOpK8DocW3//NZrvr1YpsgL5L6psuYekJfpUCXnEenK8yAK8NTsPSh
	 fAaf8DqODzlAGyqy2w+ozdsJmjhqwSBLke+xRJDRkp2hXUS2jchYnGjTzVTZeF7gb58TR
	 EaQTGJKtkTJ3rxa0gXde6i/5xhvAFiznAPt9rydlf2idgsyEnZ1zE8hZEwjbBpVEYag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794034439;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=N+SKmYa/90KYEhIUYYr4bjcjtYuCagVo6ezbU8wsG+E=;
	b=MQulOQm+mZZQK+870XLC0zyS/tyM1ebDtNRv095c6UVtvnNZ0FOsuvd2V7SdFM2cbw4O
	 WRO9MxhWL7Qf8YiQKtAsulnJPbQndSSBwyiqiRLKrusCbtBrO5ZmB1lUUaL99p2z0QY3j
	 ksakNremmMxnOA3mEvvuDFAuygZnZzc2EeHAyxAMi6Ce9yWJEEPpWNDhwB+iSgOrZehTZ
	 kHmrJ8SI4KL369zV7gxkg/Vqc4sDesJVjeFLnt5ASh11XYhlPG1QAEbI7L9hm4VMII+Fq
	 9vWzo1yCLx8Sz7u9d2oQaY5bq4ARMEcUbzB9LgUyGC3nfp3vOiM8Lp9GTuONeCbGgLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MITg27h6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4B606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MITg27h6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CC31F0089F;
	Sat,  7 Nov 2026 06:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794034438;
	bh=N+SKmYa/90KYEhIUYYr4bjcjtYuCagVo6ezbU8wsG+E=;
	h=Date:To:From:Subject;
	b=MITg27h6cBTlbyLu24Fj63m223Fujhux62u2xg2IIC6tCHpa/Ek++jT50FbO+S6Sz
	 cd4D5IBk+uyOnq5oHut9SCzWraZ4UWaDGAyq2ZPWbrSNZYIp5OzEG+tdhuG9z8da4T
	 oPRFxh/g9+UR49USR0nBco60LF+Gp19Y7TIC+TOg=
Date: Fri, 06 Nov 2026 22:53:58 -0800
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,
	ritesh.list@gmail.com,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,lance.yang@linux.dev,
	kernel@xen0n.name,david@kernel.org,chleroy@kernel.org,chenhuacai@kernel.org,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch added to mm-new branch
Message-Id: <20261107065358.C8CC31F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: powerpc/mm: drop powerpc vmemmap_can_optimize()
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: powerpc/mm: drop powerpc vmemmap_can_optimize()
Date: Sat, 07 Nov 2026 12:31:19 +0800

Whether the optimized mapping can be used is now decided in the
architecture-specific vmemmap_populate() path. When PowerPC has to fall
back, such as on Hash MMU, it can disable optimization for the populated
vmemmap range there.

Add section_vmemmap_optimization_disable() to centralize this fallback,
use it in the Hash MMU path, and drop the radix-specific
vmemmap_can_optimize() override.

Link: https://lore.kernel.org/20261107043122.25650-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 arch/powerpc/include/asm/book3s/64/radix.h |    5 -----
 arch/powerpc/mm/book3s64/radix_pgtable.c   |   10 ----------
 arch/powerpc/mm/init_64.c                  |    2 ++
 include/linux/vmemmap-optimization.h       |    6 ++++++
 mm/sparse-vmemmap.c                        |   17 +++++++++++++++++
 5 files changed, 25 insertions(+), 15 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/radix.h~powerpc-mm-drop-powerpc-vmemmap_can_optimize
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -351,10 +351,5 @@ int radix__create_section_mapping(unsign
 				  int nid, pgprot_t prot);
 int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #endif /* CONFIG_MEMORY_HOTPLUG */
-
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-#define vmemmap_can_optimize vmemmap_can_optimize
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-#endif
 #endif /* __ASSEMBLER__ */
 #endif
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-drop-powerpc-vmemmap_can_optimize
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -978,16 +978,6 @@ int __meminit radix__vmemmap_create_mapp
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	if (radix_enabled())
-		return __vmemmap_can_optimize(altmap, pgmap);
-
-	return false;
-}
-#endif
-
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
 {
--- a/arch/powerpc/mm/init_64.c~powerpc-mm-drop-powerpc-vmemmap_can_optimize
+++ a/arch/powerpc/mm/init_64.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
+#include <linux/vmemmap-optimization.h>
 #include <linux/swap.h>
 #include <linux/stddef.h>
 #include <linux/vmalloc.h>
@@ -281,6 +282,7 @@ int __meminit vmemmap_populate(unsigned
 	if (radix_enabled())
 		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
+	section_vmemmap_optimization_disable(start, end);
 
 	return __vmemmap_populate(start, end, node, altmap);
 }
--- a/include/linux/vmemmap-optimization.h~powerpc-mm-drop-powerpc-vmemmap_can_optimize
+++ a/include/linux/vmemmap-optimization.h
@@ -63,6 +63,7 @@ static inline unsigned int pfn_to_sectio
 }
 
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
+void section_vmemmap_optimization_disable(unsigned long start, unsigned long end);
 #else
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -79,6 +80,11 @@ static inline void section_set_compound_
 {
 }
 
+static inline void section_vmemmap_optimization_disable(unsigned long start,
+		unsigned long end)
+{
+}
+
 static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return 0;
--- a/mm/sparse-vmemmap.c~powerpc-mm-drop-powerpc-vmemmap_can_optimize
+++ a/mm/sparse-vmemmap.c
@@ -232,6 +232,23 @@ struct page __ref *vmemmap_shared_tail_p
 
 	return page;
 }
+
+void __meminit section_vmemmap_optimization_disable(unsigned long start,
+		unsigned long end)
+{
+	unsigned long pfn = page_to_pfn((struct page *)start);
+	unsigned long nr_pages = (end - start) / sizeof(struct page);
+	struct mem_section *section = __pfn_to_section(pfn);
+
+	if (nr_pages < PAGES_PER_SECTION) {
+		VM_WARN_ON_ONCE(section_vmemmap_optimizable(section));
+		return;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SECTION));
+	VM_WARN_ON_ONCE(nr_pages != PAGES_PER_SECTION);
+	section_set_compound_order(section, 0);
+}
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch
powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
loongarch-mm-disable-device-dax-vmemmap-optimization.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

