Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A0347276D
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 20:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222995; cv=none; b=lHcEIw7aMUGW15CcHJoJqc4tjwcrz3IqHLG+He3WIO0wKD1/KjtNzo5s9yOfNBF5CRB6Bwk7UNtdLWJNZFErscW4cq+RClndo7H7HsXPqcXPfV6DZUVR2JylMZKtge5RvCj+5/Q7gvNQbWoctj6rXspC6b5CqanQknma7X/7/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222995; c=relaxed/simple;
	bh=5N9ATerv0OaDW11j0jD0bDVQgayVJDS/nufTwYczaIo=;
	h=Date:To:From:Subject:Message-Id; b=NFysHvbE8SO7DgX1mH5b8HvvuabtzjDySJN2GBdfIv4hfLrAfNwTPsrMktBFxPYr3AEfKL0rcfezGdB46/kA5ovk8FyhD6MXFnkzL1gFQb5+pwz+eYN3xU3xhlgd6m+camZ1zYQypzDJLwFmTQBFrTF2RolZGlaZ+DOXLYf6EO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yrzB9l09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yrzB9l09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC82DC116C6;
	Fri, 27 Feb 2026 20:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772222994;
	bh=5N9ATerv0OaDW11j0jD0bDVQgayVJDS/nufTwYczaIo=;
	h=Date:To:From:Subject:From;
	b=yrzB9l09H1CQppvp/dGGOUcTtuTdAEhZBhjRnW/NrW04iWnE2vZTBGzlet3HAX46L
	 cAVnoCl0KBuVkkvCXOLAPW0j8EZd+5d1goA7ILMdLD4PMSr/b7Ow/TDneOZ0zyp3At
	 dcOqEoh9BmrIFuH355+5PJC4jjI6mcOMmFFUYC/0=
Date: Fri, 27 Feb 2026 12:09:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch added to mm-new branch
Message-Id: <20260227200954.CC82DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: defer vmemmap population for bootmem hugepages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
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

mm-move-max_folio_order-definition-to-mmzoneh.patch
mm-change-the-interface-of-prep_compound_tail.patch
mm-rename-the-compound_head-field-in-the-struct-page-to-compound_info.patch
mm-move-set-clear_compound_head-next-to-compound_head.patch
riscv-mm-align-vmemmap-to-maximal-folio-size.patch
loongarch-mm-align-vmemmap-to-maximal-folio-size.patch
mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch
mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch
mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch
mm-hugetlb-refactor-code-around-vmemmap_walk.patch
x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch
mm-hugetlb-remove-fake-head-pages.patch
mm-drop-fake-head-checks.patch
hugetlb-remove-vmemmap_synchronize_rcu.patch
mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch
mm-remove-the-branch-from-compound_head.patch
hugetlb-update-vmemmap_deduprst.patch
mm-slab-use-compound_head-in-page_slab.patch

