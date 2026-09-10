Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5A93876DF
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081547; cv=none; b=pzLR96dIX2PZ9FRzP5seN/OR0e++8FeF1BJcXKWg1JKe1h6TBBrg3XBUN++ywALKnoaGNrpjTuCGtnUQZK5AvX83HIx1rIzxck1f37ZdOn9BPCY3uk3pW3tE4n9PWyKuPfFAvqiXJIsKsah/J8G/cuMbD9WMQN+CY1SGKTx7/YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081547; c=relaxed/simple;
	bh=/6U/1gebJvYjFbeyw3Mi8lNRhvX2wCuWG2I8S/turxs=;
	h=Date:To:From:Subject:Message-Id; b=hhfCs7f65CFoqmZoNuDDBDL3ANpOP84frH46XF4UvDMU1m00h9YgxO3nqfSn8s6yrGjW3ht7+ItaDVMQGESyNVZoGVco9QkcZDFj7pIoOd3sbDhHAvfSX2SabGuTH4TbF7xhSDInHbC7Q267M+pTM2XfdGQYeNbzas3ch6gb4UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=detktSf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="detktSf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D151F000FF;
	Thu, 10 Sep 2026 23:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081546;
	bh=3E5BLquTMaIzRohjliWTvCyVF4CC2nyYU5IjRVYGHQM=;
	h=Date:To:From:Subject;
	b=detktSf5uw/dGEJlU6nF8edTEyWgnjlviCzGQp/1ztV/v0gOCrkYj+3qxgZ1bXuJP
	 SmiiIFhNkn1hjk4Y25UFTsPRFUI9yFsKbQirUagVbM0aMr99qrEsIbxX2cr9AeQGeC
	 uOgAb9k1iOE4CQKHjoVmXdf9AtKV0zSVIXJylRk4=
Date: Thu, 10 Sep 2026 16:05:45 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-huge_bootmem_hvo.patch added to mm-unstable branch
Message-Id: <20260910230546.20D151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-huge_bootmem_hvo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-huge_bootmem_hvo.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Thu, 10 Sep 2026 14:32:53 +0800

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had already
gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the compound page order stored in section metadata.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state directly
when deciding whether to mark a folio as vmemmap-optimized.

Link: https://lore.kernel.org/20260910063256.64386-15-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++---
 mm/hugetlb.c            |   16 +++-------------
 mm/hugetlb_vmemmap.c    |    2 --
 3 files changed, 5 insertions(+), 18 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
--- a/mm/hugetlb.c~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/mm/hugetlb.c
@@ -3220,11 +3220,6 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3299,6 +3294,7 @@ static void __init gather_bootmem_preall
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
+		const unsigned long pfn = folio_pfn(folio);
 
 		h = m->hstate;
 		/*
@@ -3316,15 +3312,9 @@ static void __init gather_bootmem_preall
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_compound_order_range(folio_pfn(folio),
-						 folio_nr_pages(folio), 0);
+		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -715,8 +715,6 @@ void __init hugetlb_vmemmap_optimize_boo
 
 	section_set_compound_order_range(pfn, pages_per_huge_page(h),
 					 huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
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

