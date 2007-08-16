From: akpm@linux-foundation.org
Subject: + fix-vm_fault-flags-conversion-for-hugetlb.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:26:19 -0700
Message-ID: <200708162026.l7GKQJXB005168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbXHPU0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, npiggin@suse.de


The patch titled
     Fix VM_FAULT flags conversion for hugetlb
has been added to the -mm tree.  Its filename is
     fix-vm_fault-flags-conversion-for-hugetlb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix VM_FAULT flags conversion for hugetlb
From: Adam Litke <agl@us.ibm.com>

It seems a simple mistake was made when converting follow_hugetlb_page()
over to the VM_FAULT flags bitmask stuff:
	(commit  83c54070ee1a2d05c89793884bea1a03f2851ed4).

By using the wrong bitmask, hugetlb_fault() failures are not being
recognized.  This results in an infinite loop whenever follow_hugetlb_page
is involved in a failed fault.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~fix-vm_fault-flags-conversion-for-hugetlb mm/hugetlb.c
--- a/mm/hugetlb.c~fix-vm_fault-flags-conversion-for-hugetlb
+++ a/mm/hugetlb.c
@@ -643,7 +643,7 @@ int follow_hugetlb_page(struct mm_struct
 			spin_unlock(&mm->page_table_lock);
 			ret = hugetlb_fault(mm, vma, vaddr, 0);
 			spin_lock(&mm->page_table_lock);
-			if (!(ret & VM_FAULT_MAJOR))
+			if (!(ret & VM_FAULT_ERROR))
 				continue;
 
 			remainder = 0;
_

Patches currently in -mm which might be from agl@us.ibm.com are

fix-vm_fault-flags-conversion-for-hugetlb.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
