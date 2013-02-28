From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-on-parisc-architecture.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:26 -0800
Message-ID: <20130228201027.0640F5A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:47235 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3B1UK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:28 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so260889qah.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, deller@gmx.de, jejb@parisc-linux.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() on parisc architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-parisc-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on parisc architecture

Update the parisc arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

[akpm@linux-foundation.org: remove now-unused DCACHE_ALIGN(), per James]
Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Acked-by: Helge Deller <deller@gmx.de>
Tested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/sys_parisc.c |   48 ++++++++++--------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff -puN arch/parisc/kernel/sys_parisc.c~mm-use-vm_unmapped_area-on-parisc-architecture arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~mm-use-vm_unmapped_area-on-parisc-architecture
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -35,22 +35,17 @@
 
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
 
-#define DCACHE_ALIGN(addr) (((addr) + (SHMLBA - 1)) &~ (SHMLBA - 1))
-
 /*
  * We need to know the offset to use.  Old scheme was to look for
  * existing mapping and use the same offset.  New scheme is to use the
@@ -63,30 +58,21 @@ static unsigned long get_unshared_area(u
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
+	struct vm_unmapped_area_info info;
 
-	offset = (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
-
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

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mutex-subsystem-synchro-test-module.patch

