From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-drop-__have_arch_huge_ptep_get.patch added to
 -mm tree
Date: Mon, 11 May 2020 13:50:40 -0700
Message-ID: <20200511205040.iUz_-SRaN%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgEKUun (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 16:50:43 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: arm64/mm: drop __HAVE_ARCH_HUGE_PTEP_GET
has been added to the -mm tree.  Its filename is
     arm64-mm-drop-__have_arch_huge_ptep_get.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-drop-__have_arch_huge_ptep_get.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-drop-__have_arch_huge_ptep_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: drop __HAVE_ARCH_HUGE_PTEP_GET

Patch series "mm/hugetlb: Add some new generic fallbacks", v3.

This series adds the following new generic fallbacks.  Before that it
drops __HAVE_ARCH_HUGE_PTEP_GET from arm64 platform.

1. is_hugepage_only_range()
2. arch_clear_hugepage_flags()

After this arm (32 bit) remains the sole platform defining it's own
huge_ptep_get() via __HAVE_ARCH_HUGE_PTEP_GET.


This patch (of 3):

Platform specific huge_ptep_get() is required only when fetching the huge
PTE involves more than just dereferencing the page table pointer.  This is
not the case on arm64 platform.  Hence huge_ptep_pte() can be dropped
along with it's __HAVE_ARCH_HUGE_PTEP_GET subscription.  Before that, it
updates the generic huge_ptep_get() with READ_ONCE() which will prevent
known page table issues with THP on arm64.

Link: http://lkml.kernel.org/r/1588907271-11920-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r//1506527369-19535-1-git-send-email-will.deacon@arm.com/
Link: http://lkml.kernel.org/r/1588907271-11920-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/hugetlb.h |    6 ------
 include/asm-generic/hugetlb.h    |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~arm64-mm-drop-__have_arch_huge_ptep_get
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -17,12 +17,6 @@
 extern bool arch_hugetlb_migration_supported(struct hstate *h);
 #endif
 
-#define __HAVE_ARCH_HUGE_PTEP_GET
-static inline pte_t huge_ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-
 static inline int is_hugepage_only_range(struct mm_struct *mm,
 					 unsigned long addr, unsigned long len)
 {
--- a/include/asm-generic/hugetlb.h~arm64-mm-drop-__have_arch_huge_ptep_get
+++ a/include/asm-generic/hugetlb.h
@@ -122,7 +122,7 @@ static inline int huge_ptep_set_access_f
 #ifndef __HAVE_ARCH_HUGE_PTEP_GET
 static inline pte_t huge_ptep_get(pte_t *ptep)
 {
-	return *ptep;
+	return READ_ONCE(*ptep);
 }
 #endif
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

arm64-mm-drop-__have_arch_huge_ptep_get.patch
mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
