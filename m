Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023389;
	b=H1QsN/Y+KgKERBmsVvIQKnI6esiaoCZ6eKOrizOisBWIKqSnIwX274JWmTdm4/CqLp7N
	 mYogaOdz9mFdSZeIkG2JlsQC2Pk91KepvpJXnrT9XP4Z58xwkTBOC6wthwJF/yyjWHy6C
	 5efay20lHGry4lCOiQMODmlPV52JPSJcH3/doJaTi/FQTMwK5YLZgWdgVVgUPB8F7RxS/
	 qM6FHWQxuZcaQF22CupQRgvK/jedhz2Ay30A35eeplm0FDy0IJPuEqX5nuNOFCYJtqT2Q
	 zYuo/cE7M9gTYResrp33t2d4GZIWvo39E6IsVvY/lC6AwP3DemJUhLqeNoDlNWBgrxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023389;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7U0aWRTb/vx8vZMalXtg9v6C3ZUXt250K+PMd+6pshI=;
	b=uUCyZt/UWMjjZ1DimFBeJ2xuKYufS1R0uYTgIxBvcHCad2kNZeF5VqHCh5UIkZLW3IZg
	 CFQKfdFnD6bvuJODHnpTFKPwcrLffC/Y/vqVRMMB9ceAMSEwBB7iWdtbE2ijSDZg1sATt
	 0DdLkCh+0A420wFd4fLAYT8y2c8MrN1oFv10vpvh29vmmWCXIiigoT2ukN/HE5atrR0cr
	 I52w9sdXKeeFv5YZRURiQwz54W4c8cW550e2fF+9FK4QpYQFkobAhLKnMVAsFZ8ufs0aZ
	 F9nIZ8tBvipeM4DrOUaZB6RzifIFR7oBh1tYn2ThvT1Jz5wCFtdIv75u84GlNB5t1hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JqBZ5bmC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991FB606A32C
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JqBZ5bmC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3054E1F0089F;
	Sat,  7 Nov 2026 03:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023389;
	bh=7U0aWRTb/vx8vZMalXtg9v6C3ZUXt250K+PMd+6pshI=;
	h=Date:To:From:Subject;
	b=JqBZ5bmCfaebz6e7df0AsJT9y9MUkih1+sZ2IHuAU8x9AhB/bcwHxTE3AQwLgaB3Y
	 GrlN3iWgFLJe7SyyRTwKt9ZQxDIrEybvY/v9SSkONutwksbu1IoxMC8h3BCcnX9InV
	 u7+ztaN48S3/H2ngRYzIMMy5fnBzEehmFd8Q3EtA=
Date: Fri, 06 Nov 2026 19:49:48 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch removed from -mm tree
Message-Id: <20261107034949.3054E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: generalize vmemmap page allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch

This patch was dropped because an updated version will be issued

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
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103224659.2865b9ff27d09994949edd78@linux-foundation.org
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

