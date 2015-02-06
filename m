From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
 removed from -mm tree
Date: Fri, 06 Feb 2015 14:02:27 -0800
Message-ID: <54d539f3.t3Nwyf/jJwoqQnWq%akpm__119.646176654165$1423260164$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbBFWC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 17:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shashim@codeaurora.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: call pte_hole() for VM_PFNMAP during walk_page_range
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shiraz Hashim <shashim@codeaurora.org>
Subject: mm: pagewalk: call pte_hole() for VM_PFNMAP during walk_page_range

walk_page_range() silently skips vma having VM_PFNMAP set, which leads to
undesirable behaviour at client end (who called walk_page_range). 
Userspace applications get the wrong data, so the effect is like just
confusing users (if the applications just display the data) or sometimes
killing the processes (if the applications do something with
misunderstanding virtual addresses due to the wrong data.)

For example for pagemap_read, when no callbacks are called against
VM_PFNMAP vma, pagemap_read may prepare pagemap data for next virtual
address range at wrong index.

Eventually userspace may get wrong pagemap data for a task.  Corresponding
to a VM_PFNMAP marked vma region, kernel may report mappings from
subsequent vma regions.  User space in turn may account more pages (than
really are) to the task.

In my case I was using procmem, procrack (Android utility) which uses
pagemap interface to account RSS pages of a task.  Due to this bug it was
giving a wrong picture for vmas (with VM_PFNMAP set).

Fixes: a9ff785e4437 ("mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas")
Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/pagewalk.c~mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range
+++ a/mm/pagewalk.c
@@ -199,7 +199,10 @@ int walk_page_range(unsigned long addr,
 			 */
 			if ((vma->vm_start <= addr) &&
 			    (vma->vm_flags & VM_PFNMAP)) {
-				next = vma->vm_end;
+				if (walk->pte_hole)
+					err = walk->pte_hole(addr, next, walk);
+				if (err)
+					break;
 				pgd = pgd_offset(walk->mm, next);
 				continue;
 			}
_

Patches currently in -mm which might be from shashim@codeaurora.org are

origin.patch
mm-pagemap-limit-scan-to-virtual-region-being-asked.patch
mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling.patch

