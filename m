From: akpm@linux-foundation.org
Subject: + thp-s390-architecture-backend-for-thp-on-s390-fix.patch added to -mm tree
Date: Thu, 13 Sep 2012 14:43:43 -0700
Message-ID: <20120913214343.A60B11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56308 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2IMVno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 17:43:44 -0400
Received: by qcqs25 with SMTP id s25so378547qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 14:43:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     Subject: thp, s390: add missing earlyclobber to inline assembly
has been added to the -mm tree.  Its filename is
     thp-s390-architecture-backend-for-thp-on-s390-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp, s390: add missing earlyclobber to inline assembly

The constraints of the rrbm inline assembly are missing two
earlyclobber operands, which can lead to an addressing exception
depending on compiler register allocation decisions.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/s390/include/asm/pgtable.h~thp-s390-architecture-backend-for-thp-on-s390-fix arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~thp-s390-architecture-backend-for-thp-on-s390-fix
+++ a/arch/s390/include/asm/pgtable.h
@@ -1296,7 +1296,8 @@ static inline int pmdp_test_and_clear_yo
 			"	ogr	%1,%0\n"
 			"	la	%3,0(%4,%3)\n"
 			"	brct	%2,0b\n"
-			: "=d" (tmp), "+d" (rc), "+d" (counter), "+a" (pmd_addr)
+			: "=&d" (tmp), "+&d" (rc), "+d" (counter),
+			  "+a" (pmd_addr)
 			: "a" (64 * 4096UL) : "cc");
 		rc = !!rc;
 	} else {
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390-fix.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch

