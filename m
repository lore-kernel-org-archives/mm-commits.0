From: akpm@linux-foundation.org
Subject: [merged] mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:21 -0700
Message-ID: <552eb7d9.wzSjc3DOgxKSk3tt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbbDOTLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change vunmap to tear down huge KVA mappings
has been removed from the -mm tree.  Its filename was
     mm-change-vunmap-to-tear-down-huge-kva-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: change vunmap to tear down huge KVA mappings

Change vunmap_pmd_range() and vunmap_pud_range() to tear down huge KVA
mappings when they are set.  pud_clear_huge() and pmd_clear_huge() return
zero when no-operation is performed, i.e.  huge page mapping was not used.

These changes are only enabled when CONFIG_HAVE_ARCH_HUGE_VMAP is defined
on the architecture.

[akpm@linux-foundation.org: use consistent code layout]
Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   10 ++++++++++
 mm/vmalloc.c                  |    4 ++++
 2 files changed, 14 insertions(+)

diff -puN include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings
+++ a/include/asm-generic/pgtable.h
@@ -700,6 +700,8 @@ static inline int pmd_protnone(pmd_t pmd
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
 int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
+int pud_clear_huge(pud_t *pud);
+int pmd_clear_huge(pmd_t *pmd);
 #else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
 static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 {
@@ -709,6 +711,14 @@ static inline int pmd_set_huge(pmd_t *pm
 {
 	return 0;
 }
+static inline int pud_clear_huge(pud_t *pud)
+{
+	return 0;
+}
+static inline int pmd_clear_huge(pmd_t *pmd)
+{
+	return 0;
+}
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 #endif /* !__ASSEMBLY__ */
diff -puN mm/vmalloc.c~mm-change-vunmap-to-tear-down-huge-kva-mappings mm/vmalloc.c
--- a/mm/vmalloc.c~mm-change-vunmap-to-tear-down-huge-kva-mappings
+++ a/mm/vmalloc.c
@@ -75,6 +75,8 @@ static void vunmap_pmd_range(pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (pmd_clear_huge(pmd))
+			continue;
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next);
@@ -89,6 +91,8 @@ static void vunmap_pud_range(pgd_t *pgd,
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
+		if (pud_clear_huge(pud))
+			continue;
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		vunmap_pmd_range(pud, addr, next);
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
mm-x86-document-return-values-of-mapping-funcs.patch
mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch
mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

