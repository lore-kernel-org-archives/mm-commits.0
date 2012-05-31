From: akpm@linux-foundation.org
Subject: [merged] documentation-memcg-future-proof-hierarchical-statistics-documentation.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:35 -0700
Message-ID: <20120531191435.6328EA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40770 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab2EaTOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:37 -0400
Received: by vbnl22 with SMTP id l22so134118vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: memcg: future proof hierarchical statistics documentation
has been removed from the -mm tree.  Its filename was
     documentation-memcg-future-proof-hierarchical-statistics-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Documentation: memcg: future proof hierarchical statistics documentation

The hierarchical versions of per-memcg counters in memory.stat are all
calculated the same way and are all named total_<counter>.

Documenting the pattern is easier for maintenance than listing each
counter twice.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Ying Han <yinghan@google.com>
Randy Dunlap <rdunlap@xenotime.net>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN Documentation/cgroups/memory.txt~documentation-memcg-future-proof-hierarchical-statistics-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~documentation-memcg-future-proof-hierarchical-statistics-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -430,17 +430,10 @@ hierarchical_memory_limit - # of bytes o
 hierarchical_memsw_limit - # of bytes of memory+swap limit with regard to
 			hierarchy under which memory cgroup is.
 
-total_cache		- sum of all children's "cache"
-total_rss		- sum of all children's "rss"
-total_mapped_file	- sum of all children's "cache"
-total_pgpgin		- sum of all children's "pgpgin"
-total_pgpgout		- sum of all children's "pgpgout"
-total_swap		- sum of all children's "swap"
-total_inactive_anon	- sum of all children's "inactive_anon"
-total_active_anon	- sum of all children's "active_anon"
-total_inactive_file	- sum of all children's "inactive_file"
-total_active_file	- sum of all children's "active_file"
-total_unevictable	- sum of all children's "unevictable"
+total_<counter>		- # hierarchical version of <counter>, which in
+			addition to the cgroup's own value includes the
+			sum of all hierarchical children's values of
+			<counter>, i.e. total_cache
 
 # The following additional stats are dependent on CONFIG_DEBUG_VM.
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

