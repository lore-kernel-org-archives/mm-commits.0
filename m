Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677E049365D;
	Fri, 21 Aug 2026 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787334205; cv=none; b=Zfe1CQGilLIgdvoUYpsfAY7dfGMRK0qAvnN56HrRqlvgv6qCZss9nrWx271H+wZBw2FiyYbLBL3pO/w71yF0T6vZC8JQDSpHZsgXvlFGxSWLxtieoXP+bd6d+p/KhM9wOpP3lxeVfmZJJtC9zYAiP/sZTlRtTvhb+mUg4ICGy0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787334205; c=relaxed/simple;
	bh=cRjQqXBDa3VN/IHuV3/DZYql8VzajxfkGDpmBW9xBtQ=;
	h=Date:To:From:Subject:Message-Id; b=AtZvC7B04um1HgpavmJ99Xd8TathSNkEUb/+wmacXZ5gJ+InGVyioRQbmJ/yzvza+dNq69keaVchhylcxfVK9Jca0I641rrdVKJ9PbfnGei0kSKpqRCUq9PKK3TjyZtROQQhmYDDKKg4CC7fvfaUEsmWU/PE8nYIB/FL1guGWUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=usrCrmQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="usrCrmQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023401F000E9;
	Fri, 21 Aug 2026 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787334204;
	bh=otvhbtai+ornLzJdnkwIe0nfHiIYwkr2ql58EnvcGzA=;
	h=Date:To:From:Subject;
	b=usrCrmQdZPTdEz6cah0rqiPu1uMn2DTZGc1/M27xFwiTA+F1RXcULSClz5PPS8hLz
	 3gj2uiheFyB3DxpLOPnQ9DNbnhEx6/olm8z2nSfZDiv1FT3hlYfgzHw4FiuNEEuu1y
	 p11ecWPeqbY1rK+40AZ+QCtgLWUQPm45wN2ZMFpQ=
Date: Fri, 21 Aug 2026 10:43:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch added to mm-hotfixes-unstable branch
Message-Id: <20260821174324.023401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
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
@@ -2683,7 +2683,7 @@ static unsigned long alloc_pages_bulk_we
 	prev_node = node;
 
 	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
+	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
 	if (!weights)
 		return total_allocated;
 
_

Patches currently in -mm which might be from edumazet@google.com are

mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch

