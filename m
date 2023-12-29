Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1AC13AD9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E3Kn2bei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58063C433C7;
	Fri, 29 Dec 2023 20:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880085;
	bh=qxfJ+77RJqzIfOMnk54l25ICpJTlRScb7krrqkRlkto=;
	h=Date:To:From:Subject:From;
	b=E3Kn2beiTKs4mBFE1kFATrMeNNEAcxlY3mVG3pjbTOxuA3UNzW7iln60nqUEoCX5u
	 KcozegeBgWAHGTl0MQWr137OgdE4TYDHQZqkPdcerimZQ92rgn1JBzlbRaXppqiXF0
	 B0GDluZetdq+pw/ICuZA1vR6kki0tfxe5QQMmpoY=
Date: Fri, 29 Dec 2023 12:01:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch removed from -mm tree
Message-Id: <20231229200125.58063C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: introduce and use hugetlb_remove_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: introduce and use hugetlb_remove_rmap()
Date: Wed, 20 Dec 2023 23:44:26 +0100

hugetlb rmap handling differs quite a lot from "ordinary" rmap code.  For
example, hugetlb currently only supports entire mappings, and treats any
mapping as mapped using a single "logical PTE".  Let's move it out of the
way so we can overhaul our "ordinary" rmap.  implementation/interface.

Let's introduce and use hugetlb_remove_rmap() and remove the hugetlb code
from page_remove_rmap().  This effectively removes one check on the
small-folio path as well.

Add sanity checks that we end up with the right folios in the right
functions.

Note: all possible candidates that need care are page_remove_rmap() that
      pass compound=true.

Link: https://lkml.kernel.org/r/20231220224504.646757-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 +++++++
 mm/hugetlb.c         |    4 ++--
 mm/rmap.c            |   18 +++++++++---------
 3 files changed, 18 insertions(+), 11 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-introduce-and-use-hugetlb_remove_rmap
+++ a/include/linux/rmap.h
@@ -211,6 +211,13 @@ void hugetlb_add_anon_rmap(struct folio
 void hugetlb_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
+static inline void hugetlb_remove_rmap(struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+
+	atomic_dec(&folio->_entire_mapcount);
+}
+
 static inline void __page_dup_rmap(struct page *page, bool compound)
 {
 	if (compound) {
--- a/mm/hugetlb.c~mm-rmap-introduce-and-use-hugetlb_remove_rmap
+++ a/mm/hugetlb.c
@@ -5676,7 +5676,7 @@ void __unmap_hugepage_range(struct mmu_g
 					make_pte_marker(PTE_MARKER_UFFD_WP),
 					sz);
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		page_remove_rmap(page, vma, true);
+		hugetlb_remove_rmap(page_folio(page));
 
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
@@ -5987,7 +5987,7 @@ retry_avoidcopy:
 
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
-		page_remove_rmap(&old_folio->page, vma, true);
+		hugetlb_remove_rmap(old_folio);
 		hugetlb_add_new_anon_rmap(new_folio, vma, haddr);
 		if (huge_pte_uffd_wp(pte))
 			newpte = huge_pte_mkuffd_wp(newpte);
--- a/mm/rmap.c~mm-rmap-introduce-and-use-hugetlb_remove_rmap
+++ a/mm/rmap.c
@@ -1480,15 +1480,9 @@ void page_remove_rmap(struct page *page,
 	bool last;
 	enum node_stat_item idx;
 
+	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
 
-	/* Hugetlb pages are not counted in NR_*MAPPED */
-	if (unlikely(folio_test_hugetlb(folio))) {
-		/* hugetlb pages are always mapped with pmds */
-		atomic_dec(&folio->_entire_mapcount);
-		return;
-	}
-
 	/* Is page being unmapped by PTE? Is this its last map to be removed? */
 	if (likely(!compound)) {
 		last = atomic_add_negative(-1, &page->_mapcount);
@@ -1846,7 +1840,10 @@ static bool try_to_unmap_one(struct foli
 			dec_mm_counter(mm, mm_counter_file(&folio->page));
 		}
 discard:
-		page_remove_rmap(subpage, vma, folio_test_hugetlb(folio));
+		if (unlikely(folio_test_hugetlb(folio)))
+			hugetlb_remove_rmap(folio);
+		else
+			page_remove_rmap(subpage, vma, false);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
@@ -2199,7 +2196,10 @@ static bool try_to_migrate_one(struct fo
 			 */
 		}
 
-		page_remove_rmap(subpage, vma, folio_test_hugetlb(folio));
+		if (unlikely(folio_test_hugetlb(folio)))
+			hugetlb_remove_rmap(folio);
+		else
+			page_remove_rmap(subpage, vma, false);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
_

Patches currently in -mm which might be from david@redhat.com are


