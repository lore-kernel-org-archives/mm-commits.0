Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F64EC001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjHBSyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjHBSyD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:54:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2312728
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C236C61A8D
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23463C433C8;
        Wed,  2 Aug 2023 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002401;
        bh=vknYlLY1aysKc2ljWYWo/q1b+tC5qW8TT+45F/W63x8=;
        h=Date:To:From:Subject:From;
        b=XurqyCyZzlDb6Q5bZgidO84t200P1zswLX6GLhe1yom5A0ySjOHEQtozmhW8yKYvm
         Xh2PO+WEYekUXxud2BeXij451qmYBsidKjtQYp5xjsjIhzc6NOlxNiaLSFMG56f3xS
         iT4c2sD5jJkQyAWmRgkN3NjG6e9QCbs6t8swi/hA=
Date:   Wed, 02 Aug 2023 11:53:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-filemap_map_folio_range.patch added to mm-unstable branch
Message-Id: <20230802185321.23463C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: add filemap_map_folio_range()
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-add-filemap_map_folio_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-filemap_map_folio_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: filemap: add filemap_map_folio_range()
Date: Wed, 2 Aug 2023 16:14:02 +0100

filemap_map_folio_range() maps partial/full folio.  Comparing to original
filemap_map_pages(), it updates refcount once per folio instead of per
page and gets minor performance improvement for large folio.

With a will-it-scale.page_fault3 like app (change file write fault testing
to read fault testing.  Trying to upstream it to will-it-scale at [1]),
got 2% performance gain on a 48C/96T Cascade Lake test box with 96
processes running against xfs.

[1]: https://github.com/antonblanchard/will-it-scale/pull/37

Link: https://lkml.kernel.org/r/20230802151406.3735276-35-willy@infradead.org
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  109 ++++++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 54 deletions(-)

--- a/mm/filemap.c~filemap-add-filemap_map_folio_range
+++ a/mm/filemap.c
@@ -2168,16 +2168,6 @@ out:
 }
 EXPORT_SYMBOL(filemap_get_folios);
 
-static inline
-bool folio_more_pages(struct folio *folio, pgoff_t index, pgoff_t max)
-{
-	if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-		return false;
-	if (index >= max)
-		return false;
-	return index < folio_next_index(folio) - 1;
-}
-
 /**
  * filemap_get_folios_contig - Get a batch of contiguous folios
  * @mapping:	The address_space to search
@@ -3436,10 +3426,10 @@ static bool filemap_map_pmd(struct vm_fa
 	return false;
 }
 
-static struct folio *next_uptodate_page(struct folio *folio,
-				       struct address_space *mapping,
-				       struct xa_state *xas, pgoff_t end_pgoff)
+static struct folio *next_uptodate_folio(struct xa_state *xas,
+		struct address_space *mapping, pgoff_t end_pgoff)
 {
+	struct folio *folio = xas_next_entry(xas, end_pgoff);
 	unsigned long max_idx;
 
 	do {
@@ -3477,20 +3467,51 @@ skip:
 	return NULL;
 }
 
-static inline struct folio *first_map_page(struct address_space *mapping,
-					  struct xa_state *xas,
-					  pgoff_t end_pgoff)
+/*
+ * Map page range [start_page, start_page + nr_pages) of folio.
+ * start_page is gotten from start by folio_page(folio, start)
+ */
+static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
+			struct folio *folio, unsigned long start,
+			unsigned long addr, unsigned int nr_pages)
 {
-	return next_uptodate_page(xas_find(xas, end_pgoff),
-				  mapping, xas, end_pgoff);
-}
+	vm_fault_t ret = 0;
+	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
+	struct page *page = folio_page(folio, start);
+	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
+	unsigned int ref_count = 0, count = 0;
 
-static inline struct folio *next_map_page(struct address_space *mapping,
-					 struct xa_state *xas,
-					 pgoff_t end_pgoff)
-{
-	return next_uptodate_page(xas_next_entry(xas, end_pgoff),
-				  mapping, xas, end_pgoff);
+	do {
+		if (PageHWPoison(page))
+			continue;
+
+		if (mmap_miss > 0)
+			mmap_miss--;
+
+		/*
+		 * NOTE: If there're PTE markers, we'll leave them to be
+		 * handled in the specific fault path, and it'll prohibit the
+		 * fault-around logic.
+		 */
+		if (!pte_none(*vmf->pte))
+			continue;
+
+		if (vmf->address == addr)
+			ret = VM_FAULT_NOPAGE;
+
+		ref_count++;
+		do_set_pte(vmf, page, addr);
+		update_mmu_cache(vma, addr, vmf->pte);
+	} while (vmf->pte++, page++, addr += PAGE_SIZE, ++count < nr_pages);
+
+	/* Restore the vmf->pte */
+	vmf->pte -= nr_pages;
+
+	folio_ref_add(folio, ref_count);
+	WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss);
+
+	return ret;
 }
 
 vm_fault_t filemap_map_pages(struct vm_fault *vmf,
@@ -3503,12 +3524,11 @@ vm_fault_t filemap_map_pages(struct vm_f
 	unsigned long addr;
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct folio *folio;
-	struct page *page;
-	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
 	vm_fault_t ret = 0;
+	int nr_pages = 0;
 
 	rcu_read_lock();
-	folio = first_map_page(mapping, &xas, end_pgoff);
+	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
 	if (!folio)
 		goto out;
 
@@ -3525,17 +3545,13 @@ vm_fault_t filemap_map_pages(struct vm_f
 		goto out;
 	}
 	do {
-again:
-		page = folio_file_page(folio, xas.xa_index);
-		if (PageHWPoison(page))
-			goto unlock;
-
-		if (mmap_miss > 0)
-			mmap_miss--;
+		unsigned long end;
 
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
+		end = folio->index + folio_nr_pages(folio) - 1;
+		nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
 
 		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
@@ -3545,32 +3561,17 @@ again:
 		if (!pte_none(ptep_get(vmf->pte)))
 			goto unlock;
 
-		/* We're about to handle the fault */
-		if (vmf->address == addr)
-			ret = VM_FAULT_NOPAGE;
+		ret |= filemap_map_folio_range(vmf, folio,
+				xas.xa_index - folio->index, addr, nr_pages);
 
-		do_set_pte(vmf, page, addr);
-		/* no need to invalidate: a not-present page won't be cached */
-		update_mmu_cache(vma, addr, vmf->pte);
-		if (folio_more_pages(folio, xas.xa_index, end_pgoff)) {
-			xas.xa_index++;
-			folio_ref_inc(folio);
-			goto again;
-		}
-		folio_unlock(folio);
-		continue;
 unlock:
-		if (folio_more_pages(folio, xas.xa_index, end_pgoff)) {
-			xas.xa_index++;
-			goto again;
-		}
 		folio_unlock(folio);
 		folio_put(folio);
-	} while ((folio = next_map_page(mapping, &xas, end_pgoff)) != NULL);
+		folio = next_uptodate_folio(&xas, mapping, end_pgoff);
+	} while (folio);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	rcu_read_unlock();
-	WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss);
 	return ret;
 }
 EXPORT_SYMBOL(filemap_map_pages);
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

