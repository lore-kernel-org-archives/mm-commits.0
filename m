Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426C936EA87
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 21:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772228186; cv=none; b=ZHo+jJZEbuCoqex9F35HP+mifT/8diupzkzo7onfnluXFMRD4H4wSEliCosbRkYepv+Squ2qvWEvMQPJa1RSP6E07bvlDy5eI2f987Ni05Wi8rY9UYq4Gkb3GLtVt+jAJ1rL1GHzYC55rhzPme0eBkl70MpRiAK2rGAChY0BaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772228186; c=relaxed/simple;
	bh=d2adtB6XpEdCFmeqURdEjebWUjt3iSatlxwaZvpXKrY=;
	h=Date:To:From:Subject:Message-Id; b=AjXcPje+hxYte/Z5RC/pSm4+rxoHXJRONJSQbaVLOWX2sgS8L2DhX8eEiivmfheLRXzc7EVcejjKwgzmjWUh+nldOPbwH+U6gkhwiy/65VI8G1x4J2s0TPiOW5bu6MZdaomy0awC8zHnc1JgIbHFZuljeQlfdfqzDweGLr7fQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LSWQ71MC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LSWQ71MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59C7C19425;
	Fri, 27 Feb 2026 21:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772228185;
	bh=d2adtB6XpEdCFmeqURdEjebWUjt3iSatlxwaZvpXKrY=;
	h=Date:To:From:Subject:From;
	b=LSWQ71MCyd8j2QKcQv3v9mbpB/L1Etk6bO79Gj+INKBTboK0Ak/dxgdEyYCzw6PCg
	 wqsYM0eElIe8qDmX1RYtMn0O0hLErSND0t10X1+9MKx3LH84qyn/PVCyd7AAqtubXA
	 50Jr1T2+z0lehvC+JyCvLyqGyPLxtp5FL1e4VLRI=
Date: Fri, 27 Feb 2026 13:36:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-remove-redundant-index-check-for-pmd-folios.patch added to mm-new branch
Message-Id: <20260227213625.C59C7C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: remove redundant index check for pmd-folios
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-remove-redundant-index-check-for-pmd-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-remove-redundant-index-check-for-pmd-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: khugepaged: remove redundant index check for pmd-folios
Date: Fri, 27 Feb 2026 20:05:01 +0530

Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.

Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
iterate on the xarray, have the invariant that start <= folio->index <
start + HPAGE_PMD_NR ...  (i)

A folio is always naturally aligned in the pagecache, therefore
folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)

thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
offsets in the VMA are aligned to the order,
=> IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)

Combining (i), (ii) and (iii), the claim is proven.

Therefore, remove this check.
While at it, simplify the comments.

Link: https://lkml.kernel.org/r/20260227143501.1488110-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-redundant-index-check-for-pmd-folios
+++ a/mm/khugepaged.c
@@ -2015,9 +2015,7 @@ static enum scan_result collapse_file(st
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
-		    folio->index == start) {
-			/* Maybe PMD-mapped */
+		if (folio_order(folio) == HPAGE_PMD_ORDER) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
 		}
@@ -2345,15 +2343,11 @@ static enum scan_result hpage_collapse_s
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
-		    folio->index == start) {
-			/* Maybe PMD-mapped */
+		if (folio_order(folio) == HPAGE_PMD_ORDER) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
-			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
-			 * by the caller won't touch the page cache, and so
-			 * it's safe to skip LRU and refcount checks before
-			 * returning.
+			 * PMD-sized THP implies that we can only try
+			 * retracting the PTE table.
 			 */
 			folio_put(folio);
 			break;
_

Patches currently in -mm which might be from dev.jain@arm.com are

khugepaged-remove-redundant-index-check-for-pmd-folios.patch

