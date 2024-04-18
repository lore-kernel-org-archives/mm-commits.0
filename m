Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509D11A38CA
	for <mm-commits@vger.kernel.org>; Thu, 18 Apr 2024 19:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469748; cv=none; b=URBs3lTD0nbnf+mumPbkrCLPmfqH2k6lj/JvNc3jpeZFJ+vNJRRaBfjfymCmlq6aGI1yznNt4jeMXdh7aYxNhRZ4LgEPAI5dxg7clJeRLGoQdgO4Y5TThq5obGT+TT/HFe+T95yMUTwxzUoCdNmoPsd5JlSIgf6tbgZBYsGg94U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469748; c=relaxed/simple;
	bh=AXRi0ifrCdku2SHBPWYSlj66XUUq6nB4fjbZLgOAHs8=;
	h=Date:To:From:Subject:Message-Id; b=BG9GJvUqZPdUjHz4ZkUnLIqg0PYDUBKMa1dubqEto5DptVK1tytmyxPhnL88S1FaufV5vD3mGM/xIsr/W+x6SQupOczY8wOb810Zt5UF+XyacJJ7ShFax4Owr3Fb7kg3niCpVy+14N7EafCfMDU1hg8qcuAC+QGPjJWTSY8BYAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J90/Vtuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J90/Vtuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB4BC113CC;
	Thu, 18 Apr 2024 19:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713469747;
	bh=AXRi0ifrCdku2SHBPWYSlj66XUUq6nB4fjbZLgOAHs8=;
	h=Date:To:From:Subject:From;
	b=J90/VtukXEdn6r8DmoTCuTxbzwIfd8qo7YFF7rHOO2+psY6VBkPv0ycaHhevaNwGL
	 gnRzjN+qD5A4wMHYMbPBHNbuAfBAWAe0OLpS95ycx9trH5dW1rffnpKLx7zVEWQKUh
	 4O1IHMUEtCRwoYmORNlqzjKUDx+N7y1Pjj8/+9UI=
Date: Thu, 18 Apr 2024 12:49:07 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240418194907.CEB4BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: add any_dirty optional pointer to folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/memory: add any_dirty optional pointer to folio_pte_batch()
Date: Thu, 18 Apr 2024 21:44:34 +0800

This commit adds the any_dirty pointer as an optional parameter to
folio_pte_batch() function.  By using both the any_young and any_dirty
pointers, madvise_free can make smarter decisions about whether to clear
the PTEs when marking large folios as lazyfree.

Link: https://lkml.kernel.org/r/20240418134435.6092-4-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   12 ++++++++++--
 mm/madvise.c  |   19 ++++++++++++++-----
 mm/memory.c   |    4 ++--
 3 files changed, 26 insertions(+), 9 deletions(-)

--- a/mm/internal.h~mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch
+++ a/mm/internal.h
@@ -134,6 +134,8 @@ static inline pte_t __pte_batch_clear_ig
  *		  first one is writable.
  * @any_young: Optional pointer to indicate whether any entry except the
  *		  first one is young.
+ * @any_dirty: Optional pointer to indicate whether any entry except the
+ *		  first one is dirty.
  *
  * Detect a PTE batch: consecutive (present) PTEs that map consecutive
  * pages of the same large folio.
@@ -149,18 +151,20 @@ static inline pte_t __pte_batch_clear_ig
  */
 static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
 		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags,
-		bool *any_writable, bool *any_young)
+		bool *any_writable, bool *any_young, bool *any_dirty)
 {
 	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t expected_pte, *ptep;
-	bool writable, young;
+	bool writable, young, dirty;
 	int nr;
 
 	if (any_writable)
 		*any_writable = false;
 	if (any_young)
 		*any_young = false;
+	if (any_dirty)
+		*any_dirty = false;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 	VM_WARN_ON_FOLIO(!folio_test_large(folio) || max_nr < 1, folio);
@@ -176,6 +180,8 @@ static inline int folio_pte_batch(struct
 			writable = !!pte_write(pte);
 		if (any_young)
 			young = !!pte_young(pte);
+		if (any_dirty)
+			dirty = !!pte_dirty(pte);
 		pte = __pte_batch_clear_ignored(pte, flags);
 
 		if (!pte_same(pte, expected_pte))
@@ -193,6 +199,8 @@ static inline int folio_pte_batch(struct
 			*any_writable |= writable;
 		if (any_young)
 			*any_young |= young;
+		if (any_dirty)
+			*any_dirty |= dirty;
 
 		nr = pte_batch_hint(ptep, pte);
 		expected_pte = pte_advance_pfn(expected_pte, nr);
--- a/mm/madvise.c~mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch
+++ a/mm/madvise.c
@@ -321,6 +321,18 @@ static inline bool can_do_file_pageout(s
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
+static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
+					  struct folio *folio, pte_t *ptep,
+					  pte_t pte, bool *any_young,
+					  bool *any_dirty)
+{
+	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+	int max_nr = (end - addr) / PAGE_SIZE;
+
+	return folio_pte_batch(folio, addr, ptep, pte, max_nr, fpb_flags, NULL,
+			       any_young, any_dirty);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -456,13 +468,10 @@ restart:
 		 * next pte in the range.
 		 */
 		if (folio_test_large(folio)) {
-			const fpb_t fpb_flags = FPB_IGNORE_DIRTY |
-						FPB_IGNORE_SOFT_DIRTY;
-			int max_nr = (end - addr) / PAGE_SIZE;
 			bool any_young;
 
-			nr = folio_pte_batch(folio, addr, pte, ptent, max_nr,
-					     fpb_flags, NULL, &any_young);
+			nr = madvise_folio_pte_batch(addr, end, folio, pte,
+						     ptent, &any_young, NULL);
 			if (any_young)
 				ptent = pte_mkyoung(ptent);
 
--- a/mm/memory.c~mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch
+++ a/mm/memory.c
@@ -989,7 +989,7 @@ copy_present_ptes(struct vm_area_struct
 			flags |= FPB_IGNORE_SOFT_DIRTY;
 
 		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr, flags,
-				     &any_writable, NULL);
+				     &any_writable, NULL, NULL);
 		folio_ref_add(folio, nr);
 		if (folio_test_anon(folio)) {
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
@@ -1558,7 +1558,7 @@ static inline int zap_present_ptes(struc
 	 */
 	if (unlikely(folio_test_large(folio) && max_nr != 1)) {
 		nr = folio_pte_batch(folio, addr, pte, ptent, max_nr, fpb_flags,
-				     NULL, NULL);
+				     NULL, NULL, NULL);
 
 		zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, nr,
 				       addr, details, rss, force_flush,
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch
mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch
mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch
mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch

