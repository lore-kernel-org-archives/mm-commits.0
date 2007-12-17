From: akpm@linux-foundation.org
Subject: + revert-hugetlb-add-hugetlb_dynamic_pool-sysctl.patch added to -mm tree
Date: Mon, 17 Dec 2007 13:30:41 -0800
Message-ID: <200712172130.lBHLUgG5002579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965000AbXLQVga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 16:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, haveblue@us.ibm.com, wli@holomorphy.com


The patch titled
     Revert "hugetlb: Add hugetlb_dynamic_pool sysctl"
has been added to the -mm tree.  Its filename is
     revert-hugetlb-add-hugetlb_dynamic_pool-sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Revert "hugetlb: Add hugetlb_dynamic_pool sysctl"
From: Nishanth Aravamudan <nacc@us.ibm.com>

Revert "hugetlb: Add hugetlb_dynamic_pool sysctl"

This reverts commit 54f9f80d6543fb7b157d3b11e2e7911dc1379790.

Given the new sysctl nr_overcommit_hugepages, the boolean dynamic pool sysctl
is not needed, as its semantics can be expressed by 0 in the overcommit sysctl
(no dynamic pool) and non-0 in the overcommit sysctl (pool enabled).

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 -
 kernel/sysctl.c         |    8 --------
 mm/hugetlb.c            |    5 -----
 3 files changed, 14 deletions(-)

diff -puN include/linux/hugetlb.h~revert-hugetlb-add-hugetlb_dynamic_pool-sysctl include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~revert-hugetlb-add-hugetlb_dynamic_pool-sysctl
+++ a/include/linux/hugetlb.h
@@ -33,7 +33,6 @@ void hugetlb_unreserve_pages(struct inod
 
 extern unsigned long max_huge_pages;
 extern unsigned long hugepages_treat_as_movable;
-extern int hugetlb_dynamic_pool;
 extern unsigned long nr_overcommit_huge_pages;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
diff -puN kernel/sysctl.c~revert-hugetlb-add-hugetlb_dynamic_pool-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~revert-hugetlb-add-hugetlb_dynamic_pool-sysctl
+++ a/kernel/sysctl.c
@@ -906,14 +906,6 @@ static struct ctl_table vm_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "hugetlb_dynamic_pool",
-		.data		= &hugetlb_dynamic_pool,
-		.maxlen		= sizeof(hugetlb_dynamic_pool),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_overcommit_hugepages",
 		.data		= &nr_overcommit_huge_pages,
 		.maxlen		= sizeof(nr_overcommit_huge_pages),
diff -puN mm/hugetlb.c~revert-hugetlb-add-hugetlb_dynamic_pool-sysctl mm/hugetlb.c
--- a/mm/hugetlb.c~revert-hugetlb-add-hugetlb_dynamic_pool-sysctl
+++ a/mm/hugetlb.c
@@ -31,7 +31,6 @@ static unsigned int free_huge_pages_node
 static unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
-int hugetlb_dynamic_pool;
 unsigned long nr_overcommit_huge_pages;
 static int hugetlb_next_nid;
 
@@ -230,10 +229,6 @@ static struct page *alloc_buddy_huge_pag
 	struct page *page;
 	unsigned int nid;
 
-	/* Check if the dynamic pool is enabled */
-	if (!hugetlb_dynamic_pool)
-		return NULL;
-
 	/*
 	 * Assume we will successfully allocate the surplus page to
 	 * prevent racing processes from causing the surplus to exceed
_

Patches currently in -mm which might be from nacc@us.ibm.com are

hugetlb-introduce-nr_overcommit_hugepages-sysctl.patch
revert-hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
documetation-update-hugetlb-information.patch
