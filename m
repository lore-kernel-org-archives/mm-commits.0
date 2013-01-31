From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-on-parisc-architecture.patch added to -mm tree
Date: Thu, 31 Jan 2013 13:55:33 -0800
Message-ID: <20130131215534.412A431C1BB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40431 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3AaVzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 16:55:35 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so357865yen.0
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 13:55:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, deller@gmx.de, jejb@parisc-linux.org, riel@redhat.com


The patch titled
     Subject: mm: use vm_unmapped_area() on parisc architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-on-parisc-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on parisc architecture

Update the parisc arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/sys_parisc.c |   46 +++++++++++-------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff -puN arch/parisc/kernel/sys_parisc.c~mm-use-vm_unmapped_area-on-parisc-architecture arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~mm-use-vm_unmapped_area-on-parisc-architecture
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -35,18 +35,15 @@
 
 static unsigned long get_unshared_area(unsigned long addr, unsigned long len)
 {
-	struct vm_area_struct *vma;
+	struct vm_unmapped_area_info info;
 
-	addr = PAGE_ALIGN(addr);
-
-	for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr)
-			return -ENOMEM;
-		if (!vma || addr + len <= vma->vm_start)
-			return addr;
-		addr = vma->vm_end;
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = PAGE_ALIGN(addr);
+	info.high_limit = TASK_SIZE;
+	info.align_mask = 0;
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 #define DCACHE_ALIGN(addr) (((addr) + (SHMLBA - 1)) &~ (SHMLBA - 1))
@@ -63,30 +60,21 @@ static unsigned long get_unshared_area(u
  */
 static int get_offset(struct address_space *mapping)
 {
-	int offset = (unsigned long) mapping << (PAGE_SHIFT - 8);
-	return offset & 0x3FF000;
+	return (unsigned long) mapping >> 8;
 }
 
 static unsigned long get_shared_area(struct address_space *mapping,
 		unsigned long addr, unsigned long len, unsigned long pgoff)
 {
-	struct vm_area_struct *vma;
-	int offset = mapping ? get_offset(mapping) : 0;
-
-	offset = (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
+	struct vm_unmapped_area_info info;
 
-	addr = DCACHE_ALIGN(addr - offset) + offset;
-
-	for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr)
-			return -ENOMEM;
-		if (!vma || addr + len <= vma->vm_start)
-			return addr;
-		addr = DCACHE_ALIGN(vma->vm_end - offset) + offset;
-		if (addr < vma->vm_end) /* handle wraparound */
-			return -ENOMEM;
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = PAGE_ALIGN(addr);
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & (SHMLBA - 1);
+	info.align_offset = (get_offset(mapping) + pgoff) << PAGE_SHIFT;
+	return vm_unmapped_area(&info);
 }
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
_

Patches currently in -mm which might be from walken@google.com are

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

