Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B601A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274502; cv=none; b=PYiB6aGTtFfUnfEf4/k7Gn+iVDhQQa4aRyVeu1jZu6mPZflF6KO2s5+Ia8mcNDHESa+ZQw9aDXU6B7sMga281uP1R2RYKLeR00RQpyNuOjChnuJC5eqRCvB2JBExJVQayXHf+hQxeaDPil6wNzLP28kAYiSE3D7KPFLDDHd7s+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274502; c=relaxed/simple;
	bh=Bb2UhPP76B0rCxYccOA9AS4g1n9djv3baKvpoFlTUk4=;
	h=Date:To:From:Subject:Message-Id; b=T0loQDZfb0ykCNxiEOemcfT+97EmktgE+6jT+1QZnePuiWq2Dyf/ysN90/DAyOtkKpbhgdam3y2VvHhHHyR9V1nBOnTKgr4bYnhh/QCMT5xEf2pNdXgiqndtxqV9NJyo4O2of7I4LU7vkg73A86vWKIyJvl9SYcvLnpoLll87Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T1QmcqN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T1QmcqN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33243C4CEDD;
	Tue, 18 Mar 2025 05:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274502;
	bh=Bb2UhPP76B0rCxYccOA9AS4g1n9djv3baKvpoFlTUk4=;
	h=Date:To:From:Subject:From;
	b=T1QmcqN/8ghWuA15mhsuW4/MCfjIA7DhIflFiZVPwrUJYHOjBEhzGpcPPxL+wc6PY
	 r09yfhOI1uJd9Kao6XfDcb/SrpP6B+MgKGTEhmmrvxhr72ykfO1CsthH5OfuYiq7iJ
	 sS0Uk56m0eXqQgX5ulBXMMWUYJQvYkZGKUMUO8dE=
Date: Mon, 17 Mar 2025 22:08:21 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch removed from -mm tree
Message-Id: <20250318050822.33243C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: add support for PUD sized mappings to rmap
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/rmap: add support for PUD sized mappings to rmap
Date: Fri, 28 Feb 2025 14:31:09 +1100

The rmap doesn't currently support adding a PUD mapping of a folio.  This
patch adds support for entire PUD mappings of folios, primarily to allow
for more standard refcounting of device DAX folios.  Currently DAX is the
only user of this and it doesn't require support for partially mapped
PUD-sized folios so we don't support for that for now.

Link: https://lkml.kernel.org/r/248582c07896e30627d1aeaeebc6949cfd91b851.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   15 +++++++++
 mm/rmap.c            |   67 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 78 insertions(+), 4 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-add-support-for-pud-sized-mappings-to-rmap
+++ a/include/linux/rmap.h
@@ -192,6 +192,7 @@ typedef int __bitwise rmap_t;
 enum rmap_level {
 	RMAP_LEVEL_PTE = 0,
 	RMAP_LEVEL_PMD,
+	RMAP_LEVEL_PUD,
 };
 
 static inline void __folio_rmap_sanity_checks(const struct folio *folio,
@@ -228,6 +229,14 @@ static inline void __folio_rmap_sanity_c
 		VM_WARN_ON_FOLIO(folio_nr_pages(folio) != HPAGE_PMD_NR, folio);
 		VM_WARN_ON_FOLIO(nr_pages != HPAGE_PMD_NR, folio);
 		break;
+	case RMAP_LEVEL_PUD:
+		/*
+		 * Assume that we are creating a single "entire" mapping of the
+		 * folio.
+		 */
+		VM_WARN_ON_FOLIO(folio_nr_pages(folio) != HPAGE_PUD_NR, folio);
+		VM_WARN_ON_FOLIO(nr_pages != HPAGE_PUD_NR, folio);
+		break;
 	default:
 		VM_WARN_ON_ONCE(true);
 	}
@@ -251,12 +260,16 @@ void folio_add_file_rmap_ptes(struct fol
 	folio_add_file_rmap_ptes(folio, page, 1, vma)
 void folio_add_file_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *);
+void folio_add_file_rmap_pud(struct folio *, struct page *,
+		struct vm_area_struct *);
 void folio_remove_rmap_ptes(struct folio *, struct page *, int nr_pages,
 		struct vm_area_struct *);
 #define folio_remove_rmap_pte(folio, page, vma) \
 	folio_remove_rmap_ptes(folio, page, 1, vma)
 void folio_remove_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *);
+void folio_remove_rmap_pud(struct folio *, struct page *,
+		struct vm_area_struct *);
 
 void hugetlb_add_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
@@ -341,6 +354,7 @@ static __always_inline void __folio_dup_
 		atomic_add(orig_nr_pages, &folio->_large_mapcount);
 		break;
 	case RMAP_LEVEL_PMD:
+	case RMAP_LEVEL_PUD:
 		atomic_inc(&folio->_entire_mapcount);
 		atomic_inc(&folio->_large_mapcount);
 		break;
@@ -437,6 +451,7 @@ static __always_inline int __folio_try_d
 		atomic_add(orig_nr_pages, &folio->_large_mapcount);
 		break;
 	case RMAP_LEVEL_PMD:
+	case RMAP_LEVEL_PUD:
 		if (PageAnonExclusive(page)) {
 			if (unlikely(maybe_pinned))
 				return -EBUSY;
--- a/mm/rmap.c~mm-rmap-add-support-for-pud-sized-mappings-to-rmap
+++ a/mm/rmap.c
@@ -1269,12 +1269,19 @@ static __always_inline unsigned int __fo
 		atomic_add(orig_nr_pages, &folio->_large_mapcount);
 		break;
 	case RMAP_LEVEL_PMD:
+	case RMAP_LEVEL_PUD:
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (first) {
 			nr = atomic_add_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED + ENTIRELY_MAPPED)) {
-				*nr_pmdmapped = folio_nr_pages(folio);
-				nr = *nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
+				nr_pages = folio_nr_pages(folio);
+				/*
+				 * We only track PMD mappings of PMD-sized
+				 * folios separately.
+				 */
+				if (level == RMAP_LEVEL_PMD)
+					*nr_pmdmapped = nr_pages;
+				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
 					nr = 0;
@@ -1420,6 +1427,13 @@ static __always_inline void __folio_add_
 		case RMAP_LEVEL_PMD:
 			SetPageAnonExclusive(page);
 			break;
+		case RMAP_LEVEL_PUD:
+			/*
+			 * Keep the compiler happy, we don't support anonymous
+			 * PUD mappings.
+			 */
+			WARN_ON_ONCE(1);
+			break;
 		}
 	}
 	for (i = 0; i < nr_pages; i++) {
@@ -1613,6 +1627,27 @@ void folio_add_file_rmap_pmd(struct foli
 #endif
 }
 
+/**
+ * folio_add_file_rmap_pud - add a PUD mapping to a page range of a folio
+ * @folio:	The folio to add the mapping to
+ * @page:	The first page to add
+ * @vma:	The vm area in which the mapping is added
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+void folio_add_file_rmap_pud(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_add_file_rmap(folio, page, HPAGE_PUD_NR, vma, RMAP_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
@@ -1642,13 +1677,16 @@ static __always_inline void __folio_remo
 		partially_mapped = nr && atomic_read(mapped);
 		break;
 	case RMAP_LEVEL_PMD:
+	case RMAP_LEVEL_PUD:
 		atomic_dec(&folio->_large_mapcount);
 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
 			nr = atomic_sub_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED)) {
-				nr_pmdmapped = folio_nr_pages(folio);
-				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
+				nr_pages = folio_nr_pages(folio);
+				if (level == RMAP_LEVEL_PMD)
+					nr_pmdmapped = nr_pages;
+				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
 					nr = 0;
@@ -1720,6 +1758,27 @@ void folio_remove_rmap_pmd(struct folio
 #else
 	WARN_ON_ONCE(true);
 #endif
+}
+
+/**
+ * folio_remove_rmap_pud - remove a PUD mapping from a page range of a folio
+ * @folio:	The folio to remove the mapping from
+ * @page:	The first page to remove
+ * @vma:	The vm area from which the mapping is removed
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+void folio_remove_rmap_pud(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, RMAP_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
 }
 
 /* We support batch unmapping of PTEs for lazyfree large folios */
_

Patches currently in -mm which might be from apopple@nvidia.com are


