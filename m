From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged]
 mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch removed from -mm
 tree
Date: Mon, 11 May 2020 14:12:14 -0700
Message-ID: <20200511211214.WuV8bV5h0%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEKVMR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:12:17 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: vmscan: consistent update to pgsteal and pgscan
has been removed from the -mm tree.  Its filename was
     mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: vmscan: consistent update to pgsteal and pgscan

One way to measure the efficiency of memory reclaim is to look at the
ratio (pgscan+pfrefill)/pgsteal.  However at the moment these stats are
not updated consistently at the system level and the ratio of these are
not very meaningful.  The pgsteal and pgscan are updated for only global
reclaim while pgrefill gets updated for global as well as cgroup reclaim.

Please note that this difference is only for system level vmstats.  The
cgroup stats returned by memory.stat are actually consistent.  The
cgroup's pgsteal contains number of reclaimed pages for global as well as
cgroup reclaim.  So, one way to get the system level stats is to get these
stats from root's memory.stat but root does not expose that interface. 
Also for !CONFIG_MEMCG machines /proc/vmstat is the only way to get these
stats.  So, make these stats consistent.

Link: http://lkml.kernel.org/r/20200507204913.18661-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-consistent-update-to-pgsteal-and-pgscan
+++ a/mm/vmscan.c
@@ -1943,8 +1943,7 @@ shrink_inactive_list(unsigned long nr_to
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	item = current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_scanned);
+	__count_vm_events(item, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
 	spin_unlock_irq(&pgdat->lru_lock);
 
@@ -1957,8 +1956,7 @@ shrink_inactive_list(unsigned long nr_to
 	spin_lock_irq(&pgdat->lru_lock);
 
 	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
+	__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	reclaim_stat->recent_rotated[0] += stat.nr_activate[0];
 	reclaim_stat->recent_rotated[1] += stat.nr_activate[1];
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-optimize-memorynuma_stat-like-memorystat.patch
memcg-expose-root-cgroups-memorystat.patch
