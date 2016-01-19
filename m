From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:13 -0800
Message-ID: <569e9915.3+Xk3C96lP8AgMxx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liangchen.linux@gmail.com, andi@firstfloor.org, gavin.guo@canonical.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: skip non-migratable VMAs when setting MPOL_MF_LAZY
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liang Chen <liangchen.linux@gmail.com>
Subject: mm: mempolicy: skip non-migratable VMAs when setting MPOL_MF_LAZY

MPOL_MF_LAZY is not visible from userspace since a720094ded8c ("mm:
mempolicy: Hide MPOL_NOOP and MPOL_MF_LAZY from userspace for now"), but
it should still skip non-migratable VMAs such as VM_IO, VM_PFNMAP, and
VM_HUGETLB VMAs, and avoid useless overhead of minor faults.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy
+++ a/mm/mempolicy.c
@@ -644,7 +644,8 @@ static int queue_pages_test_walk(unsigne
 
 	if (flags & MPOL_MF_LAZY) {
 		/* Similar to task_numa_work, skip inaccessible VMAs */
-		if (vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
+		if (vma_migratable(vma) &&
+			vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
 			change_prot_numa(vma, start, endvma);
 		return 1;
 	}
_

Patches currently in -mm which might be from liangchen.linux@gmail.com are


