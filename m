From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:50 -0700
Message-ID: <533f086a.OmYp1iZEuRNlMXRp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: [merged] mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch removed from -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:50 -0700


The patch titled
     Subject: mm: vmscan: respect NUMA policy mask when shrinking slab on direct reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
slub-fix-leak-of-name-in-sysfs_slab_add.patch

