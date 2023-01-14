Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30F4C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjANEUA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjANETk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:19:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9C298
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:19:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1B1608C1
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D2CC433D2;
        Sat, 14 Jan 2023 04:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669978;
        bh=xUfoGBFX+Vlg7PVF450Tl8hkjPxRg1eti9VilH0UDxI=;
        h=Date:To:From:Subject:From;
        b=MPLRZsymRLuBM0QLHSz7rIJmVYo1cFBbY/kzKypViU+JkkCCOM02fVfjrXYbfJxFd
         5iUXWpwMXueAn8eE2ExxIUEKL4xOQZ3d2otEg1ipO5T6tr9bs7URdHMTtIcHS0DQuS
         uwJDqYF/IID68Li0DqM1wkmGdFxF6wP7JVpCqNfg=
Date:   Fri, 13 Jan 2023 20:19:37 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nios2-mm-support-__have_arch_pte_swp_exclusive.patch added to mm-unstable branch
Message-Id: <20230114041938.11D2CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been added to the -mm mm-unstable branch.  Its filename is
     nios2-mm-support-__have_arch_pte_swp_exclusive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nios2-mm-support-__have_arch_pte_swp_exclusive.patch

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
Subject: nios2/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:14 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by using the yet-unused bit
31.

Link: https://lkml.kernel.org/r/20230113171026.582290-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/nios2/include/asm/pgtable-bits.h~nios2-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/nios2/include/asm/pgtable-bits.h
@@ -31,4 +31,7 @@
 #define _PAGE_ACCESSED	(1<<26)	/* page referenced */
 #define _PAGE_DIRTY	(1<<27)	/* dirty page */
 
+/* We borrow bit 31 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1<<31)
+
 #endif /* _ASM_NIOS2_PGTABLE_BITS_H */
--- a/arch/nios2/include/asm/pgtable.h~nios2-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/nios2/include/asm/pgtable.h
@@ -239,7 +239,9 @@ static inline unsigned long pmd_page_vad
  *
  *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
  *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   0 < type -> 0 0 0 0 0 0 <-------------- offset --------------->
+ *   E < type -> 0 0 0 0 0 0 <-------------- offset --------------->
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
  *
  * Note that the offset field is always non-zero if the swap type is 0, thus
  * !pte_none() is always true.
@@ -251,6 +253,24 @@ static inline unsigned long pmd_page_vad
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 
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
 extern void __init paging_init(void);
 extern void __init mmu_init(void);
 
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

