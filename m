From: akpm@linux-foundation.org
Subject: + hugetlb-follow_hugetlb_page-for-write-access.patch added to -mm tree
Date: Fri, 09 Nov 2007 14:08:43 -0800
Message-ID: <200711092208.lA9M8hcI001740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307AbXKIWJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 17:09:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     hugetlb: follow_hugetlb_page() for write access
has been added to the -mm tree.  Its filename is
     hugetlb-follow_hugetlb_page-for-write-access.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: follow_hugetlb_page() for write access
From: Adam Litke <agl@us.ibm.com>

When calling get_user_pages(), a write flag is passed in by the caller to
indicate if write access is required on the faulted-in pages.  Currently,
follow_hugetlb_page() ignores this flag and always faults pages for
read-only access.  This can cause data corruption because a device driver
that calls get_user_pages() with write set will not expect COW faults to
occur on the returned pages.

This patch passes the write flag down to follow_hugetlb_page() and makes
sure hugetlb_fault() is called with the right write_access parameter.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Reviewed-by: Ken Chen <kenchen@google.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    5 +++--
 mm/memory.c             |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-follow_hugetlb_page-for-write-access include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-follow_hugetlb_page-for-write-access
+++ a/include/linux/hugetlb.h
@@ -19,7 +19,7 @@ static inline int is_vm_hugetlb_page(str
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
-int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int);
+int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
 void unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 void __unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
diff -puN mm/hugetlb.c~hugetlb-follow_hugetlb_page-for-write-access mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-follow_hugetlb_page-for-write-access
+++ a/mm/hugetlb.c
@@ -868,7 +868,8 @@ int hugetlb_fault(struct mm_struct *mm, 
 
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
-			unsigned long *position, int *length, int i)
+			unsigned long *position, int *length, int i,
+			int write)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
@@ -890,7 +891,7 @@ int follow_hugetlb_page(struct mm_struct
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
-			ret = hugetlb_fault(mm, vma, vaddr, 0);
+			ret = hugetlb_fault(mm, vma, vaddr, write);
 			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
diff -puN mm/memory.c~hugetlb-follow_hugetlb_page-for-write-access mm/memory.c
--- a/mm/memory.c~hugetlb-follow_hugetlb_page-for-write-access
+++ a/mm/memory.c
@@ -1036,7 +1036,7 @@ int get_user_pages(struct task_struct *t
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i);
+						&start, &len, i, write);
 			continue;
 		}
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-follow_hugetlb_page-for-write-access.patch
hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
mm-hugetlbc-make-a-function-static.patch
