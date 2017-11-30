From: akpm@linux-foundation.org
Subject: [patch 10/28] mm, hugetlbfs: introduce ->split() to
 vm_operations_struct
Date: Wed, 29 Nov 2017 16:10:28 -0800
Message-ID: <5a1f4c74.6E3QsI7zlpYpXXYc%akpm__1412.62807087532$1512000634$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753344AbdK3AKa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.j.williams@intel.com, jmoyer@redhat.com, stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, hugetlbfs: introduce ->split() to vm_operations_struct

Patch series "device-dax: fix unaligned munmap handling"

When device-dax is operating in huge-page mode we want it to behave like
hugetlbfs and fail attempts to split vmas into unaligned ranges.  It would
be messy to teach the munmap path about device-dax alignment constraints
in the same (hstate) way that hugetlbfs communicates this constraint. 
Instead, these patches introduce a new ->split() vm operation.


This patch (of 2):

The device-dax interface has similar constraints as hugetlbfs in that it
requires the munmap path to unmap in huge page aligned units.  Rather than
add more custom vma handling code in __split_vma() introduce a new vm
operation to perform this vma specific check.

Link: http://lkml.kernel.org/r/151130418135.4029.6783191281930729710.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/hugetlb.c       |    8 ++++++++
 mm/mmap.c          |    8 +++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-hugetlbfs-introduce-split-to-vm_operations_struct include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlbfs-introduce-split-to-vm_operations_struct
+++ a/include/linux/mm.h
@@ -377,6 +377,7 @@ enum page_entry_size {
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
+	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_fault *vmf);
 	int (*huge_fault)(struct vm_fault *vmf, enum page_entry_size pe_size);
diff -puN mm/hugetlb.c~mm-hugetlbfs-introduce-split-to-vm_operations_struct mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-introduce-split-to-vm_operations_struct
+++ a/mm/hugetlb.c
@@ -3125,6 +3125,13 @@ static void hugetlb_vm_op_close(struct v
 	}
 }
 
+static int hugetlb_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	if (addr & ~(huge_page_mask(hstate_vma(vma))))
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * We cannot handle pagefaults against hugetlb pages at all.  They cause
  * handle_mm_fault() to try to instantiate regular-sized pages in the
@@ -3141,6 +3148,7 @@ const struct vm_operations_struct hugetl
 	.fault = hugetlb_vm_op_fault,
 	.open = hugetlb_vm_op_open,
 	.close = hugetlb_vm_op_close,
+	.split = hugetlb_vm_op_split,
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
diff -puN mm/mmap.c~mm-hugetlbfs-introduce-split-to-vm_operations_struct mm/mmap.c
--- a/mm/mmap.c~mm-hugetlbfs-introduce-split-to-vm_operations_struct
+++ a/mm/mmap.c
@@ -2555,9 +2555,11 @@ int __split_vma(struct mm_struct *mm, st
 	struct vm_area_struct *new;
 	int err;
 
-	if (is_vm_hugetlb_page(vma) && (addr &
-					~(huge_page_mask(hstate_vma(vma)))))
-		return -EINVAL;
+	if (vma->vm_ops && vma->vm_ops->split) {
+		err = vma->vm_ops->split(vma, addr);
+		if (err)
+			return err;
+	}
 
 	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!new)
_
