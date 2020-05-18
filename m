From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 hugetlbfs-get-unmapped-area-below-task_unmapped_base-for-hugetlbfs.patch
 added to -mm tree
Date: Mon, 18 May 2020 13:32:09 -0700
Message-ID: <20200518203209.ue1QJo7SX%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgERUcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:32:11 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cg.chen@huawei.com, chenjie6@huawei.com, hushijie3@huawei.com, lkp@intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, nixiaoming@huawei.com, wangkefeng.wang@huawei.com, will@kernel.org, yangerkun@huawei.com


The patch titled
     Subject: hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for hugetlbfs
has been added to the -mm tree.  Its filename is
     hugetlbfs-get-unmapped-area-below-task_unmapped_base-for-hugetlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-get-unmapped-area-below-task_unmapped_base-for-hugetlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-get-unmapped-area-below-task_unmapped_base-for-hugetlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shijie Hu <hushijie3@huawei.com>
Subject: hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for hugetlbfs

In a 32-bit program, running on arm64 architecture.  When the address
space below mmap base is completely exhausted, shmat() for huge pages will
return ENOMEM, but shmat() for normal pages can still success on no-legacy
mode.  This seems not fair.

For normal pages, the calling trace of get_unmapped_area() is:

	=> mm->get_unmapped_area()
	if on legacy mode,
		=> arch_get_unmapped_area()
			=> vm_unmapped_area()
	if on no-legacy mode,
		=> arch_get_unmapped_area_topdown()
			=> vm_unmapped_area()

For huge pages, the calling trace of get_unmapped_area() is:

	=> file->f_op->get_unmapped_area()
		=> hugetlb_get_unmapped_area()
			=> vm_unmapped_area()

To solve this issue, we only need to make hugetlb_get_unmapped_area() take
the same way as mm->get_unmapped_area().  Add *bottomup() and *topdown()
for hugetlbfs, and check current mm->get_unmapped_area() to decide which
one to use.  If mm->get_unmapped_area is equal to
arch_get_unmapped_area_topdown(), hugetlb_get_unmapped_area() calls
topdown routine, otherwise calls bottomup routine.

Link: http://lkml.kernel.org/r/20200518065338.113664-1-hushijie3@huawei.com
Signed-off-by: Shijie Hu <hushijie3@huawei.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: yangerkun <yangerkun@huawei.com>
Cc: ChenGang <cg.chen@huawei.com>
Cc: Chen Jie <chenjie6@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   67 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 8 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-get-unmapped-area-below-task_unmapped_base-for-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -38,6 +38,7 @@
 #include <linux/uio.h>
 
 #include <linux/uaccess.h>
+#include <linux/sched/mm.h>
 
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
@@ -191,13 +192,60 @@ out:
 
 #ifndef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 static unsigned long
+hugetlb_get_unmapped_area_bottomup(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
+
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = current->mm->mmap_base;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
+}
+
+static unsigned long
+hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
+
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit = current->mm->mmap_base;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	addr = vm_unmapped_area(&info);
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	if (unlikely(offset_in_page(addr))) {
+		VM_BUG_ON(addr != -ENOMEM);
+		info.flags = 0;
+		info.low_limit = current->mm->mmap_base;
+		info.high_limit = TASK_SIZE;
+		addr = vm_unmapped_area(&info);
+	}
+
+	return addr;
+}
+
+static unsigned long
 hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -218,13 +266,16 @@ hugetlb_get_unmapped_area(struct file *f
 			return addr;
 	}
 
-	info.flags = 0;
-	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
-	info.high_limit = TASK_SIZE;
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
-	return vm_unmapped_area(&info);
+	/*
+	 * Use mm->get_unmapped_area value as a hint to use topdown routine.
+	 * If architectures have special needs, they should define their own
+	 * version of hugetlb_get_unmapped_area.
+	 */
+	if (mm->get_unmapped_area == arch_get_unmapped_area_topdown)
+		return hugetlb_get_unmapped_area_topdown(file, addr, len,
+				pgoff, flags);
+	return hugetlb_get_unmapped_area_bottomup(file, addr, len,
+			pgoff, flags);
 }
 #endif
 
_

Patches currently in -mm which might be from hushijie3@huawei.com are

hugetlbfs-get-unmapped-area-below-task_unmapped_base-for-hugetlbfs.patch
