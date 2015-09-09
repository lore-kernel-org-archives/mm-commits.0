From: akpm@linux-foundation.org
Subject: [merged] mm-add-a-pmd_fault-handler.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:42:58 -0700
Message-ID: <55f08bc2.IXgJBnegkDNht60N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a pmd_fault handler
has been removed from the -mm tree.  Its filename was
     mm-add-a-pmd_fault-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: add a pmd_fault handler

Allow non-anonymous VMAs to provide huge pages in response to a page fault.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   30 ++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-add-a-pmd_fault-handler include/linux/mm.h
--- a/include/linux/mm.h~mm-add-a-pmd_fault-handler
+++ a/include/linux/mm.h
@@ -249,6 +249,8 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
+	int (*pmd_fault)(struct vm_area_struct *, unsigned long address,
+						pmd_t *, unsigned int flags);
 	void (*map_pages)(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 	/* notification that a previously read-only page is about to become
diff -puN mm/memory.c~mm-add-a-pmd_fault-handler mm/memory.c
--- a/mm/memory.c~mm-add-a-pmd_fault-handler
+++ a/mm/memory.c
@@ -3232,6 +3232,27 @@ out:
 	return 0;
 }
 
+static int create_huge_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pmd_t *pmd, unsigned int flags)
+{
+	if (!vma->vm_ops)
+		return do_huge_pmd_anonymous_page(mm, vma, address, pmd, flags);
+	if (vma->vm_ops->pmd_fault)
+		return vma->vm_ops->pmd_fault(vma, address, pmd, flags);
+	return VM_FAULT_FALLBACK;
+}
+
+static int wp_huge_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pmd_t *pmd, pmd_t orig_pmd,
+			unsigned int flags)
+{
+	if (!vma->vm_ops)
+		return do_huge_pmd_wp_page(mm, vma, address, pmd, orig_pmd);
+	if (vma->vm_ops->pmd_fault)
+		return vma->vm_ops->pmd_fault(vma, address, pmd, flags);
+	return VM_FAULT_FALLBACK;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3334,10 +3355,7 @@ static int __handle_mm_fault(struct mm_s
 	if (!pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
-		int ret = VM_FAULT_FALLBACK;
-		if (!vma->vm_ops)
-			ret = do_huge_pmd_anonymous_page(mm, vma, address,
-					pmd, flags);
+		int ret = create_huge_pmd(mm, vma, address, pmd, flags);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
@@ -3361,8 +3379,8 @@ static int __handle_mm_fault(struct mm_s
 							     orig_pmd, pmd);
 
 			if (dirty && !pmd_write(orig_pmd)) {
-				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
-							  orig_pmd);
+				ret = wp_huge_pmd(mm, vma, address, pmd,
+							orig_pmd, flags);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
_

Patches currently in -mm which might be from willy@linux.intel.com are


