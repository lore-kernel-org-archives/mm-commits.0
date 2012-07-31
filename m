From: akpm@linux-foundation.org
Subject: [folded] memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:28:56 -0700
Message-ID: <20120731232856.7DB46A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44960 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaX26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:28:58 -0400
Received: by wibhr14 with SMTP id hr14so153323wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:28:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-make-mem_cgroup_force_empty_list-return-bool-fix
has been removed from the -mm tree.  Its filename was
     memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch

This patch was dropped because it was folded into memcg-make-mem_cgroup_force_empty_list-return-bool.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-make-mem_cgroup_force_empty_list-return-bool-fix

rework mem_cgroup_force_empty_list()'s comment

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_force_empty_list-return-bool-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_force_empty_list-return-bool-fix
+++ a/mm/memcontrol.c
@@ -3609,8 +3609,10 @@ unsigned long mem_cgroup_soft_limit_recl
 }
 
 /*
- * This routine traverse page_cgroup in given list and drop them all.
- * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
+ * Traverse a specified page_cgroup list and try to drop them all.  This doesn't
+ * reclaim the pages page themselves - it just removes the page_cgroups.
+ * Returns true if some page_cgroups were not freed, indicating that the caller
+ * must retry this operation.
  */
 static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 				int node, int zid, enum lru_list lru)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

