From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch added to -mm tree
Date: Tue, 26 Jan 2016 16:06:27 -0800
Message-ID: <56a80a03.LnqVGwIKzHJTha2P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbcA0AG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 19:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liangchen.linux@gmail.com, gavin.guo@canonical.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sj38.park@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: skip VM_HUGETLB and VM_MIXEDMAP VMA for lazy mbind
has been added to the -mm tree.  Its filename is
     mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/mempolicy.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind
+++ a/mm/mempolicy.c
@@ -644,8 +644,9 @@ static int queue_pages_test_walk(unsigne
 
 	if (flags & MPOL_MF_LAZY) {
 		/* Similar to task_numa_work, skip inaccessible VMAs */
-		if (vma_migratable(vma) &&
-			vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
+		if (vma_migratable(vma) && !is_vm_hugetlb_page(vma) &&
+			(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)) &&
+			!(vma->vm_flags & VM_MIXEDMAP))
 			change_prot_numa(vma, start, endvma);
 		return 1;
 	}
_

Patches currently in -mm which might be from liangchen.linux@gmail.com are

mm-mempolicy-skip-vm_hugetlb-and-vm_mixedmap-vma-for-lazy-mbind.patch

