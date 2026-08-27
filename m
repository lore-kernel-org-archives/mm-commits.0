Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA6368D5F;
	Thu, 27 Aug 2026 20:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861316; cv=none; b=hUCvNQ8hr7R0N8FxhCO3BzgI9eO7latM7w4tmnaXDI9dH8ruy9y+8yMVEFvinI8edfBeFURbPKwEoCRRv93erzfVhzJKgN0BMvWrRYEj/QgLFVb/SKaqxyn9WgvOrjNH2aFdbiol3EeV48qfTQo84qaUiuogvhyoakZx5kTsdZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861316; c=relaxed/simple;
	bh=Rv5cGUG7x4RjllMYkTiGqjrRO7gj7+XnICs8REL0sws=;
	h=Date:To:From:Subject:Message-Id; b=J9bvXq2FRcmg7i19NQsMDv3BqMvEl3foAs6PJwuTGPWAqWKrT5vepLqQ2aag8B435rtez6Kz4YRBTjXOEKFTDCY7PDn56+Hk6oAx6uiJVbagCmq7muH31UW1Ttqy7amZ9e3lNZUbvXSKa4m/NWytv28U/PTlglGqiFFMQW14ai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zEAImXc1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zEAImXc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B090C1F000E9;
	Thu, 27 Aug 2026 20:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861314;
	bh=QF6NxKOGfzLXI8A+xaBHlFeCmBDGJH8h6c2gvvVNOsQ=;
	h=Date:To:From:Subject;
	b=zEAImXc1rSHy5Svxu0vzb84KJen0o6L65UDWLVqypCfkdPI4OcKBv+GtduUop4h+M
	 a5ZGOCGhPMKmamL2EYdhsa4XIExv6cVxxmnxYUo897CeLjoQgEUrz8trIKhHrSNq9h
	 cr5w/wjiMzc3WUx083aOewa/v2Q7TJQI340A1Kw8=
Date: Thu, 27 Aug 2026 13:08:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch removed from -mm tree
Message-Id: <20260827200834.B090C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
Date: Fri, 21 Aug 2026 17:04:07 +0000

syzbot reported a sleeping function called from invalid context splat in
bucket_table_alloc().

When rhashtable_insert_slow() rehashes the table under rcu_read_lock(), it
calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).  If the bucket
table allocation uses vmalloc, __vmalloc_node_range_noprof() invokes
vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with the
passed GFP_ATOMIC flags.

If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
GFP_KERNEL when allocating the temporary weights array, triggering a
might_alloc() splat in atomic/RCU contexts.

Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
zone modifiers like __GFP_HIGHMEM) received by
alloc_pages_bulk_weighted_interleave() to kmalloc() instead of hardcoding
GFP_KERNEL.  Since the weights buffer is immediately initialized in full,
kmalloc() is sufficient.

Link: https://lore.kernel.org/20260821170407.3721004-1-edumazet@google.com
Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave
+++ a/mm/mempolicy.c
@@ -2679,7 +2679,7 @@ static unsigned long alloc_pages_bulk_we
 	prev_node = node;
 
 	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
+	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
 	if (!weights)
 		return total_allocated;
 
_

Patches currently in -mm which might be from edumazet@google.com are


