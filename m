Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5818C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiGBAIS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiGBAH6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191E073585
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35A4B8326E
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58132C3411E;
        Sat,  2 Jul 2022 00:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720473;
        bh=qUyn3jcPLly0kB5UM+TuAmWBE3Rhr1yRQq+aZrWRX9o=;
        h=Date:To:From:Subject:From;
        b=ynGBjReJH8LtLFo8gvV69bIyU3BYn3ovbGIY5xDGySuPTPw+8agMsywfUFETWdc5t
         nPWzRc+jKSNna+6hljAyEgXJwLHgiXinay6VrUHEVTsDg/+81oVjnZfB8SpUijdks5
         FDG1SkONY/s8FEde58s0YZrdVyk3T4yPnItMEnn4=
Date:   Fri, 01 Jul 2022 17:07:52 -0700
To:     mm-commits@vger.kernel.org, linux@armlinux.org.uk, arnd@arndb.de,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mm-enable-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000753.58132C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     arm-mm-enable-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-mm-enable-arch_has_vm_get_page_prot.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:27 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220630051630.1718927-24-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                   |    1 +
 arch/arm/include/asm/pgtable.h     |   17 -----------------
 arch/arm/lib/uaccess_with_memcpy.c |    2 +-
 arch/arm/mm/mmu.c                  |   20 ++++++++++++++++++++
 4 files changed, 22 insertions(+), 18 deletions(-)

--- a/arch/arm/include/asm/pgtable.h~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/include/asm/pgtable.h
@@ -137,23 +137,6 @@ extern pgprot_t phys_mem_access_prot(str
  *  2) If we could do execute protection, then read is implied
  *  3) write implies read permissions
  */
-#define __P000  __PAGE_NONE
-#define __P001  __PAGE_READONLY
-#define __P010  __PAGE_COPY
-#define __P011  __PAGE_COPY
-#define __P100  __PAGE_READONLY_EXEC
-#define __P101  __PAGE_READONLY_EXEC
-#define __P110  __PAGE_COPY_EXEC
-#define __P111  __PAGE_COPY_EXEC
-
-#define __S000  __PAGE_NONE
-#define __S001  __PAGE_READONLY
-#define __S010  __PAGE_SHARED
-#define __S011  __PAGE_SHARED
-#define __S100  __PAGE_READONLY_EXEC
-#define __S101  __PAGE_READONLY_EXEC
-#define __S110  __PAGE_SHARED_EXEC
-#define __S111  __PAGE_SHARED_EXEC
 
 #ifndef __ASSEMBLY__
 /*
--- a/arch/arm/Kconfig~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/Kconfig
@@ -24,6 +24,7 @@ config ARM
 	select ARCH_HAS_SYNC_DMA_FOR_CPU if SWIOTLB || !MMU
 	select ARCH_HAS_TEARDOWN_DMA_OPS if MMU
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if CPU_V7 || CPU_V7M || CPU_V6K
 	select ARCH_HAS_GCOV_PROFILE_ALL
--- a/arch/arm/lib/uaccess_with_memcpy.c~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -237,7 +237,7 @@ static int __init test_size_treshold(voi
 	if (!dst_page)
 		goto no_dst;
 	kernel_ptr = page_address(src_page);
-	user_ptr = vmap(&dst_page, 1, VM_IOREMAP, __pgprot(__P010));
+	user_ptr = vmap(&dst_page, 1, VM_IOREMAP, __pgprot(__PAGE_COPY));
 	if (!user_ptr)
 		goto no_vmap;
 
--- a/arch/arm/mm/mmu.c~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/mm/mmu.c
@@ -405,6 +405,26 @@ void __set_fixmap(enum fixed_addresses i
 	local_flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }
 
+static pgprot_t protection_map[16] __ro_after_init = {
+	[VM_NONE]					= __PAGE_NONE,
+	[VM_READ]					= __PAGE_READONLY,
+	[VM_WRITE]					= __PAGE_COPY,
+	[VM_WRITE | VM_READ]				= __PAGE_COPY,
+	[VM_EXEC]					= __PAGE_READONLY_EXEC,
+	[VM_EXEC | VM_READ]				= __PAGE_READONLY_EXEC,
+	[VM_EXEC | VM_WRITE]				= __PAGE_COPY_EXEC,
+	[VM_EXEC | VM_WRITE | VM_READ]			= __PAGE_COPY_EXEC,
+	[VM_SHARED]					= __PAGE_NONE,
+	[VM_SHARED | VM_READ]				= __PAGE_READONLY,
+	[VM_SHARED | VM_WRITE]				= __PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= __PAGE_SHARED,
+	[VM_SHARED | VM_EXEC]				= __PAGE_READONLY_EXEC,
+	[VM_SHARED | VM_EXEC | VM_READ]			= __PAGE_READONLY_EXEC,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= __PAGE_SHARED_EXEC,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __PAGE_SHARED_EXEC
+};
+DECLARE_VM_GET_PAGE_PROT
+
 /*
  * Adjust the PMD section entries according to the CPU in use.
  */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-mmap-build-protect-protection_map-with-__p000.patch
mm-mmap-define-declare_vm_get_page_prot.patch
powerpc-mm-move-protection_map-inside-the-platform.patch
sparc-mm-move-protection_map-inside-the-platform.patch
arm64-mm-move-protection_map-inside-the-platform.patch
x86-mm-move-protection_map-inside-the-platform.patch
mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
loongarch-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
xtensa-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch

