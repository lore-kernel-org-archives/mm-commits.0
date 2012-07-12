From: akpm@linux-foundation.org
Subject: + memcg-prevent-oom-with-too-many-dirty-pages-fix.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:11:45 -0700
Message-ID: <20120712211146.A8C0820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58537 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab2GLVLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:11:49 -0400
Received: by wibhr14 with SMTP id hr14so148873wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:11:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujtisu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: mm/vmscan.c: fix deadlock with lopp driver
has been added to the -mm tree.  Its filename is
     memcg-prevent-oom-with-too-many-dirty-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/vmscan.c: fix deadlock with lopp driver

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
prio_tree-debugging-patch.patch

