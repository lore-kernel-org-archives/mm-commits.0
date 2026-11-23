Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403055;
	b=CUpvf7xPABE21IiNR9Miin55178A0bcJlNEPYY/Suuhot+gbzeS1A2hyc7tmz9MbYUPH
	 TsRPy7WVflRlrQGh0xgj3XEb5tGwJHjTmD3Nqb7H/JoGXoxC9P5bvGvO30h88EQXgg9hl
	 De5Jljr8scGk6/W/eaKgFY0SKiahsLg55ooakaxD5fExVZT9piqgb93fzb6snYvyrkbIj
	 73+m+HUa19V5AVqKmrzDgqXUVW0zITt3T5zdW9HLYl8vz31Z74vTZ0Rmq9kjAA0JnLxHu
	 kY34jYTeVpGlvjmBngHyzYBVFmbT3xYHWmElPbhunXUSNNpHCUc9uSGb2y0XWPKXzXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403055;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=vrY5uhz5A96pOoEUwdFr1T5opYuMbAXCcEVN4GMimsg=;
	b=FWIpMPGmQ68kgGDRCcHisZrN2g0gmlwxOsyrIFd6fhw0HKovT2zquoKGlx0wp+aD/Gia
	 Gj1Q+lsMPMy5GxM4Iacn349ZxNWq3/BWkS4Hep9MLGygQuUWFp35bo5b9BAQHeBWGj1RD
	 jvI2bgsitOjkY6IjTYfcVxajgFigWF0emjrxUqzY+N0iw/QUcn/Ah+64iUv7FgTDfjaNF
	 sjtFS/VbrlT8jhJNRaHduRv7hz7HkvKbdqZ72kVfEemrh6rvjf8ClnDQza7c9IyHaqDnj
	 7Fp4ZChlzUADbcDoP7Ntvgxs/VfWFsNLfA2Vhqwj5TIA4GPGKjilhDKCG1jrF2hbHyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QalCIPqo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B17E606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QalCIPqo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E61F000C0;
	Mon, 23 Nov 2026 03:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403054;
	bh=vrY5uhz5A96pOoEUwdFr1T5opYuMbAXCcEVN4GMimsg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=QalCIPqoTGUNJstfxWp8d9nsPGTH90f5acPj0n7KLxg0PsVH6vre5pudFb47BbzCG
	 XGSbNfqCS0dtRvlKIwW5iV34T+SAR3aXhrZ8qd72oqZj0x//2StzkIYGVShZAbr9aS
	 kcBO4uOFpaqmdElT92RmnG1caYBXIm5oBI26N4IA=
Date: Sun, 22 Nov 2026 19:04:14 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-6-songmuchun@bytedance.com>
References: <20261120100856.16929-6-songmuchun@bytedance.com>
Subject: + mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch added to mm-new branch
Message-Id: <20261123030414.A31E61F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: drop boot-time HVO handling for gigantic folios
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch

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
Subject: mm/hugetlb: drop boot-time HVO handling for gigantic folios
Date: Fri, 20 Nov 2026 18:08:50 +0800

HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
section size, so the existing section-based vmemmap optimization
infrastructure is already sufficient to cover the whole folio.  On
LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.

Therefore, boot-time HugeTLB HVO folios can rely on the section-based
vmemmap optimization infrastructure directly, without the extra bulk
optimization and fallback handling.

Link: https://patch.msgid.link/20261120100856.16929-6-songmuchun@bytedance.com
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

 mm/hugetlb.c         |   25 +++++++------------------
 mm/hugetlb_vmemmap.c |   19 +------------------
 2 files changed, 8 insertions(+), 36 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios
+++ a/mm/hugetlb.c
@@ -3402,21 +3402,7 @@ static void __init prep_and_add_bootmem_
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
 
-	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_folios(h, folio_list);
-
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * If HVO fails, initialize all tail struct pages
-			 * We do not worry about potential long lock hold
-			 * time as this is early in boot and there should
-			 * be no contention.
-			 */
-			hugetlb_folio_init_tail_vmemmap(folio, h,
-					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
-					pages_per_huge_page(h));
-		}
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
@@ -3440,6 +3426,8 @@ static void __init gather_bootmem_preall
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
 		/*
@@ -3453,13 +3441,14 @@ static void __init gather_bootmem_preall
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
-		hugetlb_folio_init_vmemmap(folio, h,
-					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
+		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+		hugetlb_folio_init_vmemmap(folio, h, nr_struct_pages);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
+		section_set_compound_order_range(pfn, nr_pages, 0);
 
 		list_add(&folio->lru, &folio_list);
 
@@ -3474,7 +3463,7 @@ static void __init gather_bootmem_preall
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
 		else
-			adjust_managed_page_count(page, pages_per_huge_page(h));
+			adjust_managed_page_count(page, nr_pages);
 		cond_resched();
 	}
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios
+++ a/mm/hugetlb_vmemmap.c
@@ -565,7 +565,6 @@ static int hugetlb_vmemmap_pteify_folio(
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
@@ -574,18 +573,7 @@ void hugetlb_vmemmap_optimize_folios(str
 
 	down_write(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret;
-
-		/*
-		 * Bootmem gigantic folios may already be marked optimized when
-		 * their vmemmap layout was prepared earlier, so skip them here.
-		 */
-		if (folio_test_hugetlb_vmemmap_optimized(folio))
-			continue;
-
-		nr_to_optimize++;
-
-		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
+		int ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
@@ -597,11 +585,6 @@ void hugetlb_vmemmap_optimize_folios(str
 			break;
 	}
 
-	if (!nr_to_optimize) {
-		up_write(&vmemmap_remap_rwsem);
-		return;
-	}
-
 	flush_tlb_all();
 	downgrade_write(&vmemmap_remap_rwsem);
 
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

