From: akpm@linux-foundation.org
Subject: + revert-s390-mm-change-hpage_shift-type-to-int.patch added to
 -mm tree
Date: Mon, 06 Jul 2015 15:35:26 -0700
Message-ID: <559b02ae.Z19N7zrCTtUbEwMj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbGFWf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, borntraeger@de.ibm.com, gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "s390/mm: change HPAGE_SHIFT type to int"
has been added to the -mm tree.  Its filename is
     revert-s390-mm-change-hpage_shift-type-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-s390-mm-change-hpage_shift-type-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-s390-mm-change-hpage_shift-type-to-int.patch

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
Subject: revert "s390/mm: change HPAGE_SHIFT type to int"

Heiko noticed that the current check for hugepage support on s390 is a
little bit to harsh as systems which do not support will crash.  The
reason is that pageblock_order can now get negative when we set
HPAGE_SHIFT to 0.  To avoid all this and to avoid opening another can of
worms with enabling HUGETLB_PAGE_SIZE_VARIABLE I think it would be best to
simply allow architectures to define their own hugepages_supported().


This patch (of 4): revert commit cf54e2fce51c7a ("s390/mm: change
HPAGE_SHIFT type to int") in preparation.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/page.h |    2 +-
 arch/s390/mm/pgtable.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/s390/include/asm/page.h~revert-s390-mm-change-hpage_shift-type-to-int arch/s390/include/asm/page.h
--- a/arch/s390/include/asm/page.h~revert-s390-mm-change-hpage_shift-type-to-int
+++ a/arch/s390/include/asm/page.h
@@ -20,7 +20,7 @@
 #include <asm/setup.h>
 #ifndef __ASSEMBLY__
 
-extern int HPAGE_SHIFT;
+extern unsigned int HPAGE_SHIFT;
 #define HPAGE_SIZE	(1UL << HPAGE_SHIFT)
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
diff -puN arch/s390/mm/pgtable.c~revert-s390-mm-change-hpage_shift-type-to-int arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~revert-s390-mm-change-hpage_shift-type-to-int
+++ a/arch/s390/mm/pgtable.c
@@ -31,7 +31,7 @@
 #define ALLOC_ORDER	2
 #define FRAG_MASK	0x03
 
-int HPAGE_SHIFT;
+unsigned int HPAGE_SHIFT;
 
 unsigned long *crst_table_alloc(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

revert-s390-mm-change-hpage_shift-type-to-int.patch
revert-s390-mm-make-hugepages_supported-a-boot-time-decision.patch
mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch
s390-hugetlb-add-hugepages_supported-define.patch

