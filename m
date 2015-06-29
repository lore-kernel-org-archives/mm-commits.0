From: akpm@linux-foundation.org
Subject: [merged] s390-mm-change-hpage_shift-type-to-int.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:39:48 -0700
Message-ID: <5591ad14.WNw3Tlb7xt3cN0Nu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbF2Ujt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, akpm@linux-foundation.org, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: change HPAGE_SHIFT type to int
has been removed from the -mm tree.  Its filename was
     s390-mm-change-hpage_shift-type-to-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/mm: change HPAGE_SHIFT type to int

With making HPAGE_SHIFT an unsigned integer we also accidentally changed
pageblock_order.  In order to avoid compiler warnings we make HPAGE_SHFIT
an int again.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/page.h |    2 +-
 arch/s390/mm/pgtable.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/s390/include/asm/page.h~s390-mm-change-hpage_shift-type-to-int arch/s390/include/asm/page.h
--- a/arch/s390/include/asm/page.h~s390-mm-change-hpage_shift-type-to-int
+++ a/arch/s390/include/asm/page.h
@@ -20,7 +20,7 @@
 #include <asm/setup.h>
 #ifndef __ASSEMBLY__
 
-extern unsigned int HPAGE_SHIFT;
+extern int HPAGE_SHIFT;
 #define HPAGE_SIZE	(1UL << HPAGE_SHIFT)
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
diff -puN arch/s390/mm/pgtable.c~s390-mm-change-hpage_shift-type-to-int arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~s390-mm-change-hpage_shift-type-to-int
+++ a/arch/s390/mm/pgtable.c
@@ -31,7 +31,7 @@
 #define ALLOC_ORDER	2
 #define FRAG_MASK	0x03
 
-unsigned int HPAGE_SHIFT;
+int HPAGE_SHIFT;
 
 unsigned long *crst_table_alloc(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

origin.patch

