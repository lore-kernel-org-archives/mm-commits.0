Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1B13B7AE
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434832; cv=none; b=Xp+JISOZoCzA5aMhqCcFtytSJDVi3TNxJaWTyk9uoZS7o4GGh/F98Pr3I6844MCFYFwSq9gWulgKpKqMsqA7EOl1fWqGslgFmXsSTZ15qiwyVapgYzTo4cYjG8T7VIIIQJLukvO4cZMyRtvnXka6lwMKLjyvJaj5Tfnpww3sZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434832; c=relaxed/simple;
	bh=g1XCD95+8FzRqkoufQRUwynJ3jRgcc2URPABAu7xYlQ=;
	h=Date:To:From:Subject:Message-Id; b=YUnlFCxRU2+g0QR7yEsQNHXvtQfrnFz1cKU3qvStqk/Kn04HX0jwvRx/liMCD1oVlWvT+8yiYdK2UeMsg8UUmAUf441CmIzikT1uGE/x9AoUfl9fssfTCxSzolYX72KX0XmM5L9WxVKysMavDWCQ8h3viiTUSGr0aDL9WAnRAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ebc83gHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebc83gHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAAC1F00A3A;
	Fri, 26 Jun 2026 00:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434830;
	bh=r/GvJK2bNGdojYy0uxeLTxSi4nBaye39ujSgONDGm5A=;
	h=Date:To:From:Subject;
	b=ebc83gHtKGOR/zOfIiSLKBkpItqlul0uE1cklHhqCNTqMqmwmIk0EHted/4Qi0VrZ
	 O6i1RV2HQ1Vg/R5Ck2nis/Fmi2N/naLIQQTPCe8fPA+/XRJMhVgTabIMDA190o+sBg
	 2mGotAszjemtvw+WEasIhtxrHPzWn0E5sEMsSra0=
Date: Thu, 25 Jun 2026 17:47:10 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch added to mm-new branch
Message-Id: <20260626004710.8FAAC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: fix wrong addr_pfn tracking in compound vmemmap population
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch

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
Subject: powerpc/mm: fix wrong addr_pfn tracking in compound vmemmap population
Date: Fri, 12 Jun 2026 11:58:47 +0800

vmemmap_populate_compound_pages() uses addr_pfn to determine the PFN
offset within a compound page and to decide whether the current vmemmap
slot should be populated as a head page mapping or should reuse a tail
page mapping.

However, addr_pfn is advanced manually in parallel with addr.  The loop
itself progresses in vmemmap address space, so each PAGE_SIZE step in addr
covers PAGE_SIZE / sizeof(struct page) struct page slots.  Since addr_pfn
is compared against nr_pages in data-PFN units, it should advance by the
same number of PFNs.  The existing manual increments do not match that and
therefore do not reliably track the PFN corresponding to the current addr.

As a result, pfn_offset can be computed from the wrong PFN and the code
can make the head/tail decision for the wrong compound-page position.

Fix this by deriving addr_pfn directly from the current vmemmap address
instead of carrying it as loop state.

Link: https://lore.kernel.org/20260612035903.2468601-4-songmuchun@bytedance.com
Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1314,7 +1314,6 @@ int __meminit vmemmap_populate_compound_
 	 * covering out both edges.
 	 */
 	unsigned long addr;
-	unsigned long addr_pfn = start_pfn;
 	unsigned long next;
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1335,7 +1334,6 @@ int __meminit vmemmap_populate_compound_
 
 		if (pmd_leaf(READ_ONCE(*pmd))) {
 			/* existing huge mapping. Skip the range */
-			addr_pfn += (PMD_SIZE >> PAGE_SHIFT);
 			next = pmd_addr_end(addr, end);
 			continue;
 		}
@@ -1348,11 +1346,11 @@ int __meminit vmemmap_populate_compound_
 			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
 			 * this request fall in those pages.
 			 */
-			addr_pfn += 1;
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
 			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
 			pte_t *tail_page_pte;
 
@@ -1376,7 +1374,6 @@ int __meminit vmemmap_populate_compound_
 				if (!pte)
 					return -ENOMEM;
 
-				addr_pfn += 2;
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
@@ -1392,7 +1389,6 @@ int __meminit vmemmap_populate_compound_
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				addr_pfn += 1;
 				next = addr + PAGE_SIZE;
 				continue;
 			}
@@ -1402,7 +1398,6 @@ int __meminit vmemmap_populate_compound_
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-			addr_pfn += 1;
 			next = addr + PAGE_SIZE;
 			continue;
 		}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

