Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9228030595C
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388640; cv=none; b=shgpPHr4Nj+00Gm4aC6ttW9x9qfglJSTXe42dy5qAKGjPCOi3rdaQGf5vMrlRlgEkHsQcwg0pb5t1l0i8axSFayyBK7fb5CZABkFCFzT7pPwaQiuIU0XphEdDCJO8HwDVUxe+hV+QRxlXiToPZoFzzh8rUajjqiCDYwey68wVvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388640; c=relaxed/simple;
	bh=XYZusy228G8ukABSAipNLzKSWJcV6Hzk6+yT0mabc9k=;
	h=Date:To:From:Subject:Message-Id; b=DxZlu1LuvyxZALXAHaJWztWnBiMS6TlVUbWCsTP8tOHXLdWi9K3vsJ/ILz/tVHbiqtrnzyJKkSfaUAdN+haqmIUn2ZrgkS9mDLQYItk7OzVm2nJdegFIFffuqZ80kt1mt0V9osEyCVV0qe4QsyCrBw/2WtkP47AH/rm8JNv2URs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NOXQhX7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NOXQhX7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B375C2BC9E;
	Tue, 24 Mar 2026 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388640;
	bh=XYZusy228G8ukABSAipNLzKSWJcV6Hzk6+yT0mabc9k=;
	h=Date:To:From:Subject:From;
	b=NOXQhX7ctnapvt+l9+tUc5szpHeQ0R2fvkD0Pbq2SOfO4oaf5+HFVOikZbtcA51N4
	 QWbl2zGt5w4kJ1K+XjU2DFCOEEAFNYRCMYL4BpiglMmWeavmANV6R2RYmqlapa0TK1
	 STtK3QI29euUeSZKEixxp+3ByQmdTfwC/iFaCI/o=
Date: Tue, 24 Mar 2026 14:43:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch removed from -mm tree
Message-Id: <20260324214400.6B375C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: defer vmemmap population for bootmem hugepages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/hugetlb: defer vmemmap population for bootmem hugepages
Date: Fri, 27 Feb 2026 19:42:47 +0000

Currently, the vmemmap for bootmem-allocated gigantic pages is populated
early in hugetlb_vmemmap_init_early().  However, the zone information is
only available after zones are initialized.  If it is later discovered
that a page spans multiple zones, the HVO mapping must be undone and
replaced with a normal mapping using vmemmap_undo_hvo().

Defer the actual vmemmap population to hugetlb_vmemmap_init_late().  At
this stage, zones are already initialized, so it can be checked if the
page is valid for HVO before deciding how to populate the vmemmap.

This allows us to remove vmemmap_undo_hvo() and the complex logic required
to rollback HVO mappings.

In hugetlb_vmemmap_init_late(), if HVO population fails or if the zones
are invalid, fall back to a normal vmemmap population.

Postponing population until hugetlb_vmemmap_init_late() also makes zone
information available from within vmemmap_populate_hvo().

Link: https://lkml.kernel.org/r/20260227194302.274384-10-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    2 -
 mm/hugetlb_vmemmap.c |   37 +++++++++++++---------------
 mm/sparse-vmemmap.c  |   53 -----------------------------------------
 3 files changed, 18 insertions(+), 74 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages
+++ a/include/linux/mm.h
@@ -4474,8 +4474,6 @@ int vmemmap_populate(unsigned long start
 		struct vmem_altmap *altmap);
 int vmemmap_populate_hvo(unsigned long start, unsigned long end, int node,
 			 unsigned long headsize);
-int vmemmap_undo_hvo(unsigned long start, unsigned long end, int node,
-		     unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages
+++ a/mm/hugetlb_vmemmap.c
@@ -790,7 +790,6 @@ void __init hugetlb_vmemmap_init_early(i
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
-	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -808,14 +807,6 @@ void __init hugetlb_vmemmap_init_early(i
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (vmemmap_populate_hvo(start, end, nid,
-					HUGETLB_VMEMMAP_RESERVE_SIZE) < 0)
-			continue;
-
-		memmap_boot_pages_add(HUGETLB_VMEMMAP_RESERVE_SIZE / PAGE_SIZE);
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -850,28 +841,36 @@ void __init hugetlb_vmemmap_init_late(in
 		h = m->hstate;
 		pfn = PHYS_PFN(phys);
 		nr_pages = pages_per_huge_page(h);
+		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + nr_pages * sizeof(struct page);
 
 		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
 			/*
 			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and undo HVO.
+			 * Remove it from the list, and populate it normally.
 			 */
 			list_del(&m->list);
 
-			map = pfn_to_page(pfn);
-
-			start = (unsigned long)map;
-			end = start + nr_pages * sizeof(struct page);
-
-			vmemmap_undo_hvo(start, end, nid,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE);
-			nr_mmap = end - start - HUGETLB_VMEMMAP_RESERVE_SIZE;
+			vmemmap_populate(start, end, nid, NULL);
+			nr_mmap = end - start;
 			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
 
 			memblock_phys_free(phys, huge_page_size(h));
 			continue;
-		} else
+		}
+
+		if (vmemmap_populate_hvo(start, end, nid,
+					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
+			/* Fallback if HVO population fails */
+			vmemmap_populate(start, end, nid, NULL);
+			nr_mmap = end - start;
+		} else {
 			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
+		}
+
+		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
 	}
 }
 #endif
--- a/mm/sparse-vmemmap.c~mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages
+++ a/mm/sparse-vmemmap.c
@@ -303,59 +303,6 @@ int __meminit vmemmap_populate_basepages
 }
 
 /*
- * Undo populate_hvo, and replace it with a normal base page mapping.
- * Used in memory init in case a HVO mapping needs to be undone.
- *
- * This can happen when it is discovered that a memblock allocated
- * hugetlb page spans multiple zones, which can only be verified
- * after zones have been initialized.
- *
- * We know that:
- * 1) The first @headsize / PAGE_SIZE vmemmap pages were individually
- *    allocated through memblock, and mapped.
- *
- * 2) The rest of the vmemmap pages are mirrors of the last head page.
- */
-int __meminit vmemmap_undo_hvo(unsigned long addr, unsigned long end,
-				      int node, unsigned long headsize)
-{
-	unsigned long maddr, pfn;
-	pte_t *pte;
-	int headpages;
-
-	/*
-	 * Should only be called early in boot, so nothing will
-	 * be accessing these page structures.
-	 */
-	WARN_ON(!early_boot_irqs_disabled);
-
-	headpages = headsize >> PAGE_SHIFT;
-
-	/*
-	 * Clear mirrored mappings for tail page structs.
-	 */
-	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		pte_clear(&init_mm, maddr, pte);
-	}
-
-	/*
-	 * Clear and free mappings for head page and first tail page
-	 * structs.
-	 */
-	for (maddr = addr; headpages-- > 0; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		pfn = pte_pfn(ptep_get(pte));
-		pte_clear(&init_mm, maddr, pte);
-		memblock_phys_free(PFN_PHYS(pfn), PAGE_SIZE);
-	}
-
-	flush_tlb_kernel_range(addr, end);
-
-	return vmemmap_populate(addr, end, node, NULL);
-}
-
-/*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
  * memblock allocated gigantic pages. The write protect can't be
_

Patches currently in -mm which might be from kas@kernel.org are


