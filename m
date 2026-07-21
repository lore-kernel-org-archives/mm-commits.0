Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880F6449B12;
	Tue, 21 Jul 2026 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594609; cv=none; b=Ayf3ZmcH+0STlPMBeBSqWJILEvXxQwNQBG37RVWokuYnRBnvhf/xfk0org4H8/xNXHpysF3d3GphkswMBBnoKskXotw8a1FkGfb8vD5iaz+qZNxxg5QHQg/fezXonLbFGn/0F7LtMFbCr6vOVN/xTH90mbRgj/r79s4+aMmeCmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594609; c=relaxed/simple;
	bh=SF4oOdXT6d3Qi/lQj/EyvYvi8R81pVmipaJu6fphWBs=;
	h=Date:To:From:Subject:Message-Id; b=cYpv8N/owf/0bNU4U8Z1BnVEp/WcDTzgqTVzOSYebk5AKU3k+oMZ16ZsGVsigRUwqj1zNxTJN4QCFu4N/CWdBVR3W6k9OwQ0cu2+rBfWChA6PTJInh+arBCLzDQrb+BBpyg1NrxSuJGLlGpJjWejqeehF/ln034eJysheYXd0lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGLOro4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGLOro4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087C81F000E9;
	Tue, 21 Jul 2026 00:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594608;
	bh=1SZeWRnnHL0MCHTiXimh6ljpvsLX4gVK37fQRaIq2Yk=;
	h=Date:To:From:Subject;
	b=qGLOro4WHrvRveUqs9293ifWwykMWfDi0MRjegxq/G+lxC6Rrl43hmyC90kP6Bwf7
	 od7c5CwIdPRn7fRtX3mtd84mMLUQZwwc1RbCa1aAZSa6tNj7RKvQS7PdwCOa1zaKI7
	 L8e2e4CLAfqBEoJieEW2KFm8ovqDGzAXplaaUD4s=
Date: Mon, 20 Jul 2026 17:43:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch removed from -mm tree
Message-Id: <20260721004328.087C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: fold stranded per-cpu node stats when a node comes online
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/vmstat: fold stranded per-cpu node stats when a node comes online
Date: Sat, 27 Jun 2026 16:22:43 -0400

A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.  A
balanced counter can sit split as global=+N / per-cpu=-N.

The folds reconciling the split only walk online nodes, so when
try_offline_node() marks a node offline the per-cpu deltas are stranded.

A subsequent online resets the per-cpu area but not pgdat->vm_stat[],
orphaning the +N permanently.  All NR_VM_NODE_STAT_ITEMS are affected.

The existing code zeroes the per-cpu counters and causes a permanent skew.
Fold the stranded deltas instead, before the node rejoins the online set.
The node is not online yet and the hotplug lock is held, so the remote
access to per-cpu values is safe.

Discovered when node compaction hung for a nearly empty node, as the math
to determine throttling broke.  Reproduced by repeated memory
hotplug/unplug cycles on a node under pressure: NR_ISOLATED_ANON ratchets
up and never returns to zero.

Link: https://lore.kernel.org/20260627202243.758289-1-gourry@gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online
+++ a/mm/mm_init.c
@@ -1540,7 +1540,7 @@ void __ref free_area_init_core_hotplug(s
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
-	int cpu;
+	int cpu, i;
 
 	pgdat_init_internals(pgdat);
 
@@ -1558,10 +1558,17 @@ void __ref free_area_init_core_hotplug(s
 	pgdat->node_start_pfn = 0;
 	pgdat->node_present_pages = 0;
 
-	for_each_online_cpu(cpu) {
-		struct per_cpu_nodestat *p;
+	/*
+	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
+	 * offline nodes) - reconcile this at online. Foreign access to counters
+	 * is safe: the node is not online yet and we hold the hotplug lock.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
 
-		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+			if (p->vm_node_stat_diff[i])
+				node_page_state_add(p->vm_node_stat_diff[i], pgdat, i);
 		memset(p, 0, sizeof(*p));
 	}
 
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch
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

