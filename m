Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A8E21CC51;
	Tue, 30 Jun 2026 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860131; cv=none; b=QtKGgffVz6YY4vuiHKAH8Cj+KlqZlzdzxPthyEtddWMRsP1XX+o2azd5fxNJK8IJJkjObFIJVvH1pIqCMPfAR7Pgk2uRDZjP2sRmepmlMVIqC7vNnoBLy1A2LzgJNK8sB+rt7jRg2JO1hlkqda1wi0Pm2yMAS04EpB7fCuSpGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860131; c=relaxed/simple;
	bh=PJHuKndL1Ty7Hzyb9y0N59/fYRssMKPdJ7wJr7ZVk6w=;
	h=Date:To:From:Subject:Message-Id; b=on3AsZDnistLiJ3gjh3WioFvYsWAcIdXmIGA6xQnea55UbsGEeFjQhJHC5nJ/GOuf1zkj6b5SHCbjumX+X4vRKNqKHXWk9Kt61YtW0I9efZq9yEt8O4rgNeGjwUAIzL6SOl4S8oFLuOHjWJghE0G5qWZo4kiCRUIHkCwFxbDgGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1DvMYIGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1DvMYIGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC331F000E9;
	Tue, 30 Jun 2026 22:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860129;
	bh=sEARnuA1AIjYngcy4Yz7fWEcrZY4Nv0lMLJrzcEyJA8=;
	h=Date:To:From:Subject;
	b=1DvMYIGRgJYkjlW1pJvksxf1bwodpwWEU8Q3Y7tj35yMDpt+JtMwxl1rQvWgHuXJU
	 j9vslvErngwCYklFBtShOB3q2j+1qRyzEjgBAddVlNo6fcy3SV5lzWSAcXJH++8GQL
	 ZRuwx2MmQ4D1paCZlLNYjnJmiX3HbjjlHb7Bd/mE=
Date: Tue, 30 Jun 2026 15:55:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch added to mm-hotfixes-unstable branch
Message-Id: <20260630225529.ABC331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: fold stranded per-cpu node stats when a node comes online
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch

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

mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch
mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch

