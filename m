From: akpm@linux-foundation.org
Subject: +
 mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one.patch added to -mm tree
Date: Fri, 09 Feb 2018 14:03:29 -0800
Message-ID: <5a7e1ab1.QmI23tp8RO2pUF7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752942AbeBIWDa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 17:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linux.alibaba.com, akpm@linux-foundation.org, gavin.dg@linux.alibaba.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix potential clearing to referenced flag in page_idle_clear_pte_refs_one()
has been added to the -mm tree.  Its filename is
     mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: thp: fix potential clearing to referenced flag in page_idle_clear_pte_refs_one()

For PTE-mapped THP, the compound THP has not been split to normal 4K pages
yet, the whole THP is considered referenced if any one of sub page is
referenced.

When walking PTE-mapped THP by pvmw, all relevant PTEs will be checked to
retrieve referenced bit.  But, the current code just returns the result of
the last PTE.  If the last PTE has not referenced, the referenced flag
will be cleared.

Just set referenced when ptep{pmdp}_clear_young_notify() returns true.

Link: http://lkml.kernel.org/r/1518212451-87134-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/page_idle.c~mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one mm/page_idle.c
--- a/mm/page_idle.c~mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one
+++ a/mm/page_idle.c
@@ -65,11 +65,15 @@ static bool page_idle_clear_pte_refs_one
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			referenced = ptep_clear_young_notify(vma, addr,
-					pvmw.pte);
+			/*
+			 * For PTE-mapped THP, one sub page is referenced,
+			 * the whole THP is referenced.
+			 */
+			if (ptep_clear_young_notify(vma, addr, pvmw.pte))
+				referenced = true;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			referenced = pmdp_clear_young_notify(vma, addr,
-					pvmw.pmd);
+			if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
+				referenced = true;
 		} else {
 			/* unexpected pmd-mapped page? */
 			WARN_ON_ONCE(1);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-thp-fix-potential-clearing-to-referenced-flag-in-page_idle_clear_pte_refs_one.patch

