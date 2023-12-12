Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78347B3A4
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rre0IJ6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42622C433C8;
	Tue, 12 Dec 2023 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702400179;
	bh=0GzNzliUsqR7d69u3sdL29HOkzHNjC6n0EhCXaWTYz0=;
	h=Date:To:From:Subject:From;
	b=Rre0IJ6I8dsHAxditvW1PZWuKu+wlQFES0qYNxjmgf5ncnV7459LH16NVFFUT+oq/
	 PqOtstrkV7To4fqBdalDywthWQzqtmt5LCy6G/ragfvnfyGf/YL8om0e5lcK/hcI+a
	 C7JlDJKG/TfqEPQ/QmVMu+Rl5hahfjql0VlHan+o=
Date: Tue, 12 Dec 2023 08:56:18 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch added to mm-unstable branch
Message-Id: <20231212165619.42622C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageAnonExclusive assertions in unuse_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch

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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

