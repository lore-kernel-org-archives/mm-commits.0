Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8696DC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jul 2022 20:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiGFUee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jul 2022 16:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiGFUee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2022 16:34:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2777D248CD
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 13:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F43DB81EDB
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 20:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42063C3411C;
        Wed,  6 Jul 2022 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657139670;
        bh=ZBbyaXAD2CrmhMm7sFrCTwkNNrSeOOMUgWmKjmTw55Y=;
        h=Date:To:From:Subject:From;
        b=nHYFfNbyXCfjjrQSTssYiyyhdnAa5S0y7OIk0qy0I3qGjXORfUNu5GV9QcqOSObq/
         xRH4DNHMqn+NyzIicrcUVw2FlrKCh1mTKO45PBhdr5NtIsOlNCUS1WSG0I3AmAIzFr
         C1Jw/GqGBDx2YjRKt7BHCUZWxCOUt2LHZZ0M3+cw=
Date:   Wed, 06 Jul 2022 13:34:29 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        dalias@libc.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-enable-arch_has_vm_get_page_prot-fix.patch added to mm-unstable branch
Message-Id: <20220706203430.42063C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: noMMU: fix vm_get_page_prot definition
has been added to the -mm mm-unstable branch.  Its filename is
     sh-mm-enable-arch_has_vm_get_page_prot-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-enable-arch_has_vm_get_page_prot-fix.patch

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
Subject: sh: noMMU: fix vm_get_page_prot definition
Date: Wed, 6 Jul 2022 11:10:02 +0530

Don't define protection_map and don't use DECLARE_VM_GET_PAGE_PROT in
noMMU configs, because in that case the definition for vm_get_page_prot is
provided by the include/linux/mm.h

Link: https://lkml.kernel.org/r/20220706054002.1936820-1-anshuman.khandual@arm.com
Fixes: 03a92d45899c ("sh/mm: enable ARCH_HAS_VM_GET_PAGE_PROT")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/mmap.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/arch/sh/mm/mmap.c~sh-mm-enable-arch_has_vm_get_page_prot-fix
+++ a/arch/sh/mm/mmap.c
@@ -19,6 +19,26 @@ unsigned long shm_align_mask = PAGE_SIZE
 EXPORT_SYMBOL(shm_align_mask);
 
 #ifdef CONFIG_MMU
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= PAGE_READONLY,
+	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE | VM_READ]				= PAGE_COPY,
+	[VM_EXEC]					= PAGE_EXECREAD,
+	[VM_EXEC | VM_READ]				= PAGE_EXECREAD,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY,
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_READONLY,
+	[VM_SHARED | VM_WRITE]				= PAGE_WRITEONLY,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC]				= PAGE_EXECREAD,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_EXECREAD,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_RWX,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_RWX
+};
+DECLARE_VM_GET_PAGE_PROT
+
 /*
  * To avoid cache aliases, we map the shared page with same color.
  */
@@ -162,23 +182,3 @@ int valid_mmap_phys_addr_range(unsigned
 {
 	return 1;
 }
-
-static const pgprot_t protection_map[16] = {
-	[VM_NONE]					= PAGE_NONE,
-	[VM_READ]					= PAGE_READONLY,
-	[VM_WRITE]					= PAGE_COPY,
-	[VM_WRITE | VM_READ]				= PAGE_COPY,
-	[VM_EXEC]					= PAGE_EXECREAD,
-	[VM_EXEC | VM_READ]				= PAGE_EXECREAD,
-	[VM_EXEC | VM_WRITE]				= PAGE_COPY,
-	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY,
-	[VM_SHARED]					= PAGE_NONE,
-	[VM_SHARED | VM_READ]				= PAGE_READONLY,
-	[VM_SHARED | VM_WRITE]				= PAGE_WRITEONLY,
-	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED,
-	[VM_SHARED | VM_EXEC]				= PAGE_EXECREAD,
-	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_EXECREAD,
-	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_RWX,
-	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_RWX
-};
-DECLARE_VM_GET_PAGE_PROT
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
sh-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch

