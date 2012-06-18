From: akpm@linux-foundation.org
Subject: + hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch added to -mm tree
Date: Mon, 18 Jun 2012 14:21:50 -0700
Message-ID: <20120618212150.9A74AA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42085 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2FRVVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:21:52 -0400
Received: by yhgm50 with SMTP id m50so577144yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:21:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: hugeltb: mark hugelb_max_hstate __read_mostly
has been added to the -mm tree.  Its filename is
     hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch

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
Subject: Subject: hugeltb: mark hugelb_max_hstate __read_mostly

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch

