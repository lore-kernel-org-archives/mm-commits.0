From: akpm@linux-foundation.org
Subject: [folded-dropped] thp-s390-architecture-backend-for-thp-on-s390-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:04:41 -0700
Message-ID: <20121008230442.AEF6B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:41806 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2JHXEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:04:45 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so295119wey.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:04:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, s390: add missing earlyclobber to inline assembly
has been removed from the -mm tree.  Its filename was
     thp-s390-architecture-backend-for-thp-on-s390-fix.patch

This patch was dropped because it was folded into thp-s390-architecture-backend-for-thp-on-s390.patch

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
@@ -1305,7 +1305,8 @@ static inline int pmdp_test_and_clear_yo
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

origin.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch

