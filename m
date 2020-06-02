From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 078/128] memcg: expose root cgroup's memory.stat
Date: Mon, 01 Jun 2020 21:49:39 -0700
Message-ID: <20200602044939.Qwy-kLSIU%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEtk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:40 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org, mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: expose root cgroup's memory.stat

One way to measure the efficiency of memory reclaim is to look at the
ratio (pgscan+pfrefill)/pgsteal.  However at the moment these stats are
not updated consistently at the system level and the ratio of these are
not very meaningful.  The pgsteal and pgscan are updated for only global
reclaim while pgrefill gets updated for global as well as cgroup reclaim.

Please note that this difference is only for system level vmstats.  The
cgroup stats returned by memory.stat are actually consistent.  The
cgroup's pgsteal contains number of reclaimed pages for global as well as
cgroup reclaim.  So, one way to get the system level stats is to get these
stats from root's memory.stat, so, expose memory.stat for the root cgroup.

	from Johannes Weiner:
	There are subtle differences between /proc/vmstat and
	memory.stat, and cgroup-aware code that wants to watch the full
	hierarchy currently has to know about these intricacies and
	translate semantics back and forth.

	Generally having the fully recursive memory.stat at the root
	level could help a broader range of usecases.

Why not fix the stats by including both the global and cgroup reclaim
activity instead of exposing root cgroup's memory.stat?  The reason is
the benefit of having metrics exposing the activity that happens purely
due to machine capacity rather than localized activity that happens due
to the limits throughout the cgroup tree.  Additionally there are
userspace tools like sysstat(sar) which reads these stats to inform
about the system level reclaim activity.  So, we should not break such
use-cases.

Link: http://lkml.kernel.org/r/20200508170630.94406-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~memcg-expose-root-cgroups-memorystat
+++ a/mm/memcontrol.c
@@ -6228,7 +6228,6 @@ static struct cftype memory_files[] = {
 	},
 	{
 		.name = "stat",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = memory_stat_show,
 	},
 	{
_
