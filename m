Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173FF27FB2A
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 20:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766952190; cv=none; b=VErIN9yyzkTm7f9FKWRxgluaQ7P3ypIT6H3VamP2auTCaHpjw1aQflxeeWzb7FLjuABhgs5LaarNZCUrZWk0N4SysDbt61eeCCgeeuGFpKwref70/SXhPbrzweCaNx3qLJJe5VxAboG6OzCu0cR32jOwRFU32yCwqRhuSGJvmvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766952190; c=relaxed/simple;
	bh=9AFYdTUOEDKFn8iaJrjbVTJn9LKnIEGaZ9akD/Ty+v8=;
	h=Date:To:From:Subject:Message-Id; b=bQxPcclRDKGgNAvVt6gwaFIZ22JcbqhrijGkn4D+umgnyV8pRQbyjFYdHhXsvW0NGJivCaS6M3OWfljJn0VGsk0IShoIaEukpDAtIv2a8dEAk05OQ3R+3vXZk1W55plbmJNanHb4UhOtYnAEL/04j/SD8YX31bEas3u2VVc5YMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DdShIvLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DdShIvLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A17CC4CEFB;
	Sun, 28 Dec 2025 20:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766952188;
	bh=9AFYdTUOEDKFn8iaJrjbVTJn9LKnIEGaZ9akD/Ty+v8=;
	h=Date:To:From:Subject:From;
	b=DdShIvLOBMDnQ/k4Run7HFIqvRLHuXUuPvxP+tUeMiTexLj9MR3HSrDBFjkEwcQrn
	 OefBzNOT+8G0K1Q4gTFHyHq+eD2aYDYvxszlTOALFBwWAxqshuaKwqQNcSDr43yTqh
	 oBDaK2MqYI7lffwE2MmVAr7QoYxr5BhjyAv3ZqVI=
Date: Sun, 28 Dec 2025 12:03:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-support-batched-unmapping-for-file-large-folios.patch added to mm-new branch
Message-Id: <20251228200308.8A17CC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: support batched unmapping for file large folios
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-support-batched-unmapping-for-file-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-support-batched-unmapping-for-file-large-folios.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: support batched unmapping for file large folios
Date: Fri, 26 Dec 2025 14:07:59 +0800

Similar to folio_referenced_one(), we can apply batched unmapping for file
large folios to optimize the performance of file folios reclamation.

Barry previously implemented batched unmapping for lazyfree anonymous
large folios[1] and did not further optimize anonymous large folios or
file-backed large folios at that stage.  As for file-backed large folios,
the batched unmapping support is relatively straightforward, as we only
need to clear the consecutive (present) PTE entries for file-backed large
folios.

Performance testing: Allocate 10G clean file-backed folios by mmap() in a
memory cgroup, and try to reclaim 8G file-backed folios via the
memory.reclaim interface.  I can observe 75% performance improvement on my
Arm64 32-core server (and 50%+ improvement on my X86 machine) with this
patch.

W/o patch:
real    0m1.018s
user    0m0.000s
sys     0m1.018s

W/ patch:
real	0m0.249s
user	0m0.000s
sys	0m0.249s

Link: https://lkml.kernel.org/r/142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u [1]
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-support-batched-unmapping-for-file-large-folios
+++ a/mm/rmap.c
@@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_p
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree batching for now ... */
-	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
+	/* We only support lazyfree or file folios batching for now ... */
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+
 	if (pte_unused(pte))
 		return 1;
 
@@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct foli
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(folio));
+			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio))) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch

