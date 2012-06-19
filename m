From: akpm@linux-foundation.org
Subject: + memcg-remove-check-for-signal_pending-during-rmdir.patch added to -mm tree
Date: Tue, 19 Jun 2012 16:52:20 -0700
Message-ID: <20120619235221.4F16DA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36961 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2FSXwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 19:52:23 -0400
Received: by bkty5 with SMTP id y5so375203bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 16:52:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz


The patch titled
     Subject: memcg: remove check for signal_pending() during rmdir()
has been added to the -mm tree.  Its filename is
     memcg-remove-check-for-signal_pending-during-rmdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: remove check for signal_pending() during rmdir()

After bf544fdc241da8 "memcg: move charges to root cgroup if
use_hierarchy=0 in mem_cgroup_move_hugetlb_parent()", no memory reclaim
will occur when removing a memory cgroup.  If -EINTR is returned here,
cgroup will show a warning.

We don't need to handle any user interruption signal.  Remove this.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-check-for-signal_pending-during-rmdir mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-check-for-signal_pending-during-rmdir
+++ a/mm/memcontrol.c
@@ -3691,9 +3691,6 @@ move_account:
 		ret = -EBUSY;
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
-		ret = -EINTR;
-		if (signal_pending(current))
-			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
_
Subject: Subject: memcg: remove check for signal_pending() during rmdir()

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
memcg-remove-check-for-signal_pending-during-rmdir.patch

