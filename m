Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B064E1AD
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175637; cv=none; b=WFluEDq6CCXjv32StVUlOfwi4relarKutI0JQp9cMPJ8sOYXbkh1xo4ZZWihBM08+kMIZWzZ9hs3rJQg9pnki0KP+hA1lPAqkUo/JMGYqkCqKmx8gBQx5v50+ohWuXgPvgCXaHgUmOW/6TwhH3IlzAqGEWjraif9fIlPNAj+iGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175637; c=relaxed/simple;
	bh=cWb6bGYWnQC+r7UtioAflWvNlU9QJmAPkJoUOfUSxDQ=;
	h=Date:To:From:Subject:Message-Id; b=owgByDJ/JADwCTCtZPlknaS2KTZ0DJhr6Fgy9I53pnt8PuB0DH7LQtvYL8Vf4NT0p0NM5NWyoo8qXg23bVtsh3xwNLLZYO9cJRPSLJaBKZCDrhmOIqZDHgBPix3mBLImaZM3cFozrLSsP6M83gKrmnY/CirBqmuWqHukDTJUgJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DMOkwGtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DMOkwGtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22BCC433C7;
	Mon,  5 Feb 2024 23:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175637;
	bh=cWb6bGYWnQC+r7UtioAflWvNlU9QJmAPkJoUOfUSxDQ=;
	h=Date:To:From:Subject:From;
	b=DMOkwGtQMCnTnFPDiC9d5uYIX3fea6penzhsXNVJn78ixpipkWE6ROGkdGtFAvwYF
	 SC24MxAjfyOnjDRuNUgqapZfAiYhCm+QZ5rkJB7WxcuoSvQhIACb6N4ThsvqTK97xZ
	 py0FJcifocm4auQk9Ften7paZ41ABTi9246PtDvc=
Date: Mon, 05 Feb 2024 15:27:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch removed from -mm tree
Message-Id: <20240205232716.F22BCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: add missing flag and statistics for kernel PTE page
has been removed from the -mm tree.  Its filename was
     mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: add missing flag and statistics for kernel PTE page
Date: Thu, 1 Feb 2024 16:05:40 +0800

For kernel PTE page, we do not need to allocate and initialize its split
ptlock, but as a page table page, it's still necessary to add PG_table
flag and NR_PAGETABLE statistics for it.

Link: https://lkml.kernel.org/r/f023a6687b9f2109401e7522b727aa4708dc05f1.1706774109.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    7 ++++++-
 include/linux/mm.h            |   21 ++++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/include/asm-generic/pgalloc.h~mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page
+++ a/include/asm-generic/pgalloc.h
@@ -23,6 +23,8 @@ static inline pte_t *__pte_alloc_one_ker
 
 	if (!ptdesc)
 		return NULL;
+
+	__pagetable_pte_ctor(ptdesc);
 	return ptdesc_address(ptdesc);
 }
 
@@ -46,7 +48,10 @@ static inline pte_t *pte_alloc_one_kerne
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_free(virt_to_ptdesc(pte));
+	struct ptdesc *ptdesc = virt_to_ptdesc(pte);
+
+	__pagetable_pte_dtor(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 /**
--- a/include/linux/mm.h~mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page
+++ a/include/linux/mm.h
@@ -2922,26 +2922,37 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
-static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
+static inline void __pagetable_pte_ctor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	if (!ptlock_init(ptdesc))
-		return false;
 	__folio_set_pgtable(folio);
 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
+static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
+{
+	if (!ptlock_init(ptdesc))
+		return false;
+
+	__pagetable_pte_ctor(ptdesc);
 	return true;
 }
 
-static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+static inline void __pagetable_pte_dtor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	ptlock_free(ptdesc);
 	__folio_clear_pgtable(folio);
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+{
+	ptlock_free(ptdesc);
+	__pagetable_pte_dtor(ptdesc);
+}
+
 pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch

