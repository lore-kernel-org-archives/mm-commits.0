Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129912E46
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGMaUnvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BB1C433C7;
	Fri, 29 Dec 2023 19:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879981;
	bh=fvHyCHMlImhyjqb/nfCtT2P29R1ErSocVk5GBkQbkns=;
	h=Date:To:From:Subject:From;
	b=VGMaUnvSR+Pm6RadcztIOGvJnmI2+jz9PZpHW/LXhgnZYxP1cvjT2X+EVuTed+RkT
	 49AGtT2qnWrAkkAUbQpXsfcVflbS5BYAS95Nb3rI/gZIniMmrk3StWH29X+R71SI2o
	 HaSPH+bCtjI9lNkHCNzVeKFJdzC7v1rL+CWLPiM0=
Date: Fri, 29 Dec 2023 11:59:41 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch removed from -mm tree
Message-Id: <20231229195941.A9BB1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageAnonExclusive assertions in unuse_pte()
has been removed from the -mm tree.  Its filename was
     mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageAnonExclusive assertions in unuse_pte()
Date: Tue, 12 Dec 2023 16:48:13 +0000

The page in question is either freshly allocated or known to be in
the swap cache; these assertions are not particularly useful.

Link: https://lkml.kernel.org/r/20231212164813.2540119-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swapfile.c~mm-remove-pageanonexclusive-assertions-in-unuse_pte
+++ a/mm/swapfile.c
@@ -1788,10 +1788,6 @@ static int unuse_pte(struct vm_area_stru
 	 */
 	arch_swap_restore(entry, page_folio(page));
 
-	/* See do_swap_page() */
-	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
-	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
-
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

