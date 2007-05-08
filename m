From: akpm@linux-foundation.org
Subject: - uml-only-flush-areas-covered-by-vma.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:40 -0700
Message-ID: <200705080007.l4807ecx009305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967376AbXEHAIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: only flush areas covered by VMA
has been removed from the -mm tree.  Its filename was
     uml-only-flush-areas-covered-by-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: only flush areas covered by VMA
From: Jeff Dike <jdike@addtoit.com>

When doing a full address space flush, only look at areas covered by a VMA.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/tlb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/skas/tlb.c~uml-only-flush-areas-covered-by-vma arch/um/kernel/skas/tlb.c
--- a/arch/um/kernel/skas/tlb.c~uml-only-flush-areas-covered-by-vma
+++ a/arch/um/kernel/skas/tlb.c
@@ -89,8 +89,13 @@ void flush_tlb_mm_skas(struct mm_struct 
 
 void force_flush_all_skas(void)
 {
-	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
-        fix_range(current->mm, 0, end, 1);
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = mm->mmap;
+
+	while(vma != NULL) {
+		fix_range(mm, vma->vm_start, vma->vm_end, 1);
+		vma = vma->vm_next;
+	}
 }
 
 void flush_tlb_page_skas(struct vm_area_struct *vma, unsigned long address)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
