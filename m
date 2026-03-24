Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C70378D6B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388657; cv=none; b=nrjCx68A32pqmlh3XWNs87M61J0QWjLaZqhYBJL/7mg+x2dAj0glJZ96kOx64jggR1IuoC7jGfWoUFd+ytqot/zhCLwCGLemAKewzOAwAUgx/Rrq1Z1/MMNng3bm8GLjb9u3Q/Jn0fGLDpaNuSNZ7m9akbIe/mBYK9FqK1g2OaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388657; c=relaxed/simple;
	bh=yqtSqFWKLVdaG/Jmnk5T6Dht/z7up7YIKtccrj0QlsQ=;
	h=Date:To:From:Subject:Message-Id; b=hhKcIH/I+jMN7bRwJliOnfbJ3qBQH2/GkPnX0WbVAbD38Ai/vmlIydbY4/8myMidYGrOiZr3VOoMUXYs2bnBNTV4wpF6E6cpXc8us9Qsy7A5tJGmgi68N7jzC7A/nH3TSJgfiaoGzKF7zU88xuNIijCB3fYfilXFD66Nt1xMyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mIMxn4ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mIMxn4ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01043C19424;
	Tue, 24 Mar 2026 21:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388657;
	bh=yqtSqFWKLVdaG/Jmnk5T6Dht/z7up7YIKtccrj0QlsQ=;
	h=Date:To:From:Subject:From;
	b=mIMxn4ielQx80P+FUSEYJJp8iDQJ2hNTlrzklJFbii9GTvWj/30gg4uSuJ4oD1TR2
	 BB2j/WXf9nTFU8O7R8Oin4OHYjGk+vJ2Gul4+zuyWU1Jk/GDjJXOZIWNYTinj9lkdg
	 nxFi9IUTVd7iHige9c6H7qgU5f9L5nU1ZJUwwWvk=
Date: Tue, 24 Mar 2026 14:44:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-remove-redundant-index-check-for-pmd-folios.patch removed from -mm tree
Message-Id: <20260324214417.01043C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: remove redundant index check for pmd-folios
has been removed from the -mm tree.  Its filename was
     khugepaged-remove-redundant-index-check-for-pmd-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-redundant-index-check-for-pmd-folios
+++ a/mm/khugepaged.c
@@ -2023,9 +2023,7 @@ static enum scan_result collapse_file(st
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
@@ -2353,15 +2351,11 @@ static enum scan_result hpage_collapse_s
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


