From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-on-frv-architecture.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:47 -0800
Message-ID: <20130228201047.A837331C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:38282 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3B1UKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:48 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so244692ggn.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() on frv architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-frv-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on frv architecture

Update the frv arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/elf-fdpic.c |   49 +++++++++++++-------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff -puN arch/frv/mm/elf-fdpic.c~mm-use-vm_unmapped_area-on-frv-architecture arch/frv/mm/elf-fdpic.c
--- a/arch/frv/mm/elf-fdpic.c~mm-use-vm_unmapped_area-on-frv-architecture
+++ a/arch/frv/mm/elf-fdpic.c
@@ -60,7 +60,7 @@ unsigned long arch_get_unmapped_area(str
 				     unsigned long pgoff, unsigned long flags)
 {
 	struct vm_area_struct *vma;
-	unsigned long limit;
+	struct vm_unmapped_area_info info;
 
 	if (len > TASK_SIZE)
 		return -ENOMEM;
@@ -79,39 +79,24 @@ unsigned long arch_get_unmapped_area(str
 	}
 
 	/* search between the bottom of user VM and the stack grow area */
-	addr = PAGE_SIZE;
-	limit = (current->mm->start_stack - 0x00200000);
-	if (addr + len <= limit) {
-		limit -= len;
-
-		if (addr <= limit) {
-			vma = find_vma(current->mm, PAGE_SIZE);
-			for (; vma; vma = vma->vm_next) {
-				if (addr > limit)
-					break;
-				if (addr + len <= vma->vm_start)
-					goto success;
-				addr = vma->vm_end;
-			}
-		}
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = PAGE_SIZE;
+	info.high_limit = (current->mm->start_stack - 0x00200000);
+	info.align_mask = 0;
+	info.align_offset = 0;
+	addr = vm_unmapped_area(&info);
+	if (!(addr & ~PAGE_MASK))
+		goto success;
+	VM_BUG_ON(addr != -ENOMEM);
 
 	/* search from just above the WorkRAM area to the top of memory */
-	addr = PAGE_ALIGN(0x80000000);
-	limit = TASK_SIZE - len;
-	if (addr <= limit) {
-		vma = find_vma(current->mm, addr);
-		for (; vma; vma = vma->vm_next) {
-			if (addr > limit)
-				break;
-			if (addr + len <= vma->vm_start)
-				goto success;
-			addr = vma->vm_end;
-		}
