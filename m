Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A4F148857
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064848; cv=none; b=fXdtG1z723D3JicbbpI4y/NC/D9Tkjc9S7ma3TUR6KumEk3YlLCio9nULdQB3+qjknVPyAHukWt2bC3ky9Pszr5BWbwM3Fvuniib9z4JEkdiQUn3zPIOrFlyBBU77f3xX6wRc+xQ8HGmfQ0PS08WDZurPSt3HUvME2oQ7CZeD+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064848; c=relaxed/simple;
	bh=sCM2XLm0Ft4O5UMRp0N4Rqde3TXVqtDTjiIhjAWn6Jw=;
	h=Date:To:From:Subject:Message-Id; b=INUoGTWoj/Y8RUJ69+9hihxwYno1IMDysGiUOjpjygYLCHU+OyKLnm2utARGsK3rU2TgORd7rcPE/etU1dX0uejp11MXs4EecKrrLNQnOoDk5+GlMI6MYMwcGedCy92V43YfVuqd2uRM04O96HMUhVDi1/uxJ4jWswlACqwWWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVlBXJ32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVlBXJ32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA10FC32782;
	Wed,  7 Aug 2024 21:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723064847;
	bh=sCM2XLm0Ft4O5UMRp0N4Rqde3TXVqtDTjiIhjAWn6Jw=;
	h=Date:To:From:Subject:From;
	b=fVlBXJ32Q23bFqVkAdHm4ywLfsAR3NsOmJ5TyOE+X85d3gNqolZDRtRmaoz4/Dyuw
	 ch06MJ/TAbl6pVCgBGNddjxQOhf6+q2M71LPm4sO97YCGfi4ybly6XkXkoggyFQJZv
	 oFP2Ywp1LVdsTZsCgQeULpWiyf2IP+nlf18e/AMg=
Date: Wed, 07 Aug 2024 14:07:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-return-the-folio-from-swapin_readahead.patch added to mm-unstable branch
Message-Id: <20240807210727.AA10FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: return the folio from swapin_readahead
has been added to the -mm mm-unstable branch.  Its filename is
     mm-return-the-folio-from-swapin_readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-return-the-folio-from-swapin_readahead.patch

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
@@ -4223,7 +4223,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			folio = alloc_swap_folio(vmf);
-			page = &folio->page;
 			if (folio) {
 				__folio_set_locked(folio);
 				__folio_set_swapbacked(folio);
@@ -4265,10 +4264,8 @@ vm_fault_t do_swap_page(struct vm_fault
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
 
@@ -4289,6 +4286,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
+		page = folio_file_page(folio, swp_offset(entry));
 	} else if (PageHWPoison(page)) {
 		/*
 		 * hwpoisoned dirty swapcache pages are kept for killing
--- a/mm/swapfile.c~mm-return-the-folio-from-swapin_readahead
+++ a/mm/swapfile.c
@@ -2124,7 +2124,6 @@ static int unuse_pte_range(struct vm_are
 
 		folio = swap_cache_get_folio(entry, vma, addr);
 		if (!folio) {
-			struct page *page;
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = addr,
@@ -2132,10 +2131,8 @@ static int unuse_pte_range(struct vm_are
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

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch

