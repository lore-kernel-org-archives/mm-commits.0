Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDDFBA46
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628228; cv=none; b=YzDIE7R93lZv/e/ROiK149u9eJLd0FFjKo/6+gxnFvPTWE4fwSRtNCX9iVfHCniXDjwOOXc/rFUI48Dgwflcy9bG8qIWTaWCOPS8qvEPKJ3Fy71pj/NjwvvlWLrAuKtwK6WFdL+W+7kRk5Ix5EvapZp+AerFk3kqELk/KHkKbwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628228; c=relaxed/simple;
	bh=LY/Qp/h17GZeqqDnFgebmwm3LZr5cmSvp1uS5b+P2iQ=;
	h=Date:To:From:Subject:Message-Id; b=h34KdV/V2IzpuJ7SNZtIV1nt8Bkr8UM9jGdH0dc5yQQJGBPRxqs+7HsAUaGhPlXOV9l68uUeVZmz5yq3RnZZcFkAx61XaUnwq6bvjskI/+mJh4k+ATXqvn+xZLYkQfano1wl59zl4//c/8wMLRujXjH6pPUD8lkFGmNjqutkEUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cD5qHBKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cD5qHBKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82638C4AF0A;
	Sat, 29 Jun 2024 02:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628228;
	bh=LY/Qp/h17GZeqqDnFgebmwm3LZr5cmSvp1uS5b+P2iQ=;
	h=Date:To:From:Subject:From;
	b=cD5qHBKD1utLkyBZayCyflNJ/qbkox8yaxIBs5Fe9FwK9/qlRzr+RiPRtPFcYbQlg
	 dCiaYDmIjoMJHThJUC1SWONBsoWSA9N7BAwR0TaqV5i4C6BCw7sT3M8vvs7KNgO8wY
	 R08m2Ns/I//ihOb9apUVnTAVs3uQstzkql2atStM=
Date: Fri, 28 Jun 2024 19:30:28 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-improve-copy_user_large_folio.patch removed from -mm tree
Message-Id: <20240629023028.82638C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: improve copy_user_large_folio()
has been removed from the -mm tree.  Its filename was
     mm-memory-improve-copy_user_large_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: improve copy_user_large_folio()
Date: Tue, 18 Jun 2024 17:12:41 +0800

Use nr_pages instead of pages_per_huge_page and move the address alignment
from copy_user_large_folio() into the callers since it is only needed when
we don't know which address will be accessed.

Link: https://lkml.kernel.org/r/20240618091242.2140164-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++++----------
 mm/memory.c  |   11 ++++-------
 2 files changed, 12 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~mm-memory-improve-copy_user_large_folio
+++ a/mm/hugetlb.c
@@ -5492,9 +5492,8 @@ again:
 					ret = PTR_ERR(new_folio);
 					break;
 				}
-				ret = copy_user_large_folio(new_folio,
-							    pte_folio,
-							    addr, dst_vma);
+				ret = copy_user_large_folio(new_folio, pte_folio,
+						ALIGN_DOWN(addr, sz), dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
 					folio_put(new_folio);
@@ -6684,7 +6683,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	struct hstate *h = hstate_vma(dst_vma);
 	struct address_space *mapping = dst_vma->vm_file->f_mapping;
 	pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
-	unsigned long size;
+	unsigned long size = huge_page_size(h);
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	pte_t _dst_pte;
 	spinlock_t *ptl;
@@ -6703,8 +6702,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		}
 
 		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
-		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte,
-				huge_page_size(h));
+		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
 		/* No need to invalidate - it was non-present before */
 		update_mmu_cache(dst_vma, dst_addr, dst_pte);
@@ -6778,7 +6776,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			*foliop = NULL;
 			goto out;
 		}
-		ret = copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
+		ret = copy_user_large_folio(folio, *foliop,
+					    ALIGN_DOWN(dst_addr, size), dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
@@ -6805,9 +6804,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 
 	/* Add shared, newly allocated pages to the page cache. */
 	if (vm_shared && !is_continue) {
-		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		ret = -EFAULT;
-		if (idx >= size)
+		if (idx >= (i_size_read(mapping->host) >> huge_page_shift(h)))
 			goto out_release_nounlock;
 
 		/*
@@ -6864,7 +6862,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	if (wp_enabled)
 		_dst_pte = huge_pte_mkuffd_wp(_dst_pte);
 
-	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, huge_page_size(h));
+	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
 	hugetlb_count_add(pages_per_huge_page(h), dst_mm);
 
--- a/mm/memory.c~mm-memory-improve-copy_user_large_folio
+++ a/mm/memory.c
@@ -6521,20 +6521,17 @@ static int copy_subpage(unsigned long ad
 int copy_user_large_folio(struct folio *dst, struct folio *src,
 			  unsigned long addr_hint, struct vm_area_struct *vma)
 {
-	unsigned int pages_per_huge_page = folio_nr_pages(dst);
-	unsigned long addr = addr_hint &
-		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
+	unsigned int nr_pages = folio_nr_pages(dst);
 	struct copy_subpage_arg arg = {
 		.dst = dst,
 		.src = src,
 		.vma = vma,
 	};
 
-	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES))
-		return copy_user_gigantic_page(dst, src, addr, vma,
-					       pages_per_huge_page);
+	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
+		return copy_user_gigantic_page(dst, src, addr_hint, vma, nr_pages);
 
-	return process_huge_page(addr_hint, pages_per_huge_page, copy_subpage, &arg);
+	return process_huge_page(addr_hint, nr_pages, copy_subpage, &arg);
 }
 
 long copy_folio_from_user(struct folio *dst_folio,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

