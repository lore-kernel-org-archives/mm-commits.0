Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3114016
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/u2QzxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DAEC433C7;
	Fri, 29 Dec 2023 20:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880087;
	bh=Rn29Uq5oQx3pWaRsUTTXldMCQyL7uHnRWQHLEu6wq5Q=;
	h=Date:To:From:Subject:From;
	b=j/u2QzxRVRKgsPNYHB9ShANC9tRhniBoAI1XwYPsnHGCe8oZZstM6zJDApfO/gLD2
	 5u4aDbjka/ym+6ZbffH5giV0e5Ja9tWELjSadtqFVwmSAAwhjr49szp1dVhoKxK6KI
	 26w5rGgA2rc/M5n8iiR8kuYMXtwBexjzoOjDEkSs=
Date: Fri, 29 Dec 2023 12:01:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch removed from -mm tree
Message-Id: <20231229200127.78DAEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: introduce and use hugetlb_try_dup_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: introduce and use hugetlb_try_dup_anon_rmap()
Date: Wed, 20 Dec 2023 23:44:28 +0100

hugetlb rmap handling differs quite a lot from "ordinary" rmap code.  For
example, hugetlb currently only supports entire mappings, and treats any
mapping as mapped using a single "logical PTE".  Let's move it out of the
way so we can overhaul our "ordinary" rmap.  implementation/interface.

So let's introduce and use hugetlb_try_dup_anon_rmap() to make all hugetlb
handling use dedicated hugetlb_* rmap functions.

Add sanity checks that we end up with the right folios in the right
functions.

Note that is_device_private_page() does not apply to hugetlb.

Link: https://lkml.kernel.org/r/20231220224504.646757-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |   12 +++++++++---
 include/linux/rmap.h |   18 ++++++++++++++++++
 mm/hugetlb.c         |    3 +--
 3 files changed, 28 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap
+++ a/include/linux/mm.h
@@ -1964,15 +1964,21 @@ static inline bool page_maybe_dma_pinned
  *
  * The caller has to hold the PT lock and the vma->vm_mm->->write_protect_seq.
  */
-static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
-					  struct page *page)
+static inline bool folio_needs_cow_for_dma(struct vm_area_struct *vma,
+					  struct folio *folio)
 {
 	VM_BUG_ON(!(raw_read_seqcount(&vma->vm_mm->write_protect_seq) & 1));
 
 	if (!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags))
 		return false;
 
-	return page_maybe_dma_pinned(page);
+	return folio_maybe_dma_pinned(folio);
+}
+
+static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
+					  struct page *page)
+{
+	return folio_needs_cow_for_dma(vma, page_folio(page));
 }
 
 /**
--- a/include/linux/rmap.h~mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap
+++ a/include/linux/rmap.h
@@ -211,6 +211,22 @@ void hugetlb_add_anon_rmap(struct folio
 void hugetlb_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
+/* See page_try_dup_anon_rmap() */
+static inline int hugetlb_try_dup_anon_rmap(struct folio *folio,
+		struct vm_area_struct *vma)
+{
+	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
+	if (PageAnonExclusive(&folio->page)) {
+		if (unlikely(folio_needs_cow_for_dma(vma, folio)))
+			return -EBUSY;
+		ClearPageAnonExclusive(&folio->page);
+	}
+	atomic_inc(&folio->_entire_mapcount);
+	return 0;
+}
+
 static inline void hugetlb_add_file_rmap(struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -228,6 +244,8 @@ static inline void hugetlb_remove_rmap(s
 
 static inline void __page_dup_rmap(struct page *page, bool compound)
 {
+	VM_WARN_ON(folio_test_hugetlb(page_folio(page)));
+
 	if (compound) {
 		struct folio *folio = (struct folio *)page;
 
--- a/mm/hugetlb.c~mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap
+++ a/mm/hugetlb.c
@@ -5409,8 +5409,7 @@ again:
 			 */
 			if (!folio_test_anon(pte_folio)) {
 				hugetlb_add_file_rmap(pte_folio);
-			} else if (page_try_dup_anon_rmap(&pte_folio->page,
-							  true, src_vma)) {
+			} else if (hugetlb_try_dup_anon_rmap(pte_folio, src_vma)) {
 				pte_t src_pte_old = entry;
 				struct folio *new_folio;
 
_

Patches currently in -mm which might be from david@redhat.com are


