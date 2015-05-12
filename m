From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-x86-document-return-values-of-mapping-funcs.patch removed from -mm tree
Date: Tue, 12 May 2015 12:57:38 -0700
Message-ID: <55525b32.ytCD4FRmD0bWPP5x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbbELT5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 15:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: document return values of mapping funcs
has been removed from the -mm tree.  Its filename was
     mm-x86-document-return-values-of-mapping-funcs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm, x86: document return values of mapping funcs

This patchset enhances MTRR checks for the kernel huge I/O mapping, which
was enabled by the patchset below:

  https://lkml.org/lkml/2015/3/3/589

The following functional changes are made in patch 7/7.
 - Allow pud_set_huge() and pmd_set_huge() to create a huge page
   mapping to a range covered by a single MTRR entry of any memory
   type.
 - Log a pr_warn() message when a specified PMD map range spans more
   than a single MTRR entry.  Drivers should make a mapping request
   aligned to a single MTRR entry when the range is covered by MTRRs.



This patch (of 7):

Document the return values of KVA mapping functions, pud_set_huge(),
pmd_set_huge, pud_clear_huge() and pmd_clear_huge().

Simplify the conditions to select HAVE_ARCH_HUGE_VMAP in the Kconfig,
since X86_PAE depends on X86_32.

There is no functional change in this patch.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    2 +-
 arch/x86/mm/pgtable.c |   36 ++++++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff -puN arch/x86/Kconfig~mm-x86-document-return-values-of-mapping-funcs arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-x86-document-return-values-of-mapping-funcs
+++ a/arch/x86/Kconfig
@@ -100,7 +100,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
-	select HAVE_ARCH_HUGE_VMAP if X86_64 || (X86_32 && X86_PAE)
+	select HAVE_ARCH_HUGE_VMAP if X86_64 || X86_PAE
 	select ARCH_HAS_SG_CHAIN
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/x86/mm/pgtable.c~mm-x86-document-return-values-of-mapping-funcs arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~mm-x86-document-return-values-of-mapping-funcs
+++ a/arch/x86/mm/pgtable.c
@@ -563,14 +563,19 @@ void native_set_fixmap(enum fixed_addres
 }
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+/**
+ * pud_set_huge - setup kernel PUD mapping
+ *
+ * MTRR can override PAT memory types with 4KB granularity.  Therefore,
+ * it does not set up a huge page when the range is covered by a non-WB
+ * type of MTRR.  0xFF indicates that MTRR are disabled.
+ *
+ * Return 1 on success, and 0 when no PUD was set.
+ */
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 {
 	u8 mtrr;
 
-	/*
-	 * Do not use a huge page when the range is covered by non-WB type
-	 * of MTRRs.
-	 */
 	mtrr = mtrr_type_lookup(addr, addr + PUD_SIZE);
 	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != 0xFF))
 		return 0;
@@ -584,14 +589,19 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 	return 1;
 }
 
+/**
+ * pmd_set_huge - setup kernel PMD mapping
+ *
+ * MTRR can override PAT memory types with 4KB granularity.  Therefore,
+ * it does not set up a huge page when the range is covered by a non-WB
+ * type of MTRR.  0xFF indicates that MTRR are disabled.
+ *
+ * Return 1 on success, and 0 when no PMD was set.
+ */
 int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 {
 	u8 mtrr;
 
-	/*
-	 * Do not use a huge page when the range is covered by non-WB type
-	 * of MTRRs.
-	 */
 	mtrr = mtrr_type_lookup(addr, addr + PMD_SIZE);
 	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != 0xFF))
 		return 0;
@@ -605,6 +615,11 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 	return 1;
 }
 
+/**
+ * pud_clear_huge - clear kernel PUD mapping when it is set
+ *
+ * Return 1 on success, and 0 when no PUD map was found.
+ */
 int pud_clear_huge(pud_t *pud)
 {
 	if (pud_large(*pud)) {
@@ -615,6 +630,11 @@ int pud_clear_huge(pud_t *pud)
 	return 0;
 }
 
+/**
+ * pmd_clear_huge - clear kernel PMD mapping when it is set
+ *
+ * Return 1 on success, and 0 when no PMD map was found.
+ */
 int pmd_clear_huge(pmd_t *pmd)
 {
 	if (pmd_large(*pmd)) {
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

