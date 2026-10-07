Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C02D7DEF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334155; cv=none; b=BAze0thMLqkR/n6SRH0Re3DrMdvi62VMPHg9oE2MEMyKC5uSOqHy0qDv50O1oKX1c/ON1U7Or2tVzoO55SIIEhOi54FZ+UnXfJ8MbI4ImCB4HhNQGB0YksVqrP5CI+WrTS2f12tnZ+mNphbYl/mfjI9y+b5YYBxhbGwrBIx/+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334155; c=relaxed/simple;
	bh=+sR2KbZesEbXiEbAEfUqrfRFiTeU7Hm6qId1ItW0GJ8=;
	h=Date:To:From:Subject:Message-Id; b=FfzTQm3KgQiyj6n/kOeft2xhcnaAq3OBFqKhHd4i91tA+hnTdmaaMOvNRknUMLbIGq67i3mtS+GNtt5PzkksOG0ZdjuKaoca6dH5kLCjTepBXm6o2QZeZwTY5dvcwwszo77/i9givS5eAOw8JeUCvrE+lK2jm+0WkbFrjzL+vRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VtpTgSBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VtpTgSBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E231F0089B;
	Wed,  7 Oct 2026 00:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334153;
	bh=HEKr9B/5VYUEw7CH5ma9GJptt0BfKbY9ZsN+8mnxfeU=;
	h=Date:To:From:Subject;
	b=VtpTgSBghGKqerBmUjv59GIXtYzqJ8PA1Vz65R1gdTBwEI1IoDcDYy+v/b+JV4qlZ
	 FQxyCSmwvHbCuk7WePPpy8octXMGqVPfBCMMnzUi+yUUsISbZAdubLrWusmSgNuPI6
	 d64u3X13bCsyVIBzoD2XafNvAYBhuLCPAobcgXFc=
Date: Tue, 06 Oct 2026 17:49:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch removed from -mm tree
Message-Id: <20261007004913.73E231F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: support section-based vmemmap accounting
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: support section-based vmemmap accounting
Date: Thu, 10 Sep 2026 14:32:44 +0800

section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
but section-based vmemmap optimization stores the compound page order in
struct mem_section and retains a different number of vmemmap pages.

Teach section_nr_vmemmap_pages() to recognize section-based optimized
sections and calculate their vmemmap page count from the stored compound
page order and the HVO retained page count.

Link: https://lore.kernel.org/20260910063256.64386-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/mmzone.h |    6 ++++--
 mm/sparse-vmemmap.c    |   10 ++++++----
 mm/sparse.h            |   16 ++++++++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-support-section-based-vmemmap-accounting
+++ a/include/linux/mmzone.h
@@ -107,8 +107,10 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
--- a/mm/sparse.h~mm-sparse-vmemmap-support-section-based-vmemmap-accounting
+++ a/mm/sparse.h
@@ -43,6 +43,17 @@ static inline bool vmemmap_optimizable_p
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
 
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 /*
  * mm/sparse.c
  */
@@ -86,6 +97,11 @@ static inline size_t mem_section_usage_s
 	return struct_size_t(struct mem_section_usage, pageblock_flags,
 			     BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
 }
+
+static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
+{
+	return vmemmap_optimizable_order(section_compound_order(ms));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-support-section-based-vmemmap-accounting
+++ a/mm/sparse-vmemmap.c
@@ -649,24 +649,26 @@ void offline_mem_sections(unsigned long
 static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+		return vmemmap_pages * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return VMEMMAP_RESERVE_NR;
+		return vmemmap_pages;
 
 	return 0;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


