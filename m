Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD9FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbiBVDOd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbiBVDO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:14:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721ADE0A8
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:14:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F3ABB80AEA
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB721C340E9;
        Tue, 22 Feb 2022 03:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499640;
        bh=lVeuQZ3hq5AczKPDEIKmuAD1nVFktWLdMljgkwn1aM8=;
        h=Date:To:From:Subject:From;
        b=qXSZDuiZw6CDIlZ6bllnNiSAh68M4vI/0GndnDv0IrllIbWUQVp2aLxYRwxNJdWZ5
         q5l37z+FhcFxJLzKwrPsbufwB/5B/C9y8SkAU+PUvr68gC/OuSei3HwhN2nofeWqNq
         DTmORxU/2NydkX6xT/CAj6fBiWPH2fEDxhQoYhHo=
Date:   Mon, 21 Feb 2022 19:14:00 -0800
To:     mm-commits@vger.kernel.org, dinguyen@kernel.org,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nios2-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031400.CB721C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     nios2-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nios2-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nios2-mm-enable-arch_has_vm_get_page_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: nios2/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/1645425519-9034-26-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/Kconfig               |    1 
 arch/nios2/include/asm/pgtable.h |   16 ----------
 arch/nios2/mm/init.c             |   45 +++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 16 deletions(-)

--- a/arch/nios2/include/asm/pgtable.h~nios2-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/nios2/include/asm/pgtable.h
@@ -40,24 +40,8 @@ struct mm_struct;
  */
 
 /* Remove W bit on private pages for COW support */
-#define __P000	MKP(0, 0, 0)
-#define __P001	MKP(0, 0, 1)
-#define __P010	MKP(0, 0, 0)	/* COW */
-#define __P011	MKP(0, 0, 1)	/* COW */
-#define __P100	MKP(1, 0, 0)
-#define __P101	MKP(1, 0, 1)
-#define __P110	MKP(1, 0, 0)	/* COW */
-#define __P111	MKP(1, 0, 1)	/* COW */
 
 /* Shared pages can have exact HW mapping */
-#define __S000	MKP(0, 0, 0)
-#define __S001	MKP(0, 0, 1)
-#define __S010	MKP(0, 1, 0)
-#define __S011	MKP(0, 1, 1)
-#define __S100	MKP(1, 0, 0)
-#define __S101	MKP(1, 0, 1)
-#define __S110	MKP(1, 1, 0)
-#define __S111	MKP(1, 1, 1)
 
 /* Used all over the kernel */
 #define PAGE_KERNEL __pgprot(_PAGE_PRESENT | _PAGE_CACHED | _PAGE_READ | \
--- a/arch/nios2/Kconfig~nios2-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/nios2/Kconfig
@@ -6,6 +6,7 @@ config NIOS2
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_HAS_DMA_SET_UNCACHED
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_SWAP
 	select COMMON_CLK
 	select TIMER_OF
--- a/arch/nios2/mm/init.c~nios2-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/nios2/mm/init.c
@@ -124,3 +124,48 @@ const char *arch_vma_name(struct vm_area
 {
 	return (vma->vm_start == KUSER_BASE) ? "[kuser]" : NULL;
 }
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return MKP(0, 0, 0);
+	case VM_READ:
+		return MKP(0, 0, 1);
+	/* COW */
+	case VM_WRITE:
+		return MKP(0, 0, 0);
+	/* COW */
+	case VM_WRITE | VM_READ:
+		return MKP(0, 0, 1);
+	case VM_EXEC:
+		return MKP(1, 0, 0);
+	case VM_EXEC | VM_READ:
+		return MKP(1, 0, 1);
+	/* COW */
+	case VM_EXEC | VM_WRITE:
+		return MKP(1, 0, 0);
+	/* COW */
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return MKP(1, 0, 1);
+	case VM_SHARED:
+		return MKP(0, 0, 0);
+	case VM_SHARED | VM_READ:
+		return MKP(0, 0, 1);
+	case VM_SHARED | VM_WRITE:
+		return MKP(0, 1, 0);
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return MKP(0, 1, 1);
+	case VM_SHARED | VM_EXEC:
+		return MKP(1, 0, 0);
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return MKP(1, 0, 1);
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+		return MKP(1, 1, 0);
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return MKP(1, 1, 1);
+	default:
+		BUILD_BUG();
+	}
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-merge-pte_mkhuge-call-into-arch_make_huge_pte.patch
mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-protection_map.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
extensa-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
nds32-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-generic-vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch
mm-hugetlb-generalize-arch_want_general_hugetlb.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

