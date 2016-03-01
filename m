From: akpm@linux-foundation.org
Subject: + mm-memcontrol-cleanup-css_reset-callback.patch added to -mm
 tree
Date: Tue, 01 Mar 2016 13:44:49 -0800
Message-ID: <56d60d51.WM+CJ8vAh6k5ODy4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcCAVou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 16:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: cleanup css_reset callback
has been added to the -mm tree.  Its filename is
     mm-memcontrol-cleanup-css_reset-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-cleanup-css_reset-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-cleanup-css_reset-callback.patch

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
Subject: mm: memcontrol: cleanup css_reset callback

- Do not take memcg_limit_mutex for resetting limits - the cgroup cannot
  be altered from userspace anymore, so no need to protect them.

- Use plain page_counter_limit() for resetting ->memory and ->memsw
  limits instead of mem_cgrouop_resize_* helpers - we enlarge the limits,
  so no need in special handling.

- Reset ->swap and ->tcpmem limits as well.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-cleanup-css_reset-callback mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-cleanup-css_reset-callback
+++ a/mm/memcontrol.c
@@ -4257,9 +4257,11 @@ static void mem_cgroup_css_reset(struct
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
-	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
-	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->swap, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->memsw, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->kmem, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	memcg->low = 0;
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
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
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch
mm-memcontrol-cleanup-css_reset-callback.patch

