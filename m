Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC47CC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011114; cv=none; b=uVAhlT/4wSpVGcNDj3lpTHosKxa3RJwoOqi50C3tH0wEzh5WSYJnr+OMvYpay0XCwAg6bi/4j6+UBogl3Y19DAGySCAFrsTUNlq1HRmSQwy05CY74oGKcbTxJB6UrRDKe5dRL2zmLfvEYw+v9rCR0CulecQ6qyHX5zMcGGbEa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011114; c=relaxed/simple;
	bh=uxCKl/sd4upoAxcxPmKlL/5APuRA3nfi8uG77Tiu150=;
	h=Date:To:From:Subject:Message-Id; b=Eg4wR3J2b/M/OokxnqqcCIYat2Tduu+nGneVoinEFcY+BNlH+EvaSvQfuVkcxR/YKn9H4BHxkX2XmKRiFZ5lVlhjvYaKDyS7kukmT/2BtA4Qm69w3LHQj5LLuMtjjx0DTDobw74bxPS+1sEEdqhC6W8RGYPd6V6gR1zJPAPe2bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bVKSej16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bVKSej16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E28C4CEE4;
	Mon, 12 May 2025 00:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011114;
	bh=uxCKl/sd4upoAxcxPmKlL/5APuRA3nfi8uG77Tiu150=;
	h=Date:To:From:Subject:From;
	b=bVKSej16Unck2ePR0gmvKfwgrtNwqOY6Bj/ofIvSuRh0tLbFgS9xYr4uQnjlqLQM5
	 6V0uDq/9jROktMC8H5IHLmzjcaXW2OTBAtbcl6xUpgK1hdOM7BKtpUn7vgeyQFnaRH
	 K7E4+cu3we50hNkWCmVKH6jqsDRPe41NUpNm5P6s=
Date: Sun, 11 May 2025 17:51:54 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch removed from -mm tree
Message-Id: <20250512005154.91E28C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: batch tlb flushes for MADV_DONTNEED[_LOCKED]
has been removed from the -mm tree.  Its filename was
     mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: batch tlb flushes for MADV_DONTNEED[_LOCKED]
Date: Wed, 9 Apr 2025 17:00:22 -0700

MADV_DONTNEED[_LOCKED] handling for [process_]madvise() flushes tlb for
each vma of each address range.  Update the logic to do tlb flushes in a
batched way.  Initialize an mmu_gather object from do_madvise() and
vector_madvise(), which are the entry level functions for
[process_]madvise(), respectively.  And pass those objects to the function
for per-vma work, via madvise_behavior struct.  Make the per-vma logic not
flushes tlb on their own but just saves the tlb entries to the received
mmu_gather object.  For this internal logic change, make
zap_page_range_single_batched() non-static and use it directly from
madvise_dontneed_single_vma().  Finally, the entry level functions flush
the tlb entries that gathered for the entire user request, at once.

Link: https://lkml.kernel.org/r/20250410000022.1901-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/madvise.c  |   11 ++++++++---
 mm/memory.c   |    4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-madvise-batch-tlb-flushes-for-madv_dontneed
+++ a/mm/internal.h
@@ -430,6 +430,9 @@ void unmap_page_range(struct mmu_gather
 			     struct vm_area_struct *vma,
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
+void zap_page_range_single_batched(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned long size, struct zap_details *details);
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp);
 
--- a/mm/madvise.c~mm-madvise-batch-tlb-flushes-for-madv_dontneed
+++ a/mm/madvise.c
@@ -851,7 +851,8 @@ static int madvise_free_single_vma(struc
  * An interface that causes the system to free clean pages and flush
  * dirty pages is already available as msync(MS_INVALIDATE).
  */
-static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
+static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior,
+					struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
 	struct zap_details details = {
@@ -859,7 +860,8 @@ static long madvise_dontneed_single_vma(
 		.even_cows = true,
 	};
 
-	zap_page_range_single(vma, start, end - start, &details);
+	zap_page_range_single_batched(
+			madv_behavior->tlb, vma, start, end - start, &details);
 	return 0;
 }
 
@@ -950,7 +952,8 @@ static long madvise_dontneed_free(struct
 	}
 
 	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
-		return madvise_dontneed_single_vma(vma, start, end);
+		return madvise_dontneed_single_vma(
+				madv_behavior, vma, start, end);
 	else if (behavior == MADV_FREE)
 		return madvise_free_single_vma(madv_behavior, vma, start, end);
 	else
@@ -1628,6 +1631,8 @@ static void madvise_unlock(struct mm_str
 static bool madvise_batch_tlb_flush(int behavior)
 {
 	switch (behavior) {
+	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
 		return true;
 	default:
--- a/mm/memory.c~mm-madvise-batch-tlb-flushes-for-madv_dontneed
+++ a/mm/memory.c
@@ -1998,7 +1998,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 	mmu_notifier_invalidate_range_end(&range);
 }
 
-/*
+/**
  * zap_page_range_single_batched - remove user pages in a given range
  * @tlb: pointer to the caller's struct mmu_gather
  * @vma: vm_area_struct holding the applicable pages
@@ -2009,7 +2009,7 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @tlb shouldn't be NULL.  The range must fit into one VMA.  If @vma is for
  * hugetlb, @tlb is flushed and re-initialized by this function.
  */
-static void zap_page_range_single_batched(struct mmu_gather *tlb,
+void zap_page_range_single_batched(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

