Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DA020E702
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388479; cv=none; b=anDoyR+sGWZy0cPNSYFN2MJkNQan6H3iVM+ccVFWPSmKu302MgcSABslQT8KXhIJwmdqSRxso9pPvJgn8eXm0sAwYRfXOFMM6kwetCZ3UwiWsrT9XJ16HLpvWCZCkk0SWeQcWeAxaxMhQBXzlpQhtKUZA5mB+0XT2XFFpafWtAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388479; c=relaxed/simple;
	bh=ff+ky05zvwTYmhZUi1uBOR3h/nUzi7DmrgIxFWrLROE=;
	h=Date:To:From:Subject:Message-Id; b=ci5xaBG1rRXA3TFCJfgJ1nzk3Tfjvk2v+HZvkdWSRaXU5RYpWJFEy5pZMRxqtcuY4Hp6wQcCXCBq0g23b1YHgifDEu/W3ORt9DBeyGjK+Pzgjt12E3vcH/K7IK6wrQ/fuxPkPRUUe8ElHyjQSnYPWjWC4ruWzUzgEc7h8SyTpJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0CknjUcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0CknjUcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666B9C19424;
	Tue, 24 Mar 2026 21:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388479;
	bh=ff+ky05zvwTYmhZUi1uBOR3h/nUzi7DmrgIxFWrLROE=;
	h=Date:To:From:Subject:From;
	b=0CknjUcbfTXCEug/9Wja/m2Ccose9u8fOwtrmiMXPxfylkdB80ph/oStU1yU784U9
	 5Apu5cXgM8u+1MEKwjpVkc8+tejaVs9g1yG0oDV0c8Gca8YUuDA19XOpaQq0dMTn26
	 LlsYzgwK6JjfyEfLOItSfHTaCclIRDIdo82iRAlQ=
Date: Tue, 24 Mar 2026 14:41:18 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch removed from -mm tree
Message-Id: <20260324214119.666B9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: initialize the addr only once in rmap_walk_ksm
has been removed from the -mm tree.  Its filename was
     ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


