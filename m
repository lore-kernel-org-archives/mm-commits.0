From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
 added to -mm tree
Date: Fri, 05 Feb 2016 11:29:03 -0800
Message-ID: <56b4f7ff.qgHRVmHu3+buwq0G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbcBET3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 14:29:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2

> The only thing that strikes me is that you
> appended the new stat items to the enum, but then prepended them to
> the doc and stat file sections. Why is that?

No reason. Let's rearrange the enum fields to be consistent with the
stat file output.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2
+++ a/include/linux/memcontrol.h
@@ -52,10 +52,10 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
-	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
+	MEMCG_KERNEL_STACK = MEM_CGROUP_STAT_NSTATS,
 	MEMCG_SLAB_RECLAIMABLE,
 	MEMCG_SLAB_UNRECLAIMABLE,
-	MEMCG_KERNEL_STACK,
+	MEMCG_SOCK,
 	MEMCG_NR_STAT,
 };
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch

