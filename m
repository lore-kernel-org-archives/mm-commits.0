Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EBEC6379F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjANEUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjANET4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:19:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7BEC0
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:19:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F930B800C1
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9BBC433D2;
        Sat, 14 Jan 2023 04:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669992;
        bh=do//wttbtBHNL3e3ZaN8z6Adkwc4Ze3esMVD9PrdeaQ=;
        h=Date:To:From:Subject:From;
        b=k1N9CLM0yof2H0Be7BxfcCxGGxwhDhnKtxPacPK/CQesre3NBEbwwHsZezIok4Tcc
         CI3VRVG4dhJIBMmSFPMAOE+zTL4Fm3qqWU2CnWaAZZl0+HZczfdN8imuDrkVdsD0Bn
         nD4B4qK+LwgrSbVXJuZB9Rx+L3l621UW8dIttPtY=
Date:   Fri, 13 Jan 2023 20:19:51 -0800
To:     mm-commits@vger.kernel.org, davem@davemloft.net, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch added to mm-unstable branch
Message-Id: <20230114041951.EA9BBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE on 32bit
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch

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
Subject: sparc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE on 32bit
Date: Fri, 13 Jan 2023 18:10:21 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by reusing the SRMMU_DIRTY bit
as that seems to be safe to reuse inside a swap PTE.  This avoids having
to steal one bit from the swap offset.

While at it, relocate the swap PTE layout documentation and use the same
style now used for most other archs.  Note that the old documentation was
wrong: we use 20 bit for the offset and the reserved bits were 8 instead
of 7 bits in the ascii art.

Link: https://lkml.kernel.org/r/20230113171026.582290-22-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/sparc/include/asm/pgtable_32.h~sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -323,7 +323,16 @@ void srmmu_mapiorange(unsigned int bus,
                       unsigned long xva, unsigned int len);
 void srmmu_unmapiorange(unsigned long virt_addr, unsigned int len);
 
-/* Encode and de-code a swap entry */
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <-------------- offset ---------------> < type -> E 0 0 0 0 0 0
+ */
 static inline unsigned long __swp_type(swp_entry_t entry)
 {
 	return (entry.val >> SRMMU_SWP_TYPE_SHIFT) & SRMMU_SWP_TYPE_MASK;
@@ -344,6 +353,22 @@ static inline swp_entry_t __swp_entry(un
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & SRMMU_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return __pte(pte_val(pte) | SRMMU_SWP_EXCLUSIVE);
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~SRMMU_SWP_EXCLUSIVE);
+}
+
 static inline unsigned long
 __get_phys (unsigned long addr)
 {
--- a/arch/sparc/include/asm/pgtsrmmu.h~sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit
+++ a/arch/sparc/include/asm/pgtsrmmu.h
@@ -53,21 +53,13 @@
 
 #define SRMMU_CHG_MASK    (0xffffff00 | SRMMU_REF | SRMMU_DIRTY)
 
-/* SRMMU swap entry encoding
- *
- * We use 5 bits for the type and 19 for the offset.  This gives us
- * 32 swapfiles of 4GB each.  Encoding looks like:
- *
- * oooooooooooooooooootttttRRRRRRRR
- * fedcba9876543210fedcba9876543210
- *
- * The bottom 7 bits are reserved for protection and status bits, especially
- * PRESENT.
- */
+/* SRMMU swap entry encoding */
 #define SRMMU_SWP_TYPE_MASK	0x1f
 #define SRMMU_SWP_TYPE_SHIFT	7
 #define SRMMU_SWP_OFF_MASK	0xfffff
 #define SRMMU_SWP_OFF_SHIFT	(SRMMU_SWP_TYPE_SHIFT + 5)
+/* We borrow bit 6 to store the exclusive marker in swap PTEs. */
+#define SRMMU_SWP_EXCLUSIVE	SRMMU_DIRTY
 
 /* Some day I will implement true fine grained access bits for
  * user pages because the SRMMU gives us the capabilities to
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

