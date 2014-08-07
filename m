From: akpm@linux-foundation.org
Subject: [merged] mm-softdirty-respect-vm_softdirty-in-pte-holes.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:33 -0700
Message-ID: <53e3dc49.F6/bWVGKjsqJD22E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:57719 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaHGUGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:34 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so844056obc.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: softdirty: respect VM_SOFTDIRTY in PTE holes
has been removed from the -mm tree.  Its filename was
     mm-softdirty-respect-vm_softdirty-in-pte-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm: softdirty: respect VM_SOFTDIRTY in PTE holes

After a VMA is created with the VM_SOFTDIRTY flag set, /proc/pid/pagemap
should report that the VMA's virtual pages are soft-dirty until
VM_SOFTDIRTY is cleared (i.e., by the next write of "4" to
/proc/pid/clear_refs).  However, pagemap ignores the VM_SOFTDIRTY flag for
virtual addresses that fall in PTE holes (i.e., virtual addresses that
don't have a PMD, PUD, or PGD allocated yet).

To observe this bug, use mmap to create a VMA large enough such that
there's a good chance that the VMA will occupy an unused PMD, then test
the soft-dirty bit on its pages.  In practice, I found that a VMA that
covered a PMD's worth of address space was big enough.

This patch adds the necessary VMA lookup to the PTE hole callback in
/proc/pid/pagemap's page walk and sets soft-dirty according to the VMAs'
VM_SOFTDIRTY flag.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-respect-vm_softdirty-in-pte-holes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-respect-vm_softdirty-in-pte-holes
+++ a/fs/proc/task_mmu.c
@@ -925,15 +925,30 @@ static int pagemap_pte_hole(unsigned lon
 				struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
-	unsigned long addr;
+	unsigned long addr = start;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		err = add_to_pagemap(addr, &pme, pm);
-		if (err)
-			break;
+	while (addr < end) {
+		struct vm_area_struct *vma = find_vma(walk->mm, addr);
+		pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+		unsigned long vm_end;
+
+		if (!vma) {
+			vm_end = end;
+		} else {
+			vm_end = min(end, vma->vm_end);
+			if (vma->vm_flags & VM_SOFTDIRTY)
+				pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
+		}
+
+		for (; addr < vm_end; addr += PAGE_SIZE) {
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				goto out;
+		}
 	}
+
+out:
 	return err;
 }
 
_

Patches currently in -mm which might be from pfeiner@google.com are

origin.patch

