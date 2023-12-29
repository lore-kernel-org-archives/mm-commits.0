Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C8514006
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2OOoHp8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02191C433C9;
	Fri, 29 Dec 2023 20:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880105;
	bh=8y/AWyj88NOtRAdomliA922cK0Rsx4ZCVL15Y47sD2Y=;
	h=Date:To:From:Subject:From;
	b=2OOoHp8Q5RO+3puzKMacfMMXsrBy423uSpIUWVtEceuIwBymEBDg4WTOHsTh2MaKU
	 26W/7IWt2DyOuyb+CP5MGZ058pc0fEq2QRX5ck/D/+G+EVwa9wGyeCW7MPHww5n3aH
	 VMq/z3hMLq5EeD12OguC6nm1Xb+S1Fj/ycWRx5Dc=
Date: Fri, 29 Dec 2023 12:01:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-page_add_anon_rmap.patch removed from -mm tree
Message-Id: <20231229200145.02191C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove page_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-page_add_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: remove page_add_anon_rmap()
Date: Wed, 20 Dec 2023 23:44:45 +0100

All users are gone, remove it and all traces.

Link: https://lkml.kernel.org/r/20231220224504.646757-22-david@redhat.com
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

 include/linux/rmap.h |    2 --
 mm/rmap.c            |   31 ++++---------------------------
 2 files changed, 4 insertions(+), 29 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-page_add_anon_rmap
+++ a/include/linux/rmap.h
@@ -239,8 +239,6 @@ void folio_add_anon_rmap_ptes(struct fol
 	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
 void folio_add_anon_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *, unsigned long address, rmap_t flags);
-void page_add_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address, rmap_t flags);
 void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
--- a/mm/rmap.c~mm-rmap-remove-page_add_anon_rmap
+++ a/mm/rmap.c
@@ -1270,7 +1270,7 @@ static void __page_check_anon_rmap(struc
 	 * The page's anon-rmap details (mapping and index) are guaranteed to
 	 * be set up correctly at this point.
 	 *
-	 * We have exclusion against page_add_anon_rmap because the caller
+	 * We have exclusion against folio_add_anon_rmap_*() because the caller
 	 * always holds the page locked.
 	 *
 	 * We have exclusion against folio_add_new_anon_rmap because those pages
@@ -1283,29 +1283,6 @@ static void __page_check_anon_rmap(struc
 		       page);
 }
 
-/**
- * page_add_anon_rmap - add pte mapping to an anonymous page
- * @page:	the page to add the mapping to
- * @vma:	the vm area in which the mapping is added
- * @address:	the user virtual address mapped
- * @flags:	the rmap flags
- *
- * The caller needs to hold the pte lock, and the page must be locked in
- * the anon_vma case: to serialize mapping,index checking after setting,
- * and to ensure that PageAnon is not being upgraded racily to PageKsm
- * (but PageKsm is never downgraded to PageAnon).
- */
-void page_add_anon_rmap(struct page *page, struct vm_area_struct *vma,
-		unsigned long address, rmap_t flags)
-{
-	struct folio *folio = page_folio(page);
-
-	if (likely(!(flags & RMAP_COMPOUND)))
-		folio_add_anon_rmap_pte(folio, page, vma, address, flags);
-	else
-		folio_add_anon_rmap_pmd(folio, page, vma, address, flags);
-}
-
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags, enum rmap_level level)
@@ -1419,7 +1396,7 @@ void folio_add_anon_rmap_pmd(struct foli
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  *
- * Like page_add_anon_rmap() but must only be called on *new* folios.
+ * Like folio_add_anon_rmap_*() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
  * The folio does not have to be locked.
  *
@@ -1479,7 +1456,7 @@ static __always_inline void __folio_add_
 	if (nr)
 		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
 
-	/* See comments in page_add_anon_rmap() */
+	/* See comments in folio_add_anon_rmap_*() */
 	if (!folio_test_large(folio))
 		mlock_vma_folio(folio, vma);
 }
@@ -1593,7 +1570,7 @@ void page_remove_rmap(struct page *page,
 
 	/*
 	 * It would be tidy to reset folio_test_anon mapping when fully
-	 * unmapped, but that might overwrite a racing page_add_anon_rmap
+	 * unmapped, but that might overwrite a racing folio_add_anon_rmap_*()
 	 * which increments mapcount after us but sets mapping before us:
 	 * so leave the reset to free_pages_prepare, and remember that
 	 * it's only reliable while mapped.
_

Patches currently in -mm which might be from david@redhat.com are


