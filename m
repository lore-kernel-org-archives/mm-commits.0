Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18312727E5
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 23:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757026869; cv=none; b=MAx7c1PNHaHOO1RDSkkeS3rCpUXKWjwN47MZVK+sfilokcQ+9XcTX71AxI3MO9UYzsYl8XBe7cVbsg13ynUXi6C5JFj1bYMMQt2xg9Bo6bLlMwbU8wkPvXTBx3vGy2camqyi4szbehkqyUZAKfN0Iad6OY6qZVaD2N0UT3bauhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757026869; c=relaxed/simple;
	bh=dHUNIbmdd3MtGZv85luj71r/KfigHo92woPBpCRG88w=;
	h=Date:To:From:Subject:Message-Id; b=KFVtlU4y2TU5cWZkx5SeXR685Tu8ApP8j2oVfDGelmjxS16Eu2yo/EHHbKKde9T0h+zOTfa00XWSpXtTqHsDDppFoVsQaUHTqARIKXKpePa9I6EbjbJne7QLHpN0MROsXUSE2DbuIVQItxHsnXNEUyfWKcsccTFnQGt5EvEOG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUE1O0Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUE1O0Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D37C4CEF0;
	Thu,  4 Sep 2025 23:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757026869;
	bh=dHUNIbmdd3MtGZv85luj71r/KfigHo92woPBpCRG88w=;
	h=Date:To:From:Subject:From;
	b=qUE1O0SeTv7CTp5Rf4osp2cuL+761skz5DR4h3mC8S2APPKTi+hliFgSAh89cOkdI
	 bMxeEvtZ+IH/hCj2ZR821nRhL2mj1AbNkrV5TKqv2I23/lc0PrrcJRz8DnXf7WPNQw
	 CV0pBrpmuWfrZpQCJqmPZQh6QYLdl75uquts7WP4=
Date: Thu, 04 Sep 2025 16:01:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-optimize-folio-refount-update-in-filemap_map_pages.patch added to mm-new branch
Message-Id: <20250904230109.69D37C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: optimize folio refount update in filemap_map_pages
has been added to the -mm mm-new branch.  Its filename is
     filemap-optimize-folio-refount-update-in-filemap_map_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-optimize-folio-refount-update-in-filemap_map_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

filemap-optimize-folio-refount-update-in-filemap_map_pages.patch

