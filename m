Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB422572
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 00:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198759; cv=none; b=ISqEFmh160gMD1U+DWkxPp/ISsEd93NTqCaZxgsJOCiOlpb7Y/WlrZBB5/7tWsauLlfX/BZKrH1SAln9T29ShQOc+cmEdMRvTbtxYB0v2oTzGJy8Qkey/kW5EG7vjpmiVoL408y4lU0lZgyP8ENEiY+DlZziP1AWOvN4zm2Ue6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198759; c=relaxed/simple;
	bh=/mmJNLk9PMnPxE35OPEFRvpMcIp5+CKQOG/GhHtBcMk=;
	h=Date:To:From:Subject:Message-Id; b=VW799V0t7nW1JpEaFdGyovvsxp82/VBquVOZfNaVUmCMUi7Kn+k5wafy+9wUTaCNRi/lg2b1kitfxumdr8L4WUweaWmW9PfsUpqKaPSqCg+hK3wTTZBZcCSNaVmmqmcBXAOfvgTJ3PvkndyL34bKEEhdD4O7Gu0YqzbITxFQmQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yRR520dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yRR520dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC79C4AF09;
	Wed, 21 Aug 2024 00:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724198758;
	bh=/mmJNLk9PMnPxE35OPEFRvpMcIp5+CKQOG/GhHtBcMk=;
	h=Date:To:From:Subject:From;
	b=yRR520dFM2e3WqIfd7dj/lcD38yOdF1mhpAOf37V9GCrKg24kt4teeQwalDZTB0FL
	 yf7ZN0kbrZ4yPAV8egCxzArWVJmwjiu/ioQ/aUKLwYHfuzL5NaKA/4jpGvKvLrnZGZ
	 ACNTqFwwSjtcmG8q3ppeoj1FaF0zGj0gbgZM/ZE0=
Date: Tue, 20 Aug 2024 17:05:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-support-shmem-mthp-collapse.patch added to mm-unstable branch
Message-Id: <20240821000558.7AC79C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: support shmem mTHP collapse
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-support-shmem-mthp-collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-support-shmem-mthp-collapse.patch

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

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

