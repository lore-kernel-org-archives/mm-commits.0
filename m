Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB4B678
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FsukIxk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBA2C433C7;
	Thu, 21 Dec 2023 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197807;
	bh=vFLmHEoD+260qtXK2cLGCRhroY9RWFvD7bBnpWJfdlA=;
	h=Date:To:From:Subject:From;
	b=FsukIxk4NtGxFDawL1xs6K7Ml8yaZA2u1o7C56bPm65MqlEGzuLb0R4LDgckt0ASh
	 A7pwsLyhIeIFg/1Oed2/ox3xPEBO/kMURfk39K07mPivJS3VcfC9tKkaeN67NVLwCC
	 +vWBrzcl9VIkWPIl95R8pniJl8nrP3nYdthg0oPo=
Date: Thu, 21 Dec 2023 14:30:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch added to mm-unstable branch
Message-Id: <20231221223007.CEBA2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch

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
Subject: mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()
Date: Wed, 20 Dec 2023 23:44:57 +0100

Let's convert page_dup_file_rmap() like the other rmap functions.  As
there is only a single caller, convert that single caller right away and
remove page_dup_file_rmap().

Add folio_dup_file_rmap_ptes() right away, we want to perform rmap baching
during fork() soon.

Link: https://lkml.kernel.org/r/20231220224504.646757-34-david@redhat.com
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

 include/linux/rmap.h |   59 +++++++++++++++++++++++++++++++++++++----
 mm/memory.c          |    2 -
 2 files changed, 55 insertions(+), 6 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_
+++ a/include/linux/rmap.h
@@ -308,6 +308,60 @@ static inline void hugetlb_remove_rmap(s
 	atomic_dec(&folio->_entire_mapcount);
 }
 
+static __always_inline void __folio_dup_file_rmap(struct folio *folio,
+		struct page *page, int nr_pages, enum rmap_level level)
+{
+	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
+
+	switch (level) {
+	case RMAP_LEVEL_PTE:
+		do {
+			atomic_inc(&page->_mapcount);
+		} while (page++, --nr_pages > 0);
+		break;
+	case RMAP_LEVEL_PMD:
+		atomic_inc(&folio->_entire_mapcount);
+		break;
+	}
+}
+
+/**
+ * folio_dup_file_rmap_ptes - duplicate PTE mappings of a page range of a folio
+ * @folio:	The folio to duplicate the mappings of
+ * @page:	The first page to duplicate the mappings of
+ * @nr_pages:	The number of pages of which the mapping will be duplicated
+ *
+ * The page range of the folio is defined by [page, page + nr_pages)
+ *
+ * The caller needs to hold the page table lock.
+ */
+static inline void folio_dup_file_rmap_ptes(struct folio *folio,
+		struct page *page, int nr_pages)
+{
+	__folio_dup_file_rmap(folio, page, nr_pages, RMAP_LEVEL_PTE);
+}
+#define folio_dup_file_rmap_pte(folio, page) \
+	folio_dup_file_rmap_ptes(folio, page, 1)
+
+/**
+ * folio_dup_file_rmap_pmd - duplicate a PMD mapping of a page range of a folio
+ * @folio:	The folio to duplicate the mapping of
+ * @page:	The first page to duplicate the mapping of
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PMD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+static inline void folio_dup_file_rmap_pmd(struct folio *folio,
+		struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, RMAP_LEVEL_PTE);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 static inline void __page_dup_rmap(struct page *page, bool compound)
 {
 	VM_WARN_ON(folio_test_hugetlb(page_folio(page)));
@@ -322,11 +376,6 @@ static inline void __page_dup_rmap(struc
 	}
 }
 
-static inline void page_dup_file_rmap(struct page *page, bool compound)
-{
-	__page_dup_rmap(page, compound);
-}
-
 /**
  * page_try_dup_anon_rmap - try duplicating a mapping of an already mapped
  *			    anonymous page
--- a/mm/memory.c~mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_
+++ a/mm/memory.c
@@ -965,7 +965,7 @@ copy_present_pte(struct vm_area_struct *
 		rss[MM_ANONPAGES]++;
 	} else if (page) {
 		folio_get(folio);
-		page_dup_file_rmap(page, false);
+		folio_dup_file_rmap_pte(folio, page);
 		rss[mm_counter_file(page)]++;
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

