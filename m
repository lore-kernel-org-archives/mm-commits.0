From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-use-offset_in_page-macro.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:07:54 -0800
Message-ID: <563d089a.alBV4/wKcNnU/K11%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033628AbbKFUHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/mmap: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmap-use-offset_in_page-macro mm/mmap.c
--- a/mm/mmap.c~mm-mmap-use-offset_in_page-macro
+++ a/mm/mmap.c
@@ -1302,7 +1302,7 @@ unsigned long do_mmap(struct file *file,
 	 * that it represents a valid section of the address space.
 	 */
 	addr = get_unmapped_area(file, addr, len, pgoff, flags);
-	if (addr & ~PAGE_MASK)
+	if (offset_in_page(addr))
 		return addr;
 
 	/* Do simple checking here so the lower-level routines won't have
@@ -1473,7 +1473,7 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	if (a.offset & ~PAGE_MASK)
+	if (offset_in_page(a.offset))
 		return -EINVAL;
 
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
@@ -1989,7 +1989,7 @@ arch_get_unmapped_area_topdown(struct fi
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	if (addr & ~PAGE_MASK) {
+	if (offset_in_page(addr)) {
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
@@ -2025,7 +2025,7 @@ get_unmapped_area(struct file *file, uns
 
 	if (addr > TASK_SIZE - len)
 		return -ENOMEM;
-	if (addr & ~PAGE_MASK)
+	if (offset_in_page(addr))
 		return -EINVAL;
 
 	addr = arch_rebalance_pgtables(addr, len);
@@ -2535,7 +2535,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
 
-	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
+	if ((offset_in_page(start)) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
 
 	len = PAGE_ALIGN(len);
@@ -2733,7 +2733,7 @@ static unsigned long do_brk(unsigned lon
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
-	if (error & ~PAGE_MASK)
+	if (offset_in_page(error))
 		return error;
 
 	error = mlock_future_check(mm, mm->def_flags, len);
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

