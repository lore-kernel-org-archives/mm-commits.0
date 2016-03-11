From: akpm@linux-foundation.org
Subject: + mm-memcontrol-zap-oom_info_lock.patch added to -mm tree
Date: Fri, 11 Mar 2016 12:47:45 -0800
Message-ID: <56e32ef1.Vcbp4hGOZqiCL5A9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbcCKUrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2016 15:47:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: zap oom_info_lock
has been added to the -mm tree.  Its filename is
     mm-memcontrol-zap-oom_info_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-zap-oom_info_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-zap-oom_info_lock.patch

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
Subject: mm: memcontrol: zap oom_info_lock

mem_cgroup_print_oom_info is always called under oom_lock, so
oom_info_lock is redundant.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-zap-oom_info_lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-zap-oom_info_lock
+++ a/mm/memcontrol.c
@@ -1150,12 +1150,9 @@ static bool mem_cgroup_wait_acct_move(st
  */
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
-	/* oom_info_lock ensures that parallel ooms do not interleave */
-	static DEFINE_MUTEX(oom_info_lock);
 	struct mem_cgroup *iter;
 	unsigned int i;
 
-	mutex_lock(&oom_info_lock);
 	rcu_read_lock();
 
 	if (p) {
@@ -1199,7 +1196,6 @@ void mem_cgroup_print_oom_info(struct me
 
 		pr_cont("\n");
 	}
-	mutex_unlock(&oom_info_lock);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-oom_reaper-implement-oom-victims-queuing-fix.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
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

