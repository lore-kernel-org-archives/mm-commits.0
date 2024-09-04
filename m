Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BB6762DF
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423503; cv=none; b=QuPlFjnaEWXpjkETh5OFKaquNSAQftXK5bDNRvzjL7kh/r4xCCcSJGD0jZmwKqfm/DlppmD4arML7dFiJ2dvtz7tzu2E1HILlujUIADf7thP6KWqc9lOkhqZymS0m2qRAh/ZJcutPWqibMMjVjzA21Mnq9iQRSHzinidSniaJ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423503; c=relaxed/simple;
	bh=Rs18MS17ULaRpvCExTtXNjiBhIP5phXBShRThW44Yjo=;
	h=Date:To:From:Subject:Message-Id; b=r+nuuu/D/y2q6goBT3dzz85LRu7/IYsIeIFQea2cs2UUL4rbKdpRWINJyJy72zwLuD2ml52ndaKw5+umHJLhGbFhrpWR7C6a1qGthQXZ92wz+URe+9HskMiFvQVaJrV7pfQ90GBLb1KcgnZpuyeBXlzii6WhugUUccQNbTImhuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oiiro32A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oiiro32A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7BCC4CEC2;
	Wed,  4 Sep 2024 04:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423503;
	bh=Rs18MS17ULaRpvCExTtXNjiBhIP5phXBShRThW44Yjo=;
	h=Date:To:From:Subject:From;
	b=Oiiro32AV7zEDKh7xPZkSVMVWXS0QP7MhAsq+e5ZuJhsW3Vs15ESKyWuEFBz/j9lX
	 os1J9Q+IQqyeWJRD2eiFgGN3CG/FAW589aoSfP8ecd9A5AGmKAYRNeaZ+EBHg0ZBan
	 3UZWwIpnwH5AdO5VWQH121ZRPgeUxi8nxZYJPlFQ=
Date: Tue, 03 Sep 2024 21:18:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-support-shmem-mthp-collapse.patch removed from -mm tree
Message-Id: <20240904041823.0D7BCC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: support shmem mTHP collapse
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-support-shmem-mthp-collapse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: support shmem mTHP collapse
Date: Tue, 20 Aug 2024 17:49:16 +0800

Shmem already supports the allocation of mTHP, but khugepaged does not yet
support collapsing mTHP folios.  Now khugepaged is ready to support mTHP,
and this patch enables the collapse of shmem mTHP.

Link: https://lkml.kernel.org/r/b9da76aab4276eb6e5d12c479af2b5eea5b4575d.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-support-shmem-mthp-collapse
+++ a/mm/khugepaged.c
@@ -1843,7 +1843,7 @@ static int collapse_file(struct mm_struc
 		}
 	} while (1);
 
-	for (index = start; index < end; index++) {
+	for (index = start; index < end;) {
 		xas_set(&xas, index);
 		folio = xas_load(&xas);
 
@@ -1862,6 +1862,7 @@ static int collapse_file(struct mm_struc
 					}
 				}
 				nr_none++;
+				index++;
 				continue;
 			}
 
@@ -1943,12 +1944,10 @@ static int collapse_file(struct mm_struc
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_test_large(folio)) {
-			result = folio_order(folio) == HPAGE_PMD_ORDER &&
-					folio->index == start
-					/* Maybe PMD-mapped */
-					? SCAN_PTE_MAPPED_HUGEPAGE
-					: SCAN_PAGE_COMPOUND;
+		if (folio_order(folio) == HPAGE_PMD_ORDER &&
+		    folio->index == start) {
+			/* Maybe PMD-mapped */
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
 		}
 
@@ -2009,6 +2008,7 @@ static int collapse_file(struct mm_struc
 		 * Accumulate the folios that are being collapsed.
 		 */
 		list_add_tail(&folio->lru, &pagelist);
+		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
 		folio_unlock(folio);
@@ -2261,16 +2261,10 @@ static int hpage_collapse_scan_file(stru
 			continue;
 		}
 
-		/*
-		 * TODO: khugepaged should compact smaller compound pages
-		 * into a PMD sized page
-		 */
-		if (folio_test_large(folio)) {
-			result = folio_order(folio) == HPAGE_PMD_ORDER &&
-					folio->index == start
-					/* Maybe PMD-mapped */
-					? SCAN_PTE_MAPPED_HUGEPAGE
-					: SCAN_PAGE_COMPOUND;
+		if (folio_order(folio) == HPAGE_PMD_ORDER &&
+		    folio->index == start) {
+			/* Maybe PMD-mapped */
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
 			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
 			 * by the caller won't touch the page cache, and so
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


