Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8143630E82B
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768240045; cv=none; b=ZPRQcRV8qC+IAidE75C1dWabCh2Tz9pFaqXHU6JpBvIzrUgltbREttskzSQDPG8umGmiek7DNdk8wtAapAXbGY1fyYe8dlvpabZWefwsYPP8YIZ7vybPDuABuuonxOT6RZPsbuCMx8iagW/BLL0r8/j+pCnHTLIAqrfe71M0CTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768240045; c=relaxed/simple;
	bh=NUWsVeubym0n75RWcIXLQ04y9hc8rONMI1BjEzCARtw=;
	h=Date:To:From:Subject:Message-Id; b=FG3gmvoc60XwQgm1yEC8uUnpfn64DL30/AGx2TGhgWTc14mBmbd7/ji87Aw5RBqmgn+s4a7iXBPqV8qsUPN0DyrMLTmz9aTR+8GwlYxr6w/zqy/WgR/0/ewml9dap08skv20wBnLWuBn14YUYNwCXzfzWuYlUdZ1qf3ZSMxthRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gg6Z3gvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gg6Z3gvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A23FC19425;
	Mon, 12 Jan 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768240045;
	bh=NUWsVeubym0n75RWcIXLQ04y9hc8rONMI1BjEzCARtw=;
	h=Date:To:From:Subject:From;
	b=Gg6Z3gvkQGnZlgdInvz/jrmmui80QXIk0Uq/dbOSuTwrrVkGaiAQzT3iAHUVQVcHS
	 pnTTyoA6MY3P7fTWFEcuSt/Bf4TGOz/3gzCiOAK83Uu1eawTZlehz5RNuP5LAWYT9N
	 Szv+8MG6mXZL9giPZwWGTqbpYfGlNdbMvkaFFiHk=
Date: Mon, 12 Jan 2026 09:47:24 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange.patch added to mm-new branch
Message-Id: <20260112174725.2A23FC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: optimize rmap_walk_ksm by passing a suitable addressrange
has been added to the -mm mm-new branch.  Its filename is
     ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: optimize rmap_walk_ksm by passing a suitable addressrange
Date: Mon, 12 Jan 2026 22:01:43 +0800 (CST)

Problem
=======
When available memory is extremely tight, causing KSM pages to be swapped
out, or when there is significant memory fragmentation and THP triggers
memory compaction, the system will invoke rmap_walk_ksm() to perform
reverse mapping.  However, we observed that this function becomes
particularly time-consuming when a large number of VMAs (e.g., 20,000)
share the same anon_vma.  Through debug trace analysis, we found that most
of the latency occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or
more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

Root Reason
===========
Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check "if
(addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective.  This inefficiency arises
because the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
In fact, we can significantly improve performance by passing a more
precise range based on the given addr.  Since the original pages merged by
KSM correspond to anonymous VMAs, the page offset can be calculated as
pgoff = address >> PAGE_SHIFT.  Therefore, we can optimize the call by
defining:

	pgoff_start = rmap_item->address >> PAGE_SHIFT;
	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;

Performance
===========
In our real embedded Linux environment, the measured metrics were as follows:

1) Time_ms: Max time for holding anon_vma lock in a single
   rmap_walk_ksm.

2) Nr_iteration_total: The max times of iterations in a loop of
   anon_vma_interval_tree_foreach

3) Skip_addr_out_of_range: The max times of skipping due to the first
   check (vma->vm_start and vma->vm_end) in a loop of
   anon_vma_interval_tree_foreach.

4) Skip_mm_mismatch: The max times of skipping due to the second check
   (rmap_item->mm == vma->vm_mm) in a loop of
   anon_vma_interval_tree_foreach.

The result is as follows:

                 Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
Before patched:  228.65       22169                 22168                    0
After pacthed:   0.396        3                     0                        2

Link: https://lkml.kernel.org/r/20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn
Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange
+++ a/mm/ksm.c
@@ -3172,6 +3172,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 		unsigned long addr;
+		pgoff_t pgoff_start, pgoff_end;
 
 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3185,8 +3186,11 @@ again:
 		/* Ignore the stable/unstable/sqnr flags */
 		addr = rmap_item->address & PAGE_MASK;
 
+		pgoff_start = rmap_item->address >> PAGE_SHIFT;
+		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
+
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff_start, pgoff_end) {
 
 			cond_resched();
 			vma = vmac->vma;
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange.patch

