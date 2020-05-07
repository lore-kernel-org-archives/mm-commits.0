From: akpm@linux-foundation.org
Subject: + mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch
 added to -mm tree
Date: Thu, 07 May 2020 14:15:05 -0700
Message-ID: <20200507211505.bMnDGUunm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgEGVPG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 17:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: vmscan: consistent update to pgsteal and pgscan
has been added to the -mm tree.  Its filename is
     mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch
