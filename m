From: akpm@linux-foundation.org
Subject: + mm-convert-an-open-coded-vm_bug_on_vma.patch added to -mm tree
Date: Wed, 27 Jan 2016 12:26:53 -0800
Message-ID: <56a9280d.WxE8XCnOAq8z7upy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602AbcA0U0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, darrick.wong@oracle.com, david@fromorbit.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingming.cao@oracle.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: convert an open-coded VM_BUG_ON_VMA
has been added to the -mm tree.  Its filename is
     mm-convert-an-open-coded-vm_bug_on_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-an-open-coded-vm_bug_on_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-an-open-coded-vm_bug_on_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm/memory.c: convert an open-coded VM_BUG_ON_VMA

We have customer demand to use 1GB pages to map DAX files.  Unlike the 2MB
page support, the Linux MM does not currently support PUD pages, so I have
attempted to add support for the necessary pieces for DAX huge PUD pages.

Filesystems still need work to allocate 1GB pages.  With ext4, I can only
get 16MB of contiguous space, although it is aligned.  With XFS, I can get
80MB less than 1GB, and it's not aligned.  The XFS problem may be due to
the small amount of RAM in my test machine.

I'd like to thank Dave Chinner & Kirill Shutemov for their reviews of v1. 
The conversion of pmd_fault & pud_fault to huge_fault is thanks to Dave's
poking, and Kirill spotted a couple of problems in the MM code.  Version 2
of the patch set is about 200 lines smaller (1016 insertions, 23 deletions
in v1).

I've done some light testing using a program to mmap a block device with
DAX enabled, calling mincore() and examining /proc/smaps and
/proc/pagemap.


This patch (of 8):

Spotted during PUD support review.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mingming cao <mingming.cao@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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

mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch

