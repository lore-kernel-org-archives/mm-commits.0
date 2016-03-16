From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:21 -0700
Message-ID: <56e9ba65.c9nsDxmq9hSVtEH3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934945AbcCPT4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liangchen.linux@gmail.com, gavin.guo@canonical.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sj38.park@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: skip VM_HUGETLB and VM_MIXEDMAP VMA for lazy mbind
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liang Chen <liangchen.linux@gmail.com>
Subject: mm/mempolicy.c: skip VM_HUGETLB and VM_MIXEDMAP VMA for lazy mbind

VM_HUGETLB and VM_MIXEDMAP vma needs to be excluded to avoid compound
pages being marked for migration and unexpected COWs when handling hugetlb
fault.

Thanks to Naoya Horiguchi for reminding me on these checks.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind
+++ a/mm/mempolicy.c
@@ -643,7 +643,9 @@ static int queue_pages_test_walk(unsigne
 
 	if (flags & MPOL_MF_LAZY) {
 		/* Similar to task_numa_work, skip inaccessible VMAs */
-		if (vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
+		if (!is_vm_hugetlb_page(vma) &&
+			(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)) &&
+			!(vma->vm_flags & VM_MIXEDMAP))
 			change_prot_numa(vma, start, endvma);
 		return 1;
 	}
_

Patches currently in -mm which might be from liangchen.linux@gmail.com are


