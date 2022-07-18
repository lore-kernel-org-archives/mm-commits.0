Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90C3CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiGRATO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiGRASN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:18:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C2E13E1A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F8160EED
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D5CC3411E;
        Mon, 18 Jul 2022 00:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103458;
        bh=uHdSt5rsiaUzu34nHyB6ekBTykQrQa6rDX2o9N0i/ow=;
        h=Date:To:From:Subject:From;
        b=PwWiWJtiFqag3w3wyvH1u/bfvZTBRFRzv03Mq1TSMG8ExAZuSg1kMGznH09sUOGFe
         FBEe4a4p/zA79l02ZEQP5EVIr04CD955i/vyzFKnLMOS9fmA8+kiU6pfuS6Z7XsF11
         bxeei/Y8lZ9DODKFuG9XD7ZpywF5S4wHbNWJMUnI=
Date:   Sun, 17 Jul 2022 17:17:37 -0700
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
Subject: [merged mm-stable] mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220718001738.80D5CC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: build protect protection_map[] with ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: build protect protection_map[] with ARCH_HAS_VM_GET_PAGE_PROT
Date: Mon, 11 Jul 2022 12:35:41 +0530

Now that protection_map[] has been moved inside those platforms that
enable ARCH_HAS_VM_GET_PAGE_PROT.  Hence generic protection_map[] array
now can be protected with CONFIG_ARCH_HAS_VM_GET_PAGE_PROT intead of
__P000.

Link: https://lkml.kernel.org/r/20220711070600.2378316-8-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 include/linux/mm.h |    2 +-
 mm/mmap.c          |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot
+++ a/include/linux/mm.h
@@ -425,7 +425,7 @@ extern unsigned int kobjsize(const void
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
-#ifdef __P000
+#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 extern pgprot_t protection_map[16];
 #endif
 
--- a/mm/mmap.c~mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot
+++ a/mm/mmap.c
@@ -81,7 +81,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
 
-#ifdef __P000
+#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 pgprot_t protection_map[16] __ro_after_init = {
 	[VM_NONE]					= __P000,
 	[VM_READ]					= __P001,
@@ -100,9 +100,6 @@ pgprot_t protection_map[16] __ro_after_i
 	[VM_SHARED | VM_EXEC | VM_WRITE]		= __S110,
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __S111
 };
-#endif
-
-#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 DECLARE_VM_GET_PAGE_PROT
 #endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


