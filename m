Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778681E98EF
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651279; cv=none; b=ARFq58YyE0hdQ0sIpwEeZj598hfWhy7IIWpA7lWoPAhlGGMIEjdvn1IGf1DAMjw4NemofcF8kX1m7F74Iq4RLdoMJ79T/bgkYHxyRVEpIbAWAtCW+RXJU4KOeDV1Qvn11E4L18ZTbL3lifH+PLDChR9VnZRyqpxFRuCpbkerBBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651279; c=relaxed/simple;
	bh=1eIt6/TiQgK9JiY1U8+WiApzvyo42YpL8+o01mF7Qsk=;
	h=Date:To:From:Subject:Message-Id; b=LXH9weDm1lu5ZjCaBrm3WJ6wNw/UkMOoMqRWWPHBryUJ0eJZY60Ky3FQ2MOiiFcJfMKZyGgSazYoz5vJAxuI22a9IeaTiijSQgPNOODcj4UMpZkfFCsSd0/hpS/n8twkJPeSXkQZraTNj93+bNA18uCpmMOqge00EhIsR4N4G6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCszFNQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCszFNQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1279D1F00A3A;
	Sat,  5 Sep 2026 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651278;
	bh=SE7+YaOlJxfKunCSlbA4IcaLEQgOwsFeHEEOLxhqj2E=;
	h=Date:To:From:Subject;
	b=XCszFNQbSpL+jzfxQGaWne1q+8lAd14gPyDIYGQM9qtYJAYQCGZKKLU2rIHyfpTdT
	 +hp+FyyRxwxEfhgTYeNCnWwNxT9RlMgtHUtJBYwi+WU3oxKabeiqI2tFlwGOuviNc1
	 laor9ttvK+x7A+E5artHSXaiNyEYKlarj7baMZm4=
Date: Sat, 05 Sep 2026 16:34:37 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-per-node-objcg-to-the-read-mostly-fields.patch added to mm-new branch
Message-Id: <20260905233438.1279D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move per-node objcg to the read-mostly fields
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-per-node-objcg-to-the-read-mostly-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-per-node-objcg-to-the-read-mostly-fields.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch
memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

