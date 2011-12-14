From: akpm@linux-foundation.org
Subject: + memcg-clean-up-soft_limit_tree-if-allocation-fails.patch added to -mm tree
Date: Tue, 13 Dec 2011 17:00:40 -0800
Message-ID: <201112140100.pBE10ehp014197@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pz0-f74.google.com ([209.85.210.74]:34470 "EHLO
	mail-pz0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1LNBAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 20:00:43 -0500
Received: by dadi14 with SMTP id i14so46447dad.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 17:00:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, aarcange@redhat.com, bsingharora@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: memcg: free entries in soft_limit_tree if allocation fails
has been added to the -mm tree.  Its filename is
     memcg-clean-up-soft_limit_tree-if-allocation-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: free entries in soft_limit_tree if allocation fails

If we are not able to allocate tree nodes for all NUMA nodes then we
should release those that were allocated.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-clean-up-soft_limit_tree-if-allocation-fails mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-soft_limit_tree-if-allocation-fails
+++ a/mm/memcontrol.c
@@ -4859,7 +4859,7 @@ static int mem_cgroup_soft_limit_tree_in
 			tmp = -1;
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
 		if (!rtpn)
-			return 1;
+			goto err_cleanup;
 
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 
@@ -4870,6 +4870,16 @@ static int mem_cgroup_soft_limit_tree_in
 		}
 	}
 	return 0;
+
+err_cleanup:
+	for_each_node_state(node, N_POSSIBLE) {
+		if (!soft_limit_tree.rb_tree_per_node[node])
+			break;
+		kfree(soft_limit_tree.rb_tree_per_node[node]);
+		soft_limit_tree.rb_tree_per_node[node] = NULL;
+	}
+	return 1;
+
 }
 
 static struct cgroup_subsys_state * __ref
_
Subject: Subject: memcg: free entries in soft_limit_tree if allocation fails

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mm-simplify-find_vma_prev.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch

