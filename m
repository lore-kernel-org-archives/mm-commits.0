Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE2F35F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388481; cv=none; b=SqQPJceLo+rCYdRN3AkO+WcxIOby8SwECTMqFaRCTvViS99Mzhd3NFndgR0R+YjmWebdXJ6Id5nbm8cl18XRtNrk93zxWHFQ6T/MHLhnkseTyAKma3y+2c07wfHTVeE+Ff+ZyILg2epF8uc5qLzIXTZNm1hfB0lnRyhRmofnJsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388481; c=relaxed/simple;
	bh=WI+6fk2Lram/1IpaBzoK0JT4Vu2QqGjMRlHhcrRvOLc=;
	h=Date:To:From:Subject:Message-Id; b=D1/c5j+4pkoct/VM4pQ4EbuRqkoCaSshYIwmsR+Syw6X+b8jgCqutjoYIXwN5e/mNoY+rx8y5vH/WWlQELuRoHzRgtnIek3yrQmA+RshQs55ppVg+yKKFsJ9QB96mC5UkMxt9YGBBhnI6VsIRoIbTsTF0Y4qbWLCZ7kovacn0Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WPxjAEZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WPxjAEZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9A2C19424;
	Tue, 24 Mar 2026 21:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388481;
	bh=WI+6fk2Lram/1IpaBzoK0JT4Vu2QqGjMRlHhcrRvOLc=;
	h=Date:To:From:Subject:From;
	b=WPxjAEZb2b8wUXFfF6rCDsSQj4puV6ZIXJq6FxJklzTmbGSddoCknTJZsZPmustth
	 ko7oN9wFJ42iha8y66uR+6luqWMiNA2Hh4YZ64MgC+QffExVXRbY3bvRve4hbYLywi
	 hzi6stfAWn1BT/WJvWEc74TcZoocmNEtsN+DqjjQ=
Date: Tue, 24 Mar 2026 14:41:20 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch removed from -mm tree
Message-Id: <20260324214121.1A9A2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: optimize rmap_walk_ksm by passing a suitable address range
has been removed from the -mm tree.  Its filename was
     ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range
+++ a/mm/ksm.c
@@ -3170,6 +3170,7 @@ again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3183,8 +3184,12 @@ again:
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


