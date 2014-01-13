From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch added to -mm tree
Date: Mon, 13 Jan 2014 15:15:29 -0800
Message-ID: <52d47391.H/A/gwEQaZIZuh5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaAMXPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 18:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: + mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch added to -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 15:15:29 -0800


The patch titled
     Subject: mm: vmscan: respect NUMA policy mask when shrinking slab on direct reclaim
has been added to the -mm tree.  Its filename is
     mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch

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
Subject: mm: vmscan: respect NUMA policy mask when shrinking slab on direct reclaim

When direct reclaim is executed by a process bound to a set of NUMA nodes,
we should scan only those nodes when possible, but currently we will scan
kmem from all online nodes even if the kmem shrinker is NUMA aware.  That
said, binding a process to a particular NUMA node won't prevent it from
shrinking inode/dentry caches from other nodes, which is not good.  Fix
this.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim
+++ a/mm/vmscan.c
@@ -2425,8 +2425,8 @@ static unsigned long do_try_to_free_page
 			unsigned long lru_pages = 0;
 
 			nodes_clear(shrink->nodes_to_scan);
-			for_each_zone_zonelist(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask)) {
+			for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					gfp_zone(sc->gfp_mask), sc->nodemask) {
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

fs-superc-fix-warn-on-alloc_super-fail-path.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
linux-next.patch

