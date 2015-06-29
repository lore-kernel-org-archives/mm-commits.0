From: akpm@linux-foundation.org
Subject: [merged] s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:46 -0700
Message-ID: <5591ad12.9HHREbiqlai9sXOm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbbF2Ujq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: forward check for huge pmds to pmd_large()
has been removed from the -mm tree.  Its filename was
     s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/mm: forward check for huge pmds to pmd_large()

We already do the check in pmd_large, so we can just forward the call.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/hugetlbpage.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/s390/mm/hugetlbpage.c~s390-mm-forward-check-for-huge-pmds-to-pmd_large arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~s390-mm-forward-check-for-huge-pmds-to-pmd_large
+++ a/arch/s390/mm/hugetlbpage.c
@@ -141,10 +141,7 @@ pte_t *huge_pte_offset(struct mm_struct
 
 int pmd_huge(pmd_t pmd)
 {
-	if (!MACHINE_HAS_HPAGE)
-		return 0;
