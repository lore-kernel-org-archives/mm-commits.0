Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3A522F02
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957045; cv=none; b=PEXMYd185E5zBNpFr4kay15+jZY1DC0XSUZOnXJrzCfegM3FWZRC3HfrSjhIP4YiYRM4TaPQaSWZn0GoyjLSHL8BueW4omTXDbcdXOHHLPohGvreajf7EgLS7VEWt4X7W3yRZ169jHwvvBnJx9YMjMJ2zQvsDugVVYFhEzUt66s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957045; c=relaxed/simple;
	bh=4fAkn08wTty5bT/A1pIK9jxraXEqdfhGF1NBcSb3n+I=;
	h=Date:To:From:Subject:Message-Id; b=GEdmX3ZWC/u7gC5L7sne4oR2mOwS0vxGgdxny6oDbdO05iYPztZNJmlMNv4N2hHu1NGtRUSy804uxCBKs5ltgXB3thwWnIZu71R6/4e8NjkDoAHpwR4PmJgW0eLkj4Vjr80NLOm0lsAHqUVmBBYPjxpc16WvcJxPKQiAJIiZL3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B4LsC9kA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B4LsC9kA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA152C113CC;
	Mon,  6 May 2024 00:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957045;
	bh=4fAkn08wTty5bT/A1pIK9jxraXEqdfhGF1NBcSb3n+I=;
	h=Date:To:From:Subject:From;
	b=B4LsC9kAehFar37cGkSRjLvGB3Ew2sVGq4ztdMoaUr16xrMkZAQAQHRIrnwTFGckc
	 UizbQqftGoMiIOK01Q+boRhSF/aE9rAo0qGIpn6/gUXlfN2em0z+aC95lL0SOAp38B
	 gOJUdUsSAq2q/0Lj+BkVpMFS9WXEQ9GUyQiW7D38=
Date: Sun, 05 May 2024 17:57:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch removed from -mm tree
Message-Id: <20240506005724.EA152C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: batch mm counter updating in filemap_map_pages()
has been removed from the -mm tree.  Its filename was
     mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: filemap: batch mm counter updating in filemap_map_pages()
Date: Fri, 12 Apr 2024 14:47:51 +0800

Like copy_pte_range()/zap_pte_range(), make mm counter batch updating in
filemap_map_pages(), since folios type are same(MM_SHMEMPAGES or
MM_FILEPAGES) in filemap_map_pages(), only check the first folio type is
enough, the 'lat_pagefault -P 1 file' test from lmbench shows 12%
improvement, and the percpu_counter_add_batch() is gone from perf flame
graph.

Link: https://lkml.kernel.org/r/20240412064751.119015-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/filemap.c~mm-filemap-batch-mm-counter-updating-in-filemap_map_pages
+++ a/mm/filemap.c
@@ -3505,7 +3505,7 @@ skip:
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned int *mmap_miss)
+			unsigned long *rss, unsigned int *mmap_miss)
 {
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
@@ -3539,8 +3539,7 @@ static vm_fault_t filemap_map_folio_rang
 skip:
 		if (count) {
 			set_pte_range(vmf, folio, page, count, addr);
-			add_mm_counter(vmf->vma->vm_mm, mm_counter_file(folio),
-				       count);
+			*rss += count;
 			folio_ref_add(folio, count);
 			if (in_range(vmf->address, addr, count * PAGE_SIZE))
 				ret = VM_FAULT_NOPAGE;
@@ -3555,7 +3554,7 @@ skip:
 
 	if (count) {
 		set_pte_range(vmf, folio, page, count, addr);
-		add_mm_counter(vmf->vma->vm_mm, mm_counter_file(folio), count);
+		*rss += count;
 		folio_ref_add(folio, count);
 		if (in_range(vmf->address, addr, count * PAGE_SIZE))
 			ret = VM_FAULT_NOPAGE;
@@ -3568,7 +3567,7 @@ skip:
 
 static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 		struct folio *folio, unsigned long addr,
-		unsigned int *mmap_miss)
+		unsigned long *rss, unsigned int *mmap_miss)
 {
 	vm_fault_t ret = 0;
 	struct page *page = &folio->page;
@@ -3592,7 +3591,7 @@ static vm_fault_t filemap_map_order0_fol
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
-	add_mm_counter(vmf->vma->vm_mm, mm_counter_file(folio), 1);
+	(*rss)++;
 	folio_ref_inc(folio);
 
 	return ret;
@@ -3609,7 +3608,8 @@ vm_fault_t filemap_map_pages(struct vm_f
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct folio *folio;
 	vm_fault_t ret = 0;
-	unsigned int nr_pages = 0, mmap_miss = 0, mmap_miss_saved;
+	unsigned long rss = 0;
+	unsigned int nr_pages = 0, mmap_miss = 0, mmap_miss_saved, folio_type;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
@@ -3628,6 +3628,8 @@ vm_fault_t filemap_map_pages(struct vm_f
 		folio_put(folio);
 		goto out;
 	}
+
+	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
 
@@ -3639,15 +3641,16 @@ vm_fault_t filemap_map_pages(struct vm_f
 
 		if (!folio_test_large(folio))
 			ret |= filemap_map_order0_folio(vmf,
-					folio, addr, &mmap_miss);
+					folio, addr, &rss, &mmap_miss);
 		else
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
-					nr_pages, &mmap_miss);
+					nr_pages, &rss, &mmap_miss);
 
 		folio_unlock(folio);
 		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
+	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


