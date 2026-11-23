Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403058;
	b=vqvDguHpElYEhMzzFiar49znpfmGSReM1llSAzzkgSNkfw/3oBWkXb8aAOlgPxzroV1G
	 Yk9ZiBOG6ddMAMeRqEGpwPddunSd8GsBRsSoD7xudzVfIujwA2Jal3jZUx+BHhZXRxTcp
	 TyYM8UlO5AG6uUvLbhUYE1JiOIl5WznADDOiOO2X17gxISELL6X5h5USataowesYz8pwN
	 KcPIMGV67AT0WV+oILE7ugJsjJEkpPQCj7Ea+ZWx4EUs+nG3WwJqBUVbmVonXeFtWK9c7
	 xfyj2JePrEVclrHNL+zt5GlewqYEQ2u++4nsTx51aP2/6aEiCrXtIUzYNi8IsJy/tfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403058;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=j+NdnE/fjPE4SIXEaoG0K9HW9W8NnOolTXyLs0J+ufU=;
	b=NZ5+ejoBrW79Jrah/yVhEIS7J8f6QsuK8brpbiP8kbt0ApVGf/v+KlSbRaUqYCpEv35C
	 wmViwa9l15an+y3wlAgqB4D2P0t3KvNCbAiLOx50cbP5s9kcBgoPtcruTBrzUE6uYnR4D
	 qBF+GQo76G5zLFqd+ciXQUbjLuEpeVhDBH+IGHScGtXc8HeXq2st638G6hA62dd5Codbx
	 o9RbtqQ3MovxCy/L+iELAbI/xF9vVj5d9XT96qHJckmspr6Ah0ssrKVrVG4OOum0Blp/j
	 1t5eK74AEvj2WC9FYp55BOfACRCK4Rk/yXyhwmrBGKsNcaEswEHsIyJU9TC1DIScrng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FGMcRvpq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B37C606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FGMcRvpq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC441F000C6;
	Mon, 23 Nov 2026 03:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403057;
	bh=j+NdnE/fjPE4SIXEaoG0K9HW9W8NnOolTXyLs0J+ufU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=FGMcRvpqWQWxjhxicFPI9S+jLEordtU/RAP5eUNKSH2LZSOF+XilUCndnGMp2NTnE
	 8YblG0N+m8tAkRNQ+kobi1ZDnP5pIYfzR/hh4cW+q1zxfyBJjkdlb03kgcyduFURPS
	 uicfRQmQoU8q6B79/x+bSQTMr+dI9WBD+bwN7wc0=
Date: Sun, 22 Nov 2026 19:04:17 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-7-songmuchun@bytedance.com>
References: <20261120100856.16929-7-songmuchun@bytedance.com>
Subject: + mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch added to mm-new branch
Message-Id: <20261123030417.7DC441F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: initialize all struct pages for bootmem hugepages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch

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
Subject: mm/hugetlb: initialize all struct pages for bootmem hugepages
Date: Fri, 20 Nov 2026 18:08:51 +0800

Boot-time gigantic hugepages currently leave the head struct page to
the generic memmap initialization path while the HugeTLB code
initializes the remaining struct pages itself.

Mark the full hugepage noinit and initialize the head struct page in
hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
is handled in one place.

This can also reduce memblock metadata overhead when many boot-time
HugeTLB pages are reserved, because physically contiguous hugepages
can be covered by fewer noinit regions.

Link: https://patch.msgid.link/20261120100856.16929-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/hugetlb.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages
+++ a/mm/hugetlb.c
@@ -3313,15 +3313,7 @@ static bool __init alloc_bootmem_huge_pa
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
 		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
-		/*
-		 * Only initialize the head struct page in memmap_init_reserved_pages,
-		 * rest of the struct pages will be initialized by the HugeTLB
-		 * subsystem itself.
-		 * The head struct page is used to get folio information by the HugeTLB
-		 * subsystem like zone id and node id.
-		 */
-		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
-				huge_page_size(h) - PAGE_SIZE);
+		memblock_reserved_mark_noinit(__pa(m), huge_page_size(h));
 	}
 
 	return true;
@@ -3352,22 +3344,23 @@ static void __init hugetlb_folio_init_ta
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
+					      unsigned long pfn,
 					      struct hstate *h,
+					      enum zone_type zone, int nid,
 					      unsigned long nr_pages)
 {
-	int ret;
+	struct page *head = &folio->page;
 
 	/*
 	 * This is an open-coded prep_compound_page() whereby we avoid
 	 * walking pages twice by initializing/preparing+freezing them in the
 	 * same go.
 	 */
-	__folio_clear_reserved(folio);
+	__init_single_page(head, pfn, zone, nid);
 	__folio_set_head(folio);
-	ret = folio_ref_freeze(folio, 1);
-	VM_BUG_ON(!ret);
+	set_page_count(head, 0);
 	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(&folio->page, huge_page_order(h));
+	prep_compound_head(head, huge_page_order(h));
 }
 
 /*
@@ -3425,8 +3418,9 @@ static void __init gather_bootmem_preall
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
-		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
 		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
@@ -3439,11 +3433,10 @@ static void __init gather_bootmem_preall
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-		WARN_ON(folio_ref_count(folio) != 1);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, h, nr_struct_pages);
+		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
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

