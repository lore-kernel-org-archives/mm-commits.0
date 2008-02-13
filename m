From: akpm@linux-foundation.org
Subject: - x86-fix-pgtable_t-build-breakage.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:03 -0800
Message-ID: <200802132015.m1DKF3Xh011272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490AbYBMUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix pgtable_t build breakage
has been removed from the -mm tree.  Its filename was
     x86-fix-pgtable_t-build-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix pgtable_t build breakage
From: Ingo Molnar <mingo@elte.hu>

Fix build breakage caused by commit 2f569afd9ced9ebec9.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/page_32.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/page_32.h~x86-fix-pgtable_t-build-breakage include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~x86-fix-pgtable_t-build-breakage
+++ a/include/asm-x86/page_32.h
@@ -50,11 +50,13 @@ typedef unsigned long	phys_addr_t;
 typedef union { pteval_t pte, pte_low; } pte_t;
 typedef pte_t boot_pte_t;
 
-typedef struct page *pgtable_t;
-
 #endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
 
+#ifndef __ASSEMBLY__
+typedef struct page *pgtable_t;
+#endif
+
 #ifdef CONFIG_HUGETLB_PAGE
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
softlockup-workaround.patch
git-hrt.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
git-sched.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-visws-fix-printk-format-warnings.patch
x86-minor-cleanup-of-comments-in-processorh.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
rtc-cmos-display-hpet-emulation-mode.patch
acer-wmi-fail-gracefully-if-acpi-is-disabled.patch
tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
proc-add-rlimit_rttime-to-proc-pid-limits.patch
smack-unlabeled-outgoing-ambient-packets.patch
x86-configurable-dmi-scanning-code.patch
d_path-make-d_path-use-a-struct-path-fix.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
