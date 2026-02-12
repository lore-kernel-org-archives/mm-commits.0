Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761A4F9D9
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 20:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770928388; cv=none; b=J0684xVLkm4ozmhiAFSlb1AV+EPzDmvJHQMu4IQG7ZnQ71D/WRvrtVLUHUA6AIwzc5lfHTkih8aCspwaqyzQKAshCgnkoQxjSAPbBlCu2us7dRD2H3rOOEoY6ChMhMhclZGeMQSY/0ez3xOa6elB6ArTQb9vBC1Nq7zpzEAIByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770928388; c=relaxed/simple;
	bh=uGHAWQD81SxXi870Qe9NfeFeVC2swuHB1UKt82gdifo=;
	h=Date:To:From:Subject:Message-Id; b=dd2ETAJtLUBxmd21CJ82rUIf82cE2TeUuUjSEf3VXO5CX+hq9nwDC6VUWctczLW/SIWNXLIcFFjG33VymTAAt4xBu5NK4q6CAa4L6RZDEBYLLDmpSIc2q7UiZAK1LGgGvC4jb+5FAiZwMzLLct36wIykAS9u6ajvjZt9WAj4D/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y/sTu3ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y/sTu3ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA983C4CEF7;
	Thu, 12 Feb 2026 20:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770928388;
	bh=uGHAWQD81SxXi870Qe9NfeFeVC2swuHB1UKt82gdifo=;
	h=Date:To:From:Subject:From;
	b=y/sTu3akydGnaHiL0tmw6f3a9S1Iv8rMKa24fZVarKxXpzy6waMXy2MphQJ1vWgwD
	 zQQGRA8KHk1+Ls1G+zLA93g3EA2kQioK5DaK9hLdXF+qxGtn9S/EFiHuTVXIjDbHZH
	 a8352Num177sr5Hacq4P6aK3k9AYy8uFmHza3K+Y=
Date: Thu, 12 Feb 2026 12:33:07 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch added to mm-new branch
Message-Id: <20260212203307.EA983C4CEF7@smtp.kernel.org>
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
Date: Thu, 12 Feb 2026 19:29:32 +0800 (CST)

Patch series "KSM: Optimizations for rmap_walk_ksm", v3.

There are two performance optimization patches for rmap_walk_ksm.

The patch [1/2] move the initializaion of addr from the position inside
loop to the position before the loop, since the variable will not change
in the loop.

The patch [2/2] optimize rmap_walk_ksm by passing a suitable page offset
range to the anon_vma_interval_tree_foreach loop to reduce ineffective
checks.

The metric performance and reproducer can be found at patch[2/2].


This patch (of 2):

This is a minor performance optimization, especially when there are many
for-loop iterations, because the addr variable doesn't change across
iterations.

Therefore, it only needs to be initialized once before the loop.

Link: https://lkml.kernel.org/r/20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn
Link: https://lkml.kernel.org/r/20260212192932941MSsJEAyoRW4YdLBN7_myn@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~ksm-initialize-the-addr-only-once-in-rmap_walk_ksm
+++ a/mm/ksm.c
@@ -3168,6 +3168,8 @@ void rmap_walk_ksm(struct folio *folio,
 		return;
 again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
+		/* Ignore the stable/unstable/sqnr flags */
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3180,16 +3182,13 @@ again:
 			}
 			anon_vma_lock_read(anon_vma);
 		}
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
ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-address-range.patch

