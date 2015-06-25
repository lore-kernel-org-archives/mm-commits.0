From: akpm@linux-foundation.org
Subject: + s390-mm-change-hpage_shift-type-to-int.patch added to -mm tree
Date: Thu, 25 Jun 2015 12:16:26 -0700
Message-ID: <558c538a.pNFJbH7NOuWs+aQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbFYTQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 15:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, akpm@linux-foundation.org, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: change HPAGE_SHIFT type to int
has been added to the -mm tree.  Its filename is
     s390-mm-change-hpage_shift-type-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-mm-change-hpage_shift-type-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-mm-change-hpage_shift-type-to-int.patch

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
s390-mm-make-hugepages_supported-a-boot-time-decision.patch
mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage.patch
mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers.patch
s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages.patch
s390-mm-forward-check-for-huge-pmds-to-pmd_large.patch
s390-mm-change-hpage_shift-type-to-int.patch

