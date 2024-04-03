Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29D42BB02
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712179005; cv=none; b=lwB6jzjE/tk0SPT18u9Upt6AlS/JNVuLeULt70uq0nc6G0ifBZ271G0H4E3B7LiHYzwiQkhwMizgmD8wnfQ0j8emUSdFa37NNbdbsxCzqacpxdKeuSDWO7vmCJ5z4IVgHss9kO260ubeAeHWJGNBmrVeqw0hhuj7+bzWqHzrlQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712179005; c=relaxed/simple;
	bh=f3p/lZ/b3DtBtGDPAsHS/0zcj8NJ3amJb91R9Wf1/Mo=;
	h=Date:To:From:Subject:Message-Id; b=OzYv27dATcYbkYE8N/YSe7X9zAnqHzaF08a7HXEf0pzMRjAtdBrTTZyg7FyHwjRy5jgPVqrU2KawsEFYfMqvoTWbrrfFMXum241z8SrqfTz0TfyU9qDm2FJp8W278Gv+py2zInWDVtQ12K9EnFegiWN0rdoZ7gGXiAhkZKtctOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=091Vc7O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="091Vc7O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF56C433F1;
	Wed,  3 Apr 2024 21:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712179005;
	bh=f3p/lZ/b3DtBtGDPAsHS/0zcj8NJ3amJb91R9Wf1/Mo=;
	h=Date:To:From:Subject:From;
	b=091Vc7O4gfUj3WwVEHevCgaUCVpelWORFAajaaQIPGDikwmDsm7rKyfWbCJnm1Wxw
	 p3dmHNIN2pe/AhB2SZwVAB0CkT21uv1sGqUmy9/jeJU2QD+CxaI9sUHomGcb/NDDDl
	 jo9que4zpPtP6YMJuKOuLiopE9r+2LEHKy4DU+cM=
Date: Wed, 03 Apr 2024 14:16:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,nathan@kernel.org,kernel@xen0n.name,jgg@nvidia.com,david@redhat.com,chenhuacai@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch added to mm-unstable branch
Message-Id: <20240403211645.1EF56C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow anon exclusive check over hugetlb tail pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm: allow anon exclusive check over hugetlb tail pages
Date: Tue, 2 Apr 2024 21:32:47 -0400

PageAnonExclusive() used to forbid tail pages for hugetlbfs, as that used
to be called mostly in hugetlb specific paths and the head page was
guaranteed.

As we move forward towards merging hugetlb paths into generic mm, we may
start to pass in tail hugetlb pages (when with cont-pte/cont-pmd huge
pages) for such check.  Allow it to properly fetch the head, in which case
the anon-exclusiveness of the head will always represents the tail page.

There's already a sign of it when we look at the GUP-fast which already
contain the hugetlb processing altogether: we used to have a specific
commit 5805192c7b72 ("mm/gup: handle cont-PTE hugetlb pages correctly in
gup_must_unshare() via GUP-fast") covering that area.  Now with this more
generic change, that can also go away.

Link: https://lkml.kernel.org/r/20240403013249.1418299-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 +++++++-
 mm/internal.h              |   10 ----------
 2 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-allow-anon-exclusive-check-over-hugetlb-tail-pages
+++ a/include/linux/page-flags.h
@@ -1095,7 +1095,13 @@ PAGEFLAG(Isolated, isolated, PF_ANY);
 static __always_inline int PageAnonExclusive(const struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
-	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
+	/*
+	 * Allow the anon-exclusive check to work on hugetlb tail pages.
+	 * Here hugetlb pages will always guarantee the anon-exclusiveness
+	 * of the head page represents the tail pages.
+	 */
+	if (PageHuge(page) && !PageHead(page))
+		page = compound_head(page);
 	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
--- a/mm/internal.h~mm-allow-anon-exclusive-check-over-hugetlb-tail-pages
+++ a/mm/internal.h
@@ -1204,16 +1204,6 @@ static inline bool gup_must_unshare(stru
 		smp_rmb();
 
 	/*
-	 * During GUP-fast we might not get called on the head page for a
-	 * hugetlb page that is mapped using cont-PTE, because GUP-fast does
-	 * not work with the abstracted hugetlb PTEs that always point at the
-	 * head page. For hugetlb, PageAnonExclusive only applies on the head
-	 * page (as it cannot be partially COW-shared), so lookup the head page.
-	 */
-	if (unlikely(!PageHead(page) && PageHuge(page)))
-		page = compound_head(page);
-
-	/*
 	 * Note that PageKsm() pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
 	 */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

