From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:22 -0700
Message-ID: <20120611210922.C618CA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45852 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2FKVJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:26 -0400
Received: by bkty5 with SMTP id y5so250049bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: rename max_hstate to hugetlb_max_hstate
has been removed from the -mm tree.  Its filename was
     hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: rename max_hstate to hugetlb_max_hstate

This patchset implements a memory controller extension to control HugeTLB
allocations.  The extension allows to limit the HugeTLB usage per control
group and enforces the controller limit during page fault.  Since HugeTLB
doesn't support page reclaim, enforcing the limit at page fault time
implies that, the application will get SIGBUS signal if it tries to access
HugeTLB pages beyond its limit.  This requires the application to know
beforehand how much HugeTLB memory it would require for its use.

The goal is to control how many HugeTLB pages a group of tasks can
allocate.  It can be looked at as an extension of the existing quota
interface which limits the number of HugeTLB pages per hugetlbfs
superblock.  An HPC job scheduler requires jobs to specify their resource
requirements in the job file.  Once their requirements can be met, job
schedulers (such as SLURM) will schedule the job.  We need to make sure
that the jobs won't consume more resources than requested.  If they do we
should either error out or kill the application.

This patch:

Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
subsystems like memcg in later patches.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-rename-max_hstate-to-hugetlb_max_hstate mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-rename-max_hstate-to-hugetlb_max_hstate
+++ a/mm/hugetlb.c
@@ -34,7 +34,7 @@ const unsigned long hugetlb_zero = 0, hu
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-static int max_hstate;
+static int hugetlb_max_hstate;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
@@ -46,7 +46,7 @@ static unsigned long __initdata default_
 static unsigned long __initdata default_hstate_size;
 
 #define for_each_hstate(h) \
-	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
+	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -1897,9 +1897,9 @@ void __init hugetlb_add_hstate(unsigned 
 		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
 		return;
 	}
-	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
+	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order == 0);
-	h = &hstates[max_hstate++];
+	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
 	h->nr_huge_pages = 0;
@@ -1920,10 +1920,10 @@ static int __init hugetlb_nrpages_setup(
 	static unsigned long *last_mhp;
 
 	/*
-	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
+	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
 	 * so this hugepages= parameter goes to the "default hstate".
 	 */
-	if (!max_hstate)
+	if (!hugetlb_max_hstate)
 		mhp = &default_hstate_max_huge_pages;
 	else
 		mhp = &parsed_hstate->max_huge_pages;
@@ -1942,7 +1942,7 @@ static int __init hugetlb_nrpages_setup(
 	 * But we need to allocate >= MAX_ORDER hstates here early to still
 	 * use the bootmem allocator.
 	 */
-	if (max_hstate && parsed_hstate->order >= MAX_ORDER)
+	if (hugetlb_max_hstate && parsed_hstate->order >= MAX_ORDER)
 		hugetlb_hstate_alloc_pages(parsed_hstate);
 
 	last_mhp = mhp;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2.patch
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
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

