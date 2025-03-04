Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9815A18A6D3
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056559; cv=none; b=pQJC1rnv1FbSBNZCgf3beTsBmciSLJhDNr3e5S5dcJXI1r3vran7PgFkmkwYyZZ9hbsPBeDHQQEmw78LMjjiSnpeRbXcLbe9C/6U1dKVUPUrcYhzwhNTQGJDAN6HRvIAs5OAkHaFaLHbnuPx0zRhV0lJ+7pZO1uNLV7sbyytXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056559; c=relaxed/simple;
	bh=fa2n2gVV72TvWZUFU3dGn536DcDAs41OLb9cFySy5uU=;
	h=Date:To:From:Subject:Message-Id; b=JDZra5VPfjORwAkUA5OWScdbnp+1m7KtB1ZJo5SjDRJ96RREFxaHefJCWbfjplZ/MYCc3ytG08erjXHd/aa+NmjcRXEqzh5xA1gBHmxOU0YucbBTu0k+kERgsJztSGzP6+21g8Zk2ETQJjFnubwbtI77/83f6kYTvklBYEMWmAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WzVqiuJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WzVqiuJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4FDC4CEE4;
	Tue,  4 Mar 2025 02:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056559;
	bh=fa2n2gVV72TvWZUFU3dGn536DcDAs41OLb9cFySy5uU=;
	h=Date:To:From:Subject:From;
	b=WzVqiuJ07fYd4vmkMbtN7SpD7TaJaAVfqnXaGM1jCR7mWDTg9tjQJyNqWSHJPjRrM
	 4W2Sph+F2o5nh4DEJvynQ/A4uWObgWpRES4+ADmMfS2kWmJQiI7I/VPQPKJYvuiI2v
	 6Ca0prAko8PnC0QyKYaxbJ5La9MLZMrzaNcp7O6Q=
Date: Mon, 03 Mar 2025 18:49:18 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-pre-hvo-framework.patch added to mm-unstable branch
Message-Id: <20250304024919.6A4FDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: add pre-HVO framework
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-pre-hvo-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-pre-hvo-framework.patch

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
Subject: mm/hugetlb: add pre-HVO framework
Date: Fri, 28 Feb 2025 18:29:18 +0000

Define flags for pre-HVOed bootmem hugetlb pages, and act on them.

The most important flag is the HVO flag, signalling that a bootmem
allocated gigantic page has already been HVO-ed.  If this flag is seen by
the hugetlb bootmem gather code, the page is marked as HVO optimized.  The
HVO code will then not try to optimize it again.  Instead, it will just
map the tail page mirror pages read-only, completing the HVO steps.

No functional change, as nothing sets the flags yet.

Link: https://lkml.kernel.org/r/20250228182928.2645936-18-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    1 
 include/linux/hugetlb.h       |    4 ++
 mm/hugetlb.c                  |   24 ++++++++++++++-
 mm/hugetlb_vmemmap.c          |   50 ++++++++++++++++++++++++++++++--
 mm/hugetlb_vmemmap.h          |    7 ++++
 5 files changed, 83 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-add-pre-hvo-framework
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -113,6 +113,7 @@ static int __init pseries_alloc_bootmem_
 	gpage_freearray[nr_gpages] = 0;
 	list_add(&m->list, &huge_boot_pages[0]);
 	m->hstate = hstate;
+	m->flags = 0;
 	return 1;
 }
 
--- a/include/linux/hugetlb.h~mm-hugetlb-add-pre-hvo-framework
+++ a/include/linux/hugetlb.h
@@ -681,8 +681,12 @@ struct hstate {
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
+	unsigned long flags;
 };
 
+#define HUGE_BOOTMEM_HVO		0x0001
+#define HUGE_BOOTMEM_ZONES_VALID	0x0002
+
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
--- a/mm/hugetlb.c~mm-hugetlb-add-pre-hvo-framework
+++ a/mm/hugetlb.c
@@ -3223,6 +3223,7 @@ found:
 	INIT_LIST_HEAD(&m->list);
 	list_add(&m->list, &huge_boot_pages[node]);
 	m->hstate = h;
+	m->flags = 0;
 	return 1;
 }
 
@@ -3290,7 +3291,7 @@ static void __init prep_and_add_bootmem_
 	struct folio *folio, *tmp_f;
 
 	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_folios(h, folio_list);
+	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
@@ -3319,6 +3320,13 @@ static bool __init hugetlb_bootmem_page_
 	unsigned long start_pfn;
 	bool valid;
 
+	if (m->flags & HUGE_BOOTMEM_ZONES_VALID) {
+		/*
+		 * Already validated, skip check.
+		 */
+		return true;
+	}
+
 	start_pfn = virt_to_phys(m) >> PAGE_SHIFT;
 
 	valid = !pfn_range_intersects_zones(nid, start_pfn,
@@ -3351,6 +3359,11 @@ static void __init hugetlb_bootmem_free_
 	}
 }
 
+static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
+{
+	return (m->flags & HUGE_BOOTMEM_HVO);
+}
+
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_PAGE_ORDER) pages.
@@ -3391,6 +3404,15 @@ static void __init gather_bootmem_preall
 		hugetlb_folio_init_vmemmap(folio, h,
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(h, folio);
+
+		if (hugetlb_bootmem_page_prehvo(m))
+			/*
+			 * If pre-HVO was done, just set the
+			 * flag, the HVO code will then skip
+			 * this folio.
+			 */
+			folio_set_hugetlb_vmemmap_optimized(folio);
+
 		list_add(&folio->lru, &folio_list);
 
 		/*
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-add-pre-hvo-framework
+++ a/mm/hugetlb_vmemmap.c
@@ -649,14 +649,39 @@ static int hugetlb_vmemmap_split_folio(c
 	return vmemmap_remap_split(vmemmap_start, vmemmap_end, vmemmap_reuse);
 }
 
-void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
+static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
+					      struct list_head *folio_list,
+					      bool boot)
 {
 	struct folio *folio;
+	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
 
+	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = hugetlb_vmemmap_split_folio(h, folio);
+		int ret;
+		unsigned long spfn, epfn;
+
+		if (boot && folio_test_hugetlb_vmemmap_optimized(folio)) {
+			/*
+			 * Already optimized by pre-HVO, just map the
+			 * mirrored tail page structs RO.
+			 */
+			spfn = (unsigned long)&folio->page;
+			epfn = spfn + pages_per_huge_page(h);
+			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
+					HUGETLB_VMEMMAP_RESERVE_SIZE);
+			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
+					&folio->page,
+					HUGETLB_VMEMMAP_RESERVE_SIZE);
+			static_branch_inc(&hugetlb_optimize_vmemmap_key);
+			continue;
+		}
+
+		nr_to_optimize++;
+
+		ret = hugetlb_vmemmap_split_folio(h, folio);
 
 		/*
 		 * Spliting the PMD requires allocating a page, thus lets fail
@@ -668,6 +693,16 @@ void hugetlb_vmemmap_optimize_folios(str
 			break;
 	}
 
+	if (!nr_to_optimize)
+		/*
+		 * All pre-HVO folios, nothing left to do. It's ok if
+		 * there is a mix of pre-HVO and not yet HVO-ed folios
+		 * here, as __hugetlb_vmemmap_optimize_folio() will
+		 * skip any folios that already have the optimized flag
+		 * set, see vmemmap_should_optimize_folio().
+		 */
+		goto out;
+
 	flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
@@ -693,10 +728,21 @@ void hugetlb_vmemmap_optimize_folios(str
 		}
 	}
 
+out:
 	flush_tlb_all();
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
+void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
+{
+	__hugetlb_vmemmap_optimize_folios(h, folio_list, false);
+}
+
+void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list)
+{
+	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
+}
+
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
 		.procname	= "hugetlb_optimize_vmemmap",
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-add-pre-hvo-framework
+++ a/mm/hugetlb_vmemmap.h
@@ -24,6 +24,8 @@ long hugetlb_vmemmap_restore_folios(cons
 					struct list_head *non_hvo_folios);
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
+void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
+
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -64,6 +66,11 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
+static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
+						struct list_head *folio_list)
+{
+}
+
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
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
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

