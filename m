Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9933F99F4
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525412; cv=none; b=TolIeVmmb3yvJdTZsZHmqaMUsZRuVvb78Otym14Ei5UnPJ4b+vQ0R8Yjjlcy7BW/+Be/uZY3UbQdVb1O5MO4lHp3Qpl+iV/cYqm1lDCr6yh/JI5/6oETdQC32IpXWym5e5egrDFpnbLJ5AGfJlEFLcLPBlxkEAg+Advdt5Ilb18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525412; c=relaxed/simple;
	bh=HMPpX4dGl+lKWe+N5PgLuwexNutaGt+vpw3vdNqv3/Y=;
	h=Date:To:From:Subject:Message-Id; b=Rv3v2F/ySdUheIuwILZYJ6QJKxpMHaix2lFUSHoBxiSzyTNbnbvYqvibLFu3KbhkfFJDnWd+UAVzBUJeMSeaZH+Ag2GnDTa82YZwVhGjYfLRbnYTAj3ynyk4T2CHojEYFsg8/Ufq53Rlqs1mH3ZWswfkFZGzXESjRb5ALrXZeAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzuFiL6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzuFiL6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13AD1F000FF;
	Fri,  9 Oct 2026 05:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525410;
	bh=6k6/QLRNZ2Wv9h4Hm0UHRByqffzwigcr4g+hr9wHr7A=;
	h=Date:To:From:Subject;
	b=ZzuFiL6hQmJ1RhEpEwtKujqMBlz+6OI9Sbgjkl/sXgcdUA3BClbOB9u78PCttJ6Q6
	 Rq4IGbFHh7NVRnr12hCunSf362f4wImK6VtfH2Yvxtr4Rw3+CM7bEMmdgK47QGAtvc
	 +LQ2v5Psc/KLXBqYUZMpyM7wzBdr9HCOhadnQhPY=
Date: Thu, 08 Oct 2026 22:56:50 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-per-node-objcg-to-the-read-mostly-fields.patch removed from -mm tree
Message-Id: <20261009055650.C13AD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move per-node objcg to the read-mostly fields
has been removed from the -mm tree.  Its filename was
     memcg-move-per-node-objcg-to-the-read-mostly-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move per-node objcg to the read-mostly fields
Date: Fri, 4 Sep 2026 20:05:17 -0700

Patch series "memcg: group struct fields by access pattern".

Every so often we get a memcg performance regression caused by nothing
more than a field moving.  Someone adds a field, removes one, or puts a
few behind a config option.  The layout shifts, fields with different
access patterns land on the same cache line, and a bot reports a
regression.

Two examples.  commit 98c9daf5ae6b ("mm: memcg: guard memcg1-specific
members of struct mem_cgroup_per_node") moved lruvec next to
lru_zone_size[] and needed commit f59adcf59332 ("mm: memcg: add cacheline
padding after lruvec in mem_cgroup_per_node") to fix it.  commit
c1afbd5de131 ("mm/memcontrol: avoid false sharing between vmstats and
events") had to add ____cacheline_aligned_in_smp for the same reason.

Each fix was correct but nothing stops the next field addition from
undoing it.

This series makes the layout a contract the compiler checks, the same
way struct net_device does it. Fields are sorted into named cache line
groups by access pattern, and memcg_struct_check() verifies at build
time that every field sits in its group. A field added in the wrong
place now breaks the build instead of quietly costing a few percent.

struct mem_cgroup gets three groups:

  memcg_write_hot     written on the charge, reclaim and socket paths
  memcg_cold          only the cgroup control paths touch these
  memcg_read_mostly   set when the memcg is created, then only read

Testing
=======

The cgroup selftests give identical results with and without the series.

For performance, two identical 30 core Xeon machines each ran both
kernels, with the boot order swapped between them so that machine and
order effects cancel.  The useful tests run two workloads at once in one
cgroup, because false sharing only shows up when one side reads a field
that the other side writes.

  slab allocs + page faults, slab side           +1.2%
  page faults + memory.stat readers, fault side  +1.3%
  page faults + memory.stat readers, reader side +0.8%
  everything else                                no change

No test regressed.  The gains are small but the point of the series is the
build time contract.


This patch (of 6):

current_obj_cgroup() reads memcg->nodeinfo[nid]->objcg on every accounted
allocation.  The field sits at the end of struct mem_cgroup_per_node, on
the same cache line as lru_zone_size[] and iter.  lru_zone_size[] is
written on every LRU add and remove, and iter is written on every reclaim
iteration.

Move objcg next to the other read-mostly pointers at the start of the
struct.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/20260905030522.1887837-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~memcg-move-per-node-objcg-to-the-read-mostly-fields
+++ a/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
+	struct obj_cgroup __rcu		*objcg;
 
 	CACHELINE_PADDING(_pad1_);
 
@@ -104,11 +105,9 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
-	 * objcg is wiped out as a part of the objcg repaprenting process.
 	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of live of memcg.
+	 * objcg until the end of life of memcg.
 	 */
-	struct obj_cgroup __rcu	*objcg;
 	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


