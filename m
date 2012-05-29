From: akpm@linux-foundation.org
Subject: + hugetlb-simplify-migrate_huge_page-fix.patch added to -mm tree
Date: Tue, 29 May 2012 11:25:51 -0700
Message-ID: <20120529182551.B0143A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44351 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2E2SZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 14:25:54 -0400
Received: by wgbdt11 with SMTP id dt11so273387wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 11:25:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb-simplify-migrate_huge_page-fix
has been added to the -mm tree.  Its filename is
     hugetlb-simplify-migrate_huge_page-fix.patch

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
Subject: hugetlb-simplify-migrate_huge_page-fix

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~hugetlb-simplify-migrate_huge_page-fix mm/memory-failure.c
--- a/mm/memory-failure.c~hugetlb-simplify-migrate_huge_page-fix
+++ a/mm/memory-failure.c
@@ -1428,8 +1428,8 @@ static int soft_offline_huge_page(struct
 	}
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
-	put_page(page);
+	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, 0, true);
+	put_page(hpage);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
_
Subject: Subject: hugetlb-simplify-migrate_huge_page-fix

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
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
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
lib-string_helpersc-make-arrays-static.patch

