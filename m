Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0B2D541B
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959035; cv=none; b=NUYF9cuMKqolrBH8YgLSs1Y5No1btvl7asZ+0vDHvl37JMmCvuxfMLHLAEnItAAgVPZ/+DGgTOODMjF+Qk1qapxGmCom+sP2dxJpl5HMUEAtojNCTRlncQoC0dECjoYRWGw4mhoWsMYaSxvpsHaUqgPWnTGWDWKeZZBte9B90LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959035; c=relaxed/simple;
	bh=lCpzTfSqFhzE8MAu27QIAbJb69AQwGGHDoAZ8yr0sW4=;
	h=Date:To:From:Subject:Message-Id; b=PlulIQMjlmTa4jDE06BMEwyyGu8yJRK8EvnpwOD0M6H8/js6p8j0mf8kFHzOYEEnF0ntLUexTh+j7utsKQH/oUA9ClTDx8k6oYpLmdNIaYGy3LK1PSYAn78Lq0T9TYpLGX6xMGuL4ux86i6d2IeVJqKpQ3AxjhuAy9qhUNdimLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KymCEMdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KymCEMdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261F4C4CEED;
	Tue, 12 Aug 2025 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959035;
	bh=lCpzTfSqFhzE8MAu27QIAbJb69AQwGGHDoAZ8yr0sW4=;
	h=Date:To:From:Subject:From;
	b=KymCEMdpKmVBTzenLFfix3KauI5b4NGKDTTaQ/qYbCuQ0pyuftTcBVGXyXhjucOy2
	 blOAe1KObNASyYR50p9FKP73hnoDdiXvCk1auu1IQMm0GQtzJlgLt8CUJU2GX/Uj9/
	 qKsr5sj8FNJxxmo944Rr6jOI4h+NLZi3pjj7I99c=
Date: Mon, 11 Aug 2025 17:37:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sstabellini@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,oleksandr_tyshchenko@epam.com,npiggin@gmail.com,npache@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jgross@suse.com,jannh@google.com,jack@suse.cz,hughd@google.com,dev.jain@arm.com,david.vrabel@citrix.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch added to mm-new branch
Message-Id: <20250812003715.261F4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
Date: Mon, 11 Aug 2025 13:26:27 +0200

Let's factor it out, and convert all checks for unsupported levels to
BUILD_BUG().  The code is written in a way such that force-inlining will
optimize out the levels.

Link: https://lkml.kernel.org/r/20250811112631.759341-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    8 +++++
 include/linux/rmap.h    |   60 +++++++++++++++++---------------------
 mm/rmap.c               |   56 +++++++++++++++++++----------------
 3 files changed, 66 insertions(+), 58 deletions(-)

--- a/include/linux/pgtable.h~mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level
+++ a/include/linux/pgtable.h
@@ -1958,6 +1958,14 @@ static inline bool arch_has_pfn_modify_c
 /* Page-Table Modification Mask */
 typedef unsigned int pgtbl_mod_mask;
 
+enum pgtable_level {
+	PGTABLE_LEVEL_PTE = 0,
+	PGTABLE_LEVEL_PMD,
+	PGTABLE_LEVEL_PUD,
+	PGTABLE_LEVEL_P4D,
+	PGTABLE_LEVEL_PGD,
+};
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
--- a/include/linux/rmap.h~mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level
+++ a/include/linux/rmap.h
@@ -394,18 +394,8 @@ typedef int __bitwise rmap_t;
 /* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
-/*
- * Internally, we're using an enum to specify the granularity. We make the
- * compiler emit specialized code for each granularity.
- */
-enum rmap_level {
-	RMAP_LEVEL_PTE = 0,
-	RMAP_LEVEL_PMD,
-	RMAP_LEVEL_PUD,
-};
-
 static inline void __folio_rmap_sanity_checks(const struct folio *folio,
-		const struct page *page, int nr_pages, enum rmap_level level)
+		const struct page *page, int nr_pages, enum pgtable_level level)
 {
 	/* hugetlb folios are handled separately. */
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
@@ -427,18 +417,18 @@ static inline void __folio_rmap_sanity_c
 	VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		break;
-	case RMAP_LEVEL_PMD:
+	case PGTABLE_LEVEL_PMD:
 		/*
 		 * We don't support folios larger than a single PMD yet. So
-		 * when RMAP_LEVEL_PMD is set, we assume that we are creating
+		 * when PGTABLE_LEVEL_PMD is set, we assume that we are creating
 		 * a single "entire" mapping of the folio.
 		 */
 		VM_WARN_ON_FOLIO(folio_nr_pages(folio) != HPAGE_PMD_NR, folio);
 		VM_WARN_ON_FOLIO(nr_pages != HPAGE_PMD_NR, folio);
 		break;
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PUD:
 		/*
 		 * Assume that we are creating a single "entire" mapping of the
 		 * folio.
@@ -447,7 +437,7 @@ static inline void __folio_rmap_sanity_c
 		VM_WARN_ON_FOLIO(nr_pages != HPAGE_PUD_NR, folio);
 		break;
 	default:
-		VM_WARN_ON_ONCE(true);
+		BUILD_BUG();
 	}
 
 	/*
@@ -567,14 +557,14 @@ static inline void hugetlb_remove_rmap(s
 
 static __always_inline void __folio_dup_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	const int orig_nr_pages = nr_pages;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
 			atomic_inc(&folio->_mapcount);
 			break;
@@ -587,11 +577,13 @@ static __always_inline void __folio_dup_
 		}
 		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		atomic_inc(&folio->_entire_mapcount);
 		folio_inc_large_mapcount(folio, dst_vma);
 		break;
+	default:
+		BUILD_BUG();
 	}
 }
 
@@ -609,13 +601,13 @@ static __always_inline void __folio_dup_
 static inline void folio_dup_file_rmap_ptes(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma)
 {
-	__folio_dup_file_rmap(folio, page, nr_pages, dst_vma, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, nr_pages, dst_vma, PGTABLE_LEVEL_PTE);
 }
 
 static __always_inline void folio_dup_file_rmap_pte(struct folio *folio,
 		struct page *page, struct vm_area_struct *dst_vma)
 {
-	__folio_dup_file_rmap(folio, page, 1, dst_vma, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, 1, dst_vma, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -632,7 +624,7 @@ static inline void folio_dup_file_rmap_p
 		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -640,7 +632,7 @@ static inline void folio_dup_file_rmap_p
 
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
-		struct vm_area_struct *src_vma, enum rmap_level level)
+		struct vm_area_struct *src_vma, enum pgtable_level level)
 {
 	const int orig_nr_pages = nr_pages;
 	bool maybe_pinned;
@@ -665,7 +657,7 @@ static __always_inline int __folio_try_d
 	 * copying if the folio maybe pinned.
 	 */
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (unlikely(maybe_pinned)) {
 			for (i = 0; i < nr_pages; i++)
 				if (PageAnonExclusive(page + i))
@@ -687,8 +679,8 @@ static __always_inline int __folio_try_d
 		} while (page++, --nr_pages > 0);
 		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		if (PageAnonExclusive(page)) {
 			if (unlikely(maybe_pinned))
 				return -EBUSY;
@@ -697,6 +689,8 @@ static __always_inline int __folio_try_d
 		atomic_inc(&folio->_entire_mapcount);
 		folio_inc_large_mapcount(folio, dst_vma);
 		break;
+	default:
+		BUILD_BUG();
 	}
 	return 0;
 }
@@ -730,7 +724,7 @@ static inline int folio_try_dup_anon_rma
 		struct vm_area_struct *src_vma)
 {
 	return __folio_try_dup_anon_rmap(folio, page, nr_pages, dst_vma,
-					 src_vma, RMAP_LEVEL_PTE);
+					 src_vma, PGTABLE_LEVEL_PTE);
 }
 
 static __always_inline int folio_try_dup_anon_rmap_pte(struct folio *folio,
@@ -738,7 +732,7 @@ static __always_inline int folio_try_dup
 		struct vm_area_struct *src_vma)
 {
 	return __folio_try_dup_anon_rmap(folio, page, 1, dst_vma, src_vma,
-					 RMAP_LEVEL_PTE);
+					 PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -770,7 +764,7 @@ static inline int folio_try_dup_anon_rma
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	return __folio_try_dup_anon_rmap(folio, page, HPAGE_PMD_NR, dst_vma,
-					 src_vma, RMAP_LEVEL_PMD);
+					 src_vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 	return -EBUSY;
@@ -778,7 +772,7 @@ static inline int folio_try_dup_anon_rma
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum rmap_level level)
+		struct page *page, int nr_pages, enum pgtable_level level)
 {
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
@@ -873,7 +867,7 @@ static __always_inline int __folio_try_s
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, RMAP_LEVEL_PTE);
+	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -904,7 +898,7 @@ static inline int folio_try_share_anon_r
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	return __folio_try_share_anon_rmap(folio, page, HPAGE_PMD_NR,
-					   RMAP_LEVEL_PMD);
+					   PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 	return -EBUSY;
--- a/mm/rmap.c~mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level
+++ a/mm/rmap.c
@@ -1265,7 +1265,7 @@ static void __folio_mod_stat(struct foli
 
 static __always_inline void __folio_add_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
@@ -1274,7 +1274,7 @@ static __always_inline void __folio_add_
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
 			nr = atomic_inc_and_test(&folio->_mapcount);
 			break;
@@ -1300,11 +1300,11 @@ static __always_inline void __folio_add_
 
 		folio_add_large_mapcount(folio, orig_nr_pages, vma);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-			if (level == RMAP_LEVEL_PMD && first)
+			if (level == PGTABLE_LEVEL_PMD && first)
 				nr_pmdmapped = folio_large_nr_pages(folio);
 			nr = folio_inc_return_large_mapcount(folio, vma);
 			if (nr == 1)
@@ -1323,7 +1323,7 @@ static __always_inline void __folio_add_
 				 * We only track PMD mappings of PMD-sized
 				 * folios separately.
 				 */
-				if (level == RMAP_LEVEL_PMD)
+				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
@@ -1336,6 +1336,8 @@ static __always_inline void __folio_add_
 		}
 		folio_inc_large_mapcount(folio, vma);
 		break;
+	default:
+		BUILD_BUG();
 	}
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 }
@@ -1427,7 +1429,7 @@ static void __page_check_anon_rmap(const
 
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		unsigned long address, rmap_t flags, enum rmap_level level)
+		unsigned long address, rmap_t flags, enum pgtable_level level)
 {
 	int i;
 
@@ -1440,20 +1442,22 @@ static __always_inline void __folio_add_
 
 	if (flags & RMAP_EXCLUSIVE) {
 		switch (level) {
-		case RMAP_LEVEL_PTE:
+		case PGTABLE_LEVEL_PTE:
 			for (i = 0; i < nr_pages; i++)
 				SetPageAnonExclusive(page + i);
 			break;
-		case RMAP_LEVEL_PMD:
+		case PGTABLE_LEVEL_PMD:
 			SetPageAnonExclusive(page);
 			break;
-		case RMAP_LEVEL_PUD:
+		case PGTABLE_LEVEL_PUD:
 			/*
 			 * Keep the compiler happy, we don't support anonymous
 			 * PUD mappings.
 			 */
 			WARN_ON_ONCE(1);
 			break;
+		default:
+			BUILD_BUG();
 		}
 	}
 
@@ -1507,7 +1511,7 @@ void folio_add_anon_rmap_ptes(struct fol
 		rmap_t flags)
 {
 	__folio_add_anon_rmap(folio, page, nr_pages, vma, address, flags,
-			      RMAP_LEVEL_PTE);
+			      PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -1528,7 +1532,7 @@ void folio_add_anon_rmap_pmd(struct foli
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	__folio_add_anon_rmap(folio, page, HPAGE_PMD_NR, vma, address, flags,
-			      RMAP_LEVEL_PMD);
+			      PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1609,7 +1613,7 @@ void folio_add_new_anon_rmap(struct foli
 
 static __always_inline void __folio_add_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
@@ -1634,7 +1638,7 @@ static __always_inline void __folio_add_
 void folio_add_file_rmap_ptes(struct folio *folio, struct page *page,
 		int nr_pages, struct vm_area_struct *vma)
 {
-	__folio_add_file_rmap(folio, page, nr_pages, vma, RMAP_LEVEL_PTE);
+	__folio_add_file_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -1651,7 +1655,7 @@ void folio_add_file_rmap_pmd(struct foli
 		struct vm_area_struct *vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_add_file_rmap(folio, page, HPAGE_PMD_NR, vma, RMAP_LEVEL_PMD);
+	__folio_add_file_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1672,7 +1676,7 @@ void folio_add_file_rmap_pud(struct foli
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	__folio_add_file_rmap(folio, page, HPAGE_PUD_NR, vma, RMAP_LEVEL_PUD);
+	__folio_add_file_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1680,7 +1684,7 @@ void folio_add_file_rmap_pud(struct foli
 
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int last = 0, nr = 0, nr_pmdmapped = 0;
@@ -1689,7 +1693,7 @@ static __always_inline void __folio_remo
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
 			nr = atomic_add_negative(-1, &folio->_mapcount);
 			break;
@@ -1719,11 +1723,11 @@ static __always_inline void __folio_remo
 
 		partially_mapped = nr && atomic_read(mapped);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
 			last = atomic_add_negative(-1, &folio->_entire_mapcount);
-			if (level == RMAP_LEVEL_PMD && last)
+			if (level == PGTABLE_LEVEL_PMD && last)
 				nr_pmdmapped = folio_large_nr_pages(folio);
 			nr = folio_dec_return_large_mapcount(folio, vma);
 			if (!nr) {
@@ -1743,7 +1747,7 @@ static __always_inline void __folio_remo
 			nr = atomic_sub_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED)) {
 				nr_pages = folio_large_nr_pages(folio);
-				if (level == RMAP_LEVEL_PMD)
+				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
@@ -1757,6 +1761,8 @@ static __always_inline void __folio_remo
 
 		partially_mapped = nr && nr < nr_pmdmapped;
 		break;
+	default:
+		BUILD_BUG();
 	}
 
 	/*
@@ -1796,7 +1802,7 @@ static __always_inline void __folio_remo
 void folio_remove_rmap_ptes(struct folio *folio, struct page *page,
 		int nr_pages, struct vm_area_struct *vma)
 {
-	__folio_remove_rmap(folio, page, nr_pages, vma, RMAP_LEVEL_PTE);
+	__folio_remove_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -1813,7 +1819,7 @@ void folio_remove_rmap_pmd(struct folio
 		struct vm_area_struct *vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, RMAP_LEVEL_PMD);
+	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1834,7 +1840,7 @@ void folio_remove_rmap_pud(struct folio
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, RMAP_LEVEL_PUD);
+	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD);
 #else
 	WARN_ON_ONCE(true);
 #endif
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch

