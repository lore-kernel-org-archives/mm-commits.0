Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9623D295;
	Tue, 18 Aug 2026 23:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787095694; cv=none; b=FIZWweEmg/MKwwUtgjE3dHJB/OMtENRes07H4Kb3YteXDmdtzkTBBoOTH41GrZuMcIQGtyAkPha+xFlY2yURV6+Gbw3bhUAqR1Ddbzbpb6J8Pp4YaqNeQ4l2KMy3RTV+AjqDhMxjHqY/s+J6BgZqfb9tPuKcMe2S8snKQj3SDkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787095694; c=relaxed/simple;
	bh=p8lWGYN4SPwCbT8u8RgCkD/rLBl5NXDmf7KYUMPYLZY=;
	h=Date:To:From:Subject:Message-Id; b=Y3LX+IBSCohpX+UuAmMuZJVGGWjIwhozLIwpeeUP3aMvJNEbR4m9JCvG6ag8prZfBGTQ6jH4PdypN6BDtr1ItqbM9hXf+j8hQH6MW09xoRjkixfyr3gqPmIKVBamJoK2v+klHlrvMiZweDXjUZFKqbO3Zi+QGMC/6v6gmGgx3G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LmzVjgii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LmzVjgii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CD31F000E9;
	Tue, 18 Aug 2026 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787095691;
	bh=6Ru1WbE+nyuqk23Q9At8GFASEFcIDodjHyn9s9UD0d8=;
	h=Date:To:From:Subject;
	b=LmzVjgii8oMu+MqPMS9Cln5kMFc6hWRbBVMpNhc2ZMiku72VSBFcdeJraXHrfyEK7
	 jGR+Ce3h7hqVNN/xSD8x0N9BPeT4m0AvHfNbK+StLPzSACp9mh6wWckAG2YoLl0hxs
	 xXR2s8xAM//KMnJ6GaGWhSX3ku4IP7WU/3lv8LXY=
Date: Tue, 18 Aug 2026 16:28:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lance.yang@linux.dev,david@kernel.org,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-add-cond_resched-to-__unmap_hugepage_range.patch added to mm-unstable branch
Message-Id: <20260818232811.58CD31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: add cond_resched() to __unmap_hugepage_range()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-add-cond_resched-to-__unmap_hugepage_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-add-cond_resched-to-__unmap_hugepage_range.patch

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
From: Leon Hwang <leon.hwang@linux.dev>
Subject: hugetlb: add cond_resched() to __unmap_hugepage_range()
Date: Tue, 18 Aug 2026 21:50:29 +0800

Packet receive timeouts were traced to sparse HugeTLB unmapping in
production.  A task unmapping a sparse 2.5 TiB HugeTLB mapping could
remain in kernel context for over 40 ms without reaching a scheduling
point while walking empty huge PTEs.  Although hard IRQs could still be
handled, the per-CPU ksoftirqd thread and other runnable tasks could not
run during that interval, delaying NET_RX softirq work queued to
ksoftirqd.

Add cond_resched() at the beginning of the hugepage loop so ksoftirqd and
other runnable tasks can run between iterations.  Testing with
PREEMPT_NONE showed that the maximum interval between scheduling points
fell from over 40 ms to below 2.5 ms.  Total time spent in
__unmap_hugepage_range() remained about 36 ms.

Link: https://lore.kernel.org/20260818135029.93288-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Reported-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~hugetlb-add-cond_resched-to-__unmap_hugepage_range
+++ a/mm/hugetlb.c
@@ -5235,6 +5235,8 @@ void __unmap_hugepage_range(struct mmu_g
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
+		cond_resched();
+
 		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep) {
 			address |= last_addr_mask;
_

Patches currently in -mm which might be from leon.hwang@linux.dev are

hugetlb-add-cond_resched-to-__unmap_hugepage_range.patch

