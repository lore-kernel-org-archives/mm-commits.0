Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023621;
	b=BwW3DKdwBrlMOytlWFW95OYQHwy0G8KOPiemsb90X8q+Amhfzmj+QUDXnZqePPFbJWik
	 CLqrSMaeuW/xZUsK/3Hu4/YIs6Bwec8xQJJXFt5ZWjYkWlR2RazopOYuPxJW989tGT+Y5
	 uTgqv5eaOcSgN2fvc4ba0RpBPYvtxOY06SOMSSlQA1SHyZgxQbrq33sI/1Xs9iQ8BhPw2
	 o3+2corOfE6lPDSKr4qr0ovcd+t+PxIlE3oJVpokQEn30EWiBiBhsq2r0l1wtwQKXiDeo
	 2Iwm8lZk79z3L8Dyz5G7JjQDqXIyjiKVdrceg+SuzgQAsT+Q7yUje1wmvkvLim3g0xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023621;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=S74esSGPa4kabNAhhEIx7Y9uTEoDVCm3sPq/0RTIa4c=;
	b=djbLpuw81B0SDTJ5+g1WPhTRRLG9F9kOfx6cIvcC44mzcCDHJcQvWHGjDz4EbFMmXuTs
	 ZaJoVA/VGj7FAAJc9W1mOwACHt6uIuZhYqBDCkI+nVMJf9PD3+hwOGCy8z8jmawFWa/+N
	 nmZsRXMERvMGEJZ5+SZuUxUeGTA0pbJJnvLJnrp7JrVWqWGTulbemTsbrFjWUlFAp+NCj
	 PY3nzFARQFgevdGvRfoFrq7YlYMOfTeXgRT0YSCbduoILE/+Fxs0r9p+qCKCtz5VHLyT4
	 tNA8GzgWmB20LoosdDA3tQLnXdp6D3+8pFhRu86uSb37hbotwVDHvMy6jf92y+cOgjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qyfzmRtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBF3606A333
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qyfzmRtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A88A1F008A2;
	Sat,  7 Nov 2026 03:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023621;
	bh=S74esSGPa4kabNAhhEIx7Y9uTEoDVCm3sPq/0RTIa4c=;
	h=Date:To:From:Subject;
	b=qyfzmRtSgsm+2Nle0AdxZUS7m10G01rTl/Ezx239whDOAK6GymJ26Tvw1qsrt6Atc
	 JV2FxZEZQVbQGhQcpcu7M6oaSRi+m2OMvRvJ/LQrsXFHMKVAv3F2m50E9TzryL2amd
	 NRkDgbc0CqBENftvKUtPOg4nlh+sXeUdlD6BNDP4=
Date: Fri, 06 Nov 2026 19:53:40 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch added to mm-unstable branch
Message-Id: <20261107035341.5A88A1F008A2@smtp.kernel.org>
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
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Sat, 07 Nov 2026 10:27:48 +0800

Vmemmap page allocation is currently tied to restoring a virtual range
and assumes an empty destination list.  These constraints prevent it from
being reused when pages are requested independently of a vmemmap range or
appended to an existing list.

Generalize the allocator and give it an all-or-nothing list contract so
the restore and optimization paths can share the same helper.

Link: https://lore.kernel.org/20261107022756.77731-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Yili Zhang <zhangyili01@baidu.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation
+++ a/mm/hugetlb_vmemmap.c
@@ -334,26 +334,24 @@ static int vmemmap_remap_free(unsigned l
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   struct list_head *list)
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid, gfp_t gfp_mask)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
-	int i;
+	LIST_HEAD(new_pages);
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
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
@@ -373,6 +371,7 @@ out:
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			       unsigned long flags)
 {
+	int ret, nid = page_to_nid((struct page *)start);
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
@@ -380,8 +379,10 @@ static int vmemmap_remap_alloc(unsigned
 		.flags		= flags,
 	};
 
-	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
-		return -ENOMEM;
+	ret = alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE,
+				      nid, GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	return vmemmap_remap_range(start, end, &walk);
 }
@@ -501,7 +502,7 @@ static int __hugetlb_vmemmap_optimize_fo
 {
 	unsigned long vmemmap_start, vmemmap_end;
 	struct page *vmemmap_head, *vmemmap_tail;
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -528,15 +529,13 @@ static int __hugetlb_vmemmap_optimize_fo
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, gfp_mask, 0);
-	if (!vmemmap_head) {
-		ret = -ENOMEM;
+	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
+				      nid, gfp_mask);
+	if (ret)
 		goto out;
-	}
 
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
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

