Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD2A4DBD88
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609085; cv=none; b=jpXfP/PEkC8W8SdjN61fwAxju1UjXBCF4Sf0XkSGYtozUTP9QPvQsCyTebVetiK2Dgr859TBTKG3PaIerHiVnia+htOoqMjZIs571QihPchc+tHsr7N5UC0yN2VU2Ry89aX9inqQHaiH4wOAVY+/zQm4+ZDn9zw9/FveW6XbGXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609085; c=relaxed/simple;
	bh=yrFbLDJ6lFp4jdB7pt9S0W+T1EYpVWka4xXPC4yfgHo=;
	h=Date:To:From:Subject:Message-Id; b=WbTrFswNKWUxpKedmIOzJ/HvLoDxCbr7G2yxvBxPt/3K1HWeq0UsA5+MdqyEoZW7BjTH+l3NMS2hgSoKB6uU/xWQUALQiyWqSOv5pBjNlf9bxHcZCnsJrPrIfZcrPYviBObtGiF8fDB9eVK4e8ZM/5ATq2CbW2zMHxoMX4oZHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a//pdEI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a//pdEI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2D41F00898;
	Thu,  4 Jun 2026 21:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609082;
	bh=PnZrNFA230z58I4qSwJ6MN3+PIeUFeHcrLoQspPwbeQ=;
	h=Date:To:From:Subject;
	b=a//pdEI5LVbaRJC346hgj/aYxiaMvBwHARZVftgeBdErPSY9NhCaauSsc1qLUUt4g
	 RJD4CfLf0jmzsqmUPSWlL8eFqfzWLg7oCpnQI28GgwnBmNDtEsYfWIKFYeCp7Y1ajW
	 B0EhqUUaS+of7grVi07J26p3ZRbnI7c0wTgzUI/w=
Date: Thu, 04 Jun 2026 14:38:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-switch-deferred-split-shrinker-to-list_lru-fix-2.patch removed from -mm tree
Message-Id: <20260604213802.9B2D41F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: switch deferred split shrinker to list_lru fix
has been removed from the -mm tree.  Its filename was
     mm-switch-deferred-split-shrinker-to-list_lru-fix-2.patch

This patch was dropped because it was folded into mm-switch-deferred-split-shrinker-to-list_lru.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: switch deferred split shrinker to list_lru fix
Date: Tue, 2 Jun 2026 17:11:46 -0400

Lance Yang points out a weirdness in the list_lru code with
cgroup.memory=nokmem: in this mode, list_lru collapses to a shared
per-node list that holds the folios, but __list_lru_add() still sets the
shrinker bit on the owning memcg.

Usually this is fine, because the generic shrinker code ignores these
random bits when !memcg_kmem_online().  But the THP shrinker still has the
SHRINKER_NONSLAB flag set, which specifically declares an independence
from kmem.  As a result, the shrinker fires twice per reclaim cycle: one
during the regular root cgroup scan, and then one more time triggered from
whichever memcg got the shrinker bit.

Drop the flag, since it's no longer true.  The deferred_split shrinker
then behaves like every other list_lru-backed shrinker under nokmem,
including the non-kmem ones (zswap, workingset shadow_nodes): skipped from
memcg-internal reclaim, driven by global reclaim only.

This needs proper cleaning up on the shrinker and list_lru side, but
that's scope for a follow-up series.  Just make it consistent now.

Link: https://lore.kernel.org/ah9PGv12mqai84ES@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-switch-deferred-split-shrinker-to-list_lru-fix-2
+++ a/mm/huge_memory.c
@@ -945,8 +945,7 @@ int folio_memcg_alloc_deferred(struct fo
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE |
-						 SHRINKER_NONSLAB,
+						 SHRINKER_MEMCG_AWARE,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-fix-set_shrinker_bit-call-during-race-with-cgroup-deletion.patch
mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-memory-flatten-alloc_anon_folio-retry-loop.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

