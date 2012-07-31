From: akpm@linux-foundation.org
Subject: [folded] hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:26:59 -0700
Message-ID: <20120731232659.B97EEA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:50975 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2GaX1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:27:01 -0400
Received: by wibhr14 with SMTP id hr14so153270wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:27:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: Remove unnecessary NULL checks
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix.patch

This patch was dropped because it was folded into hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: Remove unnecessary NULL checks

cgroup_subsys_state can never be NULL, so don't check for that in
hugetlb_cgroup_from_css.  Also current task will always be part of some
cgroup.  So hugetlb_cgrop_from_task cannot return NULL.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix
+++ a/mm/hugetlb_cgroup.c
@@ -130,9 +130,6 @@ int hugetlb_cgroup_charge_cgroup(int idx
 again:
 	rcu_read_lock();
 	h_cg = hugetlb_cgroup_from_task(current);
-	if (!h_cg)
-		h_cg = root_h_cgroup;
-
 	if (!css_tryget(&h_cg->css)) {
 		rcu_read_unlock();
 		goto again;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch

