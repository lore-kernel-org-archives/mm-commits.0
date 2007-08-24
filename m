From: akpm@linux-foundation.org
Subject: - fix-vm_fault-flags-conversion-for-hugetlb.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:40 -0700
Message-ID: <200708242056.l7OKueMG014084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763835AbXHXVIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     Fix VM_FAULT flags conversion for hugetlb
has been removed from the -mm tree.  Its filename was
     fix-vm_fault-flags-conversion-for-hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
