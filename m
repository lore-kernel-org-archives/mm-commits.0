From: akpm@linux-foundation.org
Subject: - hugetlb-add-locking-for-overcommit-sysctl.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:23 -0800
Message-ID: <200802082011.m18KB4gW010093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758189AbYBHVD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, stable@kernel.org, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: add locking for overcommit sysctl
has been removed from the -mm tree.  Its filename was
     hugetlb-add-locking-for-overcommit-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add locking for overcommit sysctl
From: Nishanth Aravamudan <nacc@us.ibm.com>

When I replaced hugetlb_dynamic_pool with nr_overcommit_hugepages I used
proc_doulongvec_minmax() directly.  However, hugetlb.c's locking rules
require that all counter modifications occur under the hugetlb_lock.  Add a
callback into the hugetlb code similar to the one for nr_hugepages.  Grab
the lock around the manipulation of nr_overcommit_hugepages in
proc_doulongvec_minmax().

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 kernel/sysctl.c         |    2 +-
 mm/hugetlb.c            |   10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlb-add-locking-for-overcommit-sysctl include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-locking-for-overcommit-sysctl
+++ a/include/linux/hugetlb.h
@@ -17,6 +17,7 @@ static inline int is_vm_hugetlb_page(str
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
+int hugetlb_overcommit_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
diff -puN kernel/sysctl.c~hugetlb-add-locking-for-overcommit-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~hugetlb-add-locking-for-overcommit-sysctl
+++ a/kernel/sysctl.c
@@ -982,7 +982,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &nr_overcommit_huge_pages,
 		.maxlen		= sizeof(nr_overcommit_huge_pages),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &hugetlb_overcommit_handler,
 	},
 #endif
 	{
diff -puN mm/hugetlb.c~hugetlb-add-locking-for-overcommit-sysctl mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-locking-for-overcommit-sysctl
+++ a/mm/hugetlb.c
@@ -605,6 +605,16 @@ int hugetlb_treat_movable_handler(struct
 	return 0;
 }
 
+int hugetlb_overcommit_handler(struct ctl_table *table, int write,
+			struct file *file, void __user *buffer,
+			size_t *length, loff_t *ppos)
+{
+	spin_lock(&hugetlb_lock);
+	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+	spin_unlock(&hugetlb_lock);
+	return 0;
+}
+
 #endif /* CONFIG_SYSCTL */
 
 int hugetlb_report_meminfo(char *buf)
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
