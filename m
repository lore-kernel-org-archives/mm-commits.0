Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D92115990C
	for <mm-commits@vger.kernel.org>; Fri,  4 Apr 2025 23:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743807898; cv=none; b=iD9RkZ6u0zmIz0gIhQcQuTz1rZgdDk8xZmbdhf/UJFLBOP2n6Qxh5PDzVz352VTb0BRKpSur/JRxFOUlPlfTDIE7HRJwdblfcW/tycmPkA2MIDiQ3DB06/FBfJS4z5tsiNgLnKJBZE8jZ0PaViECRbhnow3s+/5qEPuHmeINNvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743807898; c=relaxed/simple;
	bh=2cmiTpDMXQkIZs+9+1aPwACWZAFRMK1xNm189Tynnoc=;
	h=Date:To:From:Subject:Message-Id; b=Ng4HSQFsMbuUk0ZPoykcMY86WWPMYg/Z+kA6ToSk4kgDL/3zTUp2Xc61CFtTnRJlfuQ0a33NasgkEZpzJEtxDXh3RLFZswNTJVnUvVgeLpjk7SYoIhwoZayqOlmzeXhAukO7ZJaEiOz+E/4C8RipLvoFm2oANkmkqUCSmzlYduI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VJA0YvLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VJA0YvLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4274C4CEDD;
	Fri,  4 Apr 2025 23:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743807897;
	bh=2cmiTpDMXQkIZs+9+1aPwACWZAFRMK1xNm189Tynnoc=;
	h=Date:To:From:Subject:From;
	b=VJA0YvLYS5RyS+HB2uGDiUYY5RrvvqxJPmItnMZevJNNEuwlSvUR6GXvLdqdeX1Zt
	 xrwdgcaHTe7dljtXPd6d4O9hdxBGCMjlmE2eub7ghHGXJgP8xUMTj2FLR8Nh136GUg
	 3KxSZ88+pJLzCIsm9nHZY1SYL1QytAYxyJwMTObA=
Date: Fri, 04 Apr 2025 16:04:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,riel@surriel.com,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch added to mm-new branch
Message-Id: <20250404230457.B4274C4CEDD@smtp.kernel.org>
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
Date: Fri, 4 Apr 2025 14:07:00 -0700

Batch tlb flushes for MADV_DONTNEED[_LOCKED] for better efficiency, in a
way that very similar to the tlb flushes batching for MADV_FREE.

Link: https://lkml.kernel.org/r/20250404210700.2156-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/madvise.c  |    9 ++++++---
 mm/memory.c   |    4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-madvise-batch-tlb-flushes-for-madv_dontneed
+++ a/mm/internal.h
@@ -435,6 +435,9 @@ void unmap_page_range(struct mmu_gather
 			     struct vm_area_struct *vma,
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
+void notify_unmap_single_vma(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned long size, struct zap_details *details);
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp);
 
--- a/mm/madvise.c~mm-madvise-batch-tlb-flushes-for-madv_dontneed
+++ a/mm/madvise.c
@@ -851,7 +851,8 @@ static int madvise_free_single_vma(
  * An interface that causes the system to free clean pages and flush
  * dirty pages is already available as msync(MS_INVALIDATE).
  */
-static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
+static long madvise_dontneed_single_vma(struct madvise_behavior *behavior,
+					struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
 	struct zap_details details = {
@@ -859,7 +860,7 @@ static long madvise_dontneed_single_vma(
 		.even_cows = true,
 	};
 
-	zap_page_range_single(vma, start, end - start, &details);
+	notify_unmap_single_vma(behavior->tlb, vma, start, end - start, &details);
 	return 0;
 }
 
@@ -949,7 +950,7 @@ static long madvise_dontneed_free(struct
 	}
 
 	if (action == MADV_DONTNEED || action == MADV_DONTNEED_LOCKED)
-		return madvise_dontneed_single_vma(vma, start, end);
+		return madvise_dontneed_single_vma(behavior, vma, start, end);
 	else if (action == MADV_FREE)
 		return madvise_free_single_vma(behavior, vma, start, end);
 	else
@@ -1627,6 +1628,8 @@ static void madvise_unlock(struct mm_str
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
@@ -1989,7 +1989,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 	mmu_notifier_invalidate_range_end(&range);
 }
 
-/*
+/**
  * notify_unmap_single_vma - remove user pages in a given range
  * @tlb: pointer to the caller's struct mmu_gather
  * @vma: vm_area_struct holding the applicable pages
@@ -2000,7 +2000,7 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @tlb shouldn't be NULL.  The range must fit into one VMA.  If @vma is for
  * hugetlb, @tlb is flushed and re-initialized by this function.
  */
-static void notify_unmap_single_vma(struct mmu_gather *tlb,
+void notify_unmap_single_vma(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

