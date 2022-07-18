Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BFFC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiGRAUc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiGRATI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869113F72
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7986D60F49
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12CCC341C0;
        Mon, 18 Jul 2022 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103485;
        bh=FLXq0c0HcDM3AziIhB54fV9NlPWtIeymdaK0aCP6YX8=;
        h=Date:To:From:Subject:From;
        b=yGOgihHhDjeVFssOIhu19d8BSoWfdIkCJAxqSlX6jut2NZlLVwIyXwbQRJ7bPeBR9
         qQH67MbMk9pWEEJO7/+4rhPMj5SiFi9+Gq5FQX376cYHhXFQyMXxdPURXF5bZhkKvP
         xRq8h+lqdIw3oDtrjc4ioQIl19ioh6zO/l09JF+c=
Date:   Sun, 17 Jul 2022 17:18:05 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        will@kernel.org, vgupta@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, shorne@gmail.com, sam@ravnborg.org,
        rth@twiddle.net, paul.walmsley@sifive.com, paulus@samba.org,
        palmer@dabbelt.com, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, linux@armlinux.org.uk,
        kernel@xen0n.name, jonas@southpole.se, jdike@addtoit.com,
        James.Bottomley@HansenPartnership.com, hch@lst.de,
        hch@infradead.org, hca@linux.ibm.com, guoren@kernel.org,
        gor@linux.ibm.com, geert@linux-m68k.org, dinguyen@kernel.org,
        davem@davemloft.net, dalias@libc.org, chris@zankel.net,
        christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
        catalin.marinas@arm.com, bcain@quicinc.com, arnd@arndb.de,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220718001805.C12CCC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     sh-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: sh/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Mon, 11 Jul 2022 12:35:59 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220711070600.2378316-26-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig               |    1 +
 arch/sh/include/asm/pgtable.h |   17 -----------------
 arch/sh/mm/mmap.c             |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 17 deletions(-)

--- a/arch/sh/include/asm/pgtable.h~sh-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sh/include/asm/pgtable.h
@@ -89,23 +89,6 @@ static inline unsigned long phys_addr_ma
  * completely separate permission bits for user and kernel space.
  */
 	 /*xwr*/
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_EXECREAD
-#define __P101	PAGE_EXECREAD
-#define __P110	PAGE_COPY
-#define __P111	PAGE_COPY
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_WRITEONLY
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_EXECREAD
-#define __S101	PAGE_EXECREAD
-#define __S110	PAGE_RWX
-#define __S111	PAGE_RWX
 
 typedef pte_t *pte_addr_t;
 
--- a/arch/sh/Kconfig~sh-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sh/Kconfig
@@ -12,6 +12,7 @@ config SUPERH
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
--- a/arch/sh/mm/mmap.c~sh-mm-enable-arch_has_vm_get_page_prot
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
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


