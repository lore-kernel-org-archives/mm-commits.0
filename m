Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522B8C46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjANETx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjANETi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:19:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C713CA9
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E260B822C2
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D8AC433EF;
        Sat, 14 Jan 2023 04:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669974;
        bh=bxsUrKtE8GC2d5ZrNYpbathjp84tOqy8hANQSa/H+1g=;
        h=Date:To:From:Subject:From;
        b=iSvxIiTpns7kS36CF2EEqQdjWBDJbP9QZWMbt2gqrIJSbzelZrSAn4PYH9weJADzB
         KC8lb/3hQRKOy8T3pjVJvXmFHl/j1GC8k3X64POTfcwW6nRpelq2+5bsk5jBJBQPiK
         Yj8pawn2ScdgjlRgj/owHH3IThDoY0sX9+OBVD/A=
Date:   Fri, 13 Jan 2023 20:19:33 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-mm-support-__have_arch_pte_swp_exclusive.patch added to mm-unstable branch
Message-Id: <20230114041934.29D8AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been added to the -mm mm-unstable branch.  Its filename is
     mips-mm-support-__have_arch_pte_swp_exclusive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-mm-support-__have_arch_pte_swp_exclusive.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mips/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:12 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE.

On 64bit, steal one bit from the type.  Generic MM currently only uses 5
bits for the type (MAX_SWAPFILES_SHIFT), so the stolen bit is effectively
unused.

On 32bit we're able to locate unused bits.  As the PTE layout for 32 bit
is very confusing, document it a bit better.

While at it, mask the type in __swp_entry()/mk_swap_pte().

Link: https://lkml.kernel.org/r/20230113171026.582290-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/mips/include/asm/pgtable-32.h~mips-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -191,49 +191,113 @@ static inline pte_t pfn_pte(unsigned lon
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ */
 #if defined(CONFIG_CPU_R3K_TLB)
 
-/* Swap entries must have VALID bit cleared. */
+/*
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <----------- offset ------------> < type -> V G E 0 0 0 0 0 0 P
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_PRESENT (P), _PAGE_VALID (V) and_PAGE_GLOBAL (G) have to remain
+ *   unused.
+ */
 #define __swp_type(x)			(((x).val >> 10) & 0x1f)
 #define __swp_offset(x)			((x).val >> 15)
-#define __swp_entry(type,offset)	((swp_entry_t) { ((type) << 10) | ((offset) << 15) })
+#define __swp_entry(type, offset)	((swp_entry_t) { (((type) & 0x1f) << 10) | ((offset) << 15) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1 << 7)
+
 #else
 
 #if defined(CONFIG_XPA)
 
-/* Swap entries must have VALID and GLOBAL bits cleared. */
+/*
+ * Format of swap PTEs:
+ *
+ *   6 6 6 6 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3
+ *   3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2
+ *   0 0 0 0 0 0 E P <------------------ zeroes ------------------->
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <----------------- offset ------------------> < type -> V G 0 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_PRESENT (P), _PAGE_VALID (V) and_PAGE_GLOBAL (G) have to remain
+ *   unused.
+ */
 #define __swp_type(x)			(((x).val >> 4) & 0x1f)
 #define __swp_offset(x)			 ((x).val >> 9)
-#define __swp_entry(type,offset)	((swp_entry_t)  { ((type) << 4) | ((offset) << 9) })
+#define __swp_entry(type, offset)	((swp_entry_t)  { (((type) & 0x1f) << 4) | ((offset) << 9) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t) { 0, (x).val })
 
+/*
+ * We borrow bit 57 (bit 25 in the low PTE) to store the exclusive marker in
+ * swap PTEs.
+ */
+#define _PAGE_SWP_EXCLUSIVE	(1 << 25)
+
 #elif defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
 
-/* Swap entries must have VALID and GLOBAL bits cleared. */
+/*
+ * Format of swap PTEs:
+ *
+ *   6 6 6 6 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3
+ *   3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2
+ *   <------------------ zeroes -------------------> E P 0 0 0 0 0 0
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <------------------- offset --------------------> < type -> V G
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_PRESENT (P), _PAGE_VALID (V) and_PAGE_GLOBAL (G) have to remain
+ *   unused.
+ */
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
 #define __swp_offset(x)			 ((x).val >> 7)
-#define __swp_entry(type, offset)	((swp_entry_t)  { ((type) << 2) | ((offset) << 7) })
+#define __swp_entry(type, offset)	((swp_entry_t)  { (((type) & 0x1f) << 2) | ((offset) << 7) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t) { 0, (x).val })
 
+/*
+ * We borrow bit 39 (bit 7 in the low PTE) to store the exclusive marker in swap
+ * PTEs.
+ */
+#define _PAGE_SWP_EXCLUSIVE	(1 << 7)
+
 #else
 /*
- * Constraints:
- *      _PAGE_PRESENT at bit 0
- *      _PAGE_MODIFIED at bit 4
- *      _PAGE_GLOBAL at bit 6
- *      _PAGE_VALID at bit 7
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <------------- offset --------------> < type -> 0 0 0 0 0 0 E P
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_PRESENT (P), _PAGE_VALID (V) and_PAGE_GLOBAL (G) have to remain
+ *   unused. The location of V and G varies.
  */
 #define __swp_type(x)			(((x).val >> 8) & 0x1f)
 #define __swp_offset(x)			 ((x).val >> 13)
-#define __swp_entry(type,offset)	((swp_entry_t)	{ ((type) << 8) | ((offset) << 13) })
+#define __swp_entry(type, offset)	((swp_entry_t)	{ ((type) << 8) | ((offset) << 13) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+/* We borrow bit 1 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1 << 1)
+
 #endif /* defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32) */
 
 #endif /* defined(CONFIG_CPU_R3K_TLB) */
--- a/arch/mips/include/asm/pgtable-64.h~mips-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -320,16 +320,31 @@ extern void pud_init(void *addr);
 extern void pmd_init(void *addr);
 
 /*
- * Non-present pages:  high 40 bits are offset, next 8 bits type,
- * low 16 bits zero.
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   6 6 6 6 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3
+ *   3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2
+ *   <--------------------------- offset ---------------------------
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   --------------> E <-- type ---> <---------- zeroes ----------->
+ *
+ *  E is the exclusive marker that is not stored in swap entries.
  */
 static inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
-{ pte_t pte; pte_val(pte) = (type << 16) | (offset << 24); return pte; }
+{ pte_t pte; pte_val(pte) = ((type & 0x7f) << 16) | (offset << 24); return pte; }
 
-#define __swp_type(x)		(((x).val >> 16) & 0xff)
+#define __swp_type(x)		(((x).val >> 16) & 0x7f)
 #define __swp_offset(x)		((x).val >> 24)
 #define __swp_entry(type, offset) ((swp_entry_t) { pte_val(mk_swap_pte((type), (offset))) })
 #define __pte_to_swp_entry(pte) ((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
+/* We borrow bit 23 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1 << 23)
+
 #endif /* _ASM_PGTABLE_64_H */
--- a/arch/mips/include/asm/pgtable.h~mips-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/mips/include/asm/pgtable.h
@@ -528,6 +528,42 @@ static inline pte_t pte_modify(pte_t pte
 }
 #endif
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+#if defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte.pte_low & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	pte.pte_low |= _PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	pte.pte_low &= ~_PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+#else
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+#endif
 
 extern void __update_tlb(struct vm_area_struct *vma, unsigned long address,
 	pte_t pte);
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch
selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

