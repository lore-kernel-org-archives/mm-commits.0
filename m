Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC765332621
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465754; cv=none; b=jMFLdoj9AGcBEqbfetT9z7JUzw1Lx091TjqmwKVNLCFbvLVSPAfMb+mQVF0Jx10OCmslwaixeKjVavaxLQ/qcHIgLzGUHdvdY9qKrlH28pqdc7n3KuvOB5qe6URogRc1XJ/BN5kevz3x88OGk9rooSUrfSGeJvr8AVAJRqF1daU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465754; c=relaxed/simple;
	bh=glcU3WNt3iWgibn9P9uT9apLZoSZn2CVUz6f+tblSEo=;
	h=Date:To:From:Subject:Message-Id; b=LNxyik8a2LvjNOgVQSkVzbzJhGQn4tvYrPsuLfG/33P3xiyX1gvbwF/qtAer6jQEH0YH+hJlLg+7dr8G3xKzJEHkWKXSTDZCKRkjS/OJ3R7x67I3o7ktIhYj2tKu489ve7EjjXZGiXzXUo2kzFeyP3s6pVTBl18EkQaE4ws1EDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lRnKLCKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lRnKLCKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC381F00A3A;
	Fri, 31 Jul 2026 02:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465752;
	bh=RvU/3X4L1eArc4pP+nwFmoeGn2zcqztmhBdZ33vjamA=;
	h=Date:To:From:Subject;
	b=lRnKLCKdJyFrp4JZdl3hRu4CUuIzIAY/8HSeqUN/k37sMhtB04TzXDnEF2nAvSbO0
	 Wlg44DVU3pHs7KE/2Dv4gAZc8NNKonsW0UbVQinpL6Th1xgRKfKQilkAEeOY/X900h
	 jymPBKHPOu/QVygdxpR2lEDHTM+BqYPemp05Yn8E=
Date: Thu, 30 Jul 2026 19:42:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,osalvador@suse.de,mgorman@techsingularity.net,hannes@cmpxchg.org,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch removed from -mm tree
Message-Id: <20260731024232.AFC381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
has been removed from the -mm tree.  Its filename was
     mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
Date: Wed, 1 Jul 2026 18:16:13 -0400

We miss a failed allocation check for pgdat->per_cpu_nodestats, which
results in a NULL deref when we offset into the per-cpu area.

Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing at
boot_nodestats so a later online can retry the allocation.

hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
already maps to -ENOMEM.

On failure nothing needs to be unwound:
  - the node is never marked online
  - per_cpu_nodestats is left pointing at boot_nodestats
  - __add_memory_resource() cleans up pending memblock resources
  - later online attempts retry the per_cpu_nodestats allocation

Link: https://lore.kernel.org/20260701221613.2818148-1-gourry@gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry%40gourry.net
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 +-
 mm/memory_hotplug.c            |    3 ++-
 mm/mm_init.c                   |   14 +++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug
+++ a/include/linux/memory_hotplug.h
@@ -289,7 +289,7 @@ static inline void __remove_memory(u64 s
 /* Default online_type (MMOP_*) when new memory blocks are added. */
 extern enum mmop mhp_get_default_online_type(void);
 extern void mhp_set_default_online_type(enum mmop online_type);
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
--- a/mm/memory_hotplug.c~mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug
+++ a/mm/memory_hotplug.c
@@ -1263,7 +1263,8 @@ static pg_data_t *hotadd_init_pgdat(int
 	pgdat = NODE_DATA(nid);
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(pgdat);
+	if (free_area_init_core_hotplug(pgdat))
+		return NULL;
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
--- a/mm/mm_init.c~mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug
+++ a/mm/mm_init.c
@@ -1526,7 +1526,7 @@ static inline void __init set_pageblock_
  * NOTE: this function is only called during memory hotplug
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
@@ -1534,8 +1534,14 @@ void __ref free_area_init_core_hotplug(s
 
 	pgdat_init_internals(pgdat);
 
-	if (pgdat->per_cpu_nodestats == &boot_nodestats)
-		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
+		struct per_cpu_nodestat __percpu *p;
+
+		p = alloc_percpu(struct per_cpu_nodestat);
+		if (!p)
+			return -ENOMEM;
+		pgdat->per_cpu_nodestats = p;
+	}
 
 	/*
 	 * Reset the nr_zones, order and highest_zoneidx before reuse.
@@ -1573,6 +1579,8 @@ void __ref free_area_init_core_hotplug(s
 		zone->present_pages = 0;
 		zone_init_internals(zone, z, nid, 0);
 	}
+
+	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory-add-memory_block_aligned_range-helper.patch
mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch
mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch
mm-memory_hotplug-export-mhp_get_default_online_type.patch
mm-memory_hotplug-add-__add_memory_driver_managed-with-online_type-arg.patch
mm-memory_hotplug-add-offline_and_remove_memory_ranges.patch
dax-kmem-resolve-default-online-type-at-probe-time.patch
dax-kmem-extract-hotplug-hotremove-helper-functions.patch
dax-kmem-add-sysfs-interface-for-atomic-whole-device-hotplug.patch
selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch

