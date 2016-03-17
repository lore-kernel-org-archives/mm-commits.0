From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:48:42 -0700
Message-ID: <56eb182a.dIGwaFwldjlg9cc2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbcCQUsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch

This patch was dropped because it was folded into mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

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

mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch
mm-memcontrol-cleanup-css_reset-callback.patch
mm-memcontrol-zap-oom_info_lock.patch

