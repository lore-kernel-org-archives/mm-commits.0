From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch
 removed from -mm tree
Date: Thu, 18 Sep 2014 16:13:02 -0700
Message-ID: <541b66fe.I9ytJUQFgUrrPAN8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaIRXND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 19:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: softdirty: addresses before VMAs in PTE holes aren't softdirty
has been removed from the -mm tree.  Its filename was
     mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm: softdirty: addresses before VMAs in PTE holes aren't softdirty

In PTE holes that contain VM_SOFTDIRTY VMAs, unmapped addresses before
VM_SOFTDIRTY VMAs are reported as softdirty by /proc/pid/pagemap.  This
bug was introduced in 68b5a652485682f67eacdee3deae640fb7845b63.  The
aforementioned patch made /proc/pid/pagemap look at VM_SOFTDIRTY in PTE
holes but neglected to observe the start of VMAs returned by find_vma.

Tested:
  Wrote a selftest that creates a PMD-sized VMA then unmaps the first
  page and asserts that the page is not softdirty. I'm going to send the
  pagemap selftest in a later commit.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jamie Liu <jamieliu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty
+++ a/fs/proc/task_mmu.c
@@ -931,16 +931,26 @@ static int pagemap_pte_hole(unsigned lon
 	while (addr < end) {
 		struct vm_area_struct *vma = find_vma(walk->mm, addr);
 		pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
-		unsigned long vm_end;
+		unsigned long vm_start = end;
+		unsigned long vm_end = end;
+		unsigned long vm_flags = 0;
 
-		if (!vma) {
-			vm_end = end;
-		} else {
+		if (vma) {
+			vm_start = min(end, vma->vm_start);
 			vm_end = min(end, vma->vm_end);
-			if (vma->vm_flags & VM_SOFTDIRTY)
-				pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
+			vm_flags = vma->vm_flags;
 		}
 
+		/* Addresses before the VMA. */
+		for (; addr < vm_start; addr += PAGE_SIZE) {
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				goto out;
+		}
+
+		/* Addresses in the VMA. */
+		if (vm_flags & VM_SOFTDIRTY)
+			pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
 		for (; addr < vm_end; addr += PAGE_SIZE) {
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
_

Patches currently in -mm which might be from pfeiner@google.com are

mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch

