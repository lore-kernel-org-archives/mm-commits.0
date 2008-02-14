From: akpm@linux-foundation.org
Subject: - hugetlb-fix-overcommit-locking.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:18 -0500
Message-ID: <200802150225.m1F2Pb1W015180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763492AbYBOC03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, miles.lane@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix overcommit locking
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-overcommit-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix overcommit locking
From: Nishanth Aravamudan <nacc@us.ibm.com>

proc_doulongvec_minmax() calls copy_to_user()/copy_from_user(), so we can't
hold hugetlb_lock over the call.  Use a dummy variable to store the sysctl
result, like in hugetlb_sysctl_handler(), then grab the lock to update
nr_overcommit_huge_pages.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Reported-by: Miles Lane <miles.lane@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 kernel/sysctl.c         |    4 ++--
 mm/hugetlb.c            |    6 ++++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-fix-overcommit-locking include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-fix-overcommit-locking
+++ a/include/linux/hugetlb.h
@@ -33,8 +33,8 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 
 extern unsigned long max_huge_pages;
+extern unsigned long sysctl_overcommit_huge_pages;
 extern unsigned long hugepages_treat_as_movable;
-extern unsigned long nr_overcommit_huge_pages;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 
diff -puN kernel/sysctl.c~hugetlb-fix-overcommit-locking kernel/sysctl.c
--- a/kernel/sysctl.c~hugetlb-fix-overcommit-locking
+++ a/kernel/sysctl.c
@@ -978,8 +978,8 @@ static struct ctl_table vm_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_overcommit_hugepages",
-		.data		= &nr_overcommit_huge_pages,
-		.maxlen		= sizeof(nr_overcommit_huge_pages),
+		.data		= &sysctl_overcommit_huge_pages,
+		.maxlen		= sizeof(sysctl_overcommit_huge_pages),
 		.mode		= 0644,
 		.proc_handler	= &hugetlb_overcommit_handler,
 	},
diff -puN mm/hugetlb.c~hugetlb-fix-overcommit-locking mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-overcommit-locking
+++ a/mm/hugetlb.c
@@ -24,14 +24,15 @@
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static unsigned long nr_huge_pages, free_huge_pages, resv_huge_pages;
 static unsigned long surplus_huge_pages;
+static unsigned long nr_overcommit_huge_pages;
 unsigned long max_huge_pages;
+unsigned long sysctl_overcommit_huge_pages;
 static struct list_head hugepage_freelists[MAX_NUMNODES];
 static unsigned int nr_huge_pages_node[MAX_NUMNODES];
 static unsigned int free_huge_pages_node[MAX_NUMNODES];
 static unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
-unsigned long nr_overcommit_huge_pages;
 static int hugetlb_next_nid;
 
 /*
@@ -609,8 +610,9 @@ int hugetlb_overcommit_handler(struct ct
 			struct file *file, void __user *buffer,
 			size_t *length, loff_t *ppos)
 {
-	spin_lock(&hugetlb_lock);
 	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+	spin_lock(&hugetlb_lock);
+	nr_overcommit_huge_pages = sysctl_overcommit_huge_pages;
 	spin_unlock(&hugetlb_lock);
 	return 0;
 }
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
