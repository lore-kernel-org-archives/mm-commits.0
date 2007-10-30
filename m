From: akpm@linux-foundation.org
Subject: + hugetlb-allow-bulk-updating-in-hugetlb__quota.patch added to -mm tree
Date: Tue, 30 Oct 2007 16:22:56 -0700
Message-ID: <200710302322.l9UNMutW000814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbXJ3XXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 19:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com


The patch titled
     hugetlb: allow bulk updating in hugetlb_*_quota()
has been added to the -mm tree.  Its filename is
     hugetlb-allow-bulk-updating-in-hugetlb__quota.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: allow bulk updating in hugetlb_*_quota()
From: Adam Litke <agl@us.ibm.com>

Add a second parameter 'delta' to hugetlb_get_quota and hugetlb_put_quota to
allow bulk updating of the sbinfo->free_blocks counter.  This will be used by
the next patch in the series.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   10 +++++-----
 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-allow-bulk-updating-in-hugetlb__quota fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-allow-bulk-updating-in-hugetlb__quota
+++ a/fs/hugetlbfs/inode.c
@@ -858,15 +858,15 @@ out_free:
 	return -ENOMEM;
 }
 
-int hugetlb_get_quota(struct address_space *mapping)
+int hugetlb_get_quota(struct address_space *mapping, long delta)
 {
 	int ret = 0;
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
 
 	if (sbinfo->free_blocks > -1) {
 		spin_lock(&sbinfo->stat_lock);
-		if (sbinfo->free_blocks > 0)
-			sbinfo->free_blocks--;
+		if (sbinfo->free_blocks - delta >= 0)
+			sbinfo->free_blocks -= delta;
 		else
 			ret = -ENOMEM;
 		spin_unlock(&sbinfo->stat_lock);
@@ -875,13 +875,13 @@ int hugetlb_get_quota(struct address_spa
 	return ret;
 }
 
-void hugetlb_put_quota(struct address_space *mapping)
+void hugetlb_put_quota(struct address_space *mapping, long delta)
 {
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
 
 	if (sbinfo->free_blocks > -1) {
 		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks++;
+		sbinfo->free_blocks += delta;
 		spin_unlock(&sbinfo->stat_lock);
 	}
 }
diff -puN include/linux/hugetlb.h~hugetlb-allow-bulk-updating-in-hugetlb__quota include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-allow-bulk-updating-in-hugetlb__quota
+++ a/include/linux/hugetlb.h
@@ -165,8 +165,8 @@ static inline struct hugetlbfs_sb_info *
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t);
-int hugetlb_get_quota(struct address_space *mapping);
-void hugetlb_put_quota(struct address_space *mapping);
+int hugetlb_get_quota(struct address_space *mapping, long delta);
+void hugetlb_put_quota(struct address_space *mapping, long delta);
 
 static inline int is_file_hugepages(struct file *file)
 {
diff -puN mm/hugetlb.c~hugetlb-allow-bulk-updating-in-hugetlb__quota mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-allow-bulk-updating-in-hugetlb__quota
+++ a/mm/hugetlb.c
@@ -132,7 +132,7 @@ static void free_huge_page(struct page *
 	}
 	spin_unlock(&hugetlb_lock);
 	if (mapping)
-		hugetlb_put_quota(mapping);
+		hugetlb_put_quota(mapping, 1);
 	set_page_private(page, 0);
 }
 
@@ -390,7 +390,7 @@ static struct page *alloc_huge_page(stru
 	struct page *page;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 
-	if (hugetlb_get_quota(mapping))
+	if (hugetlb_get_quota(mapping, 1))
 		return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	if (vma->vm_flags & VM_MAYSHARE)
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
