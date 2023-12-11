Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C154D5B3
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F4wTrtnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F86C433C8;
	Mon, 11 Dec 2023 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315429;
	bh=GgTQpQg+99XM9ZW6+IVbHr/ZyWzjR3c0jJUyO8IkT7c=;
	h=Date:To:From:Subject:From;
	b=F4wTrtnjza+TVeiObykAduczHgyHilMslXkP1yRZeLvJqNNhSD8vp1idMUIrezWma
	 81l/paezXbSSNb4S5e7pzaP4CekUEP0TGEKeaNyYb5hFWCK+SzZNuD5JxYOdMGNyLk
	 YpSvi4dHfGQX88UHx8nNA25Z8ceOiNvoqvPosQ7g=
Date: Mon, 11 Dec 2023 09:23:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch added to mm-unstable branch
Message-Id: <20231211172349.15F86C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_add_new_anon_rmap and lru_cache_add_inactive_or_unevictable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

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
Subject: mm: remove page_add_new_anon_rmap and lru_cache_add_inactive_or_unevictable
Date: Mon, 11 Dec 2023 16:22:14 +0000

All callers have now been converted to folio_add_new_anon_rmap() and
folio_add_lru_vma() so we can remove the wrapper.

Link: https://lkml.kernel.org/r/20231211162214.2146080-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 --
 include/linux/swap.h |    3 ---
 mm/folio-compat.c    |   16 ----------------
 3 files changed, 21 deletions(-)

--- a/include/linux/rmap.h~mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable
+++ a/include/linux/rmap.h
@@ -197,8 +197,6 @@ typedef int __bitwise rmap_t;
 void folio_move_anon_rmap(struct folio *, struct vm_area_struct *);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
-void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address);
 void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
--- a/include/linux/swap.h~mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable
+++ a/include/linux/swap.h
@@ -397,9 +397,6 @@ void folio_deactivate(struct folio *foli
 void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
 
-extern void lru_cache_add_inactive_or_unevictable(struct page *page,
-						struct vm_area_struct *vma);
-
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
--- a/mm/folio-compat.c~mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable
+++ a/mm/folio-compat.c
@@ -77,12 +77,6 @@ bool redirty_page_for_writepage(struct w
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
-void lru_cache_add_inactive_or_unevictable(struct page *page,
-		struct vm_area_struct *vma)
-{
-	folio_add_lru_vma(page_folio(page), vma);
-}
-
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		pgoff_t index, gfp_t gfp)
 {
@@ -122,13 +116,3 @@ void putback_lru_page(struct page *page)
 {
 	folio_putback_lru(page_folio(page));
 }
-
-#ifdef CONFIG_MMU
-void page_add_new_anon_rmap(struct page *page, struct vm_area_struct *vma,
-		unsigned long address)
-{
-	VM_BUG_ON_PAGE(PageTail(page), page);
-
-	return folio_add_new_anon_rmap((struct folio *)page, vma, address);
-}
-#endif
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
mm-simplify-the-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

