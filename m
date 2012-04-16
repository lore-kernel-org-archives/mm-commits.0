From: akpm@linux-foundation.org
Subject: + hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:15:41 -0700
Message-ID: <20120416231542.65170A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59717 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2DPXPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:15:45 -0400
Received: by lbol12 with SMTP id l12so76621lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:15:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb: rename max_hstate to hugetlb_max_hstate
has been added to the -mm tree.  Its filename is
     hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: hugetlb: rename max_hstate to hugetlb_max_hstate

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

