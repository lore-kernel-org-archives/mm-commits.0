Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C1CCCA479
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGBAIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiGBAHy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8369372EE2
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44ACDB8326E
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83D0C3411E;
        Sat,  2 Jul 2022 00:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720470;
        bh=e4re9BNG2qp7+9gZ/WcHFTpYAI2foVAIsUdcuDwh+Jk=;
        h=Date:To:From:Subject:From;
        b=xqcHdqR8CTx21JlBSCk06UuYp9o69102tCtx8dxJJIp9NlkMt0IGWsT6ZfafwvA1D
         TCCLSXDl8cT41PqHlnRbEQyDrTgDWXTSnMQnRKOK8eNaL/OwZM0kusAgzGt1l8W9Ek
         zJtGcNxlgx4dV+/DlhVywLPhBHCJhQYV6HmUpkxM=
Date:   Fri, 01 Jul 2022 17:07:50 -0700
To:     mm-commits@vger.kernel.org, vgupta@kernel.org,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arc-mm-enable-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000750.D83D0C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     arc-mm-enable-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arc-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: arc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:26 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220630051630.1718927-23-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig                          |    1 +
 arch/arc/include/asm/pgtable-bits-arcv2.h |   18 ------------------
 arch/arc/mm/mmap.c                        |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 18 deletions(-)

--- a/arch/arc/include/asm/pgtable-bits-arcv2.h~arc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arc/include/asm/pgtable-bits-arcv2.h
@@ -72,24 +72,6 @@
  *     This is to enable COW mechanism
  */
 	/* xwr */
-#define __P000  PAGE_U_NONE
-#define __P001  PAGE_U_R
-#define __P010  PAGE_U_R	/* Pvt-W => !W */
-#define __P011  PAGE_U_R	/* Pvt-W => !W */
-#define __P100  PAGE_U_X_R	/* X => R */
-#define __P101  PAGE_U_X_R
-#define __P110  PAGE_U_X_R	/* Pvt-W => !W and X => R */
-#define __P111  PAGE_U_X_R	/* Pvt-W => !W */
-
-#define __S000  PAGE_U_NONE
-#define __S001  PAGE_U_R
-#define __S010  PAGE_U_W_R	/* W => R */
-#define __S011  PAGE_U_W_R
-#define __S100  PAGE_U_X_R	/* X => R */
-#define __S101  PAGE_U_X_R
-#define __S110  PAGE_U_X_W_R	/* X => R */
-#define __S111  PAGE_U_X_W_R
-
 #ifndef __ASSEMBLY__
 
 #define pte_write(pte)		(pte_val(pte) & _PAGE_WRITE)
--- a/arch/arc/Kconfig~arc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arc/Kconfig
@@ -13,6 +13,7 @@ config ARC
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_SUPPORTS_ATOMIC_RMW if ARC_HAS_LLSC
 	select ARCH_32BIT_OFF_T
 	select BUILDTIME_TABLE_SORT
--- a/arch/arc/mm/mmap.c~arc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arc/mm/mmap.c
@@ -74,3 +74,23 @@ arch_get_unmapped_area(struct file *filp
 	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
+
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_U_NONE,
+	[VM_READ]					= PAGE_U_R,
+	[VM_WRITE]					= PAGE_U_R,
+	[VM_WRITE | VM_READ]				= PAGE_U_R,
+	[VM_EXEC]					= PAGE_U_X_R,
+	[VM_EXEC | VM_READ]				= PAGE_U_X_R,
+	[VM_EXEC | VM_WRITE]				= PAGE_U_X_R,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_U_X_R,
+	[VM_SHARED]					= PAGE_U_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_U_R,
+	[VM_SHARED | VM_WRITE]				= PAGE_U_W_R,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_U_W_R,
+	[VM_SHARED | VM_EXEC]				= PAGE_U_X_R,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_U_X_R,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_U_X_W_R,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_U_X_W_R
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

