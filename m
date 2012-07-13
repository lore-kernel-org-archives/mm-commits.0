From: akpm@linux-foundation.org
Subject: [folded] memcg-prevent-oom-with-too-many-dirty-pages-fix.patch removed from -mm tree
Date: Fri, 13 Jul 2012 13:51:57 -0700
Message-ID: <20120713205157.C9A171E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42693 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2GMUv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:51:59 -0400
Received: by ghbz15 with SMTP id z15so383292ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:51:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujtisu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix deadlock with lopp driver
has been removed from the -mm tree.  Its filename was
     memcg-prevent-oom-with-too-many-dirty-pages-fix.patch

This patch was dropped because it was folded into memcg-prevent-oom-with-too-many-dirty-pages.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/vmscan.c: fix deadlock with lopp driver

Part of my load builds kernels on extN over loop over tmpfs: loop does
mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS))
because it knows it will deadlock, if the loop thread enters reclaim, and
reclaim tries to write back a dirty page, one which needs the loop thread
to perform the write.

With the may_enter_fs check restored, all is well.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~memcg-prevent-oom-with-too-many-dirty-pages-fix mm/vmscan.c
--- a/mm/vmscan.c~memcg-prevent-oom-with-too-many-dirty-pages-fix
+++ a/mm/vmscan.c
@@ -726,7 +726,8 @@ static unsigned long shrink_page_list(st
 			 * writeback from reclaim and there is nothing else to
 			 * reclaim.
 			 */
-			if (!global_reclaim(sc) && PageReclaim(page))
+			if (!global_reclaim(sc) && PageReclaim(page) &&
+					may_enter_fs)
 				wait_on_page_writeback(page);
 			else {
 				nr_writeback++;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
prio_tree-debugging-patch.patch

