Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE0D13AC4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+O8EpYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B66C433C8;
	Fri, 29 Dec 2023 20:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880099;
	bh=KLfaAGOfGFOhjwYsyPY2jeSM4XfVT+M4wn1CBaUT360=;
	h=Date:To:From:Subject:From;
	b=j+O8EpYi7u7ZnmIN7XcYW4ecpBvLt0/4KfRkfNPpx+s/3x5yEFL4IJ+5A92LNo7iJ
	 bHxYojdQOgwffgYE8H5PWkLNixtClGVm2a+S9tQHHnxR1Y5e8FQr0aq2tLeEXRrNFP
	 xxFhhnoGHpIPKgF+h8g5QlHfZpiV/vKP9Px6ZI5Q=
Date: Fri, 29 Dec 2023 12:01:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch removed from -mm tree
Message-Id: <20231229200139.17B66C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: batch rmap operations in __split_huge_pmd_locked()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: batch rmap operations in __split_huge_pmd_locked()
Date: Wed, 20 Dec 2023 23:44:39 +0100

Let's use folio_add_anon_rmap_ptes(), batching the rmap operations.

While at it, use more folio operations (but only in the code branch we're
touching), use VM_WARN_ON_FOLIO(), and pass RMAP_EXCLUSIVE instead of
manually setting PageAnonExclusive.

We should never see non-anon pages on that branch: otherwise, the existing
page_add_anon_rmap() call would have been flawed already.

Link: https://lkml.kernel.org/r/20231220224504.646757-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2398,6 +2398,7 @@ static void __split_huge_pmd_locked(stru
 		unsigned long haddr, bool freeze)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
@@ -2493,16 +2494,18 @@ static void __split_huge_pmd_locked(stru
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
 	} else {
 		page = pmd_page(old_pmd);
+		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
 			dirty = true;
-			SetPageDirty(page);
+			folio_set_dirty(folio);
 		}
 		write = pmd_write(old_pmd);
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
 		uffd_wp = pmd_uffd_wp(old_pmd);
 
-		VM_BUG_ON_PAGE(!page_count(page), page);
+		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
+		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
@@ -2519,11 +2522,18 @@ static void __split_huge_pmd_locked(stru
 		 *
 		 * See page_try_share_anon_rmap(): invalidate PMD first.
 		 */
-		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+		anon_exclusive = PageAnonExclusive(page);
 		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
 			freeze = false;
-		if (!freeze)
-			page_ref_add(page, HPAGE_PMD_NR - 1);
+		if (!freeze) {
+			rmap_t rmap_flags = RMAP_NONE;
+
+			folio_ref_add(folio, HPAGE_PMD_NR - 1);
+			if (anon_exclusive)
+				rmap_flags |= RMAP_EXCLUSIVE;
+			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+						 vma, haddr, rmap_flags);
+		}
 	}
 
 	/*
@@ -2566,8 +2576,6 @@ static void __split_huge_pmd_locked(stru
 			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
 			if (write)
 				entry = pte_mkwrite(entry, vma);
-			if (anon_exclusive)
-				SetPageAnonExclusive(page + i);
 			if (!young)
 				entry = pte_mkold(entry);
 			/* NOTE: this may set soft-dirty too on some archs */
@@ -2577,7 +2585,6 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_mkuffd_wp(entry);
-			page_add_anon_rmap(page + i, vma, addr, RMAP_NONE);
 		}
 		VM_BUG_ON(!pte_none(ptep_get(pte)));
 		set_pte_at(mm, addr, pte, entry);
_

Patches currently in -mm which might be from david@redhat.com are


