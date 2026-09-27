Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77673B71A2
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 05:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790488287; cv=none; b=O1xCUH0nEP5NRh+e8PJzOW1MEyDBbiM/8PPQdwZK1+RxCBpIQqXcD9g/zOeEiF8qRE4cA7RNWvu5NyuSWR4aL+idQ29b7ZxPdrGL7i5d6NxRh58Pwn0gXQl0jwnLrqZuRS726UasWCZcqsk/aadCiWi2HqYGUkSF4Lvx/fWGCnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790488287; c=relaxed/simple;
	bh=PiZHg34ninKeTNdjU0+y7onVSqbmxZ4UaIjmKo+HIa4=;
	h=Date:To:From:Subject:Message-Id; b=jLxCQg+ZbC1kER0cV2hxPGVfqUYovZX8IEc0TX34gZ05bhplY4/UmpD8DPpPUwkeAahVHy8Wi6lSP+NnqU+LVXETbEPv1Scm1zbltxEOMCg28sR6jaOTyEwJFYulJEBdGikV6VgLHKiZCqx7zOrw/gOJaCz7nxasVdINrYyyWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1umgbx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1umgbx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5851F000FF;
	Sun, 27 Sep 2026 05:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790488285;
	bh=3+bV16/GzOA34rYuKhnWDTQGOKCAJ4EC4bJmRvaFNXI=;
	h=Date:To:From:Subject;
	b=O1umgbx6ZyAEoSVdWDfSs0xbwCT7KgELj/KsLgAeifw3sVixHyncjiBlIrI9qUj3Z
	 eru+3GilebxrxGuc7F1hTHkZelOJ0nayvqa/MMwjuJWi5Dw7t0Yexj+DZLMTaW9KjQ
	 q0BZwziPFy5RheaNPT32P7neo28xQUa03GYjMQ1s=
Date: Sat, 26 Sep 2026 22:51:25 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch added to mm-unstable branch
Message-Id: <20260927055125.7D5851F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
Date: Sun, 27 Sep 2026 10:54:32 +0800

The section-based vmemmap optimization infrastructure is guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
and use it to guard the generic sparse-vmemmap state and helpers.

Link: https://lore.kernel.org/20260927025441.741633-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |    2 +-
 fs/Kconfig                                    |    1 +
 include/linux/mm.h                            |    3 +++
 include/linux/mmzone.h                        |   10 +++++-----
 include/linux/page-flags.h                    |    5 ++---
 mm/Kconfig                                    |    5 +++++
 mm/sparse-vmemmap.c                           |    2 +-
 mm/sparse.h                                   |    6 +++---
 8 files changed, 21 insertions(+), 13 deletions(-)

--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#undef CONFIG_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
--- a/fs/Kconfig~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/fs/Kconfig
@@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
--- a/include/linux/mm.h~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/include/linux/mm.h
@@ -5175,6 +5175,9 @@ static inline bool __vmemmap_can_optimiz
 	unsigned long nr_pages;
 	unsigned long nr_vmemmap_pages;
 
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!pgmap || !is_power_of_2(sizeof(struct page)))
 		return false;
 
--- a/include/linux/mmzone.h~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/include/linux/mmzone.h
@@ -102,9 +102,9 @@
  *
  * HVO which is only active if the size of struct page is a power of 2.
  */
-#define MAX_FOLIO_VMEMMAP_ALIGN \
-	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
-	 is_power_of_2(sizeof(struct page)) ? \
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
+	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of retained vmemmap pages with HVO enabled. */
@@ -1150,7 +1150,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	struct page **vmemmap_tails;
 #endif
 } ____cacheline_internodealigned_in_smp;
@@ -2014,7 +2014,7 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	/*
 	 * Normally, sections hold regular (order-0) pages. However, for
 	 * sections with HVO enabled, this tracks the compound page order
--- a/include/linux/page-flags.h~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/include/linux/page-flags.h
@@ -208,14 +208,13 @@ enum pageflags {
 static __always_inline bool compound_info_has_mask(void)
 {
 	/*
-	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
-	 * makes a difference.
+	 * Limit mask usage to HVO where it makes a difference.
 	 *
 	 * The approach with mask would work in the wider set of conditions,
 	 * but it requires validating that struct pages are naturally aligned
 	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
 	 */
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
--- a/mm/Kconfig~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/mm/Kconfig
@@ -461,6 +461,10 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config VMEMMAP_OPTIMIZATION
+	bool
+	depends on SPARSEMEM_VMEMMAP
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -1220,6 +1224,7 @@ config ZONE_DMA32
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
 	depends on MEMORY_HOTREMOVE
+	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	select XARRAY_MULTI
 
 	help
--- a/mm/sparse.h~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/mm/sparse.h
@@ -10,7 +10,7 @@
 
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
 	return section->compound_page_order;
@@ -75,7 +75,7 @@ static inline bool vmemmap_optimizable_p
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
@@ -142,7 +142,7 @@ static inline void sparse_sections_init(
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #endif
 void sparse_init_subsection_map(void);
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-introduce-config_vmemmap_optimization
+++ a/mm/sparse-vmemmap.c
@@ -169,7 +169,7 @@ static void * __meminit vmemmap_alloc_bl
 	return p;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 
 static __ref struct page **vmemmap_tails_alloc(struct zone *zone)
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

