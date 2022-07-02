Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CE4C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGBAHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiGBAH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6727B443E6
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01B46624F7
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A6FC3411E;
        Sat,  2 Jul 2022 00:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720445;
        bh=Vnfph3ckybgXVQf8zPaTsNwfrYjTEeZZUq6MoDA8mAE=;
        h=Date:To:From:Subject:From;
        b=W215vAeF1ujT+8KQVx+Kf2aFtnnk29sB+/WDogFwwd6482t0A3yfIYnxJJNhMNvxt
         0MAlCcbZd9QONMukx+j+y4ZzD3MaRhNgKTEiBmkgUorwI21eL/Fs86SOX0nzk7IzF+
         xscPBF+bo960s96swCbEQuMAPp0xFmjR0A7NWB6A=
Date:   Fri, 01 Jul 2022 17:07:24 -0700
To:     mm-commits@vger.kernel.org, bcain@quicinc.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-mm-enable-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000725.55A6FC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     hexagon-mm-enable-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: hexagon/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:16 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220630051630.1718927-13-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/Kconfig               |    1 
 arch/hexagon/include/asm/pgtable.h |   27 -----------------
 arch/hexagon/mm/init.c             |   42 +++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 27 deletions(-)

--- a/arch/hexagon/include/asm/pgtable.h~hexagon-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -126,33 +126,6 @@ extern unsigned long _dflt_cache_att;
  */
 #define CACHEDEF	(CACHE_DEFAULT << 6)
 
-/* Private (copy-on-write) page protections. */
-#define __P000 __pgprot(_PAGE_PRESENT | _PAGE_USER | CACHEDEF)
-#define __P001 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | CACHEDEF)
-#define __P010 __P000	/* Write-only copy-on-write */
-#define __P011 __P001	/* Read/Write copy-on-write */
-#define __P100 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
-			_PAGE_EXECUTE | CACHEDEF)
-#define __P101 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_EXECUTE | \
-			_PAGE_READ | CACHEDEF)
-#define __P110 __P100	/* Write/execute copy-on-write */
-#define __P111 __P101	/* Read/Write/Execute, copy-on-write */
-
-/* Shared page protections. */
-#define __S000 __P000
-#define __S001 __P001
-#define __S010 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
-			_PAGE_WRITE | CACHEDEF)
-#define __S011 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | \
-			_PAGE_WRITE | CACHEDEF)
-#define __S100 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
-			_PAGE_EXECUTE | CACHEDEF)
-#define __S101 __P101
-#define __S110 __pgprot(_PAGE_PRESENT | _PAGE_USER | \
-			_PAGE_EXECUTE | _PAGE_WRITE | CACHEDEF)
-#define __S111 __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_READ | \
-			_PAGE_EXECUTE | _PAGE_WRITE | CACHEDEF)
-
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];  /* located in head.S */
 
 /*  HUGETLB not working currently  */
--- a/arch/hexagon/Kconfig~hexagon-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/hexagon/Kconfig
@@ -6,6 +6,7 @@ config HEXAGON
 	def_bool y
 	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_PREEMPT
 	select DMA_GLOBAL_POOL
 	# Other pending projects/to-do items.
--- a/arch/hexagon/mm/init.c~hexagon-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/hexagon/mm/init.c
@@ -234,3 +234,45 @@ void __init setup_arch_memory(void)
 	 *  which is called by start_kernel() later on in the process
 	 */
 }
+
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   CACHEDEF),
+	[VM_READ]					= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_READ | CACHEDEF),
+	[VM_WRITE]					= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   CACHEDEF),
+	[VM_WRITE | VM_READ]				= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_READ | CACHEDEF),
+	[VM_EXEC]					= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | CACHEDEF),
+	[VM_EXEC | VM_READ]				= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | _PAGE_READ |
+								   CACHEDEF),
+	[VM_EXEC | VM_WRITE]				= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | CACHEDEF),
+	[VM_EXEC | VM_WRITE | VM_READ]			= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | _PAGE_READ |
+								   CACHEDEF),
+	[VM_SHARED]                                     = __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   CACHEDEF),
+	[VM_SHARED | VM_READ]				= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_READ | CACHEDEF),
+	[VM_SHARED | VM_WRITE]				= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_WRITE | CACHEDEF),
+	[VM_SHARED | VM_WRITE | VM_READ]		= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_READ | _PAGE_WRITE |
+								   CACHEDEF),
+	[VM_SHARED | VM_EXEC]				= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | CACHEDEF),
+	[VM_SHARED | VM_EXEC | VM_READ]			= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | _PAGE_READ |
+								   CACHEDEF),
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_EXECUTE | _PAGE_WRITE |
+								   CACHEDEF),
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __pgprot(_PAGE_PRESENT | _PAGE_USER |
+								   _PAGE_READ | _PAGE_EXECUTE |
+								   _PAGE_WRITE | CACHEDEF)
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

