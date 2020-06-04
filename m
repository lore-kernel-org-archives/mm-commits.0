From: akpm@linux-foundation.org
Subject: [merged] arm64-mm-drop-__have_arch_huge_ptep_get.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:19:29 -0700
Message-ID: <20200604171929.xk_d9Vjrs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: arm64/mm: drop __HAVE_ARCH_HUGE_PTEP_GET
has been removed from the -mm tree.  Its filename was
     arm64-mm-drop-__have_arch_huge_ptep_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
