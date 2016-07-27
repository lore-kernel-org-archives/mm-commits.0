From: akpm@linux-foundation.org
Subject: [merged] thp-handle-file-cow-faults.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:02:28 -0700
Message-ID: <57990544.TCaihkioIoDgJw7j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbcG0TC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: handle file COW faults
has been removed from the -mm tree.  Its filename was
     thp-handle-file-cow-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: handle file COW faults

File COW for THP is handled on pte level: just split the pmd.

It's not clear how benefitial would be allocation of huge pages on COW
faults. And it would require some code to make them work.

I think at some point we can consider teaching khugepaged to collapse
pages in COW mappings, but allocating huge on fault is probably
overkill.

Link: http://lkml.kernel.org/r/1466021202-61880-16-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/memory.c~thp-handle-file-cow-faults mm/memory.c
--- a/mm/memory.c~thp-handle-file-cow-faults
+++ a/mm/memory.c
@@ -3446,6 +3446,11 @@ static int wp_huge_pmd(struct fault_env
 	if (fe->vma->vm_ops->pmd_fault)
 		return fe->vma->vm_ops->pmd_fault(fe->vma, fe->address, fe->pmd,
 				fe->flags);
+
+	/* COW handled on pte level: split pmd */
+	VM_BUG_ON_VMA(fe->vma->vm_flags & VM_SHARED, fe->vma);
+	split_huge_pmd(fe->vma, fe->pmd, fe->address);
+
 	return VM_FAULT_FALLBACK;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


