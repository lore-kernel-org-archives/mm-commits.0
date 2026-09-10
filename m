Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A70037F8C2
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081257; cv=none; b=LWXfo4tTAUYCpVqdAdEQ8KysGgm22J8Kp2vvBVvUJktRbyexjOsu14fPr4vkLhh9PBjo+l8pQxjxE77hNtH2sb8sG+JwaowpMyWx9anRs21aevFC0bIOV5ctQ85PsuXi2YJahlHJldsa+EyxDXM/sNVfIlTkDMHO78JIUUAxn98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081257; c=relaxed/simple;
	bh=yN10prKYoCSbhEKtUXDICrni/+rFxcQ7FPYlkQdb/0o=;
	h=Date:To:From:Subject:Message-Id; b=OTgvC0CBqssYHwfIK0t2hA2CH5j1RblQ0hur4uCbfYeWMZIlQe8ZkCI2Y2uHJFuPrKQ38KJ01+nBGahIFrFwNhy3jhDTN2EBKdSDdPiF34ajpYdwgw/vuy0S3D3jv/zicZIEsqID7IH4p6FPQaTG8FowTJ/Uezd1HnRLI5tNHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pDzIXCll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pDzIXCll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055E21F000FF;
	Thu, 10 Sep 2026 23:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081256;
	bh=btpXVsgaYrjHs2pPge/ACxH/9so6PMtYGaPldoJZDKI=;
	h=Date:To:From:Subject;
	b=pDzIXCllACf3Vtv3V4abQ+cSKpYnBepOoHC0gPo8YyebuvYVV7tFe83puLaxjx34r
	 BjFEp56E47e9mriqMRCKOGWsBTXgWaTuYK+qogq2J+9yxwzKKIra+VvumsctyITT5+
	 PmFuacuw97OnyhLydnTr+tmMf5SsPXgCK46ikNX8=
Date: Thu, 10 Sep 2026 16:00:55 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-remove-huge_bootmem_hvo.patch removed from -mm tree
Message-Id: <20260910230056.055E21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-huge_bootmem_hvo.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Tue, 25 Aug 2026 16:46:05 +0800

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had already
gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state directly
when deciding whether to mark a folio as vmemmap-optimized.

Link: https://lore.kernel.org/20260825084608.47437-15-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
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
 mm/hugetlb.c            |   12 +-----------
 mm/hugetlb_vmemmap.c    |    2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

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
@@ -3316,12 +3311,7 @@ static void __init gather_bootmem_preall
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_order(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -714,8 +714,6 @@ void __init hugetlb_vmemmap_optimize_boo
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

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

