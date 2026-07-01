Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52D639FD4
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782877737; cv=none; b=hYg86sbvifUljz2m9yX0aZd/0oJ3jbSHxy44TnITxv5zqRkGDvNI70PwOAsPQisoY6+oaArxQqYJkC421yTwMasgmFWl4VetszQOwaadoXK0cg8bR8DtAvfjSD1LRp9fMt3d0EC+XTR2smCSeyGLHTZOGUvT3fziIhynlKHRehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782877737; c=relaxed/simple;
	bh=MUCZyolcSKb80cbpzFYb/gK6XuGvNdX/DGf3bfdKiEc=;
	h=Date:To:From:Subject:Message-Id; b=o1swF3UViiNt+CY2wzAypJSx6y2ahE1GIUrRNeUV5Qrf9DVoWFUoHVIWy/rBxBAyx17O0FbAmbnoqxMMXc+fAVeLn0tGsxe09QfQepYpfUJgZZIIocAo0MlD+io2qn7O2ImObbGMSf6iC9QNy0dXFGiFxY1MQxN+j7fLNYreioU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2/byvDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2/byvDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675EF1F000E9;
	Wed,  1 Jul 2026 03:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782877735;
	bh=s2zXQBX2uAdtbfJ/MpmGuu4zLqRDgANCLTQBFn7dMko=;
	h=Date:To:From:Subject;
	b=K2/byvDMI052Ew3DpaprFcYT3LXdZb+/5ZXAP+Lbv5DrMEXDuncrrqi72czP80ITD
	 /eppZk7P3PHHqiPwW6C47aKKB5lMqoksnLngJBRUmdnR2CGrFIhMqB1DsASvx21jCk
	 KYD219Xt07Xna6NJNScIOJ3wbk9mlPSJgnej8KnY=
Date: Tue, 30 Jun 2026 20:48:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,rppt@kernel.org,osalvador@suse.de,mgorman@techsingularity.net,hannes@cmpxchg.org,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch added to mm-new branch
Message-Id: <20260701034855.675EF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
Date: Tue, 30 Jun 2026 17:40:39 -0400

We miss a failed allocation check for pgdat->per_cpu_nodestats, which
results in a NULL deref when we offset into the per-cpu area.

Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing at
boot_nodestats so a later online can retry the allocation.

hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
already maps to -ENOMEM.

Assisted-by: Sashiko:unknown-model
Link: https://lore.kernel.org/20260630214039.2263562-1-gourry@gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>
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
+extern int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
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

mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch
mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch

