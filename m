From: akpm@linux-foundation.org
Subject: [merged] mm-fix-gup_pud_range.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:17:25 -0800
Message-ID: <20200131231725.68CKzVk4i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXR0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, hqjagain@gmail.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: fix gup_pud_range
has been removed from the -mm tree.  Its filename was
     mm-fix-gup_pud_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: mm: fix gup_pud_range

sorry for not processing for a long time. I met it again.

patch v1   https://lkml.org/lkml/2019/9/20/656

do_machine_check()
  do_memory_failure()
    memory_failure()
      hw_poison_user_mappings()
        try_to_unmap()
          pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));

...and now we have a swap entry that indicates that the page entry
refers to a bad (and poisoned) page of memory, but gup_fast() at this
level of the page table was ignoring swap entries, and incorrectly
assuming that "!pxd_none() == valid and present".

And this was not just a poisoned page problem, but a generaly swap entry
problem. So, any swap entry type (device memory migration, numa migration,
or just regular swapping) could lead to the same problem.

Fix this by checking for pxd_present(), instead of pxd_none().

Link: http://lkml.kernel.org/r/1578479084-15508-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-fix-gup_pud_range
+++ a/mm/gup.c
@@ -2237,7 +2237,7 @@ static int gup_pud_range(p4d_t p4d, unsi
 		pud_t pud = READ_ONCE(*pudp);
 
 		next = pud_addr_end(addr, end);
-		if (pud_none(pud))
+		if (unlikely(!pud_present(pud)))
 			return 0;
 		if (unlikely(pud_huge(pud))) {
 			if (!gup_huge_pud(pud, pudp, addr, next, flags,
_

Patches currently in -mm which might be from hqjagain@gmail.com are
