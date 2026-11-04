Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793768272;
	b=z6kOtmSy6ye31uAq8pdbbv2kut0VfTi94DyId+UKsOo6QSBy790OL87H8w6iKLhUwWIU
	 2SK2YD7dXKVuL6hhUZwz2QuNTG8Edxfh+TXW5g+zqyeQmHX7q9KiqHmy7KamsbwqWCub6
	 B/8xmaOx8HAMehK7uWRvli83LOSM+KzQfEgEKFWWp7HhywUKs5MUrHEsRr+mkO/vXDQb+
	 kHuVqAFkXt0SodjUF4oHgz3oJKG536PvWa4ViaIWIXc5D8wpRb/QL4alNFJ2iq5qY5t+J
	 m0NkyHvvP9FSsoqDN1cBjCIXAbZzUqGS3hlSb2t4vJe53XL7Se/xpcUuwEfhQUz0VZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793768272;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RvFLgf5cM0eFsIvvET514vuESPkTJvozRRK34daWI1s=;
	b=cX2f7v9FwtZKN3euzw8W7/GoyhL3NiLZSY2PrWgFvCh8nw69T3aCZoZsUIGU6VLPHrVu
	 Hvj4qfkRwQYgRCH5wmLKpFP3gLmEU5O4/CIrjRDltBzPlYHzYsPl42KbrlNb0EqMJq8Oz
	 QXPj8SODjPSjQbrtNH5xD02I6sxt4lia4Vzr1K26tmW61uSFjqMmd9qHojVVhh9gUBhjT
	 PR7Dkc0/MzbBAxN8qyWGl2GSneD0u9NgwUSyRXdZ1Om82EQlHtNEKYL2mIwGT1I3x0EHq
	 J388HOwSK3MiTs94UUe1m2nHvhMEq59W95gKvQnD9SMIO7WmrJWEbbjxYrmCyvPd+xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S+4jUmHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E739606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 04:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S+4jUmHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C042E1F000C1;
	Wed,  4 Nov 2026 04:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793768271;
	bh=RvFLgf5cM0eFsIvvET514vuESPkTJvozRRK34daWI1s=;
	h=Date:To:From:Subject;
	b=S+4jUmHK+nA5D+JW21VvYKKgqeLkJ24PE474uSYiEY1h+2UU1hDY9DBgNyKZ+yrkM
	 bpOTGim3uCVVsocqZa8QL756WuPmP36o+MOGJzpwbGlRHYwWrW7KROc8oLq2ndSDPY
	 fuJbYi08z2Dza80koXHJ2YQ0DD0ayE/d9MlVuYFM=
Date: Tue, 03 Nov 2026 20:57:51 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,
	osalvador@suse.de,lance.yang@linux.dev,jthoughton@google.com,
	david@kernel.org,chenhuacai@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch added to mm-new branch
Message-Id: <20261104045751.C042E1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: generalize vmemmap page allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Wed, 04 Nov 2026 10:35:02 +0800

Vmemmap page allocation is currently tied to restoring a virtual range and
assumes an empty destination list.  These constraints prevent it from
being reused when pages are requested independently of a vmemmap range or
appended to an existing list.

Generalize the allocator and give it an all-or-nothing list contract so
the restore and optimization paths can share the same allocation policy. 
This also allows HVO head-page allocation to fail gracefully under memory
pressure without triggering the OOM killer.

Link: https://lore.kernel.org/20261104023510.260766-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation
+++ a/mm/hugetlb_vmemmap.c
@@ -334,26 +334,24 @@ static int vmemmap_remap_free(unsigned l
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   struct list_head *list)
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
+	LIST_HEAD(new_pages);
 	struct page *page, *next;
-	int i;
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
 		if (!page)
-			goto out;
-		list_add(&page->lru, list);
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
 	}
+	list_splice(&new_pages, head);
 	memmap_pages_add(nr_pages);
 
 	return 0;
-out:
-	list_for_each_entry_safe(page, next, list, lru)
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
 		__free_page(page);
 	return -ENOMEM;
 }
@@ -374,13 +372,14 @@ static int vmemmap_remap_alloc(unsigned
 			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
+	int nid = page_to_nid((struct page *)start);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
+	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -527,15 +526,13 @@ static int __hugetlb_vmemmap_optimize_fo
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
-	if (!vmemmap_head) {
+	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
 	copy_page(page_to_virt(vmemmap_head), folio);
-	list_add(&vmemmap_head->lru, vmemmap_pages);
-	memmap_pages_add(1);
 
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch

