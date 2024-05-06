Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1828819BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957044; cv=none; b=i51VG0MmSThkYGmJeSMisFjmxFhicZRZITe3HoGHf4VoXL6j6qSO3GTFPXGbN99gG+72H4qlCINDY1FF1x/DvzE3MEg6Rqfcq5H2GIMoEG2/UIwSOgxeh17MQrWstk47TuuSMSyzPL4FdWGarOLmmHTWOeU0QWnMu+LCPOF8PpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957044; c=relaxed/simple;
	bh=HPgHpzvT1vt0JDs//FLFazKHjbb/dT/JxWE29Fs0Ymc=;
	h=Date:To:From:Subject:Message-Id; b=A8NBvBd9BC5XlNTDG4pxWw/QnQtMMQ/+TFRbmo5AVoAPxc85+47oXAP+Nj9mKs6OPYKnkfQSGmfPpVSAgYEt5qbR5lqah3qTCzIEztPUoibXCIkoHSIL5ZU74tklQR7PJ7OasJ5OJqAH6rKE4W72q4TvC8kqWdAYwY7ULC50vkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IEmYV/kF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IEmYV/kF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4517C116B1;
	Mon,  6 May 2024 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957044;
	bh=HPgHpzvT1vt0JDs//FLFazKHjbb/dT/JxWE29Fs0Ymc=;
	h=Date:To:From:Subject:From;
	b=IEmYV/kFjPY1V7GYqAiZpfxWdjZWAWkZGLxbnG7PZme9te7n7DASkT4ehFgeb28Py
	 LHxqqHteuoJY63ctsqEEiRqYt7PSajc34bte+dhFT80Ft4JvT58UxVCKMcc+bqpzzc
	 awwrv4DbE1GgTLwO4rmfCCCKAsuDCR3NBZog3jaQ=
Date: Sun, 05 May 2024 17:57:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-mm-counter-updating-out-of-set_pte_range.patch removed from -mm tree
Message-Id: <20240506005723.E4517C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move mm counter updating out of set_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-move-mm-counter-updating-out-of-set_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: move mm counter updating out of set_pte_range()
Date: Fri, 12 Apr 2024 14:47:50 +0800

Patch series "mm: batch mm counter updating in filemap_map_pages()", v3.

Let's batch mm counter updating to accelerate filemap_map_pages().


This patch (of 2):

In order to support batch mm counter updating in filemap_map_pages(), move
mm counter updating out of set_pte_range(), the folios are file from
filemap, and distinguish folios by vmf->flags and vma->vm_flags from
another caller finish_fault().

Link: https://lkml.kernel.org/r/20240412064751.119015-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240412064751.119015-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++++
 mm/memory.c  |    8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-move-mm-counter-updating-out-of-set_pte_range
+++ a/mm/filemap.c
@@ -3539,6 +3539,8 @@ static vm_fault_t filemap_map_folio_rang
 skip:
 		if (count) {
 			set_pte_range(vmf, folio, page, count, addr);
+			add_mm_counter(vmf->vma->vm_mm, mm_counter_file(folio),
+				       count);
 			folio_ref_add(folio, count);
 			if (in_range(vmf->address, addr, count * PAGE_SIZE))
 				ret = VM_FAULT_NOPAGE;
@@ -3553,6 +3555,7 @@ skip:
 
 	if (count) {
 		set_pte_range(vmf, folio, page, count, addr);
+		add_mm_counter(vmf->vma->vm_mm, mm_counter_file(folio), count);
 		folio_ref_add(folio, count);
 		if (in_range(vmf->address, addr, count * PAGE_SIZE))
 			ret = VM_FAULT_NOPAGE;
@@ -3589,6 +3592,7 @@ static vm_fault_t filemap_map_order0_fol
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
+	add_mm_counter(vmf->vma->vm_mm, mm_counter_file(folio), 1);
 	folio_ref_inc(folio);
 
 	return ret;
--- a/mm/memory.c~mm-move-mm-counter-updating-out-of-set_pte_range
+++ a/mm/memory.c
@@ -4687,12 +4687,10 @@ void set_pte_range(struct vm_fault *vmf,
 		entry = pte_mkuffd_wp(entry);
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
-		add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr);
 		VM_BUG_ON_FOLIO(nr != 1, folio);
 		folio_add_new_anon_rmap(folio, vma, addr);
 		folio_add_lru_vma(folio, vma);
 	} else {
-		add_mm_counter(vma->vm_mm, mm_counter_file(folio), nr);
 		folio_add_file_rmap_ptes(folio, page, nr, vma);
 	}
 	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr);
@@ -4729,9 +4727,11 @@ vm_fault_t finish_fault(struct vm_fault
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
 	vm_fault_t ret;
+	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
+		      !(vma->vm_flags & VM_SHARED);
 
 	/* Did we COW the page? */
-	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
+	if (is_cow)
 		page = vmf->cow_page;
 	else
 		page = vmf->page;
@@ -4767,8 +4767,10 @@ vm_fault_t finish_fault(struct vm_fault
 	/* Re-check under ptl */
 	if (likely(!vmf_pte_changed(vmf))) {
 		struct folio *folio = page_folio(page);
+		int type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
 
 		set_pte_range(vmf, folio, page, 1, vmf->address);
+		add_mm_counter(vma->vm_mm, type, 1);
 		ret = 0;
 	} else {
 		update_mmu_tlb(vma, vmf->address, vmf->pte);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


