Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AC7DF55
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mk8qd1CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F334C433C8;
	Thu, 21 Dec 2023 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197806;
	bh=U9AR0f6OgTw3l6OL8mgmRODO7iow58lmJBRNOKWhGG8=;
	h=Date:To:From:Subject:From;
	b=mk8qd1CLF9jUegcuRPNb7taD8YFrCIgS32QP2EYmnWmHX5m4fpIl0hxVMvxemDy5s
	 vcFasVrtNDQaBTan7FbSLboxcTiA9tvI5dD3DLJW0ner7FE+A3B8Y/7cpkJaFuSrwJ
	 Cjtf9QkwjGWdPM4rACQO7CQ2Zt1qWMK4jsOpSKpI=
Date: Thu, 21 Dec 2023 14:30:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-remove-page_remove_rmap.patch added to mm-unstable branch
Message-Id: <20231221223006.2F334C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: remove page_remove_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-remove-page_remove_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-remove-page_remove_rmap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: remove page_remove_rmap()
Date: Wed, 20 Dec 2023 23:44:56 +0100

All callers are gone, let's remove it and some leftover traces.

Link: https://lkml.kernel.org/r/20231220224504.646757-33-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 +---
 mm/filemap.c         |   10 +++++-----
 mm/internal.h        |    2 +-
 mm/memory-failure.c  |    4 ++--
 mm/rmap.c            |   23 ++---------------------
 5 files changed, 11 insertions(+), 32 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-page_remove_rmap
+++ a/include/linux/rmap.h
@@ -241,8 +241,6 @@ void folio_add_file_rmap_ptes(struct fol
 	folio_add_file_rmap_ptes(folio, page, 1, vma)
 void folio_add_file_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *);
-void page_remove_rmap(struct page *, struct vm_area_struct *,
-		bool compound);
 void folio_remove_rmap_ptes(struct folio *, struct page *, int nr_pages,
 		struct vm_area_struct *);
 #define folio_remove_rmap_pte(folio, page, vma) \
@@ -389,7 +387,7 @@ dup:
  *
  * This is similar to page_try_dup_anon_rmap(), however, not used during fork()
  * to duplicate a mapping, but instead to prepare for KSM or temporarily
- * unmapping a page (swap, migration) via page_remove_rmap().
+ * unmapping a page (swap, migration) via folio_remove_rmap_*().
  *
  * Marking the page shared can only fail if the page may be pinned; device
  * private pages cannot get pinned and consequently this function cannot fail.
--- a/mm/filemap.c~mm-rmap-remove-page_remove_rmap
+++ a/mm/filemap.c
@@ -113,11 +113,11 @@
  *    ->i_pages lock		(try_to_unmap_one)
  *    ->lruvec->lru_lock	(follow_page->mark_page_accessed)
  *    ->lruvec->lru_lock	(check_pte_range->isolate_lru_page)
- *    ->private_lock		(page_remove_rmap->set_page_dirty)
- *    ->i_pages lock		(page_remove_rmap->set_page_dirty)
- *    bdi.wb->list_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
- *    ->memcg->move_lock	(page_remove_rmap->folio_memcg_lock)
+ *    ->private_lock		(folio_remove_rmap_pte->set_page_dirty)
+ *    ->i_pages lock		(folio_remove_rmap_pte->set_page_dirty)
+ *    bdi.wb->list_lock		(folio_remove_rmap_pte->set_page_dirty)
+ *    ->inode->i_lock		(folio_remove_rmap_pte->set_page_dirty)
+ *    ->memcg->move_lock	(folio_remove_rmap_pte->folio_memcg_lock)
  *    bdi.wb->list_lock		(zap_pte_range->set_page_dirty)
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
--- a/mm/internal.h~mm-rmap-remove-page_remove_rmap
+++ a/mm/internal.h
@@ -651,7 +651,7 @@ folio_within_vma(struct folio *folio, st
  * under page table lock for the pte/pmd being added or removed.
  *
  * mlock is usually called at the end of page_add_*_rmap(), munlock at
- * the end of page_remove_rmap(); but new anon folios are managed by
+ * the end of folio_remove_rmap_*(); but new anon folios are managed by
  * folio_add_lru_vma() calling mlock_new_folio().
  */
 void mlock_folio(struct folio *folio);
--- a/mm/memory-failure.c~mm-rmap-remove-page_remove_rmap
+++ a/mm/memory-failure.c
@@ -2315,8 +2315,8 @@ try_again:
 	 * We use page flags to determine what action should be taken, but
 	 * the flags can be modified by the error containment action.  One
 	 * example is an mlocked page, where PG_mlocked is cleared by
-	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
-	 * correctly, we save a copy of the page flags at this time.
+	 * folio_remove_rmap_*() in try_to_unmap_one(). So to determine page
+	 * status correctly, we save a copy of the page flags at this time.
 	 */
 	page_flags = p->flags;
 
--- a/mm/rmap.c~mm-rmap-remove-page_remove_rmap
+++ a/mm/rmap.c
@@ -470,7 +470,7 @@ void __init anon_vma_init(void)
 /*
  * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
  *
- * Since there is no serialization what so ever against page_remove_rmap()
+ * Since there is no serialization what so ever against folio_remove_rmap_*()
  * the best this function can do is return a refcount increased anon_vma
  * that might have been relevant to this page.
  *
@@ -487,7 +487,7 @@ void __init anon_vma_init(void)
  * [ something equivalent to page_mapped_in_vma() ].
  *
  * Since anon_vma's slab is SLAB_TYPESAFE_BY_RCU and we know from
- * page_remove_rmap() that the anon_vma pointer from page->mapping is valid
+ * folio_remove_rmap_*() that the anon_vma pointer from page->mapping is valid
  * if there is a mapcount, we can dereference the anon_vma after observing
  * those.
  *
@@ -1498,25 +1498,6 @@ void folio_add_file_rmap_pmd(struct foli
 #endif
 }
 
-/**
- * page_remove_rmap - take down pte mapping from a page
- * @page:	page to remove mapping from
- * @vma:	the vm area from which the mapping is removed
- * @compound:	uncharge the page as compound or small page
- *
- * The caller needs to hold the pte lock.
- */
-void page_remove_rmap(struct page *page, struct vm_area_struct *vma,
-		bool compound)
-{
-	struct folio *folio = page_folio(page);
-
-	if (likely(!compound))
-		folio_remove_rmap_pte(folio, page, vma);
-	else
-		folio_remove_rmap_pmd(folio, page, vma);
-}
-
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-rename-hugepage_add-to-hugetlb_add.patch
mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch
mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch
mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch
mm-rmap-convert-folio_add_file_rmap_range-into-folio_add_file_rmap_.patch
mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch
mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch
mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-rmap-remove-page_add_file_rmap.patch
mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch
mm-rmap-introduce-folio_add_anon_rmap_.patch
mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch
mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch
mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-rmap-remove-page_add_anon_rmap.patch
mm-rmap-remove-rmap_compound.patch
mm-rmap-introduce-folio_remove_rmap_.patch
kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch
mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch
mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch
mm-ksm-page_remove_rmap-folio_remove_rmap_pte.patch
mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch
mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch
mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch
documentation-stop-referring-to-page_remove_rmap.patch
mm-rmap-remove-page_remove_rmap.patch
mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch
mm-rmap-introduce-folio_try_dup_anon_rmap_.patch
mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch
mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch
mm-rmap-remove-page_try_dup_anon_rmap.patch
mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch
mm-rmap-rename-compound_mapped-to-entirely_mapped.patch
mm-remove-one-last-reference-to-page_add__rmap.patch

