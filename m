From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:55 -0700
Message-ID: <20120531191755.6AD91A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:32900 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2EaTR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:56 -0400
Received: by qabg24 with SMTP id g24so154442qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: convert numa stat to read_seq_string interface
has been removed from the -mm tree.  Its filename was
     mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: convert numa stat to read_seq_string interface

Instead of using the raw seq_file file interface, switch over to the
read_seq_string cftype callback and let cgroup core code set up the
seq_file.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-convert-numa-stat-to-read_seq_string-interface mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-convert-numa-stat-to-read_seq_string-interface
+++ a/mm/memcontrol.c
@@ -4128,12 +4128,12 @@ mem_cgroup_get_total_stat(struct mem_cgr
 }
 
 #ifdef CONFIG_NUMA
-static int mem_control_numa_stat_show(struct seq_file *m, void *arg)
+static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
+				      struct seq_file *m)
 {
 	int nid;
 	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
 	unsigned long node_nr;
-	struct cgroup *cont = m->private;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
 	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
@@ -4608,22 +4608,6 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
-#ifdef CONFIG_NUMA
-static const struct file_operations mem_control_numa_stat_file_operations = {
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int mem_control_numa_stat_open(struct inode *unused, struct file *file)
-{
-	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
-
-	file->f_op = &mem_control_numa_stat_file_operations;
-	return single_open(file, mem_control_numa_stat_show, cont);
-}
-#endif /* CONFIG_NUMA */
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
@@ -4711,8 +4695,7 @@ static struct cftype mem_cgroup_files[] 
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.open = mem_control_numa_stat_open,
-		.mode = S_IRUGO,
+		.read_seq_string = mem_control_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
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

