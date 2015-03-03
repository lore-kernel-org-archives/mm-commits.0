From: akpm@linux-foundation.org
Subject: + mm-change-vunmap-to-tear-down-huge-kva-mappings.patch added to
 -mm tree
Date: Tue, 03 Mar 2015 14:46:02 -0800
Message-ID: <54f639aa.BSN7YkFyUGlQ0gUe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbbCCWqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:46:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change vunmap to tear down huge KVA mappings
has been added to the -mm tree.  Its filename is
     mm-change-vunmap-to-tear-down-huge-kva-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-vunmap-to-tear-down-huge-kva-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: change vunmap to tear down huge KVA mappings

Change vunmap_pmd_range() and vunmap_pud_range() to tear down huge KVA
mappings when they are set.  pud_clear_huge() and pmd_clear_huge() return
zero when no-operation is performed, i.e.  huge page mapping was not used.

These changes are only enabled when CONFIG_HAVE_ARCH_HUGE_VMAP is defined
on the architecture.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    4 ++++
 mm/vmalloc.c                  |    4 ++++
 2 files changed, 8 insertions(+)

diff -puN include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings
+++ a/include/asm-generic/pgtable.h
@@ -706,6 +706,8 @@ static inline int pmd_protnone(pmd_t pmd
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
 int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
+int pud_clear_huge(pud_t *pud);
+int pmd_clear_huge(pmd_t *pmd);
 #else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
 static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 {
@@ -715,6 +717,8 @@ static inline int pmd_set_huge(pmd_t *pm
 {
 	return 0;
 }
+static inline int pud_clear_huge(pud_t *pud) { return 0; }
+static inline int pmd_clear_huge(pmd_t *pmd) { return 0; }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
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

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

