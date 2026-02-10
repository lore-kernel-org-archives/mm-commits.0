Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E026ED35
	for <mm-commits@vger.kernel.org>; Tue, 10 Feb 2026 01:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770688435; cv=none; b=H5tQj9axwwMzaivXuVGi/urex9QoafGUouIdxz1UYTz7sKS741wKSsFVDtaGTRyKeMjo8gUd1J4W5jBOwyorN/fXZYJLNoQ2XJTGBwgQTXcOSd7NN9Z4SapL9VDPEOVbyISBOKd4ev/35zUmK66WRIcuIYPlUz2y8S0eP9YnEls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770688435; c=relaxed/simple;
	bh=BScOjXAFEYHW/AmK+BSrL9ASIQpcwFsYJtwXNDl6MVs=;
	h=Date:To:From:Subject:Message-Id; b=GqQv/ryu46PD4cKFgwk2N0d+Ph1EkYfby+xwFTGuJrt9T2z9Q6ChW27ILhIFKaXdKu7ffkhiWu/AhbqoptIOtONaJGNKxMmP7B8Hz3FFKXNTiA2+CpLqnBZkgArV/NxYCnTQoHjlPwqNMtlcAVKhcTUmotvvvPrcuvOoHeC2wjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRZLxBUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRZLxBUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75A0C116C6;
	Tue, 10 Feb 2026 01:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770688434;
	bh=BScOjXAFEYHW/AmK+BSrL9ASIQpcwFsYJtwXNDl6MVs=;
	h=Date:To:From:Subject:From;
	b=MRZLxBUOcP/nzLZbnRo18dRx9lBYCk8dZnMc+gF6MeMyJnxCD/xowCxrL+ACss9o+
	 ZlaQYLS+lGxzB4pnaF6jzMdEJL/XW1A1fYWh9k6/mK2QEl6o0Fc3zZa5ttK9Va7+Oy
	 wnG8vsLHOxCkjbEQJ/DOfvO/UjutSTe6cbZUE67A=
Date: Mon, 09 Feb 2026 17:53:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-support-batched-unmapping-for-file-large-folios.patch added to mm-unstable branch
Message-Id: <20260210015354.C75A0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: support batched unmapping for file large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-support-batched-unmapping-for-file-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-support-batched-unmapping-for-file-large-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Mon, 9 Feb 2026 22:07:28 +0800

Similar to folio_referenced_one(), we can apply batched unmapping for file
large folios to optimize the performance of file folios reclamation.

Barry previously implemented batched unmapping for lazyfree anonymous
large folios[1] and did not further optimize anonymous large folios or
file-backed large folios at that stage.  As for file-backed large folios,
the batched unmapping support is relatively straightforward, as we only
need to clear the consecutive (present) PTE entries for file-backed large
folios.

Note that it's not ready to support batched unmapping for uffd case, so
let's still fallback to per-page unmapping for the uffd case.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and
try to reclaim 8G file-backed folios via the memory.reclaim interface.  I
can observe 75% performance improvement on my Arm64 32-core server (and
50%+ improvement on my X86 machine) with this patch.

W/o patch:
real    0m1.018s
user    0m0.000s
sys     0m1.018s

W/ patch:
real	0m0.249s
user	0m0.000s
sys	0m0.249s

[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
Link: https://lkml.kernel.org/r/b53a16f67c93a3fe65e78092069ad135edf00eff.1770645603.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 mm/rmap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-support-batched-unmapping-for-file-large-folios
+++ a/mm/rmap.c
@@ -1945,12 +1945,16 @@ static inline unsigned int folio_unmap_p
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
 
+	if (userfaultfd_wp(vma))
+		return 1;
+
 	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
 }
 
@@ -2313,7 +2317,7 @@ static bool try_to_unmap_one(struct foli
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

