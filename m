From: akpm@linux-foundation.org
Subject: [merged] kmem-add-slab-specific-documentation-about-the-kmem-controller.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:18 -0800
Message-ID: <20121219204219.4CF4020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:44833 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2LSUmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:23 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so121366lag.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmem: add slab-specific documentation about the kmem controller
has been removed from the -mm tree.  Its filename was
     kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: kmem: add slab-specific documentation about the kmem controller

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/cgroups/memory.txt~kmem-add-slab-specific-documentation-about-the-kmem-controller Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~kmem-add-slab-specific-documentation-about-the-kmem-controller
+++ a/Documentation/cgroups/memory.txt
@@ -301,6 +301,13 @@ to trigger slab reclaim when those limit
 kernel memory, we prevent new processes from being created when the kernel
 memory usage is too high.
 
+* slab pages: pages allocated by the SLAB or SLUB allocator are tracked. A copy
+of each kmem_cache is created everytime the cache is touched by the first time
+from inside the memcg. The creation is done lazily, so some objects can still be
+skipped while the cache is being created. All objects in a slab page should
+belong to the same memcg. This only fails to hold when a task is migrated to a
+different memcg during the page allocation by the cache.
+
 * sockets memory pressure: some sockets protocols have memory pressure
 thresholds. The Memory Controller allows them to be controlled individually
 per cgroup, instead of globally.
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

