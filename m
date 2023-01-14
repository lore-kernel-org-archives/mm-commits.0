Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E95C6379F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjANEUI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjANETo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:19:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11FFB1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:19:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 416E9608C1
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976FAC433D2;
        Sat, 14 Jan 2023 04:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669981;
        bh=ICRa9f2DI2ukDfsdyOcjx8BjBfhEp62dHVQlIXfM4Ic=;
        h=Date:To:From:Subject:From;
        b=GjPfHpMGGD68wgrl0FoUWIDK+wMeGGFRMoJ7mAtmZRIoAf7Jom0OkBoDKBtwypxRm
         UfGMi3wV9UbyrBLMD0qCnYygQJN1auVaTlXc20/Vz2JQf7a/trFz3WDHbIAB038IDT
         hQR7qgMvJYqMdgYNXJz/iphtkERMxQWA2GLmiHjU=
Date:   Fri, 13 Jan 2023 20:19:41 -0800
To:     mm-commits@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        deller@gmx.de, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-mm-support-__have_arch_pte_swp_exclusive.patch added to mm-unstable branch
Message-Id: <20230114041941.976FAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: parisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been added to the -mm mm-unstable branch.  Its filename is
     parisc-mm-support-__have_arch_pte_swp_exclusive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-mm-support-__have_arch_pte_swp_exclusive.patch

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
Subject: parisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:16 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by using the yet-unused
_PAGE_ACCESSED location in the swap PTE.  Looking at pte_present() and
pte_none() checks, there seems to be no actual reason why we cannot use
it: we only have to make sure we're not using _PAGE_PRESENT.

Reusing this bit avoids having to steal one bit from the swap offset.

Link: https://lkml.kernel.org/r/20230113171026.582290-17-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/parisc/include/asm/pgtable.h~parisc-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/parisc/include/asm/pgtable.h
@@ -218,6 +218,9 @@ extern void __update_cache(pte_t pte);
 #define _PAGE_KERNEL_RWX	(_PAGE_KERNEL_EXEC | _PAGE_WRITE)
 #define _PAGE_KERNEL		(_PAGE_KERNEL_RO | _PAGE_WRITE)
 
+/* We borrow bit 23 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_ACCESSED
+
 /* The pgd/pmd contains a ptr (in phys addr space); since all pgds/pmds
  * are page-aligned, we don't care about the PAGE_OFFSET bits, except
  * for a few meta-information bits, so we shift the address to be
@@ -394,17 +397,49 @@ extern void paging_init (void);
 
 #define update_mmu_cache(vms,addr,ptep) __update_cache(*ptep)
 
-/* Encode and de-code a swap entry */
-
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs (32bit):
+ *
+ *                         1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
+ *   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *   <---------------- offset -----------------> P E <ofs> < type ->
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_PRESENT (P) must be 0.
+ *
+ *   For the 64bit version, the offset is extended by 32bit.
+ */
 #define __swp_type(x)                     ((x).val & 0x1f)
 #define __swp_offset(x)                   ( (((x).val >> 6) &  0x7) | \
 					  (((x).val >> 8) & ~0x7) )
-#define __swp_entry(type, offset)         ((swp_entry_t) { (type) | \
+#define __swp_entry(type, offset)         ((swp_entry_t) { \
+					    ((type) & 0x1f) | \
 					    ((offset &  0x7) << 6) | \
 					    ((offset & ~0x7) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
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
+
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	pte_t pte;
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

