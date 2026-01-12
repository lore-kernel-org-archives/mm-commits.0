Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609FE37F8BD
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768240043; cv=none; b=ApP8wZT653Z/dyOSw1DsVXyXAcboHMZxhJeepVGCW+oq7VJKq0xi107IMAA+pKi8FqjT5wWGXcvbt/+Uhyf1BwnR6zHokIANQekn7n3920ZGGh1Uq5IwazDn2DduSEDV/o+40YLUt42NWmRaEeQk9A+1ulhF6xIgF5qU5SWu4KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768240043; c=relaxed/simple;
	bh=5uE0jZZ5H6SF2i8OaPh/OIUrHaMr+QS5GcED7Vz9aqw=;
	h=Date:To:From:Subject:Message-Id; b=Ml0DDzITmWz1PxAFiI3TSuhjOOTCOveydiofy34E2D8seAAFoFH7TIJXnEZy3W2bSAiwAWeJETYzzTtIdgANOpQNZDskRnoHt6bWm5ExinIE5uKtI28cZ0ZT6vH8AVW6naEPaUhqX7q55WJYMrIk9Z+m6Uk1waQFErsC7H6mk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yO0NQezj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yO0NQezj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2154C19425;
	Mon, 12 Jan 2026 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768240043;
	bh=5uE0jZZ5H6SF2i8OaPh/OIUrHaMr+QS5GcED7Vz9aqw=;
	h=Date:To:From:Subject:From;
	b=yO0NQezjS0kHezURWJQs+I2ysP8HSzo9bgikmbhcytparJhNbXo0lTIHP+7ihMCfU
	 NurjHjN7F2gQOK23n4tORNjj982HBeeHIOXJrJ6rc34iTk5Yaa9PAzP8atnQAgoCmI
	 Io0DQQ9QGNGjA76tyHQDBO2h5rYcXEXZGU81w80w=
Date: Mon, 12 Jan 2026 09:47:22 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch added to mm-new branch
Message-Id: <20260112174722.F2154C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: initialize the addr only once in rmap_walk_ksm
has been added to the -mm mm-new branch.  Its filename is
     ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch

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
Subject: ksm: initialize the addr only once in rmap_walk_ksm
Date: Mon, 12 Jan 2026 21:55:22 +0800 (CST)

Patch series "KSM: Optimizations for rmap_walk_ksm".

There are two perfomance optimization patches for rmap_walk_ksm.  Patch
[1/2] moves the initializaion of addr from the position inside loop to the
position before the loop, since the variable will not change in the loop. 
Patch [2/2] optimizes rmap_walk_ksm() by passing a suitable page offset
range to the anon_vma_interval_tree_foreach loop to reduce ineffective
checks.

The performance metrics are presented in [2/2].


This patch (of 2):

This is a minor performance optimization, especially when there are many
for-loop iterations, because the addr variable doesn't change across
iterations.

Therefore, it only needs to be initialized once before the loop.

Link: https://lkml.kernel.org/r/20260112215522600q2jPW2Un_1HGohr1lVXJ3@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~ksm-initialize-the-addr-only-once-in-rmap_walk_ksm
+++ a/mm/ksm.c
@@ -3171,6 +3171,7 @@ again:
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
+		unsigned long addr;
 
 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3180,16 +3181,16 @@ again:
 			}
 			anon_vma_lock_read(anon_vma);
 		}
+
+		/* Ignore the stable/unstable/sqnr flags */
+		addr = rmap_item->address & PAGE_MASK;
+
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
-			unsigned long addr;
 
 			cond_resched();
 			vma = vmac->vma;
 
-			/* Ignore the stable/unstable/sqnr flags */
-			addr = rmap_item->address & PAGE_MASK;
-
 			if (addr < vma->vm_start || addr >= vma->vm_end)
 				continue;
 			/*
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange.patch

