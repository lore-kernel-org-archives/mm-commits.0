From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-support-file_region-coalescing-again-fix-2.patch removed from -mm
 tree
Date: Wed, 01 Apr 2020 20:39:49 -0700
Message-ID: <20200402033949.r5vN0PheD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDBDju (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, shakeelb@google.com


The patch titled
     Subject: hugetlb: remove check_coalesce_bug debug code
has been removed from the -mm tree.  Its filename was
     hugetlb-support-file_region-coalescing-again-fix-2.patch

This patch was dropped because it was folded into hugetlb-support-file_region-coalescing-again.patch

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
