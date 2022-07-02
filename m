Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23C4CCA479
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiGBAHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGBAH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBEB4091E
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37FB5B8326F
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9EFC3411E;
        Sat,  2 Jul 2022 00:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720443;
        bh=dVaTnVTBZaddl3uILPgobpxv1Ue0dVJWp9WdF+tjtS8=;
        h=Date:To:From:Subject:From;
        b=1KBuAA/zjmsoijFtWzIJKi5QUtJoFBwCSe0lLlbJf1fKVm/SDijMNzmVdLwRPFgli
         jLAfreKS9uOG1HWGbRJJGdXS1e1QOgaV/WW3qmkEmptOhGas047zq7Mc9MV5a4fm4t
         VSbHgRhblLJtdI/1qPoACsjvBuqb1gfn/BaAidwo=
Date:   Fri, 01 Jul 2022 17:07:22 -0700
To:     mm-commits@vger.kernel.org, guoren@kernel.org, chris@zankel.net,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-mm-enable-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000722.EB9EFC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-mm-enable-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: xtensa/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:15 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220630051630.1718927-12-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig               |    1 +
 arch/xtensa/include/asm/pgtable.h |   18 ------------------
 arch/xtensa/mm/init.c             |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 18 deletions(-)

--- a/arch/xtensa/include/asm/pgtable.h~xtensa-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -200,24 +200,6 @@
  * What follows is the closest we can get by reasonable means..
  * See linux/mm/mmap.c for protection_map[] array that uses these definitions.
  */
-#define __P000	PAGE_NONE		/* private --- */
-#define __P001	PAGE_READONLY		/* private --r */
-#define __P010	PAGE_COPY		/* private -w- */
-#define __P011	PAGE_COPY		/* private -wr */
-#define __P100	PAGE_READONLY_EXEC	/* private x-- */
-#define __P101	PAGE_READONLY_EXEC	/* private x-r */
-#define __P110	PAGE_COPY_EXEC		/* private xw- */
-#define __P111	PAGE_COPY_EXEC		/* private xwr */
-
-#define __S000	PAGE_NONE		/* shared  --- */
-#define __S001	PAGE_READONLY		/* shared  --r */
-#define __S010	PAGE_SHARED		/* shared  -w- */
-#define __S011	PAGE_SHARED		/* shared  -wr */
-#define __S100	PAGE_READONLY_EXEC	/* shared  x-- */
-#define __S101	PAGE_READONLY_EXEC	/* shared  x-r */
-#define __S110	PAGE_SHARED_EXEC	/* shared  xw- */
-#define __S111	PAGE_SHARED_EXEC	/* shared  xwr */
-
 #ifndef __ASSEMBLY__
 
 #define pte_ERROR(e) \
--- a/arch/xtensa/Kconfig~xtensa-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/xtensa/Kconfig
@@ -11,6 +11,7 @@ config XTENSA
 	select ARCH_HAS_DMA_SET_UNCACHED if MMU
 	select ARCH_HAS_STRNCPY_FROM_USER if !KASAN
 	select ARCH_HAS_STRNLEN_USER
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
--- a/arch/xtensa/mm/init.c~xtensa-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/xtensa/mm/init.c
@@ -216,3 +216,23 @@ static int __init parse_memmap_opt(char
 	return 0;
 }
 early_param("memmap", parse_memmap_opt);
+
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= PAGE_READONLY,
+	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE | VM_READ]				= PAGE_COPY,
+	[VM_EXEC]					= PAGE_READONLY_EXEC,
+	[VM_EXEC | VM_READ]				= PAGE_READONLY_EXEC,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY_EXEC,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_EXEC,
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_READONLY,
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC]				= PAGE_READONLY_EXEC,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_READONLY_EXEC,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_SHARED_EXEC,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_EXEC
+};
+DECLARE_VM_GET_PAGE_PROT
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

