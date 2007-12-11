From: akpm@linux-foundation.org
Subject: - hugetlb-handle-write-protection-faults-in-follow_hugetlb_page.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:41:53 -0800
Message-ID: <200712112241.lBBMfr7k012567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbXLKWmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, shaggy@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: handle write-protection faults in follow_hugetlb_page
has been removed from the -mm tree.  Its filename was
     hugetlb-handle-write-protection-faults-in-follow_hugetlb_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: handle write-protection faults in follow_hugetlb_page
From: Adam Litke <agl@us.ibm.com>

The follow_hugetlb_page() fix I posted (merged as git commit
5b23dbe8173c212d6a326e35347b038705603d39) missed one case.  If the pte is
present, but not writable and write access is requested by the caller to
get_user_pages(), the code will do the wrong thing.  Rather than calling
hugetlb_fault to make the pte writable, it notes the presence of the pte
and continues.

This simple one-liner makes sure we also fault on the pte for this case.
Please apply.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Dave Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-handle-write-protection-faults-in-follow_hugetlb_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-handle-write-protection-faults-in-follow_hugetlb_page
+++ a/mm/hugetlb.c
@@ -907,7 +907,7 @@ int follow_hugetlb_page(struct mm_struct
 		 */
 		pte = huge_pte_offset(mm, vaddr & HPAGE_MASK);
 
-		if (!pte || pte_none(*pte)) {
+		if (!pte || pte_none(*pte) || (write && !pte_write(*pte))) {
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
