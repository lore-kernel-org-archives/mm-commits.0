From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-expose-root-cgroups-memorystat.patch added to -mm
 tree
Date: Fri, 08 May 2020 16:40:21 -0700
Message-ID: <20200508234021._axCoYCPN%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgEHXkW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:40:22 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: memcg: expose root cgroup's memory.stat
has been added to the -mm tree.  Its filename is
     memcg-expose-root-cgroups-memorystat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-expose-root-cgroups-memorystat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-expose-root-cgroups-memorystat.patch

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

Link: http://lkml.kernel.org/r/20200508170630.94406-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~memcg-expose-root-cgroups-memorystat
+++ a/mm/memcontrol.c
@@ -6180,7 +6180,6 @@ static struct cftype memory_files[] = {
 	},
 	{
 		.name = "stat",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = memory_stat_show,
 	},
 	{
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-optimize-memorynuma_stat-like-memorystat.patch
memcg-expose-root-cgroups-memorystat.patch
mm-vmscan-consistent-update-to-pgsteal-and-pgscan.patch
