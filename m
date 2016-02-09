From: akpm@linux-foundation.org
Subject: +
 mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch added
 to -mm tree
Date: Tue, 09 Feb 2016 13:18:13 -0800
Message-ID: <56ba5795.DIx9ImnKhwoG036h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbcBIVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 16:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: size shadow nodes lru basing on file cache size
has been added to the -mm tree.  Its filename is
     mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch

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
Subject: mm: workingset: size shadow nodes lru basing on file cache size

A page is activated on refault if the refault distance stored in the
corresponding shadow entry is less than the number of active file pages. 
Since active file pages can't occupy more than half memory, we assume that
the maximal effective refault distance can't be greater than half the
number of present pages and size the shadow nodes lru list appropriately. 
Generally speaking, this assumption is correct, but it can result in
wasting a considerable chunk of memory on stale shadow nodes in case the
portion of file pages is small, e.g.  if a workload mostly uses anonymous
memory.

To sort this out, we need to compute the size of shadow nodes lru basing
not on the maximal possible, but the current size of file cache.  We could
take the size of active file lru for the maximal refault distance, but
active lru is pretty unstable - it can shrink dramatically at runtime
possibly disrupting workingset detection logic.

Instead we assume that the maximal refault distance equals half the total
number of file cache pages.  This will protect us against active file lru
size fluctuations while still being correct, because size of active lru is
normally maintained lower than size of inactive lru.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size mm/workingset.c
--- a/mm/workingset.c~mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size
+++ a/mm/workingset.c
@@ -349,7 +349,9 @@ static unsigned long count_shadow_nodes(
 	shadow_nodes = list_lru_shrink_count(&workingset_shadow_nodes, sc);
 	local_irq_enable();
 
-	pages = node_present_pages(sc->nid);
+	pages = node_page_state(sc->nid, NR_ACTIVE_FILE) +
+		node_page_state(sc->nid, NR_INACTIVE_FILE);
+
 	/*
 	 * Active cache pages are limited to 50% of memory, and shadow
 	 * entries that represent a refault distance bigger than that
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

