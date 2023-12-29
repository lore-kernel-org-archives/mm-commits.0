Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A4D13AEB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A3TXg9Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3BC433C9;
	Fri, 29 Dec 2023 20:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880088;
	bh=+i3tFYklOBOR6b9fhCStfVENfJQFEoQ9zqPRvCDEWbQ=;
	h=Date:To:From:Subject:From;
	b=A3TXg9Ro9+JqRdSgbHs7+LPvvYJztF1ZN/O7fKYm7podR1MmKfLpUQNifRqMsOjya
	 rk+X8eBxS7PRy4X3IRMW1uvP7fS0AoyWz8LtyB0VzpIT4SqcJWYBh2/LACD/JaVnER
	 SoobQK6/ijyU9yuliiAHeLHwt3JQb8EtP5kZkcf4=
Date: Fri, 29 Dec 2023 12:01:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch removed from -mm tree
Message-Id: <20231229200128.7EF3BC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: introduce and use hugetlb_try_share_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: introduce and use hugetlb_try_share_anon_rmap()
Date: Wed, 20 Dec 2023 23:44:29 +0100

hugetlb rmap handling differs quite a lot from "ordinary" rmap code.  For
example, hugetlb currently only supports entire mappings, and treats any
mapping as mapped using a single "logical PTE".  Let's move it out of the
way so we can overhaul our "ordinary" rmap.  implementation/interface.

So let's introduce and use hugetlb_try_dup_anon_rmap() to make all hugetlb
handling use dedicated hugetlb_* rmap functions.

Add sanity checks that we end up with the right folios in the right
functions.

Note that try_to_unmap_one() does not need care.  Easy to spot because
among all that nasty hugetlb special-casing in that function, we're not
using set_huge_pte_at() on the anon path -- well, and that code assumes
that we would want to swapout.

Link: https://lkml.kernel.org/r/20231220224504.646757-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   25 +++++++++++++++++++++++++
 mm/rmap.c            |   15 ++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap
+++ a/include/linux/rmap.h
@@ -227,6 +227,30 @@ static inline int hugetlb_try_dup_anon_r
 	return 0;
 }
 
+/* See page_try_share_anon_rmap() */
+static inline int hugetlb_try_share_anon_rmap(struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+	VM_WARN_ON_FOLIO(!PageAnonExclusive(&folio->page), folio);
+
+	/* Paired with the memory barrier in try_grab_folio(). */
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+		smp_mb();
+
+	if (unlikely(folio_maybe_dma_pinned(folio)))
+		return -EBUSY;
+	ClearPageAnonExclusive(&folio->page);
+
+	/*
+	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
+	 * gup_must_unshare().
+	 */
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+		smp_mb__after_atomic();
+	return 0;
+}
+
 static inline void hugetlb_add_file_rmap(struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -331,6 +355,7 @@ dup:
  */
 static inline int page_try_share_anon_rmap(struct page *page)
 {
+	VM_WARN_ON(folio_test_hugetlb(page_folio(page)));
 	VM_BUG_ON_PAGE(!PageAnon(page) || !PageAnonExclusive(page), page);
 
 	/* device private pages cannot get pinned via GUP. */
--- a/mm/rmap.c~mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap
+++ a/mm/rmap.c
@@ -2149,13 +2149,18 @@ static bool try_to_migrate_one(struct fo
 				       !anon_exclusive, subpage);
 
 			/* See page_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    page_try_share_anon_rmap(subpage)) {
-				if (folio_test_hugetlb(folio))
+			if (folio_test_hugetlb(folio)) {
+				if (anon_exclusive &&
+				    hugetlb_try_share_anon_rmap(folio)) {
 					set_huge_pte_at(mm, address, pvmw.pte,
 							pteval, hsz);
-				else
-					set_pte_at(mm, address, pvmw.pte, pteval);
+					ret = false;
+					page_vma_mapped_walk_done(&pvmw);
+					break;
+				}
+			} else if (anon_exclusive &&
+				   page_try_share_anon_rmap(subpage)) {
+				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
_

Patches currently in -mm which might be from david@redhat.com are


