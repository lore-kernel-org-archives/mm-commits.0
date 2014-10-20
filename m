From: akpm@linux-foundation.org
Subject: + slab-fix-cpuset-check-in-fallback_alloc.patch added to -mm tree
Date: Mon, 20 Oct 2014 15:36:24 -0700
Message-ID: <54458e68.w5lAYZazz0w1qF3l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaJTWgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 18:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix cpuset check in fallback_alloc
has been added to the -mm tree.  Its filename is
     slab-fix-cpuset-check-in-fallback_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-fix-cpuset-check-in-fallback_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-fix-cpuset-check-in-fallback_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3012,7 +3012,7 @@ retry:
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		nid = zone_to_nid(zone);
 
-		if (cpuset_zone_allowed(zone, flags | __GFP_HARDWALL) &&
+		if (cpuset_zone_allowed(zone, flags) &&
 			get_node(cache, nid) &&
 			get_node(cache, nid)->free_objects) {
 				obj = ____cache_alloc_node(cache,
_

Patches currently in -mm which might be from vdavydov@parallels.com are

cpuset-convert-callback_mutex-to-a-spinlock.patch
cpuset-simplify-cpuset_node_allowed-api.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch

