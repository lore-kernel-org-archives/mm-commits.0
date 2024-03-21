Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B635231
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062152; cv=none; b=njnnMAYwRXvTIycieE4q6L70gymlTljhqzZs5SBQLP4q3ExdW3PTOOuHMcqKzWp9WGoL9cepV8/zmeqFrVnT44q+Q7aeVuSMLS4viwc5+DtP5PZEMUXnAaBCnBYwGFiE8GYNI0+QgXPmmGZfnXaFriXf9HuncLbmzsFSTi7e0qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062152; c=relaxed/simple;
	bh=uyGVdIvI7M1LRqJu/RURHvd0JaU5FOHdTiEX4lDDxuw=;
	h=Date:To:From:Subject:Message-Id; b=Ud4Bhqc0G6rDv32JgfEkgd3pl6m/erw8DgJV0K2nb0DzsGZv5L4llzpNoDP8B+8EEk6SiVqu+2JVPtGI5RoEt+Tt1rOETFNiNKpzQvYMgFfdA20GdGDfBD/zsRct61OX/oS2aPj4AQghKjwUp22p06hCqpdHLw47bMN7Nr7nv28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nH51DgBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nH51DgBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0EFC433F1;
	Thu, 21 Mar 2024 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062151;
	bh=uyGVdIvI7M1LRqJu/RURHvd0JaU5FOHdTiEX4lDDxuw=;
	h=Date:To:From:Subject:From;
	b=nH51DgBZuv4iRiaLKeI70Uj6sSka3xsYKOhE0ZK5PRdohhwiyOzLqwoKx3/8+QTXd
	 +6KrfAavF6wNCfNxP3s7RSPYDSekBW20LRmjWqx1RPpVcpQ8dsOOVFq9Coo88p+kQr
	 CJhEAtHaDjjbUP7juCTE6TQYLuV6IqcBP8Pozuzo=
Date: Thu, 21 Mar 2024 16:02:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,mike.kravetz@oracle.com,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch added to mm-unstable branch
Message-Id: <20240321230231.8D0EFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: drop folio_fast_pin_allowed() in hugepd processing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch

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
Subject: mm/gup: drop folio_fast_pin_allowed() in hugepd processing
Date: Thu, 21 Mar 2024 18:07:55 -0400

Hugepd format for GUP is only used in PowerPC with hugetlbfs.  There are
some kernel usage of hugepd (can refer to hugepd_populate_kernel() for
PPC_8XX), however those pages are not candidates for GUP.

Commit a6e79df92e4a ("mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
file-backed mappings") added a check to fail gup-fast if there's potential
risk of violating GUP over writeback file systems.  That should never
apply to hugepd.  Considering that hugepd is an old format (and even
software-only), there's no plan to extend hugepd into other file typed
memories that is prone to the same issue.

Drop that check, not only because it'll never be true for hugepd per any
known plan, but also it paves way for reusing the function outside
fast-gup.

To make sure we'll still remember this issue just in case hugepd will be
extended to support non-hugetlbfs memories, add a rich comment above
gup_huge_pd(), explaining the issue with proper references.

Link: https://lkml.kernel.org/r/20240321220802.679544-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing
+++ a/mm/gup.c
@@ -2831,11 +2831,6 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
-		return 0;
-	}
-
 	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2846,6 +2841,14 @@ static int gup_hugepte(pte_t *ptep, unsi
 	return 1;
 }
 
+/*
+ * NOTE: currently GUP for a hugepd is only possible on hugetlbfs file
+ * systems on Power, which does not have issue with folio writeback against
+ * GUP updates.  When hugepd will be extended to support non-hugetlbfs or
+ * even anonymous memory, we need to do extra check as what we do with most
+ * of the other folios. See writable_file_mapping_allowed() and
+ * folio_fast_pin_allowed() for more information.
+ */
 static int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
 		struct page **pages, int *nr)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch
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
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch

