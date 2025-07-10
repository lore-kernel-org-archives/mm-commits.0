Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8346528467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126212; cv=none; b=nEbrkAmGzrp7Hy8eC+9wJD4as3L7b6WpnQyXoKBUli6IiCUtb6k4pr1ZD0pWHkDWoPCPQeeKRY02A016gnHCj/rVYvGBN23Fi1iAZzJRAKbtInl13dK62AP3XPnjkJTpeYLPSldPYAitoIdhhYTZgkrnceedgt1P8Cn8fuB6dp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126212; c=relaxed/simple;
	bh=onGozhCFpAHqRx1eiaz+8jgu/zMPEtjOHjb5ysk/9oI=;
	h=Date:To:From:Subject:Message-Id; b=ekuEx52MbAvvCj4rAeT2bJOCM/rxNoMrNVvzP5vltJinzBiG2xOklc7tDdm4adPlodxrMS7/afXs0j/JtJPtX9GQokkjbfkFGJA3blZ4T0NohSdUefFj/TjJKyJHysnvX3N22bsmpdidG6ZNqbJn9WMXP8lX3oww8MfRTOoTuqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vd19ou+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vd19ou+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500AEC4CEE3;
	Thu, 10 Jul 2025 05:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126212;
	bh=onGozhCFpAHqRx1eiaz+8jgu/zMPEtjOHjb5ysk/9oI=;
	h=Date:To:From:Subject:From;
	b=Vd19ou+0neH4HNM5ZrxiRhz4JhcT5tFfkIfZp399JfdaMEKusVpFJsI9nOSnCud81
	 /XiN5SQMOO2WYlUy839gaxb+xvHuY/Aiu1Q63wG2JVssz69gyaShs7stcP/IdVV68X
	 Np2LCefMO+A6nCIV9KvNZ41OUARJRhDOpddymJPM=
Date: Wed, 09 Jul 2025 22:43:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-vm_bug_ons.patch removed from -mm tree
Message-Id: <20250710054332.500AEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove (VM_)BUG_ONs
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-vm_bug_ons.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: remove (VM_)BUG_ONs
Date: Wed, 4 Jun 2025 16:05:44 +0200

Especially once we hit one of the assertions in
sanity_check_pinned_pages(), observing follow-up assertions failing in
other code can give good clues about what went wrong, so use
VM_WARN_ON_ONCE instead.

While at it, let's just convert all VM_BUG_ON to VM_WARN_ON_ONCE as well. 
Add one comment for the pfn_valid() check.

We have to introduce VM_WARN_ON_ONCE_VMA() to make that fly.

Drop the BUG_ON after mmap_read_lock_killable(), if that ever returns
something > 0 we're in bigger trouble.  Convert the other BUG_ON's into
VM_WARN_ON_ONCE as well, they are in a similar domain "should never
happen", but more reasonable to check for during early testing.

[david@redhat.com: use the _FOLIO variant where possible, per Lorenzo]
  Link: https://lkml.kernel.org/r/844bd929-a551-48e3-a12e-285cd65ba580@redhat.com
Link: https://lkml.kernel.org/r/20250604140544.688711-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   12 +++++++++++
 mm/gup.c                |   41 +++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 22 deletions(-)

--- a/include/linux/mmdebug.h~mm-gup-remove-vm_bug_ons
+++ a/include/linux/mmdebug.h
@@ -89,6 +89,17 @@ void vma_iter_dump_tree(const struct vma
 	}								\
 	unlikely(__ret_warn_once);					\
 })
+#define VM_WARN_ON_ONCE_VMA(cond, vma)		({			\
+	static bool __section(".data..once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_vma(vma);						\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
 #define VM_WARN_ON_VMG(cond, vmg)		({			\
 	int __ret_warn = !!(cond);					\
 									\
@@ -115,6 +126,7 @@ void vma_iter_dump_tree(const struct vma
 #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_MM(cond, mm)  BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_VMA(cond, vma)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_VMG(cond, vmg)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
--- a/mm/gup.c~mm-gup-remove-vm_bug_ons
+++ a/mm/gup.c
@@ -64,11 +64,11 @@ static inline void sanity_check_pinned_p
 		    !folio_test_anon(folio))
 			continue;
 		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-			VM_BUG_ON_PAGE(!PageAnonExclusive(&folio->page), page);
+			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(&folio->page), folio);
 		else
 			/* Either a PTE-mapped or a PMD-mapped THP. */
-			VM_BUG_ON_PAGE(!PageAnonExclusive(&folio->page) &&
-				       !PageAnonExclusive(page), page);
+			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page) &&
+					     !PageAnonExclusive(page), page);
 	}
 }
 
@@ -760,8 +760,8 @@ static struct page *follow_huge_pmd(stru
 	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
 		return ERR_PTR(-EMLINK);
 
-	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			!PageAnonExclusive(page), page);
+	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+			     !PageAnonExclusive(page), page);
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
 	if (ret)
@@ -899,8 +899,8 @@ static struct page *follow_page_pte(stru
 		goto out;
 	}
 
-	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-		       !PageAnonExclusive(page), page);
+	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+			     !PageAnonExclusive(page), page);
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	ret = try_grab_folio(folio, 1, flags);
@@ -1180,7 +1180,7 @@ static int faultin_page(struct vm_area_s
 	if (unshare) {
 		fault_flags |= FAULT_FLAG_UNSHARE;
 		/* FAULT_FLAG_WRITE and FAULT_FLAG_UNSHARE are incompatible */
-		VM_BUG_ON(fault_flags & FAULT_FLAG_WRITE);
+		VM_WARN_ON_ONCE(fault_flags & FAULT_FLAG_WRITE);
 	}
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
@@ -1760,10 +1760,7 @@ static __always_inline long __get_user_p
 		}
 
 		/* VM_FAULT_RETRY or VM_FAULT_COMPLETED cannot return errors */
-		if (!*locked) {
-			BUG_ON(ret < 0);
-			BUG_ON(ret >= nr_pages);
-		}
+		VM_WARN_ON_ONCE(!*locked && (ret < 0 || ret >= nr_pages));
 
 		if (ret > 0) {
 			nr_pages -= ret;
@@ -1808,7 +1805,6 @@ retry:
 
 		ret = mmap_read_lock_killable(mm);
 		if (ret) {
-			BUG_ON(ret > 0);
 			if (!pages_done)
 				pages_done = ret;
 			break;
@@ -1819,11 +1815,11 @@ retry:
 				       pages, locked);
 		if (!*locked) {
 			/* Continue to retry until we succeeded */
-			BUG_ON(ret != 0);
+			VM_WARN_ON_ONCE(ret != 0);
 			goto retry;
 		}
 		if (ret != 1) {
-			BUG_ON(ret > 1);
+			VM_WARN_ON_ONCE(ret > 1);
 			if (!pages_done)
 				pages_done = ret;
 			break;
@@ -1885,10 +1881,10 @@ long populate_vma_page_range(struct vm_a
 	int gup_flags;
 	long ret;
 
-	VM_BUG_ON(!PAGE_ALIGNED(start));
-	VM_BUG_ON(!PAGE_ALIGNED(end));
-	VM_BUG_ON_VMA(start < vma->vm_start, vma);
-	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(start));
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(end));
+	VM_WARN_ON_ONCE_VMA(start < vma->vm_start, vma);
+	VM_WARN_ON_ONCE_VMA(end   > vma->vm_end, vma);
 	mmap_assert_locked(mm);
 
 	/*
@@ -1957,8 +1953,8 @@ long faultin_page_range(struct mm_struct
 	int gup_flags;
 	long ret;
 
-	VM_BUG_ON(!PAGE_ALIGNED(start));
-	VM_BUG_ON(!PAGE_ALIGNED(end));
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(start));
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(end));
 	mmap_assert_locked(mm);
 
 	/*
@@ -2914,7 +2910,8 @@ static int gup_fast_pte_range(pmd_t pmd,
 		} else if (pte_special(pte))
 			goto pte_unmap;
 
-		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+		/* If it's not marked as special it must have a valid memmap. */
+		VM_WARN_ON_ONCE(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 
 		folio = try_grab_folio_fast(page, 1, flags);
_

Patches currently in -mm which might be from david@redhat.com are

mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch
mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch
mm-page_alloc-let-page-freeing-clear-any-set-page-type.patch
mm-balloon_compaction-make-pageoffline-sticky-until-the-page-is-freed.patch
mm-zsmalloc-make-pagezsmalloc-sticky-until-the-page-is-freed.patch
mm-migrate-rename-isolate_movable_page-to-isolate_movable_ops_page.patch
mm-migrate-rename-putback_movable_folio-to-putback_movable_ops_page.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch
mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch
mm-migrate-move-movable_ops-page-handling-out-of-move_to_new_folio.patch
mm-zsmalloc-stop-using-__clearpagemovable.patch
mm-balloon_compaction-stop-using-__clearpagemovable.patch
mm-migrate-remove-__clearpagemovable.patch
mm-migration-remove-pagemovable.patch
mm-rename-__pagemovable-to-page_has_movable_ops.patch
mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch
mm-remove-__folio_test_movable.patch
mm-stop-storing-migration_ops-in-page-mapping.patch
mm-convert-movable-flag-in-page-mapping-to-a-page-flag.patch
mm-rename-pg_isolated-to-pg_movable_ops_isolated.patch
mm-page-flags-rename-page_mapping_movable-to-page_mapping_anon_ksm.patch
mm-page-alloc-remove-pagemappingflags.patch
mm-page-flags-remove-folio_mapping_flags.patch
mm-simplify-folio_expected_ref_count.patch
mm-rename-page_mapping_-to-folio_mapping_.patch
docs-mm-convert-from-non-lru-page-migration-to-movable_ops-page-migration.patch
mm-balloon_compaction-movable_ops-doc-updates.patch
mm-balloon_compaction-provide-single-balloon_page_insert-and-balloon_mapping_gfp_mask.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

