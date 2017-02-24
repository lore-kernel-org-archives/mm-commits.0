From: akpm@linux-foundation.org
Subject: [patch 087/124] mm/gup: check for protnone only if it is a PTE
 entry
Date: Fri, 24 Feb 2017 14:59:53 -0800
Message-ID: <58b0bae9.JItMYKzBqxRFPaFo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdBXW7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, riel@surriel.com

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/gup: check for protnone only if it is a PTE entry

Do the prot_none/FOLL_NUMA check after we are sure this is a THP pte. 
Archs can implement prot_none such that it can return true for regular pmd
entries.

Link: http://lkml.kernel.org/r/1487498326-8734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/gup.c~mm-gup-check-for-protnone-only-if-it-is-a-pte-entry mm/gup.c
--- a/mm/gup.c~mm-gup-check-for-protnone-only-if-it-is-a-pte-entry
+++ a/mm/gup.c
@@ -272,8 +272,6 @@ struct page *follow_page_mask(struct vm_
 			return page;
 		return no_page_table(vma, flags);
 	}
-	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
-		return no_page_table(vma, flags);
 	if (pmd_devmap(*pmd)) {
 		ptl = pmd_lock(mm, pmd);
 		page = follow_devmap_pmd(vma, address, pmd, flags);
@@ -284,6 +282,9 @@ struct page *follow_page_mask(struct vm_
 	if (likely(!pmd_trans_huge(*pmd)))
 		return follow_page_pte(vma, address, pmd, flags);
 
+	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
+		return no_page_table(vma, flags);
+
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
 		spin_unlock(ptl);
_
