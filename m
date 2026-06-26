Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203EC20E023
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434862; cv=none; b=mtotcvE6wGIx2RFgcSiNahho7RlUMtGUKfOxrYtJn6swsTeB8HCWj/DYpACuJi7ABkSwrWpRy4rhe5/rB+v4zs5Uj5aoris9x/KYGnsCYHSBR2a0ML8fLm1iVlcyx1Nw4F9d8iu9wYqLJkY25Qf09yIuXpbwkkYj5Q39AbeF9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434862; c=relaxed/simple;
	bh=biKwU9DQgNb2lX+gVXQgXwD/7mJDCPK2l6N7emOIzNQ=;
	h=Date:To:From:Subject:Message-Id; b=IzyCrM6aj8m0tc/5y7JxPabgVMsOLfll2EQCYAHLJC8LYZvQsvuLo7ZParOi/YrZQpusIoyoKZEj0+uBJcp4sZwWeQ9CGvRqDof1s927FpPYjW0VZXDsZlcr8/4Uj9Fbfgpu/utAes2ztcOMgJc67indGz7H+msdMYdV3cq3V3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i8zLP9Pd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i8zLP9Pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98B11F000E9;
	Fri, 26 Jun 2026 00:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434861;
	bh=5+ry1vT6TIomF6u5coc6D08XaVhISNBehAJ8M/xv+pc=;
	h=Date:To:From:Subject;
	b=i8zLP9Pd1V3vvgHgiy1rvMQI7gYumM0Tmy5p4y/hWehLdMzsqAtSYMc2Hk21NXxlB
	 nhE6fAIE6h+apNux7jT+bQSiFABm7xsElpufMHs0F48gxgewPUdR2KM7z+f3+Uk/J8
	 8DPWDDooh2YaXZMqD9dw4voR04y9qZ5KZxjvoxVE=
Date: Thu, 25 Jun 2026 17:47:40 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch added to mm-new branch
Message-Id: <20260626004740.E98B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch

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
Subject: mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
Date: Fri, 12 Jun 2026 11:58:58 +0800

Now that hugetlb reservation runs after zone initialization, bootmem
gigantic page allocation can detect pages that span multiple zones.

Keep those cross-zone pages separate during allocation and free them after
allocation completes, so later hugetlb initialization only sees zone-valid
gigantic pages.

This chooses to free cross-zone gigantic pages directly instead of
retrying allocation.  In practice, such cross-zone cases are expected to
be very rare, so adding retry logic does not seem justified at this point.
Keeping the handling simple also preserves the previous behavior.  If
similar real-world reports show up later, retry support can be
reconsidered then.

Link: https://lore.kernel.org/20260612035903.2468601-15-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   75 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation
+++ a/mm/hugetlb.c
@@ -3060,12 +3060,15 @@ void *__init __alloc_bootmem_huge_page(s
 
 static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
+	unsigned long pfn;
+	unsigned int nid_request = nid;
 	struct huge_bootmem_page *m = arch_alloc_bootmem_huge_page(h, nid);
 
 	if (!m)
 		return false;
 
-	nid = early_pfn_to_nid(PHYS_PFN(__pa(m)));
+	pfn = PHYS_PFN(__pa(m));
+	nid = early_pfn_to_nid(pfn);
 	/*
 	 * Use the beginning of the huge page to store the huge_bootmem_page
 	 * struct (until gather_bootmem puts them into the mem_map).
@@ -3073,22 +3076,38 @@ static bool __init alloc_bootmem_huge_pa
 	 * Put them into a private list first because mem_map is not up yet.
 	 */
 	INIT_LIST_HEAD(&m->list);
-	list_add(&m->list, &huge_boot_pages[nid]);
 	m->hstate = h;
 	if (!hugetlb_early_cma(h)) {
 		m->cma = NULL;
 		m->flags = 0;
 	}
 
-	/*
-	 * Only initialize the head struct page in memmap_init_reserved_pages,
-	 * rest of the struct pages will be initialized by the HugeTLB
-	 * subsystem itself.
-	 * The head struct page is used to get folio information by the HugeTLB
-	 * subsystem like zone id and node id.
-	 */
-	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
-		huge_page_size(h) - PAGE_SIZE);
+	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
+	if (!hugetlb_early_cma(h) &&
+	    pfn_range_intersects_zones(nid, pfn, pages_per_huge_page(h))) {
+		/*
+		 * If the allocated page is on a different node than requested
+		 * (e.g., on PowerPC LPARs), put it on the requested node's list,
+		 * because hugetlb_free_cross_zone_pages() only frees cross-zone
+		 * pages belonging to the requested node.
+		 */
+		if (WARN_ON_ONCE(nid_request != NUMA_NO_NODE && nid != nid_request))
+			list_add(&m->list, &huge_boot_pages[nid_request]);
+		else
+			list_add(&m->list, &huge_boot_pages[nid]);
+	} else {
+		list_add_tail(&m->list, &huge_boot_pages[nid]);
+		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		/*
+		 * Only initialize the head struct page in memmap_init_reserved_pages,
+		 * rest of the struct pages will be initialized by the HugeTLB
+		 * subsystem itself.
+		 * The head struct page is used to get folio information by the HugeTLB
+		 * subsystem like zone id and node id.
+		 */
+		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
+				huge_page_size(h) - PAGE_SIZE);
+	}
 
 	return true;
 }
@@ -3373,6 +3392,34 @@ void __init hugetlb_bootmem_struct_page_
 	padata_do_multithreaded(&job);
 }
 
+static unsigned long __init hugetlb_free_cross_zone_pages(struct hstate *h, int nid)
+{
+	unsigned long freed = 0;
+	struct huge_bootmem_page *m, *tmp;
+
+	if (!hstate_is_gigantic(h))
+		return freed;
+
+	list_for_each_entry_safe(m, tmp, &huge_boot_pages[nid], list) {
+		if (m->flags & HUGE_BOOTMEM_ZONES_VALID)
+			break;
+
+		list_del(&m->list);
+		memblock_free(m, huge_page_size(h));
+		freed++;
+	}
+
+	if (freed) {
+		char buf[32];
+
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
+		pr_warn("HugeTLB: freed %lu cross-zone hugepages of size %s on node %d.\n",
+			freed, buf, nid);
+	}
+
+	return freed;
+}
+
 static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 {
 	unsigned long i;
@@ -3403,6 +3450,8 @@ static void __init hugetlb_hstate_alloc_
 		cond_resched();
 	}
 
+	i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	if (!list_empty(&folio_list))
 		prep_and_add_allocated_folios(h, &folio_list);
 
@@ -3476,6 +3525,7 @@ static void __init hugetlb_pages_alloc_b
 
 static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 {
+	int nid;
 	unsigned long i;
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
@@ -3484,6 +3534,9 @@ static unsigned long __init hugetlb_giga
 		cond_resched();
 	}
 
+	for_each_node(nid)
+		i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	return i;
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

