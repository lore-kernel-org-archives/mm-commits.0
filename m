Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403061;
	b=FpeJDqlp2myZWK6hWxo4qZTyGbnSYL8pH3Wo8F9x6EVPHcqMZwzHrZ2zyf0RNx8az7jc
	 0HGSCvxsrWvJAHEayBbMqL2JpIV/8HEJ2mYBB1GF+DKBCTPLPmGBThrkbsZi0TwlL1uMD
	 yCZ1lW+KjBpNHyp11cyxY7EfTSrYa4+Fu8d7y9LkLRX0oi4+DaHLLmnx6L9+q3gPFeVa8
	 SaR2KCYHbbw273DRB6LrOZL9CqKjT4w9yq7hMLZUMgwdCRMk289PCo7LOCJpHg+bj0IEx
	 Hl+ES8cmY8TxFA0qzBhmz3tHUPOISYGKevMkxzNLgv8hY+aaTVy3cnrDBHEoFXy+59g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403061;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=qrK1tGYnnCnqaoLVODtI90CY0gEF+utte/nB/acpSBs=;
	b=lXRaOkh8VeRl6zn93J8a2+mS3lE2SB62csyNRiop5ziPjBfDM0OBnGZjfXIo1TF4xEaT
	 kL6LRoSe8BI/4rIY4RacoAQz+a3c1N6S9rau7FKV5xKyjRN1iutlx1RNmj+kzdIeA1Gm6
	 DZBpV5cVAr8PXKF8eS7ATmo5d2UI0oJaB74M6wPYmeVL4AdSsWR+qp1JJeTi/bGVoK3nE
	 ZjhGG9Dyu/GJEeiw4/ZGSjA56nmsMRkbWTD673BWsZD+zjyQ7sRoae3/jbOUQD9g/CAHY
	 El18pvEtN2a3Ag0x3CrLIMviLOIINSj2tTE34XWHx3+R1X6VZbEw4k2GSTdw7UDS3Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ANfz4rrN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C889606A334
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ANfz4rrN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2451F000D0;
	Mon, 23 Nov 2026 03:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403060;
	bh=qrK1tGYnnCnqaoLVODtI90CY0gEF+utte/nB/acpSBs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ANfz4rrN5TPSip7gNpDxf8edRBrb3f2LNLFqKW8/SKsp3jzfM125g3jC6s+hbPrHK
	 nSSfJ7cHhwyGJU+Esll6R5yAkDtmax9qjTkWB18LJXeK8oCOsY3SsBe0KjVCRwc4yu
	 hh1TczHpL2LeGD+06nSCQlsTAeUj6B5uskStVRd8=
Date: Sun, 22 Nov 2026 19:04:19 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-8-songmuchun@bytedance.com>
References: <20261120100856.16929-8-songmuchun@bytedance.com>
Subject: + mm-hugetlb-use-common-compound-page-initialization-helper.patch added to mm-new branch
Message-Id: <20261123030420.6A2451F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: use common compound page initialization helper
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-use-common-compound-page-initialization-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-common-compound-page-initialization-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/hugetlb: use common compound page initialization helper
Date: Fri, 20 Nov 2026 18:08:52 +0800

Boot-time gigantic hugetlb folios currently use a separate path to
initialize their compound struct pages.

Use memmap_init_compound_page() for these folios so that HugeTLB and
ZONE_DEVICE share the common compound page initialization path. This
removes the HugeTLB-specific implementation and improves initialization
performance.

ZONE_DEVICE initializes struct pages by walking one contiguous memory
range. Boot-time HugeTLB instead initializes multiple disjoint ranges,
one for each contiguous hugepage. Measurements showed that memcpy()
performed better than memcpy_nontemporal() for the latter access pattern.
Therefore, use memcpy() for normal memory while retaining
memcpy_nontemporal() for ZONE_DEVICE.

The initialization time for 64 boot-time 1G hugepages with 4K base
pages was measured as follows:

  arch    without this patch  with this patch  reduction
  x86-64          195.60 ms          170.40 ms      12.88%
  arm64           374.40 ms          237.60 ms      36.54%

Link: https://patch.msgid.link/20261120100856.16929-8-songmuchun@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Li Zhe <lizhe.67@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/hugetlb.c |   52 +------------------------------------------------
 mm/mm_init.c |   10 +++++----
 2 files changed, 8 insertions(+), 54 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-common-compound-page-initialization-helper
+++ a/mm/hugetlb.c
@@ -3319,50 +3319,6 @@ static bool __init alloc_bootmem_huge_pa
 	return true;
 }
 
-/* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
-static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-					struct hstate *h,
-					unsigned long start_page_number,
-					unsigned long end_page_number)
-{
-	enum zone_type zone = folio_zonenum(folio);
-	int nid = folio_nid(folio);
-	struct page *page = folio_page(folio, start_page_number);
-	unsigned long head_pfn = folio_pfn(folio);
-	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	unsigned int order = huge_page_order(h);
-
-	/*
-	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
-	 * we must initialize them ourselves here.
-	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
-}
-
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-					      unsigned long pfn,
-					      struct hstate *h,
-					      enum zone_type zone, int nid,
-					      unsigned long nr_pages)
-{
-	struct page *head = &folio->page;
-
-	/*
-	 * This is an open-coded prep_compound_page() whereby we avoid
-	 * walking pages twice by initializing/preparing+freezing them in the
-	 * same go.
-	 */
-	__init_single_page(head, pfn, zone, nid);
-	__folio_set_head(folio);
-	set_page_count(head, 0);
-	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(head, huge_page_order(h));
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3420,8 +3376,7 @@ static void __init gather_bootmem_preall
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
-		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
-		unsigned long nr_struct_pages = nr_pages;
+		const struct zone *zone = pfn_to_zone(pfn, nid);
 
 		h = m->hstate;
 		/*
@@ -3433,10 +3388,7 @@ static void __init gather_bootmem_preall
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-
-		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
+		memmap_init_compound_page(page, pfn, zone, huge_page_order(h));
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
--- a/mm/mm_init.c~mm-hugetlb-use-common-compound-page-initialization-helper
+++ a/mm/mm_init.c
@@ -722,16 +722,18 @@ static void __meminit memmap_init_page_f
 		unsigned long pfn, const struct zone *zone, struct page *template)
 {
 	/*
-	 * Refresh PFN-dependent fields in the template before the non-temporal
-	 * copy, so the destination page does not need cached stores after
-	 * memcpy_nontemporal().
+	 * Refresh PFN-dependent fields in the template before copying it, so
+	 * the destination page does not need follow-up stores.
 	 */
 	set_page_section_from_pfn(template, pfn);
 #ifdef WANT_PAGE_VIRTUAL
 	if (!is_highmem_idx(zone_idx(zone)))
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
-	memcpy_nontemporal(page, template, sizeof(*page));
+	if (zone_is_zone_device(zone))
+		memcpy_nontemporal(page, template, sizeof(*page));
+	else
+		memcpy(page, template, sizeof(*page));
 	vmemmap_optimization_verify_zone(page);
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

