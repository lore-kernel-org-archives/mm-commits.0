Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85B4134A9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VsAKo7DT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8163BC433C7;
	Fri, 29 Dec 2023 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879988;
	bh=UNAVRbJjtFKg/yLcquRcetfKofaJLvFLNmyGXEZ3quw=;
	h=Date:To:From:Subject:From;
	b=VsAKo7DTUPRR4RuXxtvCpJNFhzFsEw/HEnvSnyTS/NERyN8y9dCQuCffVcu4mRKE+
	 fssrUMY3akF/YXZxvudObSOwTO6YMzAErB4lPVYq2umH0vRFZPxLy/t2nCXXz/gie8
	 4mOY9UM7i+zkHfuCS97ayCkdsmxPgtGpsseuuC8s=
Date: Fri, 29 Dec 2023 11:59:47 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch removed from -mm tree
Message-Id: <20231229195948.8163BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_add_new_anon_rmap and lru_cache_add_inactive_or_unevictable
has been removed from the -mm tree.  Its filename was
     mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_add_new_anon_rmap and lru_cache_add_inactive_or_unevictable
Date: Mon, 11 Dec 2023 16:22:14 +0000

All callers have now been converted to folio_add_new_anon_rmap() and
folio_add_lru_vma() so we can remove the wrapper.

Link: https://lkml.kernel.org/r/20231211162214.2146080-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

