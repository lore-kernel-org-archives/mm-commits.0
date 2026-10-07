Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC762D8385
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334165; cv=none; b=GCvJ1pzCpBsuMmW59NRsZLDDS3Kv2Rt681G/K3pvOST3CS40/e3bFiQfuUHyUIgB7+K4Q42ZeBHXKh5Lrp+BhSuNJrd0+TSR4LXLKUBzm8q4SWT2pY0dO/cUhzFqe9Vi46ubfTrOH1HZK9qvh8Ub1u4mo816GTAjWxJg5ybuZno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334165; c=relaxed/simple;
	bh=OyBcnZmXFyMn4LTByuTtQUdM46Qc0/n8pMU+wsNyqgU=;
	h=Date:To:From:Subject:Message-Id; b=gzTLZfWTLTzMQPQGkLlJE1NctPSetM5M8RctihC/EDGpJ3Go5SuPGviYjFqsKtUFNeNQ88nUYbDCoZJitn6H2ilk32IllNvP4uQVPw87zHsP7COYZ+FnceBph+2nNulOTWsPuul6iUz1iKfSP3NC6Rk4gBYJDB0x7viutn1n4SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PwKlpYhQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PwKlpYhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C96A1F0089C;
	Wed,  7 Oct 2026 00:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334163;
	bh=nEigeIiePTqr9NLEs9MCTnrqo1q2YbQPzXpXABeTXwI=;
	h=Date:To:From:Subject;
	b=PwKlpYhQUQ1tPvpY4GJ1/RZ2Zn/AneQWiGCVnPZ1/VZr6VuWOeuo5O1Q7Gj6klIZM
	 woLo65R3OEdyWNhy8TueaZb3FhAczHPz9WnU6Dt9o6LjHXPE+wfeyhJ62s3+HfTISu
	 LRwzPbYRSdJRePtvP10pPH630dkduSSkW+aVHMaw=
Date: Tue, 06 Oct 2026 17:49:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch removed from -mm tree
Message-Id: <20261007004923.8C96A1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
Date: Thu, 10 Sep 2026 14:32:50 +0800

SPARSEMEM_VMEMMAP_PREINIT existed only to support HugeTLB's early vmemmap
optimization setup.

Now that HugeTLB bootmem vmemmap optimization uses the common
section-based sparse-vmemmap path, the sparse initialization code no
longer needs a separate pre-initialization mechanism for vmemmap
population.

Remove the related Kconfig symbols, section flag, and empty early hook, so
present sections always go through the normal sparse setup path.

Link: https://lore.kernel.org/20260910063256.64386-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 arch/x86/Kconfig       |    1 -
 fs/Kconfig             |    1 -
 include/linux/mmzone.h |   25 -------------------------
 mm/Kconfig             |    5 -----
 mm/sparse-vmemmap.c    |   13 -------------
 mm/sparse.c            |   23 ++++++++---------------
 6 files changed, 8 insertions(+), 60 deletions(-)

--- a/arch/x86/Kconfig~mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support
+++ a/arch/x86/Kconfig
@@ -150,7 +150,6 @@ config X86
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
-	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
--- a/fs/Kconfig~mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support
+++ a/fs/Kconfig
@@ -278,7 +278,6 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
-	select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
--- a/include/linux/mmzone.h~mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support
+++ a/include/linux/mmzone.h
@@ -2096,9 +2096,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 	SECTION_TAINT_ZONE_DEVICE_BIT,
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-	SECTION_IS_VMEMMAP_PREINIT_BIT,
-#endif
 	SECTION_MAP_LAST_BIT,
 };
 
@@ -2109,9 +2106,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 #define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-#define SECTION_IS_VMEMMAP_PREINIT	BIT(SECTION_IS_VMEMMAP_PREINIT_BIT)
-#endif
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
@@ -2166,24 +2160,6 @@ static inline int online_device_section(
 }
 #endif
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-static inline int preinited_vmemmap_section(const struct mem_section *section)
-{
-	return (section &&
-		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
-}
-
-void sparse_vmemmap_init_nid_early(int nid);
-#else
-static inline int preinited_vmemmap_section(const struct mem_section *section)
-{
-	return 0;
-}
-static inline void sparse_vmemmap_init_nid_early(int nid)
-{
-}
-#endif
-
 static inline int online_section_nr(unsigned long nr)
 {
 	return online_section(__nr_to_section(nr));
@@ -2385,7 +2361,6 @@ static inline unsigned long next_present
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
--- a/mm/Kconfig~mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support
+++ a/mm/Kconfig
@@ -461,8 +461,6 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_PREINIT
-	bool
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -473,9 +471,6 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
-config ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
-	bool
-
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
--- a/mm/sparse.c~mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support
+++ a/mm/sparse.c
@@ -283,27 +283,20 @@ static void __init sparse_init_nid(int n
 	if (sparse_usage_init(nid, map_count))
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	sparse_vmemmap_init_nid_early(nid);
-
 	for_each_present_section_nr(pnum_begin, pnum) {
-		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
+		struct page *map;
 
 		if (pnum >= pnum_end)
 			break;
 
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms)) {
-			struct page *map;
-
-			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-							nid, NULL, NULL);
-			if (!map)
-				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-								       NULL, NULL));
-			sparse_init_early_section(nid, map, pnum, 0);
-		}
+		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
+						nid, NULL, NULL);
+		if (!map)
+			panic("Failed to allocate memmap for section %lu\n", pnum);
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							       NULL, NULL));
+		sparse_init_early_section(nid, map, pnum, 0);
 	}
 	sparse_usage_fini();
 }
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support
+++ a/mm/sparse-vmemmap.c
@@ -594,19 +594,6 @@ struct page * __meminit __populate_secti
 	return pfn_to_page(pfn);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-/*
- * This is called just before initializing sections for a NUMA node.
- * Any special initialization that needs to be done before the
- * generic initialization can be done from here. Sections that
- * are initialized in hooks called from here will be skipped by
- * the generic initialization.
- */
-void __init sparse_vmemmap_init_nid_early(int nid)
-{
-}
-#endif
-
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 		unsigned long nr_pages)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


