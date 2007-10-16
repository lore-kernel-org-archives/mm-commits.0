From: akpm@linux-foundation.org
Subject: - remove-frv-usage-of-flush_tlb_pgtables.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:16 -0700
Message-ID: <200710162036.l9GKaGiE015151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965806AbXJPVep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     remove frv usage of flush_tlb_pgtables()
has been removed from the -mm tree.  Its filename was
     remove-frv-usage-of-flush_tlb_pgtables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove frv usage of flush_tlb_pgtables()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

frv is the last user in the tree of that dubious hook, and it's my
understanding that it's not even needed.  It's only called by memory.c
free_pgd_range() which is always called within an mmu_gather, and
tlb_flush() on frv will do a flush_tlb_mm(), which from my reading of the
code, seems to do what flush_tlb_ptables() does, which is to clear the
cached PGE.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/tlbflush.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/asm-frv/tlbflush.h~remove-frv-usage-of-flush_tlb_pgtables include/asm-frv/tlbflush.h
--- a/include/asm-frv/tlbflush.h~remove-frv-usage-of-flush_tlb_pgtables
+++ a/include/asm-frv/tlbflush.h
@@ -57,8 +57,7 @@ do {								\
 #define __flush_tlb_global()			flush_tlb_all()
 #define flush_tlb()				flush_tlb_all()
 #define flush_tlb_kernel_range(start, end)	flush_tlb_all()
-#define flush_tlb_pgtables(mm,start,end) \
-	asm volatile("movgs %0,scr0 ! movgs %0,scr1" :: "r"(ULONG_MAX) : "memory");
+#define flush_tlb_pgtables(mm,start,end)	do { } while(0)
 
 #else
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
report-the-per-irq-statistics-on-allarches.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
delay-creation-of-khcvd-thread.patch
intel-iommu-fix-for-iommu-early-crash-2.patch
add-scaled-time-to-taskstats-based-process-accounting.patch
add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch
powerpc-add-scaled-time-accounting.patch
powerpc-add-scaled-time-accounting-speedup.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-ppc64.patch
add-documentation-for-extended-crashkernel-syntax.patch
replace-__attribute_pure__-with-__pure.patch
