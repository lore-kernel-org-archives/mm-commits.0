Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DCE36A340
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081257; cv=none; b=hYHFgWcC6HqqMasASi+ZCRPYqTK3Zs1M5PdsC9jNm8REs2iLcLPtCevycfY8IozQT+L0Xe6Lqb1+5w+UblpRZcJnvFWpU7lowynI9UMDynCIgPgeMLAb0zDMVrbimjlqjJB/6e78aBqVGv3l8yKDM93rBh+9ycGEiIZ6j4Y0zBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081257; c=relaxed/simple;
	bh=zmzgG1GgO3p1WkRmSPrq/8dlVG5zVkk5yhPzTBMtAFQ=;
	h=Date:To:From:Subject:Message-Id; b=A0qmEJFEdguYg5hVGtZscxEpzonU+NYcYFRbtGyBIK3vQ2ExzVrAYaI/tRx6jWjGBOS4P35HQkewMoA6e1AisRCiI0X++Qfgc5MRGKC8qNE0H+cynSVxaYa6HQttIpVk53hTj6JNgjzkkzJP48ts4PrPAa4khH0lCaTdNP70PYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qm6tB8IY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qm6tB8IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97B91F00893;
	Thu, 10 Sep 2026 23:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081254;
	bh=YZw2QENgiaKVUI3d9EhpWSOLFNQgurBGW7odGbiCGfA=;
	h=Date:To:From:Subject;
	b=Qm6tB8IYeWj8s/SPoHV1kAnHsgG9uIohswRZnkPSKP57ua67eG0sMlySDVhdbuhbI
	 2/yLEI0zExhmPgMfRhbUNVPTH1PhK6ycs/Ublnexm0u4dVSh6g9F9G7KI7uBWnnD5/
	 zGnF+7a1HgPKMnQ2iKyREyJU2wV6sgH1CLh3IWSI=
Date: Thu, 10 Sep 2026 16:00:54 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-remove-section_map_size.patch removed from -mm tree
Message-Id: <20260910230054.C97B91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove section_map_size()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-section_map_size.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: remove section_map_size()
Date: Tue, 25 Aug 2026 16:46:04 +0800

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Link: https://lore.kernel.org/20260825084608.47437-14-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/sparse.c        |   15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~mm-sparse-remove-section_map_size
+++ a/include/linux/mm.h
@@ -5140,7 +5140,6 @@ static inline void print_vma_addr(char *
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
--- a/mm/sparse.c~mm-sparse-remove-section_map_size
+++ a/mm/sparse.c
@@ -209,23 +209,12 @@ void __init sparse_sections_init(void)
 		memory_present(nid, start, end);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long __init section_map_size(void)
-{
-	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
-}
-
-#else
-unsigned long __init section_map_size(void)
-{
-	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-}
-
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	unsigned long size = section_map_size();
+	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

