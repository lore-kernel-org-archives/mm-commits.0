Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76039C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiGRATT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiGRASN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:18:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B221277C
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7507CB80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118F9C341CA;
        Mon, 18 Jul 2022 00:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103463;
        bh=VOh1fpYf66QFsXZShuBvQollXhUmEzgtfmuAhDNzXLo=;
        h=Date:To:From:Subject:From;
        b=hpiHSWwJAuG/j92AqVukvJxYGtan9Hl9CrNLaj3k87k2HAQnn3OchGf9LdBAFmKOr
         BwA9zOWgNyKg1Xopb1INlLrQ/2hCRUMeGkGf5uHHbVxB/sVboUsmCWYLkNv46ni3/I
         gNre9D8e+21kwRqOWOwlVbquORNzrHlHZgT7ZzCU=
Date:   Sun, 17 Jul 2022 17:17:42 -0700
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
Subject: [merged mm-stable] openrisc-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220718001743.118F9C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: openrisc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     openrisc-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: openrisc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Mon, 11 Jul 2022 12:35:44 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220711070600.2378316-11-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
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
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/Kconfig               |    1 +
 arch/openrisc/include/asm/pgtable.h |   18 ------------------
 arch/openrisc/mm/init.c             |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 18 deletions(-)

--- a/arch/openrisc/include/asm/pgtable.h~openrisc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -176,24 +176,6 @@ extern void paging_init(void);
 	__pgprot(_PAGE_ALL | _PAGE_SRE | _PAGE_SWE \
 		 | _PAGE_SHARED | _PAGE_DIRTY | _PAGE_EXEC | _PAGE_CI)
 
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY_X
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY_X
-#define __P100	PAGE_READONLY
-#define __P101	PAGE_READONLY_X
-#define __P110	PAGE_COPY
-#define __P111	PAGE_COPY_X
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY_X
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED_X
-#define __S100	PAGE_READONLY
-#define __S101	PAGE_READONLY_X
-#define __S110	PAGE_SHARED
-#define __S111	PAGE_SHARED_X
-
 /* zero page used for uninitialized stuff */
 extern unsigned long empty_zero_page[2048];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
--- a/arch/openrisc/Kconfig~openrisc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/openrisc/Kconfig
@@ -10,6 +10,7 @@ config OPENRISC
 	select ARCH_HAS_DMA_SET_UNCACHED
 	select ARCH_HAS_DMA_CLEAR_UNCACHED
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select COMMON_CLK
 	select OF
 	select OF_EARLY_FLATTREE
--- a/arch/openrisc/mm/init.c~openrisc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/openrisc/mm/init.c
@@ -208,3 +208,23 @@ void __init mem_init(void)
 	mem_init_done = 1;
 	return;
 }
+
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= PAGE_READONLY_X,
+	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE | VM_READ]				= PAGE_COPY_X,
+	[VM_EXEC]					= PAGE_READONLY,
+	[VM_EXEC | VM_READ]				= PAGE_READONLY_X,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_X,
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_READONLY_X,
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED_X,
+	[VM_SHARED | VM_EXEC]				= PAGE_READONLY,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_READONLY_X,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_X
+};
+DECLARE_VM_GET_PAGE_PROT
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


