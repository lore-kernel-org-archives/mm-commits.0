From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memory-replace-vm_no_thp-vm_bug_on-with-actual-vma-check.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:22 -0700
Message-ID: <5723daa2.jiHprid95SfHWqUC%akpm__12481.9481665783$1461967535$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbcD2WFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, aarcange@redhat.com, dvyukov@google.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: replace VM_NO_THP VM_BUG_ON with actual VMA check
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-replace-vm_no_thp-vm_bug_on-with-actual-vma-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm/huge_memory: replace VM_NO_THP VM_BUG_ON with actual VMA check

Khugepaged detects own VMAs by checking vm_file and vm_ops but this
way it cannot distinguish private /dev/zero mappings from other special
mappings like /dev/hpet which has no vm_ops and popultes PTEs in mmap.

This fixes false-positive VM_BUG_ON and prevents installing THP where
they are not expected.

Link: http://lkml.kernel.org/r/CACT4Y+ZmuZMV5CjSFOeXviwQdABAgT7T+StKfTqan9YDtgEi5g@mail.gmail.com
Fixes: 78f11a255749 ("mm: thp: fix /dev/zero MAP_PRIVATE and vm_flags cleanups")
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-replace-vm_no_thp-vm_bug_on-with-actual-vma-check mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-replace-vm_no_thp-vm_bug_on-with-actual-vma-check
+++ a/mm/huge_memory.c
@@ -1960,10 +1960,9 @@ int khugepaged_enter_vma_merge(struct vm
 		 * page fault if needed.
 		 */
 		return 0;
-	if (vma->vm_ops)
+	if (vma->vm_ops || (vm_flags & VM_NO_THP))
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
-	VM_BUG_ON_VMA(vm_flags & VM_NO_THP, vma);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
@@ -2352,8 +2351,7 @@ static bool hugepage_vma_check(struct vm
 		return false;
 	if (is_vma_temporary_stack(vma))
 		return false;
-	VM_BUG_ON_VMA(vma->vm_flags & VM_NO_THP, vma);
-	return true;
+	return !(vma->vm_flags & VM_NO_THP);
 }
 
 static void collapse_huge_page(struct mm_struct *mm,
_

Patches currently in -mm which might be from koct9i@gmail.com are

scripts-decode_stacktracesh-handle-symbols-in-modules.patch
mm-mmap-kill-hook-arch_rebalance_pgtables.patch
mm-enable-rlimit_data-by-default-with-workaround-for-valgrind.patch
arch-defconfig-remove-config_resource_counters.patch

