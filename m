Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4C3C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiGBAHH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiGBAHF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C87138795
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A766624F4
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D38AC3411E;
        Sat,  2 Jul 2022 00:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720423;
        bh=15bstEuRZKG7EFYpsMTY/QMIngsvlN0lboJ2E1qPh08=;
        h=Date:To:From:Subject:From;
        b=xXr2rH1zW/fRthddJ09/+gHw5x6oH1QOLSWkyUKQJjZ96oy1T0Vs1IhbMuopFwDBM
         m/4I5LTC2gbdisG+WbRM//1D0xPzbw8jZ3K36NjT7dQVkfQySnjYugRnln3+e/aKfR
         ANu6rbHwOs4Vtkbzr/8NDRGJ1WHofBX6+prafqt0=
Date:   Fri, 01 Jul 2022 17:07:02 -0700
To:     mm-commits@vger.kernel.org, paulus@samba.org, npiggin@gmail.com,
        mpe@ellerman.id.au, christophe.leroy@csgroup.eu,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-move-protection_map-inside-the-platform.patch added to mm-unstable branch
Message-Id: <20220702000703.5D38AC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: move protection_map[] inside the platform
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-move-protection_map-inside-the-platform.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-move-protection_map-inside-the-platform.patch

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
Subject: powerpc/mm: move protection_map[] inside the platform
Date: Thu, 30 Jun 2022 10:46:07 +0530

This moves protection_map[] inside the platform and while here, also
enable ARCH_HAS_VM_GET_PAGE_PROT on 32 bit and nohash 64 (aka book3e/64)
platforms via DECLARE_VM_GET_PAGE_PROT.

Link: https://lkml.kernel.org/r/20220630051630.1718927-4-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig               |    2 +-
 arch/powerpc/include/asm/pgtable.h |   20 +-------------------
 arch/powerpc/mm/pgtable.c          |   24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 20 deletions(-)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-move-protection_map-inside-the-platform
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -20,25 +20,6 @@ struct mm_struct;
 #include <asm/nohash/pgtable.h>
 #endif /* !CONFIG_PPC_BOOK3S */
 
-/* Note due to the way vm flags are laid out, the bits are XWR */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY_X
-#define __P101	PAGE_READONLY_X
-#define __P110	PAGE_COPY_X
-#define __P111	PAGE_COPY_X
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY_X
-#define __S101	PAGE_READONLY_X
-#define __S110	PAGE_SHARED_X
-#define __S111	PAGE_SHARED_X
-
 #ifndef __ASSEMBLY__
 
 #ifndef MAX_PTRS_PER_PGD
@@ -79,6 +60,7 @@ extern void paging_init(void);
 void poking_init(void);
 
 extern unsigned long ioremap_bot;
+extern const pgprot_t protection_map[16];
 
 /*
  * kern_addr_valid is intended to indicate whether an address is a valid
--- a/arch/powerpc/Kconfig~powerpc-mm-move-protection_map-inside-the-platform
+++ a/arch/powerpc/Kconfig
@@ -140,7 +140,7 @@ config PPC
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT	if PPC_BOOK3S_64
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-move-protection_map-inside-the-platform
+++ a/arch/powerpc/mm/pgtable.c
@@ -472,3 +472,27 @@ out:
 	return ret_pte;
 }
 EXPORT_SYMBOL_GPL(__find_linux_pte);
+
+/* Note due to the way vm flags are laid out, the bits are XWR */
+const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= PAGE_READONLY,
+	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE | VM_READ]				= PAGE_COPY,
+	[VM_EXEC]					= PAGE_READONLY_X,
+	[VM_EXEC | VM_READ]				= PAGE_READONLY_X,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY_X,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_X,
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_READONLY,
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC]				= PAGE_READONLY_X,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_READONLY_X,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_SHARED_X,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_X
+};
+
+#ifndef CONFIG_PPC_BOOK3S_64
+DECLARE_VM_GET_PAGE_PROT
+#endif
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

