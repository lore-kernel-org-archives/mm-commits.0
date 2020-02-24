From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 hugetlb-support-file_region-coalescing-again-fix-2.patch added to -mm tree
Date: Sun, 23 Feb 2020 19:46:09 -0800
Message-ID: <20200224034609.qlQcEJ0q9%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgBXDqL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 22:46:11 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, shakeelb@google.com


The patch titled
     Subject: hugetlb: remove check_coalesce_bug debug code
has been added to the -mm tree.  Its filename is
     hugetlb-support-file_region-coalescing-again-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-support-file_region-coalescing-again-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-support-file_region-coalescing-again-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb: remove check_coalesce_bug debug code

Commit b5f16a533ce8a ("hugetlb: support file_region coalescing again")
made changes to the resv_map code which are hard to test, it so added
debug code guarded by CONFIG_DEBUG_VM which conducts an expensive
operation that loops over the resv_map and checks it for errors.

Unfortunately, some distros have CONFIG_DEBUG_VM on in their default
kernels, and we don't want this debug code behind CONFIG_DEBUG_VM and
called each time a file region is added.  This patch removes this debug
code.  I may look into making it a test or leave it for my local testing.

Link: http://lkml.kernel.org/r/20200219233610.13808-1-almasrymina@google.com
Fixes: b5f16a533ce8a ("hugetlb: support file_region coalescing again")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   43 -------------------------------------------
 1 file changed, 43 deletions(-)

--- a/mm/hugetlb.c~hugetlb-support-file_region-coalescing-again-fix-2
+++ a/mm/hugetlb.c
@@ -289,48 +289,6 @@ static bool has_same_uncharge_info(struc
 #endif
 }
 
-#if defined(CONFIG_DEBUG_VM) && defined(CONFIG_CGROUP_HUGETLB)
-static void dump_resv_map(struct resv_map *resv)
-{
-	struct list_head *head = &resv->regions;
-	struct file_region *rg = NULL;
-
-	pr_err("--------- start print resv_map ---------\n");
-	list_for_each_entry(rg, head, link) {
-		pr_err("rg->from=%ld, rg->to=%ld, rg->reservation_counter=%px, rg->css=%px\n",
-		       rg->from, rg->to, rg->reservation_counter, rg->css);
-	}
-	pr_err("--------- end print resv_map ---------\n");
-}
-
-/* Debug function to loop over the resv_map and make sure that coalescing is
- * working.
- */
-static void check_coalesce_bug(struct resv_map *resv)
-{
-	struct list_head *head = &resv->regions;
-	struct file_region *rg = NULL, *nrg = NULL;
-
-	list_for_each_entry(rg, head, link) {
-		nrg = list_next_entry(rg, link);
-
-		if (&nrg->link == head)
-			break;
-
-		if (nrg->reservation_counter && nrg->from == rg->to &&
-		    nrg->reservation_counter == rg->reservation_counter &&
-		    nrg->css == rg->css) {
-			dump_resv_map(resv);
-			VM_BUG_ON(true);
-		}
-	}
-}
-#else
-static void check_coalesce_bug(struct resv_map *resv)
-{
-}
-#endif
-
 static void coalesce_file_region(struct resv_map *resv, struct file_region *rg)
 {
 	struct file_region *nrg = NULL, *prg = NULL;
@@ -435,7 +393,6 @@ static long add_reservation_in_range(str
 	}
 
 	VM_BUG_ON(add < 0);
-	check_coalesce_bug(resv);
 	return add;
 }
 
_

Patches currently in -mm which might be from almasrymina@google.com are

hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter.patch
hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations.patch
mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings.patch
hugetlb-disable-region_add-file_region-coalescing.patch
hugetlb-disable-region_add-file_region-coalescing-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings.patch
hugetlb_cgroup-support-noreserve-mappings.patch
hugetlb-support-file_region-coalescing-again.patch
hugetlb-support-file_region-coalescing-again-fix.patch
hugetlb-support-file_region-coalescing-again-fix-2.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-tests.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-docs.patch
