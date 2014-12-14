From: akpm@linux-foundation.org
Subject: [merged] slab-fix-cpuset-check-in-fallback_alloc.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:10:19 -0800
Message-ID: <548d0dab.H6+3saZtsOMcjaoE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaLNEKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix cpuset check in fallback_alloc
has been removed from the -mm tree.  Its filename was
     slab-fix-cpuset-check-in-fallback_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: fix cpuset check in fallback_alloc

fallback_alloc is called on kmalloc if the preferred node doesn't have
free or partial slabs and there's no pages on the node's free list
(GFP_THISNODE allocations fail).  Before invoking the reclaimer it tries
to locate a free or partial slab on other allowed nodes' lists.  While
iterating over the preferred node's zonelist it skips those zones which
hardwall cpuset check returns false for.  That means that for a task bound
to a specific node using cpusets fallback_alloc will always ignore free
slabs on other nodes and go directly to the reclaimer, which, however, may
allocate from other nodes if cpuset.mem_hardwall is unset (default).  As a
result, we may get lists of free slabs grow without bounds on other nodes,
which is bad, because inactive slabs are only evicted by cache_reap at a
very slow rate and cannot be dropped forcefully.

To reproduce the issue, run a process that will walk over a directory tree
with lots of files inside a cpuset bound to a node that constantly
experiences memory pressure.  Look at num_slabs vs active_slabs growth as
reported by /proc/slabinfo.

To avoid this we should use softwall cpuset check in fallback_alloc.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Zefan Li <lizefan@huawei.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-cpuset-check-in-fallback_alloc mm/slab.c
--- a/mm/slab.c~slab-fix-cpuset-check-in-fallback_alloc
+++ a/mm/slab.c
@@ -3015,7 +3015,7 @@ retry:
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		nid = zone_to_nid(zone);
 
-		if (cpuset_zone_allowed(zone, flags | __GFP_HARDWALL) &&
+		if (cpuset_zone_allowed(zone, flags) &&
 			get_node(cache, nid) &&
 			get_node(cache, nid)->free_objects) {
 				obj = ____cache_alloc_node(cache,
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

