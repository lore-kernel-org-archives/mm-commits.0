From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:28 -0700
Message-ID: <20120531191428.98A24A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60314 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab2EaTOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:30 -0400
Received: by qcsp5 with SMTP id p5so136095qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, lizf@cn.fujitsu.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: count pte references from every member of the reclaimed hierarchy
has been removed from the -mm tree.  Its filename was
     mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: count pte references from every member of the reclaimed hierarchy

The rmap walker checking page table references has historically
ignored references from VMAs that were not part of the memcg that was
being reclaimed during memcg hard limit reclaim.

When transitioning global reclaim to memcg hierarchy reclaim, I missed
that bit and now references from outside a memcg are ignored even
during global reclaim.

Reverting back to traditional behaviour - count all references during
global reclaim and only mind references of the memcg being reclaimed
during limit reclaim would be one option.

However, the more generic idea is to ignore references exactly then
when they are outside the hierarchy that is currently under reclaim;
because only then will their reclamation be of any use to help the
pressure situation.  It makes no sense to ignore references from a
sibling memcg and then evict a page that will be immediately refaulted
by that sibling which contributes to the same usage of the common
ancestor under reclaim.

The solution: make the rmap walker ignore references from VMAs that
are not part of the hierarchy that is being reclaimed.

Flat limit reclaim will stay the same, hierarchical limit reclaim will
mind the references only to pages that the hierarchy owns.  Global
reclaim, since it reclaims from all memcgs, will be fixed to regard
all references.

[akpm@linux-foundation.org: name the args in the declaration]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++++-
 mm/memcontrol.c            |   16 +++++++++++-----
 mm/vmscan.c                |    6 ++++--
 3 files changed, 21 insertions(+), 8 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy
+++ a/include/linux/memcontrol.h
@@ -79,6 +79,8 @@ extern void mem_cgroup_uncharge_cache_pa
 
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order);
+bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
+				  struct mem_cgroup *memcg);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
@@ -92,10 +94,13 @@ static inline
 int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
 {
 	struct mem_cgroup *memcg;
+	int match;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	match = __mem_cgroup_same_or_subtree(cgroup, memcg);
 	rcu_read_unlock();
-	return cgroup == memcg;
+	return match;
 }
 
 extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
diff -puN mm/memcontrol.c~mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy
+++ a/mm/memcontrol.c
@@ -1149,17 +1149,23 @@ struct lruvec *mem_cgroup_lru_move_lists
  * Checks whether given mem is same or in the root_mem_cgroup's
  * hierarchy subtree
  */
-static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-		struct mem_cgroup *memcg)
+bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
+				  struct mem_cgroup *memcg)
 {
-	bool ret;
-
 	if (root_memcg == memcg)
 		return true;
 	if (!root_memcg->use_hierarchy)
 		return false;
+	return css_is_ancestor(&memcg->css, &root_memcg->css);
+}
+
+static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
+				       struct mem_cgroup *memcg)
+{
+	bool ret;
+
 	rcu_read_lock();
-	ret = css_is_ancestor(&memcg->css, &root_memcg->css);
+	ret = __mem_cgroup_same_or_subtree(root_memcg, memcg);
 	rcu_read_unlock();
 	return ret;
 }
diff -puN mm/vmscan.c~mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy
+++ a/mm/vmscan.c
@@ -645,7 +645,8 @@ static enum page_references page_check_r
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
 
-	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
+	referenced_ptes = page_referenced(page, 1, sc->target_mem_cgroup,
+					  &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
 
 	/*
@@ -1513,7 +1514,8 @@ static void shrink_active_list(unsigned 
 			}
 		}
 
-		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
+		if (page_referenced(page, 0, sc->target_mem_cgroup,
+				    &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
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

