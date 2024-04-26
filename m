Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A7978C71
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102777; cv=none; b=aA8ZiS0MCAAuAsrxkUaPLZTynxyKEoJlUPd87LX28eCx68MYlbddUVZXYm4YWjcu6uRBSNAe5rPHOi778bko30PNAKpHf5Gz3jN01yAR0rC+8+pOceH50MIMaRfeN9a/QRZc5umRkAhYaR+tjEVmIImoeX2q54NlCmqHZKhjUE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102777; c=relaxed/simple;
	bh=o7SXGZRlURms8zFz1mxZq048grYSciYb4qdGC3gqblo=;
	h=Date:To:From:Subject:Message-Id; b=klr7X9CD/apMnJO2cNtB9mIPZKSqWfSpkKaqcrMVxW/zZ67tA5/3HazmeXOSAI6Tkwt0w/ghsEN3h+YcUZDYAhuKbpV1kXU1XhDMiYNUhme4PoZAcPV67qlW/lyAiX102De4JnUqMio3fEH2Spddu8n6F8OweqWblvEj6ERmjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yM0T9tNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yM0T9tNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C1EC116B1;
	Fri, 26 Apr 2024 03:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102776;
	bh=o7SXGZRlURms8zFz1mxZq048grYSciYb4qdGC3gqblo=;
	h=Date:To:From:Subject:From;
	b=yM0T9tNdprXWKQ/5/Boyp11p9b4WdXSKH8n0jegukAHfvjKfKbUqZcoUt/yr5BBdz
	 0Jj6EMLpqj88cYI6ZVQMHCClvIKQQzVM6uQc4UJZbhk9nQxka7z54XKPunzv+Cbcws
	 olm0VvTn2HNUv4PwRPtq74A1cF4wZyUTRPI69jqI=
Date: Thu, 25 Apr 2024 20:39:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch removed from -mm tree
Message-Id: <20240426033936.D6C1EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! mm/gup: handle huge pmd for follow_pmd_mask()
has been removed from the -mm tree.  Its filename was
     mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch

This patch was dropped because it was folded into mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm/gup: handle huge pmd for follow_pmd_mask()
Date: Tue, 2 Apr 2024 21:32:48 -0400

Allow follow_pmd_mask() to take hugetlb tail pages.  The old warnings do
not help now as hugetlb now allows it to happen, so drop them.

Link: https://lkml.kernel.org/r/20240403013249.1418299-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/gup.c~mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix
+++ a/mm/gup.c
@@ -632,8 +632,6 @@ static struct page *follow_huge_pmd(stru
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
 	page = pmd_page(pmdval);
-	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
-
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pmd(pmdval, page, vma, flags))
 		return NULL;
@@ -662,7 +660,6 @@ static struct page *follow_huge_pmd(stru
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	ctx->page_mask = HPAGE_PMD_NR - 1;
-	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
 
 	return page;
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
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
mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

