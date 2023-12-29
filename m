Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9311E13AE4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nM2OpSTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618FCC433C9;
	Fri, 29 Dec 2023 20:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880117;
	bh=hnIJ0/gzEZ+a+Q0plqaMlfZiMB4gyc5s2oc1VjMnkLI=;
	h=Date:To:From:Subject:From;
	b=nM2OpSTlPZG1EfRXzbpRp9HIQNZy0xbg5VOd/FPUA2uF7s5l4YmF3Z6mCU98Zr6+q
	 WCccMlLNtgFW+XqknILHgrZ6StU26dMBZhv24X3oFS/HLY9/Xnzz+f0BpwLKXH5dWz
	 DjQgwmcxjH5navO55Ku28XgJiLIbT/KAPCcECLdA=
Date: Fri, 29 Dec 2023 12:01:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch removed from -mm tree
Message-Id: <20231229200157.618FCC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


