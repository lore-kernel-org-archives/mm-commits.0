Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696BFCCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiGRATP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiGRARw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D4D13DDD
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05F4460F0B
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0C8C3411E;
        Mon, 18 Jul 2022 00:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103449;
        bh=COTDJWak4ksJLSRUmU78Wg5ibnalL7EzED4xkT7CdV4=;
        h=Date:To:From:Subject:From;
        b=Mj3lQc7hHORVrlLmj8087Kf3byb5JGa1zqrm+fIFWy8HvUEt1KnvXTeA9Gm1ay6+J
         eb5CUpQ1DzhZzq1GT7F8XV7eZXcoqH3dB0Z44t29p1gLO7T16i7ZncfKXj8pRRTQBj
         GPHza7UhxUXmSsc+TUcF776dEwh6Xtg5z+q0HgxA=
Date:   Sun, 17 Jul 2022 17:17:28 -0700
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
Subject: [merged mm-stable] mm-mmap-build-protect-protection_map-with-__p000.patch removed from -mm tree
Message-Id: <20220718001729.4E0C8C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: build protect protection_map[] with __P000
has been removed from the -mm tree.  Its filename was
     mm-mmap-build-protect-protection_map-with-__p000.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: build protect protection_map[] with __P000
Date: Mon, 11 Jul 2022 12:35:35 +0530

Patch series "mm/mmap: Drop __SXXX/__PXXX macros from across platforms",
v7.

__SXXX/__PXXX macros are unnecessary abstraction layer in creating the
generic protection_map[] array which is used for vm_get_page_prot().  This
abstraction layer can be avoided, if the platforms just define the array
protection_map[] for all possible vm_flags access permission combinations
and also export vm_get_page_prot() implementation.

This series drops __SXXX/__PXXX macros from across platforms in the tree. 
First it build protects generic protection_map[] array with '#ifdef
__P000' and moves it inside platforms which enable
ARCH_HAS_VM_GET_PAGE_PROT.  Later this build protects same array with
'#ifdef ARCH_HAS_VM_GET_PAGE_PROT' and moves inside remaining platforms
while enabling ARCH_HAS_VM_GET_PAGE_PROT.  This adds a new macro
DECLARE_VM_GET_PAGE_PROT defining the current generic vm_get_page_prot(),
in order for it to be reused on platforms that do not require custom
implementation.  Finally, ARCH_HAS_VM_GET_PAGE_PROT can just be dropped,
as all platforms now define and export vm_get_page_prot(), via looking up
a private and static protection_map[] array.  protection_map[] data type
has been changed as 'static const' on all platforms that do not change it
during boot.


This patch (of 26):

Build protect generic protection_map[] array with __P000, so that it can
be moved inside all the platforms one after the other.  Otherwise there
will be build failures during this process. 
CONFIG_ARCH_HAS_VM_GET_PAGE_PROT cannot be used for this purpose as only
certain platforms enable this config now.

Link: https://lkml.kernel.org/r/20220711070600.2378316-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20220711070600.2378316-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
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

 include/linux/mm.h |    2 ++
 mm/mmap.c          |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/mm.h~mm-mmap-build-protect-protection_map-with-__p000
+++ a/include/linux/mm.h
@@ -425,7 +425,9 @@ extern unsigned int kobjsize(const void
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
+#ifdef __P000
 extern pgprot_t protection_map[16];
+#endif
 
 /*
  * The default fault flags that should be used by most of the
--- a/mm/mmap.c~mm-mmap-build-protect-protection_map-with-__p000
+++ a/mm/mmap.c
@@ -101,6 +101,7 @@ static void unmap_region(struct mm_struc
  *								w: (no) no
  *								x: (yes) yes
  */
+#ifdef __P000
 pgprot_t protection_map[16] __ro_after_init = {
 	[VM_NONE]					= __P000,
 	[VM_READ]					= __P001,
@@ -119,6 +120,7 @@ pgprot_t protection_map[16] __ro_after_i
 	[VM_SHARED | VM_EXEC | VM_WRITE]		= __S110,
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __S111
 };
+#endif
 
 #ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


