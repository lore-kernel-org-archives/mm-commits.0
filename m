Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA55381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247772; cv=none; b=Or8aPdcaJAqJ+N6Kk4aXPxLFI6BMZQhZKhfqm8QUpzOLhZwRoCmOyFYdbC+CJ3ud1QPjhRGo/K5HmqRGfzFVIXG66Rd9qmOQRZbExT0c48LVuN1dAbuuQgvyao8QabP3eGJTSuBtYO/n5t9HRa3XfgBBLLqk/G5ExlhI86fZ4yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247772; c=relaxed/simple;
	bh=6FPnI9blolYivp3mjJrsrrmTHYdjlHmQiAQLV9CeZCk=;
	h=Date:To:From:Subject:Message-Id; b=pWLwq2CoppWRgN9JE2dU6d/Jk9WwcBHQUtOlGUHg9XsZfrf2KiK3iKqnBkI6kO9TCEts+rJK6JC8XztPUB1JS0in0kVGrgcrvOPFQN7alOwwatdethL07qcYHNsktW6bm1G4BFa8Vvr31dcnZcowErUYxy8pRjsupOF8PZakCw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=005ba3vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="005ba3vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13009C4CEC2;
	Mon,  2 Sep 2024 03:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247772;
	bh=6FPnI9blolYivp3mjJrsrrmTHYdjlHmQiAQLV9CeZCk=;
	h=Date:To:From:Subject:From;
	b=005ba3vluzyQzltkemiTS96xr3AmUUbB32E340jB2ZNRBow87AXuDcc0c9X9gJLAu
	 Kc8TG05bXC8W3LW/weDw2yOYjY5sRNp9Dc0gqx4bh6aTJNppj/5yVQPgX5cLIlOTHT
	 H3Y6vZe3SAoRG75SnYHauBPuukWJeraASZLBv394=
Date: Sun, 01 Sep 2024 20:29:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-return-the-folio-from-swapin_readahead.patch removed from -mm tree
Message-Id: <20240902032932.13009C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: return the folio from swapin_readahead
has been removed from the -mm tree.  Its filename was
     mm-return-the-folio-from-swapin_readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: return the folio from swapin_readahead
Date: Wed, 7 Aug 2024 20:37:32 +0100

The unuse_pte_range() caller only wants the folio while do_swap_page()
wants both the page and the folio.  Since do_swap_page() already has logic
for handling both the folio and the page, move the folio-to-page logic
there.  This also lets us allocate larger folios in the SWP_SYNCHRONOUS_IO
path in future.

Link: https://lkml.kernel.org/r/20240807193734.1865400-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |    6 ++----
 mm/swap.h       |    6 +++---
 mm/swap_state.c |    8 +++-----
 mm/swapfile.c   |    5 +----
 4 files changed, 9 insertions(+), 16 deletions(-)

--- a/mm/memory.c~mm-return-the-folio-from-swapin_readahead
+++ a/mm/memory.c
@@ -4091,7 +4091,6 @@ vm_fault_t do_swap_page(struct vm_fault
 			/* skip swapcache */
 			folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0,
 						vma, vmf->address, false);
-			page = &folio->page;
 			if (folio) {
 				__folio_set_locked(folio);
 				__folio_set_swapbacked(folio);
@@ -4116,10 +4115,8 @@ vm_fault_t do_swap_page(struct vm_fault
 				folio->private = NULL;
 			}
 		} else {
-			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
+			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						vmf);
-			if (page)
-				folio = page_folio(page);
 			swapcache = folio;
 		}
 
@@ -4140,6 +4137,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
+		page = folio_file_page(folio, swp_offset(entry));
 	} else if (PageHWPoison(page)) {
 		/*
 		 * hwpoisoned dirty swapcache pages are kept for killing
--- a/mm/swapfile.c~mm-return-the-folio-from-swapin_readahead
+++ a/mm/swapfile.c
@@ -1980,7 +1980,6 @@ static int unuse_pte_range(struct vm_are
 
 		folio = swap_cache_get_folio(entry, vma, addr);
 		if (!folio) {
-			struct page *page;
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = addr,
@@ -1988,10 +1987,8 @@ static int unuse_pte_range(struct vm_are
 				.pmd = pmd,
 			};
 
-			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
+			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						&vmf);
-			if (page)
-				folio = page_folio(page);
 		}
 		if (!folio) {
 			swp_count = READ_ONCE(si->swap_map[offset]);
--- a/mm/swap.h~mm-return-the-folio-from-swapin_readahead
+++ a/mm/swap.h
@@ -73,8 +73,8 @@ struct folio *__read_swap_cache_async(sw
 		bool skip_if_exists);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
-struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
-			      struct vm_fault *vmf);
+struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
+		struct vm_fault *vmf);
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
@@ -109,7 +109,7 @@ static inline struct folio *swap_cluster
 	return NULL;
 }
 
-static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
+static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 			struct vm_fault *vmf)
 {
 	return NULL;
--- a/mm/swap_state.c~mm-return-the-folio-from-swapin_readahead
+++ a/mm/swap_state.c
@@ -863,13 +863,13 @@ skip:
  * @gfp_mask: memory allocation flags
  * @vmf: fault information
  *
- * Returns the struct page for entry and addr, after queueing swapin.
+ * Returns the struct folio for entry and addr, after queueing swapin.
  *
  * It's a main entry function for swap readahead. By the configuration,
  * it will read ahead blocks by cluster-based(ie, physical disk based)
  * or vma-based(ie, virtual address based on faulty address) readahead.
  */
-struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
+struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
 				struct vm_fault *vmf)
 {
 	struct mempolicy *mpol;
@@ -882,9 +882,7 @@ struct page *swapin_readahead(swp_entry_
 		swap_cluster_readahead(entry, gfp_mask, mpol, ilx);
 	mpol_cond_put(mpol);
 
-	if (!folio)
-		return NULL;
-	return folio_file_page(folio, swp_offset(entry));
+	return folio;
 }
 
 #ifdef CONFIG_SYSFS
_

Patches currently in -mm which might be from willy@infradead.org are

printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch
swap-convert-swapon-to-use-a-folio.patch

