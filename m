Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B12D5432
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334170; cv=none; b=NZMi+uesiBlOGe66FpoRf0ZotSksy0i0dRhuAdifl+U4AJEfVzgOvPZbu4a/qemiD49VVs5HVdHkGbHa9hHQ3uLApneTgwZaMUySGqpMMIf06cTQQS7l5WK+w6Q0n0g6fwrnRdeMljvsMF2thS/HFGHBkKI3HQMtKxVoctVZ2Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334170; c=relaxed/simple;
	bh=wePTaNd3vjGd8PeXqh9Ajj9apSZJaWEaulIEJj3pmBI=;
	h=Date:To:From:Subject:Message-Id; b=pmTOpO8+qULR0xJT/AW035mrVHvfrq0+NMeN18hSZPHx9tkRivFHPg7dcHp/gqDbYMTAM4WjJHDxakmPeKiLflVaT5d/EkdZh9BcNKIXxsmyuh0E6ReBfaazhnsYCwL1xYhcFAuP9MaMQJXubiGbheKSXiQJ0enLBLKRS1Pd2lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u0/AYK99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u0/AYK99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE161F0089C;
	Wed,  7 Oct 2026 00:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334166;
	bh=y+H4stBpYXIT+nl2USXt49Mys8T75SmKKQB0Wf37kMM=;
	h=Date:To:From:Subject;
	b=u0/AYK99KVuI8iJh4FTqD+Kwmm4PHkpYLZfjQK5P3zANLXRk1q1BhL+EtDKvNLhzH
	 N0s2sUu7rL6TmimDxgF+eYXrR52C1VFOPobVtCzf6nt9VC1VjwIYiZZGMEWosuEjDK
	 aIbzV1MWvjbt9xivfCTuWCkurGbuu+eJl04wOJ5w=
Date: Tue, 06 Oct 2026 17:49:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-section_map_size.patch removed from -mm tree
Message-Id: <20261007004926.7CE161F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove section_map_size()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-section_map_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: remove section_map_size()
Date: Thu, 10 Sep 2026 14:32:52 +0800

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Link: https://lore.kernel.org/20260910063256.64386-14-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -208,23 +208,12 @@ void __init sparse_sections_init(void)
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
+	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


