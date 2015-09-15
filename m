From: akpm@linux-foundation.org
Subject: + mm-mmap-use-offset_in_page-macro.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:22:51 -0700
Message-ID: <55f89a3b.G4VY62sQ4QwcD52z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbIOWWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:22:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     mm-mmap-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1304,7 +1304,7 @@ unsigned long do_mmap(struct file *file,
 	 * that it represents a valid section of the address space.
 	 */
 	addr = get_unmapped_area(file, addr, len, pgoff, flags);
-	if (addr & ~PAGE_MASK)
+	if (offset_in_page(addr))
 		return addr;
 
 	/* Do simple checking here so the lower-level routines won't have
@@ -1475,7 +1475,7 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	if (a.offset & ~PAGE_MASK)
+	if (offset_in_page(a.offset))
 		return -EINVAL;
 
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
@@ -1996,7 +1996,7 @@ arch_get_unmapped_area_topdown(struct fi
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	if (addr & ~PAGE_MASK) {
+	if (offset_in_page(addr)) {
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
@@ -2032,7 +2032,7 @@ get_unmapped_area(struct file *file, uns
 
 	if (addr > TASK_SIZE - len)
 		return -ENOMEM;
-	if (addr & ~PAGE_MASK)
+	if (offset_in_page(addr))
 		return -EINVAL;
 
 	addr = arch_rebalance_pgtables(addr, len);
@@ -2542,7 +2542,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
 
-	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
+	if ((offset_in_page(start)) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
 
 	len = PAGE_ALIGN(len);
@@ -2740,7 +2740,7 @@ static unsigned long do_brk(unsigned lon
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
-	if (error & ~PAGE_MASK)
+	if (offset_in_page(error))
 		return error;
 
 	error = mlock_future_check(mm, mm->def_flags, len);
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

