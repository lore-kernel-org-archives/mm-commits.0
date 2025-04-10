Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898101E1041
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 02:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744252465; cv=none; b=GdfQKgs22A3H24vD+UmG2WUhjpy9/7t2N9Br0fYSQZa9329oQK7CYiOOy8N+o60c1wq434Te0vKEaHDS3544UjLq08/PENgLsOpyQYmpwoApHEsHLrxlgjuHRwN6mEQySEWkSXwmXOlvaasaYf/l39dLGhZIImzKgwpPUsFMxqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744252465; c=relaxed/simple;
	bh=oFQHWdS4555BDwoTPKHgMIVbtb3/wHhiNGNWovmacBs=;
	h=Date:To:From:Subject:Message-Id; b=PRAVd6RqZTdkdi6LysnJI5vRuk7ECSsYDctvhDzpdoUs2cuoNSC5dcV5P5cJeYifZWGCcIeykkSc2Dzpxgojlpyfq+4t8IAJUcYJiGgNHz1npS8n5y2A7mSFgCX3mwMh4Fy4gCJhXPkXVPAlx/PLAFzX9+Wd4vVHW/P92m5DRrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VBIr2BxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VBIr2BxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AC6C4CEE2;
	Thu, 10 Apr 2025 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744252465;
	bh=oFQHWdS4555BDwoTPKHgMIVbtb3/wHhiNGNWovmacBs=;
	h=Date:To:From:Subject:From;
	b=VBIr2BxIaLR+omD8zowVf2c+Mcmp3eKm4qUaicmhoVh9Qx1laeNhpU1/Itu3zWLJF
	 rWcg3b66AWLwlX/3RRAAqUeU4S7LrP6o8oyqQr7fOrsjlhX8hvef2vzvcY68jfQyON
	 5bsGBFde30vooe0jUgFBsqcLETw2FtkV4eDq4Lig=
Date: Wed, 09 Apr 2025 19:34:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch added to mm-new branch
Message-Id: <20250410023424.F1AC6C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: batch tlb flushes for MADV_DONTNEED[_LOCKED]
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

This patch will later appear in the mm-new branch at
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/madvise.c  |   11 ++++++++---
 mm/memory.c   |    4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-madvise-batch-tlb-flushes-for-madv_dontneed
+++ a/mm/internal.h
@@ -435,6 +435,9 @@ void unmap_page_range(struct mmu_gather
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

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

