From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-use-offset_in_page-macro.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:40 -0800
Message-ID: <563d088c.BT4mRYaVsg3HLxHP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966315AbbKFUHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     mm-nommu-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/nommu: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~mm-nommu-use-offset_in_page-macro mm/nommu.c
--- a/mm/nommu.c~mm-nommu-use-offset_in_page-macro
+++ a/mm/nommu.c
@@ -1497,7 +1497,7 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	if (a.offset & ~PAGE_MASK)
+	if (offset_in_page(a.offset))
 		return -EINVAL;
 
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
@@ -1653,9 +1653,9 @@ int do_munmap(struct mm_struct *mm, unsi
 			goto erase_whole_vma;
 		if (start < vma->vm_start || end > vma->vm_end)
 			return -EINVAL;
-		if (start & ~PAGE_MASK)
+		if (offset_in_page(start))
 			return -EINVAL;
-		if (end != vma->vm_end && end & ~PAGE_MASK)
+		if (end != vma->vm_end && offset_in_page(end))
 			return -EINVAL;
 		if (start != vma->vm_start && end != vma->vm_end) {
 			ret = split_vma(mm, vma, start, 1);
@@ -1736,7 +1736,7 @@ static unsigned long do_mremap(unsigned
 	if (old_len == 0 || new_len == 0)
 		return (unsigned long) -EINVAL;
 
-	if (addr & ~PAGE_MASK)
+	if (offset_in_page(addr))
 		return -EINVAL;
 
 	if (flags & MREMAP_FIXED && new_addr != addr)
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

