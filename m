From: akpm@linux-foundation.org
Subject: + arm64-mm-enable-have_rcu_table_free-logic.patch added to -mm
 tree
Date: Wed, 01 Oct 2014 14:23:26 -0700
Message-ID: <542c70ce.pAb/I4OZClQAuOKW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaJAVX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@linaro.org, aarcange@redhat.com, catalin.marinas@arm.com, christoffer.dall@linaro.org, dann.frazier@canonical.com, hughd@google.com, mark.rutland@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: enable HAVE_RCU_TABLE_FREE logic
has been added to the -mm tree.  Its filename is
     arm64-mm-enable-have_rcu_table_free-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-enable-have_rcu_table_free-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-enable-have_rcu_table_free-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Capper <steve.capper@linaro.org>
Subject: arm64: mm: enable HAVE_RCU_TABLE_FREE logic

In order to implement fast_get_user_pages we need to ensure that the page
table walker is protected from page table pages being freed from under it.

This patch enables HAVE_RCU_TABLE_FREE, any page table pages belonging to
address spaces with multiple users will be call_rcu_sched freed.  Meaning
that disabling interrupts will block the free and protect the fast gup
page walker.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig           |    1 +
 arch/arm64/include/asm/tlb.h |   20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-mm-enable-have_rcu_table_free-logic arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-enable-have_rcu_table_free-logic
+++ a/arch/arm64/Kconfig
@@ -55,6 +55,7 @@ config ARM64
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_RCU_TABLE_FREE
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
diff -puN arch/arm64/include/asm/tlb.h~arm64-mm-enable-have_rcu_table_free-logic arch/arm64/include/asm/tlb.h
--- a/arch/arm64/include/asm/tlb.h~arm64-mm-enable-have_rcu_table_free-logic
+++ a/arch/arm64/include/asm/tlb.h
@@ -23,6 +23,20 @@
 
 #include <asm-generic/tlb.h>
 
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+
+#define tlb_remove_entry(tlb, entry)	tlb_remove_table(tlb, entry)
+static inline void __tlb_remove_table(void *_table)
+{
+	free_page_and_swap_cache((struct page *)_table);
+}
+#else
+#define tlb_remove_entry(tlb, entry)	tlb_remove_page(tlb, entry)
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+
 /*
  * There's three ways the TLB shootdown code is used:
  *  1. Unmapping a range of vmas.  See zap_page_range(), unmap_region().
@@ -88,7 +102,7 @@ static inline void __pte_free_tlb(struct
 {
 	pgtable_page_dtor(pte);
 	tlb_add_flush(tlb, addr);
-	tlb_remove_page(tlb, pte);
+	tlb_remove_entry(tlb, pte);
 }
 
 #if CONFIG_ARM64_PGTABLE_LEVELS > 2
@@ -96,7 +110,7 @@ static inline void __pmd_free_tlb(struct
 				  unsigned long addr)
 {
 	tlb_add_flush(tlb, addr);
-	tlb_remove_page(tlb, virt_to_page(pmdp));
+	tlb_remove_entry(tlb, virt_to_page(pmdp));
 }
 #endif
 
@@ -105,7 +119,7 @@ static inline void __pud_free_tlb(struct
 				  unsigned long addr)
 {
 	tlb_add_flush(tlb, addr);
-	tlb_remove_page(tlb, virt_to_page(pudp));
+	tlb_remove_entry(tlb, virt_to_page(pudp));
 }
 #endif
 
_

Patches currently in -mm which might be from steve.capper@linaro.org are

mm-introduce-a-general-rcu-get_user_pages_fast.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm-mm-introduce-special-ptes-for-lpae.patch
arm-mm-enable-have_rcu_table_free-logic.patch
arm-mm-enable-rcu-fast_gup.patch
arm64-mm-enable-have_rcu_table_free-logic.patch
arm64-mm-enable-rcu-fast_gup.patch

