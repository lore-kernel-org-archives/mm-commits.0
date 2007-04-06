From: akpm@linux-foundation.org
Subject: + blackfin-arch-using-asm-generic-pgtable-header-file-by.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:24:40 -0700
Message-ID: <200704062124.l36LOeJG019320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34684 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbXDFVYn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin arch: using asm-generic pgtable header file by adding PAGE access macros based on CPLB management
has been added to the -mm tree.  Its filename is
     blackfin-arch-using-asm-generic-pgtable-header-file-by.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
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
move-die-notifier-handling-to-common-code-fix.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
