From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch added to -mm tree
Date: Fri, 08 Jan 2016 16:09:11 -0800
Message-ID: <56904fa7.JTWH43ZvLTw6FYP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbcAIAJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 19:09:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liangchen.linux@gmail.com, andi@firstfloor.org, gavin.guo@canonical.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: skip non-migratable VMAs when setting MPOL_MF_LAZY
has been added to the -mm tree.  Its filename is
     mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch

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
Subject: mm: mempolicy: skip non-migratable VMAs when setting MPOL_MF_LAZY

MPOL_MF_LAZY is not visible from userspace since a720094ded8c ("mm:
mempolicy: Hide MPOL_NOOP and MPOL_MF_LAZY from userspace for now"), but
it should still skip non-migratable VMAs such as VM_IO, VM_PFNMAP, and
VM_HUGETLB VMAs, and avoid useless overhead of minor faults.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
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
@@ -642,7 +642,8 @@ static int queue_pages_test_walk(unsigne
 
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

mm-mempolicy-skip-non-migratable-vmas-when-setting-mpol_mf_lazy.patch

