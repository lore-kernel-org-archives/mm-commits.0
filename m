Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA30BCCA482
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiGBAHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiGBAHh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F276B27D
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5DB8624FD
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12251C3411E;
        Sat,  2 Jul 2022 00:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720455;
        bh=duAhq3PWFh1JvJmX+Sd7u2hlNxG4Rm+02VFVdXPWEpQ=;
        h=Date:To:From:Subject:From;
        b=BcEdVEELrPD21Z4dnaNedlS1fl7GYCclLyac+uhwGFZL4Rl5yZb3rgdQvHjZED6cU
         EXNbej/xOAK+lMs8Q7IyMJMC2OW9bwjvRjV5iahoW71xz61Jvs8c15oPguZYiXTBmP
         v/5Tddt3nYod3eIWyZ5rhvUkYfev/6mBmlFiScGE=
Date:   Fri, 01 Jul 2022 17:07:34 -0700
To:     mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-enable-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000735.12251C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-mm-enable-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: riscv/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:20 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220630051630.1718927-17-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig               |    1 +
 arch/riscv/include/asm/pgtable.h |   20 --------------------
 arch/riscv/mm/init.c             |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 20 deletions(-)

--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/riscv/include/asm/pgtable.h
@@ -186,26 +186,6 @@ extern struct pt_alloc_ops pt_ops __init
 
 extern pgd_t swapper_pg_dir[];
 
-/* MAP_PRIVATE permissions: xwr (copy-on-write) */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READ
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_EXEC
-#define __P101	PAGE_READ_EXEC
-#define __P110	PAGE_COPY_EXEC
-#define __P111	PAGE_COPY_READ_EXEC
-
-/* MAP_SHARED permissions: xwr */
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READ
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_EXEC
-#define __S101	PAGE_READ_EXEC
-#define __S110	PAGE_SHARED_EXEC
-#define __S111	PAGE_SHARED_EXEC
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_present(pmd_t pmd)
 {
--- a/arch/riscv/Kconfig~riscv-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/riscv/Kconfig
@@ -32,6 +32,7 @@ config RISCV
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
 	select ARCH_STACKWALK
--- a/arch/riscv/mm/init.c~riscv-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/riscv/mm/init.c
@@ -288,6 +288,26 @@ static pmd_t __maybe_unused early_dtb_pm
 #define early_pg_dir           ((pgd_t *)XIP_FIXUP(early_pg_dir))
 #endif /* CONFIG_XIP_KERNEL */
 
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= PAGE_READ,
+	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE | VM_READ]				= PAGE_COPY,
+	[VM_EXEC]					= PAGE_EXEC,
+	[VM_EXEC | VM_READ]				= PAGE_READ_EXEC,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY_EXEC,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_READ_EXEC,
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_READ,
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC]				= PAGE_EXEC,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_READ_EXEC,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_SHARED_EXEC,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_EXEC
+};
+DECLARE_VM_GET_PAGE_PROT
+
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 {
 	unsigned long addr = __fix_to_virt(idx);
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

