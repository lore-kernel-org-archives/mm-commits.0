From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:39 -0700
Message-ID: <53e3dc4f.REs/nihLpYD8ch9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:51497 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaHGUGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:40 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175787pab.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: clean up reclaim size variable use in try_charge()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clean up reclaim size variable use in try_charge()

Charge reclaim and OOM currently use the charge batch variable, but
batching is already disabled at that point.  To simplify the charge logic,
the batch variable is reset to the original request size when reclaim is
entered, so it's functionally equal, but it's misleading.

Switch reclaim/OOM to nr_pages, which is the original request size.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge
+++ a/mm/memcontrol.c
@@ -2612,7 +2612,7 @@ retry:
 
 	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 
-	if (mem_cgroup_margin(mem_over_limit) >= batch)
+	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		goto retry;
 
 	if (gfp_mask & __GFP_NORETRY)
@@ -2626,7 +2626,7 @@ retry:
 	 * unlikely to succeed so close to the limit, and we fall back
 	 * to regular pages anyway in case of failure.
 	 */
-	if (nr_reclaimed && batch <= (1 << PAGE_ALLOC_COSTLY_ORDER))
+	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
 		goto retry;
 	/*
 	 * At task move, charge accounts can be doubly counted. So, it's
@@ -2644,7 +2644,7 @@ retry:
 	if (fatal_signal_pending(current))
 		goto bypass;
 
-	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
+	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

