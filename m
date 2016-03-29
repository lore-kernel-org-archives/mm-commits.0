From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-convert-an-open-coded-vm_bug_on_vma.patch
 removed from -mm tree
Date: Tue, 29 Mar 2016 13:43:35 -0700
Message-ID: <56fae8f7.OPmMvpknB06+78MW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbcC2Ung (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 16:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert an open-coded VM_BUG_ON_VMA
has been removed from the -mm tree.  Its filename was
     mm-convert-an-open-coded-vm_bug_on_vma.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: convert an open-coded VM_BUG_ON_VMA

Spotted during PUD support review.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/memory.c~mm-convert-an-open-coded-vm_bug_on_vma mm/memory.c
--- a/mm/memory.c~mm-convert-an-open-coded-vm_bug_on_vma
+++ a/mm/memory.c
@@ -1179,15 +1179,7 @@ static inline unsigned long zap_pmd_rang
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-#ifdef CONFIG_DEBUG_VM
-				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
-					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
-						__func__, addr, end,
-						vma->vm_start,
-						vma->vm_end);
-					BUG();
-				}
-#endif
+				VM_BUG_ON_VMA(!rwsem_is_locked(&tlb->mm->mmap_sem), vma);
 				split_huge_pmd(vma, pmd, addr);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
_

Patches currently in -mm which might be from willy@linux.intel.com are


