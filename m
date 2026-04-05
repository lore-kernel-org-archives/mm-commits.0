Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B346283FCE
	for <mm-commits@vger.kernel.org>; Sun,  5 Apr 2026 21:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775422901; cv=none; b=RcnFpfmzxbig2y9qg0FHVVzo85ajqEKHVa4s0XAxoPtQl0ZVoP5olYIuqdqAcCuz2mtuzRGvzif0uAZCaIpze/O+rI6TzRofKmYWRU/tUJ6za+yzzsA3CYLjpTKslPAM+y+JGEeBUPTu0wAKKuvweqJV76oJc1hZURwbHUx9uRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775422901; c=relaxed/simple;
	bh=7mJtCaO8oMbrrubJ599CIT+TWg5jKZ8LteEjFYAqAfs=;
	h=Date:To:From:Subject:Message-Id; b=GvKxvMhbAhWddm0pCaXRVLeO5Ptl5gdq1cBTIQPgQzwCRWk17NWBZi4o7F17wyhgp+Z4l2eGxxNbCAZRtqA8M2vXhLypv8hO6+k4R6x5Snwstto9xm2OP9Muab3UTDrKgY3YwoKOEA069NDrt8+3inqcb6nO9Fp4LWP+qAOCbb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SUuoMa67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SUuoMa67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAA9C116C6;
	Sun,  5 Apr 2026 21:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775422901;
	bh=7mJtCaO8oMbrrubJ599CIT+TWg5jKZ8LteEjFYAqAfs=;
	h=Date:To:From:Subject:From;
	b=SUuoMa67Xp3pG/0hcz5KIU6aM/QLBwrJKxyJLrV5sAZLQtInFvNjylYpGUh9AoN1q
	 9WDB6Lru1j1ZJ78w80KRbul40cr/ibj6cMZHohPWBZzDxeHnjeKR6OnoR4GxzLY+1g
	 zfTd7HOY+AoTj5zLCxhlyZMNslevgIDwHc44pnJk=
Date: Sun, 05 Apr 2026 14:01:40 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,michel@lespinasse.org,ljs@kernel.org,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch added to mm-unstable branch
Message-Id: <20260405210141.3BAA9C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: optimize rmap_walk_ksm by passing a suitable address range
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: optimize rmap_walk_ksm by passing a suitable address range
Date: Thu, 12 Feb 2026 19:30:45 +0800 (CST)

Problem
=======
When available memory is extremely tight, causing KSM pages to be swapped
out, or when there is significant memory fragmentation and THP triggers
memory compaction, the system will invoke the rmap_walk_ksm function to
perform reverse mapping.  However, we observed that this function becomes
particularly time-consuming when a large number of VMAs (e.g., 20,000)
share the same anon_vma.  Through debug trace analysis, we found that most
of the latency occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or
more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

Root Cause
==========
Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check "if
(addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective.  This inefficiency arises
because the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
In fact, we can significantly improve performance by passing a more precise
range based on the given addr. Since the original pages merged by KSM
correspond to anonymous VMAs, the page offset can be calculated as
pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
defining:

	pgoff = rmap_item->address >> PAGE_SHIFT;

Performance
===========
In our real embedded Linux environment, the measured metrcis were as
follows:

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
Before:  228.65       22169                 22168                    0
After :   0.396        3                     0                       2

The referenced reproducer of rmap_walk_ksm can be found at:
https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/

Link: https://lkml.kernel.org/r/20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn
Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range
+++ a/mm/ksm.c
@@ -3173,6 +3173,7 @@ again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3186,8 +3187,12 @@ again:
 			anon_vma_lock_read(anon_vma);
 		}
 
+		/*
+		 * Currently KSM folios are order-0 normal pages, so pgoff_end
+		 * should be the same as pgoff_start.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff, pgoff) {
 
 			cond_resched();
 			vma = vmac->vma;
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch

