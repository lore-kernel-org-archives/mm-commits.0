From: akpm@linux-foundation.org
Subject: [folded] hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:21:23 -0700
Message-ID: <20120731232124.376A0A0114@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:63326 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815Ab2GaXV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 19:21:27 -0400
Received: by lagr15 with SMTP id r15so298221lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:21:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugeltb: mark hugelb_max_hstate __read_mostly
has been removed from the -mm tree.  Its filename was
     hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch

This patch was dropped because it was folded into hugetlb-make-some-static-variables-global.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugeltb: mark hugelb_max_hstate __read_mostly

We set this value only during boot.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly
+++ a/include/linux/hugetlb.h
@@ -22,7 +22,7 @@ struct hugepage_subpool {
 };
 
 extern spinlock_t hugetlb_lock;
-extern int hugetlb_max_hstate;
+extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
diff -puN mm/hugetlb.c~hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly
+++ a/mm/hugetlb.c
@@ -35,7 +35,7 @@ const unsigned long hugetlb_zero = 0, hu
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-int hugetlb_max_hstate;
+int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
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
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-3.patch
mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix.patch
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
linux-next.patch

