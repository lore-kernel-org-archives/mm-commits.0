From: akpm@linux-foundation.org
Subject: + hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch added to -mm tree
Date: Thu, 06 Dec 2012 14:40:20 -0800
Message-ID: <20121206224021.A9FE7200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49528 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2LFWkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2012 17:40:24 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so471486fae.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Dec 2012 14:40:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com


The patch titled
     Subject: hwpoison, hugetlbfs: fix "bad pmd" warning in unmapping hwpoisoned hugepage
has been added to the -mm tree.  Its filename is
     hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2387,8 +2387,10 @@ again:
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

hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch
hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch

