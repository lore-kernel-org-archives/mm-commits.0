Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9CC3BB117
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068147; cv=none; b=bPBL3CyOU2DbUBYpzexUk0PPxAj8Mh8Sn8oDgHllPdOJWzOtsTKESC+vWEff44iQI1AlLbWOIlf64Fi4Feh5hDrM3i6ij/9+cMl7EiiJ2/woNqWeowd9XjmGgvLsqanMdboYDmdYXAZvk9DLGijF94vvR602g9pu80NOYSPT9Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068147; c=relaxed/simple;
	bh=Jhw3Z+jdcW8XbMQ5n7T+upMugobvg6bmf2soW8uwjcc=;
	h=Date:To:From:Subject:Message-Id; b=m57di1YJh1Z+gdeeBAkYa74CxIUJMsIuN+QEkYO7gqMXOue9vF2aXHxwRkyfgbm9eeLD8YDYQsCjbkdAQXFeCIYuGF6MgCubCdjvKB5Y6GYZb94d0RQNQ77WbJ1NZJBHRWCZHvY7SKVL+OmExNxq+DTHLZDW41UZ2P4V6lOsGtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nX1PQ/FG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nX1PQ/FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8698B1F00A3A;
	Fri,  7 Aug 2026 02:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068145;
	bh=vFnUhJ6Zi3PCPd2kNPhiQvBiQ0Kw9+zDcN+9p1pxP/o=;
	h=Date:To:From:Subject;
	b=nX1PQ/FGD7xMwvhcvvuXsYCmlgCY0SLfPMAU4hv6zYxgMCmjGh0PZBvx5gP+64PIn
	 O/E+RqxOIYT9C7sg0QeZNkCt/rL3LqDUD5hZEnSEAElHgNHCKsokEa2AgWMVWswhGH
	 RWplYyNbgdJF1sEdvtiu8ESQjqZb0ht3I41A6wtI=
Date: Thu, 06 Aug 2026 19:02:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,jiahuitry@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes.patch removed from -mm tree
Message-Id: <20260807020225.8698B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: prevent migration fallback to non-target nodes
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiahui Zhang <jiahuitry@outlook.com>
Subject: mm/damon/ops-common: prevent migration fallback to non-target nodes
Date: Tue, 21 Jul 2026 06:56:05 -0700

DAMOS_MIGRATE_{HOT,COLD} passes a target NUMA node to migrate_pages(). 
But alloc_migration_target() only treats mtc->nid as a preferred node
unless __GFP_THISNODE is set.  Hence target allocation can fall back to
another node, and migrate_pages() can report success without placing the
folio on the requested target node.

Consider a two-node tiered system where node 0 is a fast tier and node 1
is a CPU-less slow tier such as CXL memory, and the user wants to promote
hot regions from node 1 to node 0 with a command like:

  sudo damo start --ops vaddr --target_pid ${workload_pid} \
      --damos_action migrate_hot 0 \
      --damos_access_rate 70% max

Without the __GFP_THISNODE flag, when the memory allocator finds that node
0 is nearly full, it can fall back to node 1 without waking up kswapd. 
Then the pages allocated for migrate_pages() are still on node 1, and the
regions that are expected to be promoted to node 0 are only moved to
different physical pages on node 1.

Meanwhile, both the mm_migrate_pages tracepoint and DAMOS's own sz_applied
statistics (reported via the damos_stat_after_apply_interval tracepoint)
show the migrations as successful, which makes the failure practically
invisible and hard to investigate.

Running a demotion-purpose DAMOS scheme alongside the promotion scheme
does not fully avoid this either.  If demotion cannot keep up with the
promotion rate, allocation can still fall back to node 1 during promotion,
and the same misleading statistics show up.

Make DAMON's migration target allocation strict by setting __GFP_THISNODE,
so that a failed allocation on the target node is reported as a failure
instead of silently landing on a different node.  This is consistent with
alloc_misplaced_dst_folio(), alloc_demote_folio(), and with
do_move_pages_to_node(), which all use __GFP_THISNODE for migrations to an
explicit destination node.

Link: https://lore.kernel.org/20260721135607.251869-1-sj@kernel.org
Signed-off-by: Jiahui Zhang <jiahuitry@outlook.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes
+++ a/mm/damon/ops-common.c
@@ -312,7 +312,7 @@ static unsigned int __damon_migrate_foli
 		 * instead of migrated.
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			__GFP_NOMEMALLOC | GFP_NOWAIT,
+			__GFP_NOMEMALLOC | GFP_NOWAIT | __GFP_THISNODE,
 		.nid = target_nid,
 	};
 
_

Patches currently in -mm which might be from jiahuitry@outlook.com are


