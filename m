Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF829C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiBVDOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239811AbiBVDOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:14:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E1110FDA
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:14:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37453B8184F
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45F6C340E9;
        Tue, 22 Feb 2022 03:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499649;
        bh=mW5He9/hqvGWg2M/DmU2KId3dYfamVKzcPHlnv8N8Ls=;
        h=Date:To:From:Subject:From;
        b=HNFc1VqVMHkkERlVlHCuvkMZy8LxjC6HUtMwa4UQxmLC+b6AfxwKMpOX3QB+bx8Kw
         9jdCHKpX43SlKVfmwBBwg7dvLsVJolY3+To53aIqeYQR0gtBfiHIKfdqkgeUTNfIjN
         uDYfzr+xFisgZMHL+yLfbOEbPUKHf7tuhOFz7Lls=
Date:   Mon, 21 Feb 2022 19:14:09 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031409.C45F6C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     ia64-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: ia64/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/1645425519-9034-29-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig               |    1 
 arch/ia64/include/asm/pgtable.h |   17 ------------
 arch/ia64/mm/init.c             |   41 +++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 18 deletions(-)

--- a/arch/ia64/include/asm/pgtable.h~ia64-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/ia64/include/asm/pgtable.h
@@ -161,23 +161,6 @@
  * attempts to write to the page.
  */
 	/* xwr */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_READONLY	/* write to priv pg -> copy & make writable */
-#define __P011	PAGE_READONLY	/* ditto */
-#define __P100	__pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_X_RX)
-#define __P101	__pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RX)
-#define __P110	PAGE_COPY_EXEC
-#define __P111	PAGE_COPY_EXEC
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED	/* we don't have (and don't need) write-only */
-#define __S011	PAGE_SHARED
-#define __S100	__pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_X_RX)
-#define __S101	__pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RX)
-#define __S110	__pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RWX)
-#define __S111	__pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RWX)
 
 #define pgd_ERROR(e)	printk("%s:%d: bad pgd %016lx.\n", __FILE__, __LINE__, pgd_val(e))
 #if CONFIG_PGTABLE_LEVELS == 4
--- a/arch/ia64/Kconfig~ia64-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/ia64/Kconfig
@@ -11,6 +11,7 @@ config IA64
 	select ARCH_HAS_DMA_MARK_CLEAN
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ACPI
--- a/arch/ia64/mm/init.c~ia64-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/ia64/mm/init.c
@@ -273,7 +273,7 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_start = FIXADDR_USER_START;
 	gate_vma.vm_end = FIXADDR_USER_END;
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
-	gate_vma.vm_page_prot = __P101;
+	gate_vma.vm_page_prot = __pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RX);
 
 	return 0;
 }
@@ -492,3 +492,42 @@ void arch_remove_memory(u64 start, u64 s
 	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return PAGE_NONE;
+	case VM_READ:
+	/* write to priv pg -> copy & make writable */
+	case VM_WRITE:
+	/* write to priv pg -> copy & make writable */
+	case VM_WRITE | VM_READ:
+		return PAGE_READONLY;
+	case VM_EXEC:
+		return __pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_X_RX);
+	case VM_EXEC | VM_READ:
+		return __pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RX);
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_COPY_EXEC;
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return PAGE_READONLY;
+	/* we don't have (and don't need) write-only */
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_EXEC:
+		return __pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_X_RX);
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return __pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RX);
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(__ACCESS_BITS | _PAGE_PL_3 | _PAGE_AR_RWX);
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

