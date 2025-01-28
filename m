Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8117C18A6A6
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738023018; cv=none; b=YMsS8OTz8F813/iSrOggW3ljpIcPar+mKLWyu5RIGCUMs0aCfeFRlHf7XOOPNi9I5su1/3Q2PRYQF69Cb83rt321HQrDIMbbSNQVwDfwaKquXS7WCboMWmB1wnt68w+MSqaoUr2dgRAlL3kXZfXxnihM4dtuvr8iw2nL+EDuhxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738023018; c=relaxed/simple;
	bh=wMK9d9lyTMlOn7pEr0XdluGp9ssDKyrIzkhrAqYTunQ=;
	h=Date:To:From:Subject:Message-Id; b=mS1b2eR8Dt6pJUA3CZ8ravciob2Q2vOmQxdXGjBYdV9YOJmF/gzTGe3E6gKSzltN0bS1GNbmKlzYVKmM4BrzCZl3J9GplRkYdZfWUvCwzhh4qvYPFpgzBX1xFF9D7vPhTAh0/7fbHFKE7BIhhveDdUtugs2pPQZx06EFAgtQy2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rb19lcpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rb19lcpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FD3C4CED2;
	Tue, 28 Jan 2025 00:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738023018;
	bh=wMK9d9lyTMlOn7pEr0XdluGp9ssDKyrIzkhrAqYTunQ=;
	h=Date:To:From:Subject:From;
	b=rb19lcpP9N9oD+Dhx1n78TPMxg/rwaPYGPZt38xzUEeL63+VXy6OaXioR5tvdpjsM
	 GZlf0P/m4pOBKPko3GSFFPHiD8fm3hkLxu31qF2MoxW/xhP8qvUB9mUCe6/6Qzew7R
	 95X7cr5LMfc1PP7sgfQy0TZ03oOTaM/G/iqma79s=
Date: Mon, 27 Jan 2025 16:10:17 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usama.arif@bytedance.com,rppt@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch added to mm-unstable branch
Message-Id: <20250128001017.E6FD3C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: do pre-HVO for bootmem allocated pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: do pre-HVO for bootmem allocated pages
Date: Mon, 27 Jan 2025 23:22:00 +0000

For large systems, the overhead of vmemmap pages for hugetlb is
substantial.  It's about 1.5% of memory, which is about 45G for a 3T
system.  If you want to configure most of that system for hugetlb (e.g. 
to use as backing memory for VMs), there is a chance of running out of
memory on boot, even though you know that the 45G will become available
later.

To avoid this scenario, and since it's a waste to first allocate and then
free that 45G during boot, do pre-HVO for hugetlb bootmem allocated pages
('gigantic' pages).

pre-HVO is done by adding functions that are called from
sparse_init_nid_early and sparse_init_nid_late.  The first is called
before memmap allocation, so it takes care of allocating memmap HVO-style.
The second verifies that all bootmem pages look good, specifically it
checks that they do not intersect with multiple zones.  This can only be
done from sparse_init_nid_late path, when zones have been initialized.

The hugetlb page size must be aligned to the section size, and aligned to
the size of memory described by the number of page structures contained in
one PMD (since pre-HVO is not prepared to split PMDs).  This should be
true for most 'gigantic' pages, it is for 1G pages on x86, where both of
these alignment requirements are 128M.

This will only have an effect if hugetlb_bootmem_alloc was called early in
boot.  If not, it won't do anything, and HVO for bootmem hugetlb pages
works as before.

Link: https://lkml.kernel.org/r/20250127232207.3888640-21-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 
 mm/hugetlb.c            |    4 -
 mm/hugetlb_vmemmap.c    |  143 ++++++++++++++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.h    |    6 +
 mm/sparse-vmemmap.c     |    4 +
 5 files changed, 157 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages
+++ a/include/linux/hugetlb.h
@@ -687,6 +687,8 @@ struct huge_bootmem_page {
 #define HUGE_BOOTMEM_HVO		0x0001
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
 
+bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
+
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
--- a/mm/hugetlb.c~mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages
+++ a/mm/hugetlb.c
@@ -3311,8 +3311,8 @@ static void __init prep_and_add_bootmem_
 	}
 }
 
-static bool __init hugetlb_bootmem_page_zones_valid(int nid,
-						    struct huge_bootmem_page *m)
+bool __init hugetlb_bootmem_page_zones_valid(int nid,
+					     struct huge_bootmem_page *m)
 {
 	unsigned long start_pfn;
 	bool valid;
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -743,6 +743,149 @@ void hugetlb_vmemmap_optimize_bootmem_fo
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
+
+/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
+static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
+{
+	unsigned long section_size, psize, pmd_vmemmap_size;
+	phys_addr_t paddr;
+
+	if (!READ_ONCE(vmemmap_optimize_enabled))
+		return false;
+
+	if (!hugetlb_vmemmap_optimizable(m->hstate))
+		return false;
+
+	psize = huge_page_size(m->hstate);
+	paddr = virt_to_phys(m);
+
+	/*
+	 * Pre-HVO only works if the bootmem huge page
+	 * is aligned to the section size.
+	 */
+	section_size = (1UL << PA_SECTION_SHIFT);
+	if (!IS_ALIGNED(paddr, section_size) ||
+	    !IS_ALIGNED(psize, section_size))
+		return false;
+
+	/*
+	 * The pre-HVO code does not deal with splitting PMDS,
+	 * so the bootmem page must be aligned to the number
+	 * of base pages that can be mapped with one vmemmap PMD.
+	 */
+	pmd_vmemmap_size = (PMD_SIZE / (sizeof(struct page))) << PAGE_SHIFT;
+	if (!IS_ALIGNED(paddr, pmd_vmemmap_size) ||
+	    !IS_ALIGNED(psize, pmd_vmemmap_size))
+		return false;
+
+	return true;
+}
+
+/*
+ * Initialize memmap section for a gigantic page, HVO-style.
+ */
+void __init hugetlb_vmemmap_init_early(int nid)
+{
+	unsigned long psize, paddr, section_size;
+	unsigned long ns, i, pnum, pfn, nr_pages;
+	unsigned long start, end;
+	struct huge_bootmem_page *m = NULL;
+	void *map;
+
+	/*
+	 * Noting to do if bootmem pages were not allocated
+	 * early in boot, or if HVO wasn't enabled in the
+	 * first place.
+	 */
+	if (!hugetlb_bootmem_allocated())
+		return;
+
+	if (!READ_ONCE(vmemmap_optimize_enabled))
+		return;
+
+	section_size = (1UL << PA_SECTION_SHIFT);
+
+	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+		if (!vmemmap_should_optimize_bootmem_page(m))
+			continue;
+
+		nr_pages = pages_per_huge_page(m->hstate);
+		psize = nr_pages << PAGE_SHIFT;
+		paddr = virt_to_phys(m);
+		pfn = PHYS_PFN(paddr);
+		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + nr_pages * sizeof(struct page);
+
+		if (vmemmap_populate_hvo(start, end, nid,
+					HUGETLB_VMEMMAP_RESERVE_SIZE) < 0)
+			continue;
+
+		memmap_boot_pages_add(HUGETLB_VMEMMAP_RESERVE_SIZE / PAGE_SIZE);
+
+		pnum = pfn_to_section_nr(pfn);
+		ns = psize / section_size;
+
+		for (i = 0; i < ns; i++) {
+			sparse_init_early_section(nid, map, pnum,
+					SECTION_IS_VMEMMAP_PREINIT);
+			map += section_map_size();
+			pnum++;
+		}
+
+		m->flags |= HUGE_BOOTMEM_HVO;
+	}
+}
+
+void __init hugetlb_vmemmap_init_late(int nid)
+{
+	struct huge_bootmem_page *m, *tm;
+	unsigned long phys, nr_pages, start, end;
+	unsigned long pfn, nr_mmap;
+	struct hstate *h;
+	void *map;
+
+	if (!hugetlb_bootmem_allocated())
+		return;
+
+	if (!READ_ONCE(vmemmap_optimize_enabled))
+		return;
+
+	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
+		if (!(m->flags & HUGE_BOOTMEM_HVO))
+			continue;
+
+		phys = virt_to_phys(m);
+		h = m->hstate;
+		pfn = PHYS_PFN(phys);
+		nr_pages = pages_per_huge_page(h);
+
+		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
+			/*
+			 * Oops, the hugetlb page spans multiple zones.
+			 * Remove it from the list, and undo HVO.
+			 */
+			list_del(&m->list);
+
+			map = pfn_to_page(pfn);
+
+			start = (unsigned long)map;
+			end = start + nr_pages * sizeof(struct page);
+
+			vmemmap_undo_hvo(start, end, nid,
+					 HUGETLB_VMEMMAP_RESERVE_SIZE);
+			nr_mmap = end - start - HUGETLB_VMEMMAP_RESERVE_SIZE;
+			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
+
+			memblock_phys_free(phys, huge_page_size(h));
+			continue;
+		} else
+			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+	}
+}
+#endif
+
 static struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
 		.procname	= "hugetlb_optimize_vmemmap",
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -9,6 +9,8 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
+#include <linux/io.h>
+#include <linux/memblock.h>
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -25,6 +27,10 @@ long hugetlb_vmemmap_restore_folios(cons
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
+void hugetlb_vmemmap_init_early(int nid);
+void hugetlb_vmemmap_init_late(int nid);
+#endif
 
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
--- a/mm/sparse-vmemmap.c~mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages
+++ a/mm/sparse-vmemmap.c
@@ -32,6 +32,8 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
+#include "hugetlb_vmemmap.h"
+
 /*
  * Flags for vmemmap_populate_range and friends.
  */
@@ -594,6 +596,7 @@ struct page * __meminit __populate_secti
  */
 void __init sparse_vmemmap_init_nid_early(int nid)
 {
+	hugetlb_vmemmap_init_early(nid);
 }
 
 /*
@@ -604,5 +607,6 @@ void __init sparse_vmemmap_init_nid_earl
  */
 void __init sparse_vmemmap_init_nid_late(int nid)
 {
+	hugetlb_vmemmap_init_late(nid);
 }
 #endif
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch

