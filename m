Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949737EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104057; cv=none; b=aO2xOiF5fGlprvW6KcsOLdgakF7G1grVgpQ8Ma3Q5F4QZ+cRxyrlJDD9/FI1sEaP0S5YgF4tHKVv/QzHhXwIH7eu9XbSOcqRe8C81IkTEie2e0ow7mY56AiRQDbro0F3SyV0DUkuy724bgiFAdSgjJ21J8yV4wWC9Kb2OsIEVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104057; c=relaxed/simple;
	bh=jnKvD7qxgXVXj7NUGi31yErhCgpglK+VZZTxuuA/V8c=;
	h=Date:To:From:Subject:Message-Id; b=Mmg9/jEkgDNno2YQRbIeR6tqE5KzJ11ertcHKx3s+XVUANGoNYSmS8YXbyl1+dLYcxTxi+apfDxLkv1MLZBvGsk8qXT9yYTTbJ5RtJwSh22+mjeV+YL/3mW28CNdXgmcbM7whFoXLTFtfJPq64/8BbSuoTiPd7yS2TnUXS9CTnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=frgLc03O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="frgLc03O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69428C113CD;
	Fri, 26 Apr 2024 04:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104057;
	bh=jnKvD7qxgXVXj7NUGi31yErhCgpglK+VZZTxuuA/V8c=;
	h=Date:To:From:Subject:From;
	b=frgLc03OxZ/eC1yOv3ZaL8P/5/k3G9haggVdIN7SlcUrdXwKHmbI+8u7cvB7NH5DK
	 pDFNGvioAKSv77Eoal+HXC7NKyr2J3JZ1LbrJOVemWHtw+A6NKvPETuBT3IxZa6xXH
	 dXmrD/knzFZoHg8XXB3UqdqD1pSaiC0Eu0tcWGoo=
Date: Thu, 25 Apr 2024 21:00:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch removed from -mm tree
Message-Id: <20240426040057.69428C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: drop gup_fast_folio_allowed() in hugepd processing
has been removed from the -mm tree.  Its filename was
     mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: drop gup_fast_folio_allowed() in hugepd processing
Date: Wed, 27 Mar 2024 11:23:25 -0400

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

[akpm@linux-foundation.org: fix comment, per David]
Link: https://lkml.kernel.org/r/20240327152332.950956-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
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
@@ -2842,11 +2842,6 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
-	if (!gup_fast_folio_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
-		return 0;
-	}
-
 	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2857,6 +2852,14 @@ static int gup_hugepte(pte_t *ptep, unsi
 	return 1;
 }
 
+/*
+ * NOTE: currently GUP for a hugepd is only possible on hugetlbfs file
+ * systems on Power, which does not have issue with folio writeback against
+ * GUP updates.  When hugepd will be extended to support non-hugetlbfs or
+ * even anonymous memory, we need to do extra check as what we do with most
+ * of the other folios. See writable_file_mapping_allowed() and
+ * gup_fast_folio_allowed() for more information.
+ */
 static int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
 		struct page **pages, int *nr)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

