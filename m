From: akpm@linux-foundation.org
Subject: - hugetlb-add-hugetlb_dynamic_pool-sysctl.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:55 -0700
Message-ID: <200710162035.l9GKZts3015094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935373AbXJPVyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, bill.irwin@oracle.com, dave.mccracken@oracle.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: Add hugetlb_dynamic_pool sysctl
has been removed from the -mm tree.  Its filename was
     hugetlb-add-hugetlb_dynamic_pool-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: Add hugetlb_dynamic_pool sysctl
From: Adam Litke <agl@us.ibm.com>

The maximum size of the huge page pool can be controlled using the overall
size of the hugetlb filesystem (via its 'size' mount option).  However in the
common case the this will not be set as the pool is traditionally fixed in
size at boot time.  In order to maintain the expected semantics, we need to
prevent the pool expanding by default.

This patch introduces a new sysctl controlling dynamic pool resizing.  When
this is enabled the pool will expand beyond its base size up to the size of
the hugetlb filesystem.  It is disabled by default.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Dave McCracken <dave.mccracken@oracle.com>
Cc: William Irwin <bill.irwin@oracle.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 kernel/sysctl.c         |    8 ++++++++
 mm/hugetlb.c            |    5 +++++
 3 files changed, 14 insertions(+)

diff -puN include/linux/hugetlb.h~hugetlb-add-hugetlb_dynamic_pool-sysctl include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-hugetlb_dynamic_pool-sysctl
+++ a/include/linux/hugetlb.h
@@ -33,6 +33,7 @@ void hugetlb_unreserve_pages(struct inod
 
 extern unsigned long max_huge_pages;
 extern unsigned long hugepages_treat_as_movable;
+extern int hugetlb_dynamic_pool;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 
diff -puN kernel/sysctl.c~hugetlb-add-hugetlb_dynamic_pool-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~hugetlb-add-hugetlb_dynamic_pool-sysctl
+++ a/kernel/sysctl.c
@@ -880,6 +880,14 @@ static ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &hugetlb_treat_movable_handler,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hugetlb_dynamic_pool",
+		.data		= &hugetlb_dynamic_pool,
+		.maxlen		= sizeof(hugetlb_dynamic_pool),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= VM_LOWMEM_RESERVE_RATIO,
diff -puN mm/hugetlb.c~hugetlb-add-hugetlb_dynamic_pool-sysctl mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-hugetlb_dynamic_pool-sysctl
+++ a/mm/hugetlb.c
@@ -31,6 +31,7 @@ static unsigned int free_huge_pages_node
 static unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
+int hugetlb_dynamic_pool;
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -201,6 +202,10 @@ static struct page *alloc_buddy_huge_pag
 {
 	struct page *page;
 
+	/* Check if the dynamic pool is enabled */
+	if (!hugetlb_dynamic_pool)
+		return NULL;
+
 	page = alloc_pages(htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
 	if (page) {
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch
