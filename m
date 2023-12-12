Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7727B8002D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VmE44SEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430BFC433C8;
	Tue, 12 Dec 2023 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407578;
	bh=i93cPk4UfZUUxNLnaafkCahWf6FwpRmkI/mKFOIFH3E=;
	h=Date:To:From:Subject:From;
	b=VmE44SEmQFFLobfHXV125B6csdc9G8wn009z90EwQkB/NK9kLcY9w+6neUifS5aLL
	 rHfFUlS1Z+qOBrrf4Y8790uePlubtIuAt3GjUxs2otBJTuRn4zyzP25XpWA7SAveGM
	 ZYxiNXr3+TTUoX7WSvhtNFL2TC0yTwOWSTJrpBdg=
Date: Tue, 12 Dec 2023 10:59:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch removed from -mm tree
Message-Id: <20231212185938.430BFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ksm: use more folio api in ksm_might_need_to_copy()
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: ksm: use more folio api in ksm_might_need_to_copy()
Date: Sat, 18 Nov 2023 10:32:28 +0800

Patch series "mm: cleanup and use more folio in page fault", v3.

Rename page_copy_prealloc() to folio_prealloc(), which is used by more
functions, also do more folio conversion in page fault.


This patch (of 5):

Since ksm only support normal page, no swapout/in for ksm large folio too,
add large folio check in ksm_might_need_to_copy(), also convert
page->index to folio->index as page->index is going away.

Then convert ksm_might_need_to_copy() to use more folio api to save nine
compound_head() calls, short 'address' to reduce max-line-length.

Link: https://lkml.kernel.org/r/20231118023232.1409103-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20231118023232.1409103-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    4 ++--
 mm/ksm.c            |   39 +++++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

--- a/include/linux/ksm.h~mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy
+++ a/include/linux/ksm.h
@@ -77,7 +77,7 @@ static inline void ksm_exit(struct mm_st
  * but what if the vma was unmerged while the page was swapped out?
  */
 struct page *ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address);
+			struct vm_area_struct *vma, unsigned long addr);
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
@@ -130,7 +130,7 @@ static inline int ksm_madvise(struct vm_
 }
 
 static inline struct page *ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address)
+			struct vm_area_struct *vma, unsigned long addr)
 {
 	return page;
 }
--- a/mm/ksm.c~mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy
+++ a/mm/ksm.c
@@ -2876,48 +2876,51 @@ void __ksm_exit(struct mm_struct *mm)
 }
 
 struct page *ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address)
+			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct folio *folio = page_folio(page);
 	struct anon_vma *anon_vma = folio_anon_vma(folio);
-	struct page *new_page;
+	struct folio *new_folio;
 
-	if (PageKsm(page)) {
-		if (page_stable_node(page) &&
+	if (folio_test_large(folio))
+		return page;
+
+	if (folio_test_ksm(folio)) {
+		if (folio_stable_node(folio) &&
 		    !(ksm_run & KSM_RUN_UNMERGE))
 			return page;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return page;		/* no need to copy it */
-	} else if (page->index == linear_page_index(vma, address) &&
+	} else if (folio->index == linear_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
 		return page;		/* still no need to copy it */
 	}
 	if (PageHWPoison(page))
 		return ERR_PTR(-EHWPOISON);
-	if (!PageUptodate(page))
+	if (!folio_test_uptodate(folio))
 		return page;		/* let do_swap_page report the error */
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
-	if (new_page &&
-	    mem_cgroup_charge(page_folio(new_page), vma->vm_mm, GFP_KERNEL)) {
-		put_page(new_page);
-		new_page = NULL;
+	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (new_folio &&
+	    mem_cgroup_charge(new_folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(new_folio);
+		new_folio = NULL;
 	}
-	if (new_page) {
-		if (copy_mc_user_highpage(new_page, page, address, vma)) {
-			put_page(new_page);
+	if (new_folio) {
+		if (copy_mc_user_highpage(&new_folio->page, page, addr, vma)) {
+			folio_put(new_folio);
 			memory_failure_queue(page_to_pfn(page), 0);
 			return ERR_PTR(-EHWPOISON);
 		}
-		SetPageDirty(new_page);
-		__SetPageUptodate(new_page);
-		__SetPageLocked(new_page);
+		folio_set_dirty(new_folio);
+		__folio_mark_uptodate(new_folio);
+		__folio_set_locked(new_folio);
 #ifdef CONFIG_SWAP
 		count_vm_event(KSM_SWPIN_COPY);
 #endif
 	}
 
-	return new_page;
+	return new_folio ? &new_folio->page : NULL;
 }
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch

