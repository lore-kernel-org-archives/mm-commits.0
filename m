Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8F13AD3F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976914; cv=none; b=AafL7Lse2agj1EovQE0NDR/cs6wbXZl+iG/yHiEQX+1CJ6/BorUkFj0qgjP8khXMf+Dpkk37L3yOUYZUYRZrljiPDT2826HheySEptqOP4rGsTqCvvNEPwRfbOGEVrvME6Jjq8ckfJGHivB4JGabJXgvrxch9tcomof+BuHux98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976914; c=relaxed/simple;
	bh=REQs/hXBo//PwIcoxFNI6tL5NUVwBjHj7B9fzOu7ibM=;
	h=Date:To:From:Subject:Message-Id; b=VoZbeyd0NT3St4xBpRkKua2qoERMar5RsCcixvgOngIlxP3TAH3s0JzsuqjpsZMPpLziLtXj9KwLGAaL6ed1/Loq5rkfmZj7+gnYr9bjUPcpwSo9cRphCyIEcUJ8nG+4yNWUvVp917T7xFUHglrSAajtlw2GrzxSBgNSFtcSBdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D5FeMzcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D5FeMzcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA56C4CEE3;
	Sun, 20 Jul 2025 02:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976914;
	bh=REQs/hXBo//PwIcoxFNI6tL5NUVwBjHj7B9fzOu7ibM=;
	h=Date:To:From:Subject:From;
	b=D5FeMzcyaIJ0lyTf/cd/dG8MXw6++lWzUKcm7bqxCCfTUZ6USZnQD0wxwK1eQkcN3
	 amxSDfri4+QsqK790mjS1mMjD/28ZBjXUnIZrG9Lfl4QTgn2aeibOhr379lYiKDq8U
	 OA8WhhBiWQQUkpCQ0NNQOPPo37T7GsuJb/bgzxVU=
Date: Sat, 19 Jul 2025 19:01:53 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch removed from -mm tree
Message-Id: <20250720020153.EEA56C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: respect psi_memstall region in node reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/vmscan: respect psi_memstall region in node reclaim
Date: Mon, 23 Jun 2025 11:58:48 -0700

Patch series "mm: per-node proactive reclaim", v2.

This adds support for allowing proactive reclaim in general on a NUMA
system.  A per-node interface extends support for beyond a memcg-specific
interface, respecting the current semantics of memory.reclaim: respecting
aging LRU and not supporting artificially triggering eviction on nodes
belonging to non-bottom tiers.

This patch allows userspace to do:

     echo 512M swappiness=10 > /sys/devices/system/node/nodeX/reclaim

One of the premises for this is to semantically align as best as possible
with memory.reclaim.  During a brief time memcg did support nodemask until
55ab834a86a9 (Revert "mm: add nodes= arg to memory.reclaim"), for which
semantics around reclaim (eviction) vs demotion were not clear, rendering
charging expectations to be broken.

With this approach:

1. Users who do not use memcg can benefit from proactive reclaim.

2. Proactive reclaim on top tiers will trigger demotion, for which
   memory is still byte-addressable.  Reclaiming on the bottom nodes will
   trigger evicting to swap (the traditional sense of reclaim).  This
   follows the semantics of what is today part of the aging process on
   tiered memory, mirroring what every other form of reclaim does
   (reactive and memcg proactive reclaim).  Furthermore per-node proactive
   reclaim is not as susceptible to the memcg charging problem mentioned
   above.

3. Unlike memcg, there should be no surprises of callers expecting
   reclaim but instead got a demotion.  Essentially relying on behavior of
   shrink_folio_list() after 6b426d071419 ("mm: disable top-tier fallback
   to reclaim on proactive reclaim"), without the expectations of
   try_to_free_mem_cgroup_pages().

4. Unlike the nodes= arg, this interface avoids confusing semantics,
   such as what exactly the user wants when mixing top-tier and low-tier
   nodes in the nodemask.  Further per-node interface is less exposed to
   "free up memory in my container" usecases, where eviction is intended.

5. Users that *really* want to free up memory can use proactive
   reclaim on nodes knowingly to be on the bottom tiers to force eviction
   in a natural way - higher access latencies are still better than swap. 
   If compelled, while no guarantees and perhaps not worth the effort,
   users could also also potentially follow a ladder-like approach to
   eventually free up the memory.  Alternatively, perhaps an 'evict'
   option could be added to the parameters for both memory.reclaim and
   per-node interfaces to force this action unconditionally.


This patch (of 4):

... rather benign but keep proper ending order.

Link: https://lkml.kernel.org/r/20250623185851.830632-1-dave@stgolabs.net
Link: https://lkml.kernel.org/r/20250623185851.830632-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-respect-psi_memstall-region-in-node-reclaim
+++ a/mm/vmscan.c
@@ -7653,8 +7653,8 @@ static int __node_reclaim(struct pglist_
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc.gfp_mask);
-	psi_memstall_leave(&pflags);
 	delayacct_freepages_end();
+	psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are


