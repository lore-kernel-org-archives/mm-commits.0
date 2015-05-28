From: akpm@linux-foundation.org
Subject: + s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch added to -mm tree
Date: Thu, 28 May 2015 13:35:11 -0700
Message-ID: <55677bff.bT+oHf8InW/C8WS+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbbE1UfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 16:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: forward check for huge pmds to pmd_large()
has been added to the -mm tree.  Its filename is
     s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/mm: forward check for huge pmds to pmd_large()

We already do the check in pmd_large, so we can just forward the call.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
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
