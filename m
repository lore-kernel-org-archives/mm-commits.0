From: akpm@linux-foundation.org
Subject: [merged] hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:30:07 -0800
Message-ID: <20121214233008.46EF2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38007 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab2LNXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:30:10 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so208473fae.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:30:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison, hugetlbfs: fix "bad pmd" warning in unmapping hwpoisoned hugepage
has been removed from the -mm tree.  Its filename was
     hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hwpoison, hugetlbfs: fix "bad pmd" warning in unmapping hwpoisoned hugepage

When a process which used a hwpoisoned hugepage tries to exit() or
munmap(), the kernel can print out "bad pmd" message because page table
walker in free_pgtables() encounters 'hwpoisoned entry' on pmd.

This is because currently we fail to clear the hwpoisoned entry in
__unmap_hugepage_range(), so this patch simply does it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage
+++ a/mm/hugetlb.c
@@ -2386,8 +2386,10 @@ again:
 		/*
 		 * HWPoisoned hugepage is already unmapped and dropped reference
 		 */
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+			pte_clear(mm, address, ptep);
 			continue;
+		}
 
 		page = pte_page(pte);
 		/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-print-out-information-of-file-affected-by-memory-error.patch

