From: akpm@linux-foundation.org
Subject: - hugetlb-follow_hugetlb_page-for-write-access.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:30 -0800
Message-ID: <200711152109.lAFL9Uf4015457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213AbXKOVSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, ezk@cs.sunysb.edu, hermes@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: follow_hugetlb_page() for write access
has been removed from the -mm tree.  Its filename was
     hugetlb-follow_hugetlb_page-for-write-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[ezk@cs.sunysb.edu: build fix]
Signed-off-by: Adam Litke <agl@us.ibm.com>
Reviewed-by: Ken Chen <kenchen@google.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    5 +++--
 mm/memory.c             |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

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
@@ -106,7 +106,7 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
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

origin.patch
hugetlb-allow-sticky-directory-mount-option.patch
