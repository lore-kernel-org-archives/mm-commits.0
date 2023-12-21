Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A801768F7
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vm5FyxKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FD3C433C7;
	Thu, 21 Dec 2023 22:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197816;
	bh=uuqR5ipFr5fJfCO3evlT32nuK8NSmkFZWzKXTxHI5sM=;
	h=Date:To:From:Subject:From;
	b=Vm5FyxKxY0/mRNEMAHgh+Lta4M022SucbQ6QPthWn/KEPf4dPrkutD5Ad4QSmua++
	 QCrkhDBpc7D7hCmrkSZCeYFcLPeQ3Tn/TVyJtjXsxbf/zW1dcoafUP/DhXN3KgYpX2
	 1ZMKXcjMch6D9VgybYLWGt21n4HXPQrRL86oS1M4=
Date: Thu, 21 Dec 2023 14:30:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-compound_mapped-to-entirely_mapped.patch added to mm-unstable branch
Message-Id: <20231221223016.34FD3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: rename COMPOUND_MAPPED to ENTIRELY_MAPPED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-rename-compound_mapped-to-entirely_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-compound_mapped-to-entirely_mapped.patch

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
Subject: mm/rmap: rename COMPOUND_MAPPED to ENTIRELY_MAPPED
Date: Wed, 20 Dec 2023 23:45:03 +0100

We removed all "bool compound" and RMAP_COMPOUND parameters.  Let's remove
the remaining "compound" terminology by making COMPOUND_MAPPED match the
"folio->_entire_mapcount" terminology, renaming it to ENTIRELY_MAPPED.

ENTIRELY_MAPPED is only used when the whole folio is mapped using a single
page table entry (e.g., a single PMD mapping a PMD-sized THP).  For now,
we don't support mapping any THP bigger than that, so ENTIRELY_MAPPED only
applies to PMD-mapped PMD-sized THP only.

Link: https://lkml.kernel.org/r/20231220224504.646757-40-david@redhat.com
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

 Documentation/mm/transhuge.rst |    2 +-
 mm/internal.h                  |    6 +++---
 mm/rmap.c                      |   18 +++++++++---------
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/Documentation/mm/transhuge.rst~mm-rmap-rename-compound_mapped-to-entirely_mapped
+++ a/Documentation/mm/transhuge.rst
@@ -117,7 +117,7 @@ pages:
 
   - map/unmap of a PMD entry for the whole THP increment/decrement
     folio->_entire_mapcount and also increment/decrement
-    folio->_nr_pages_mapped by COMPOUND_MAPPED when _entire_mapcount
+    folio->_nr_pages_mapped by ENTIRELY_MAPPED when _entire_mapcount
     goes from -1 to 0 or 0 to -1.
 
   - map/unmap of individual pages with PTE entry increment/decrement
--- a/mm/internal.h~mm-rmap-rename-compound_mapped-to-entirely_mapped
+++ a/mm/internal.h
@@ -54,12 +54,12 @@ void page_writeback_init(void);
 
 /*
  * If a 16GB hugetlb folio were mapped by PTEs of all of its 4kB pages,
- * its nr_pages_mapped would be 0x400000: choose the COMPOUND_MAPPED bit
+ * its nr_pages_mapped would be 0x400000: choose the ENTIRELY_MAPPED bit
  * above that range, instead of 2*(PMD_SIZE/PAGE_SIZE).  Hugetlb currently
  * leaves nr_pages_mapped at 0, but avoid surprise if it participates later.
  */
-#define COMPOUND_MAPPED		0x800000
-#define FOLIO_PAGES_MAPPED	(COMPOUND_MAPPED - 1)
+#define ENTIRELY_MAPPED		0x800000
+#define FOLIO_PAGES_MAPPED	(ENTIRELY_MAPPED - 1)
 
 /*
  * Flags passed to __show_mem() and show_free_areas() to suppress output in
--- a/mm/rmap.c~mm-rmap-rename-compound_mapped-to-entirely_mapped
+++ a/mm/rmap.c
@@ -1172,7 +1172,7 @@ static __always_inline unsigned int __fo
 			first = atomic_inc_and_test(&page->_mapcount);
 			if (first && folio_test_large(folio)) {
 				first = atomic_inc_return_relaxed(mapped);
-				first = (first < COMPOUND_MAPPED);
+				first = (first < ENTIRELY_MAPPED);
 			}
 
 			if (first)
@@ -1182,15 +1182,15 @@ static __always_inline unsigned int __fo
 	case RMAP_LEVEL_PMD:
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (first) {
-			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
-			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
+			nr = atomic_add_return_relaxed(ENTIRELY_MAPPED, mapped);
+			if (likely(nr < ENTIRELY_MAPPED + ENTIRELY_MAPPED)) {
 				*nr_pmdmapped = folio_nr_pages(folio);
 				nr = *nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
 					nr = 0;
 			} else {
-				/* Raced ahead of a remove of COMPOUND_MAPPED */
+				/* Raced ahead of a remove of ENTIRELY_MAPPED */
 				nr = 0;
 			}
 		}
@@ -1433,7 +1433,7 @@ void folio_add_new_anon_rmap(struct foli
 	} else {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_entire_mapcount, 0);
-		atomic_set(&folio->_nr_pages_mapped, COMPOUND_MAPPED);
+		atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
 		SetPageAnonExclusive(&folio->page);
 		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
 	}
@@ -1514,7 +1514,7 @@ static __always_inline void __folio_remo
 			last = atomic_add_negative(-1, &page->_mapcount);
 			if (last && folio_test_large(folio)) {
 				last = atomic_dec_return_relaxed(mapped);
-				last = (last < COMPOUND_MAPPED);
+				last = (last < ENTIRELY_MAPPED);
 			}
 
 			if (last)
@@ -1524,15 +1524,15 @@ static __always_inline void __folio_remo
 	case RMAP_LEVEL_PMD:
 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
-			nr = atomic_sub_return_relaxed(COMPOUND_MAPPED, mapped);
-			if (likely(nr < COMPOUND_MAPPED)) {
+			nr = atomic_sub_return_relaxed(ENTIRELY_MAPPED, mapped);
+			if (likely(nr < ENTIRELY_MAPPED)) {
 				nr_pmdmapped = folio_nr_pages(folio);
 				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
 					nr = 0;
 			} else {
-				/* An add of COMPOUND_MAPPED raced ahead */
+				/* An add of ENTIRELY_MAPPED raced ahead */
 				nr = 0;
 			}
 		}
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

