From: akpm@linux-foundation.org
Subject: - blackfin-arch-using-asm-generic-pgtable-header-file-by.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:10:33 -0700
Message-ID: <200704301910.l3UJAXhi012431@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946672AbXD3TKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin arch: using asm-generic pgtable header file by adding PAGE access macros based on CPLB management
has been removed from the -mm tree.  Its filename was
     blackfin-arch-using-asm-generic-pgtable-header-file-by.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: Blackfin arch: using asm-generic pgtable header file by adding PAGE access macros based on CPLB management
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/pgtable.h |   44 ++++++++++++++++++++++++-------
 1 files changed, 35 insertions(+), 9 deletions(-)

diff -puN include/asm-blackfin/pgtable.h~blackfin-arch-using-asm-generic-pgtable-header-file-by include/asm-blackfin/pgtable.h
--- a/include/asm-blackfin/pgtable.h~blackfin-arch-using-asm-generic-pgtable-header-file-by
+++ a/include/asm-blackfin/pgtable.h
@@ -3,7 +3,8 @@
 
 #include <asm-generic/4level-fixup.h>
 
-#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/cplb.h>
 
 typedef pte_t *pte_addr_t;
 /*
@@ -14,7 +15,12 @@ typedef pte_t *pte_addr_t;
 #define pgd_bad(pgd)		(0)
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *)0)
+
+#define pmd_offset(a, b)	((void *)0)
+#define pmd_none(x)		(!pmd_val(x))
+#define pmd_present(x)		(pmd_val(x))
+#define pmd_clear(xp)		do { set_pmd(xp, __pmd(0)); } while (0)
+#define pmd_bad(x)		(pmd_val(x) & ~PAGE_MASK)
 
 #define kern_addr_valid(addr) (1)
 
@@ -37,6 +43,32 @@ static inline int pte_file(pte_t pte)
 	return 0;
 }
 
+#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+/*
+ * Page assess control based on Blackfin CPLB management
+ */
+#define _PAGE_RD	(CPLB_USER_RD)
+#define _PAGE_WR	(CPLB_USER_WR)
+#define _PAGE_USER	(CPLB_USER_RD | CPLB_USER_WR)
+#define _PAGE_ACCESSED	CPLB_ALL_ACCESS
+#define _PAGE_DIRTY	(CPLB_DIRTY)
+
+#define PTE_BIT_FUNC(fn, op) \
+	static inline pte_t pte_##fn(pte_t _pte) { _pte.pte op; return _pte; }
+
+PTE_BIT_FUNC(rdprotect, &= ~_PAGE_RD);
+PTE_BIT_FUNC(mkread, |= _PAGE_RD);
+PTE_BIT_FUNC(wrprotect, &= ~_PAGE_WR);
+PTE_BIT_FUNC(mkwrite, |= _PAGE_WR);
+PTE_BIT_FUNC(exprotect, &= ~_PAGE_USER);
+PTE_BIT_FUNC(mkexec, |= _PAGE_USER);
+PTE_BIT_FUNC(mkclean, &= ~_PAGE_DIRTY);
+PTE_BIT_FUNC(mkdirty, |= _PAGE_DIRTY);
+PTE_BIT_FUNC(mkold, &= ~_PAGE_ACCESSED);
+PTE_BIT_FUNC(mkyoung, |= _PAGE_ACCESSED);
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
@@ -59,12 +91,6 @@ extern unsigned int kobjsize(const void 
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
-#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-
-#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#include <asm-generic/pgtable.h>
 
 #endif				/* _BLACKFIN_PGTABLE_H */
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
blackfin-arch-add-missing-blackfin-support-in-lib.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
