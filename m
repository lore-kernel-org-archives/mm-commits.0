Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF41CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiGRAUE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiGRASO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAEC12AF0
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5607D60F42
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3314C3411E;
        Mon, 18 Jul 2022 00:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103470;
        bh=3zmGtnT5wa0J9r/rk58PUYmCYQxucDDjGATHmOdRcq0=;
        h=Date:To:From:Subject:From;
        b=otIGA7aDpCeHzIiIH7U9z/nZHMumxYFTxOW2lkEoL1zkrwUo9Xhn/nDk2aQctJPin
         61X+iFFZ6P4KwlGQJIggd58lKSg5ZphHMBrdDtaStHMWrPfJjlYxFyMwFrrMLKGzcJ
         /UYFEXql99lAwM5KtVxOxI1x67+3g0ZtpzoblEGI=
Date:   Sun, 17 Jul 2022 17:17:50 -0700
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
Subject: [merged mm-stable] nios2-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220718001750.A3314C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     nios2-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: nios2/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Mon, 11 Jul 2022 12:35:49 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220711070600.2378316-16-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
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
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/Kconfig               |    1 +
 arch/nios2/include/asm/pgtable.h |   16 ----------------
 arch/nios2/mm/init.c             |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 16 deletions(-)

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
@@ -124,3 +124,23 @@ const char *arch_vma_name(struct vm_area
 {
 	return (vma->vm_start == KUSER_BASE) ? "[kuser]" : NULL;
 }
+
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= MKP(0, 0, 0),
+	[VM_READ]					= MKP(0, 0, 1),
+	[VM_WRITE]					= MKP(0, 0, 0),
+	[VM_WRITE | VM_READ]				= MKP(0, 0, 1),
+	[VM_EXEC]					= MKP(1, 0, 0),
+	[VM_EXEC | VM_READ]				= MKP(1, 0, 1),
+	[VM_EXEC | VM_WRITE]				= MKP(1, 0, 0),
+	[VM_EXEC | VM_WRITE | VM_READ]			= MKP(1, 0, 1),
+	[VM_SHARED]					= MKP(0, 0, 0),
+	[VM_SHARED | VM_READ]				= MKP(0, 0, 1),
+	[VM_SHARED | VM_WRITE]				= MKP(0, 1, 0),
+	[VM_SHARED | VM_WRITE | VM_READ]		= MKP(0, 1, 1),
+	[VM_SHARED | VM_EXEC]				= MKP(1, 0, 0),
+	[VM_SHARED | VM_EXEC | VM_READ]			= MKP(1, 0, 1),
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= MKP(1, 1, 0),
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= MKP(1, 1, 1)
+};
+DECLARE_VM_GET_PAGE_PROT
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


