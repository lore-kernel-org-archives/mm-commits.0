From: akpm@linux-foundation.org
Subject: +
 mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups.patch added
 to -mm tree
Date: Tue, 28 Mar 2017 13:32:25 -0700
Message-ID: <58dac859.LeK/A+1Q2uEt5suP%akpm__40883.1298388124$1490733157$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753330AbdC1Ucc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 16:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@tarantool.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: fix premature shadow node shrinking with cgroups
has been added to the -mm tree.  Its filename is
     mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: fix premature shadow node shrinking with cgroups

0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
enabled cgroup-awareness in the shadow node shrinker, but forgot to also
enable cgroup-awareness in the list_lru the shadow nodes sit on.

Consequently, all shadow nodes are sitting on a global (per-NUMA node)
list, while the shrinker applies the limits according to the amount of
cache in the cgroup its shrinking.  The result is excessive pressure on
the shadow nodes from cgroups that have very little cache.

Enable memcg-mode on the shadow node LRUs, such that per-cgroup limits are
applied to per-cgroup lists.

Fixes: 0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
Link: http://lkml.kernel.org/r/20170322005320.8165-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@tarantool.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups mm/workingset.c
--- a/mm/workingset.c~mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups
+++ a/mm/workingset.c
@@ -532,7 +532,7 @@ static int __init workingset_init(void)
 	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
 	       timestamp_bits, max_order, bucket_order);
 
-	ret = list_lru_init_key(&shadow_nodes, &shadow_nodes_key);
+	ret = __list_lru_init(&shadow_nodes, true, &shadow_nodes_key);
 	if (ret)
 		goto err;
 	ret = register_shrinker(&workingset_shadow_shrinker);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats.patch
mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
mm-memcontrol-provide-shmem-statistics.patch
mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch

