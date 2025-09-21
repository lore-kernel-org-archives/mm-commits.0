Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7416253939
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489921; cv=none; b=cPr9cZAaC/i8o4Go8PjWro7YswuPNVWhnnr0DjulJYtu3Qx7T0O1EK7iCQu+B6WRJUDKdT/Bou2I+IVlPmJXshE/z9kiWeSbK/hUrHWCT8OKfz/orE0juDBckbQl/d5sWU563tqJkaMERxDNF48GfLdMjUAJL8syCDLbpLB4Ndc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489921; c=relaxed/simple;
	bh=xw+B9qsomEuq9ugXLU8xgBuIIlpy2Q9cfBYBYsLj97Q=;
	h=Date:To:From:Subject:Message-Id; b=P1LPCqwMf8jJKitvYXXOt3TWrqLS3gcL4VrKuErJjo+hWkzMP0lDOwK4B4yF3g1x9boERnKszFfwu1dJhUz5ZsypcYwLogQHzyk8aMmxYKIu+xH3Rsf8APE+KFBsbE5U8xNkeDkMisJdjtfZoq6zEYSDhWUF/0cgb/C88QFeWh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UUHMJt1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UUHMJt1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6241FC4CEE7;
	Sun, 21 Sep 2025 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489920;
	bh=xw+B9qsomEuq9ugXLU8xgBuIIlpy2Q9cfBYBYsLj97Q=;
	h=Date:To:From:Subject:From;
	b=UUHMJt1RjESuX61pg74G+e27USlnxWU6ib9aQuYhcV1jS+ysPk/2tbAoBDUQn8Tlv
	 lm2LqJEAHNMO/xJQWWspVA89euPVJpymBKTbYxMobA58qympGOaLHMFjc0xIW7uhFj
	 wGUfQ4cVQlSUVK4FILXIkPHQAbcg+rBuVoBRAPHE=
Date: Sun, 21 Sep 2025 14:25:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-optimize-folio-refount-update-in-filemap_map_pages.patch removed from -mm tree
Message-Id: <20250921212520.6241FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: optimize folio refount update in filemap_map_pages
has been removed from the -mm tree.  Its filename was
     filemap-optimize-folio-refount-update-in-filemap_map_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: filemap: optimize folio refount update in filemap_map_pages
Date: Thu, 4 Sep 2025 21:27:37 +0800

There are two meaningless folio refcount update for order0 folio in
filemap_map_pages().  First, filemap_map_order0_folio() adds folio
refcount after the folio is mapped to pte.  And then, filemap_map_pages()
drops a refcount grabbed by next_uptodate_folio().  We could remain the
refcount unchanged in this case.

As Matthew metenioned in [1], it is safe to call folio_unlock() before
calling folio_put() here, because the folio is in page cache with refcount
held, and truncation will wait for the unlock.

Optimize filemap_map_folio_range() with the same method too.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file' in order0 folio case, the size of file is 512M.


Link: https://lkml.kernel.org/r/20250904132737.1250368-1-tujinjiang@huawei.com
Link: https://lore.kernel.org/all/aKcU-fzxeW3xT5Wv@casper.infradead.org/ [1]
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~filemap-optimize-folio-refount-update-in-filemap_map_pages
+++ a/mm/filemap.c
@@ -3665,6 +3665,7 @@ static vm_fault_t filemap_map_folio_rang
 			unsigned long addr, unsigned int nr_pages,
 			unsigned long *rss, unsigned short *mmap_miss)
 {
+	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
@@ -3698,7 +3699,8 @@ skip:
 		if (count) {
 			set_pte_range(vmf, folio, page, count, addr);
 			*rss += count;
-			folio_ref_add(folio, count);
+			folio_ref_add(folio, count - ref_from_caller);
+			ref_from_caller = 0;
 			if (in_range(vmf->address, addr, count * PAGE_SIZE))
 				ret = VM_FAULT_NOPAGE;
 		}
@@ -3713,12 +3715,16 @@ skip:
 	if (count) {
 		set_pte_range(vmf, folio, page, count, addr);
 		*rss += count;
-		folio_ref_add(folio, count);
+		folio_ref_add(folio, count - ref_from_caller);
+		ref_from_caller = 0;
 		if (in_range(vmf->address, addr, count * PAGE_SIZE))
 			ret = VM_FAULT_NOPAGE;
 	}
 
 	vmf->pte = old_ptep;
+	if (ref_from_caller)
+		/* Locked folios cannot get truncated. */
+		folio_ref_dec(folio);
 
 	return ret;
 }
@@ -3731,7 +3737,7 @@ static vm_fault_t filemap_map_order0_fol
 	struct page *page = &folio->page;
 
 	if (PageHWPoison(page))
-		return ret;
+		goto out;
 
 	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
@@ -3743,15 +3749,18 @@ static vm_fault_t filemap_map_order0_fol
 	 * the fault-around logic.
 	 */
 	if (!pte_none(ptep_get(vmf->pte)))
-		return ret;
+		goto out;
 
 	if (vmf->address == addr)
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
 	(*rss)++;
-	folio_ref_inc(folio);
+	return ret;
 
+out:
+	/* Locked folios cannot get truncated. */
+	folio_ref_dec(folio);
 	return ret;
 }
 
@@ -3811,7 +3820,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 					nr_pages, &rss, &mmap_miss);
 
 		folio_unlock(folio);
-		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-hugetlb-fix-folio-is-still-mapped-when-deleted.patch

