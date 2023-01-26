Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093F7C61D97
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjAZAgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbjAZAgO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:36:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD774A237
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FA04CE2272
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C8CC433EF;
        Thu, 26 Jan 2023 00:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693369;
        bh=F2YRAwAApjoKrwcPGQ6r5HCqgm1+ibUczCeeXz4ZlLU=;
        h=Date:To:From:Subject:From;
        b=acIp+tbFmppFZxVmeaxPIv+ccGbMZhjlL/ush3ZH5j0/0FNun0RXMsjOkedlDpH6Z
         QrY2o34N0Pkit5fRYd3NztmUMYfE56AbcDeTDcP2mLAGtuNUin7TG6ZzEqLUwV0Xmz
         WE5aY1PQMKoyAd2XRfPHqaG6kLqj16AEUGJ5L4F4=
Date:   Wed, 25 Jan 2023 16:36:08 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vgupta@kernel.org, tsbogend@alpha.franken.de, shorne@gmail.com,
        richard@nod.at, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mattst88@gmail.com, kernel@xen0n.name,
        jcmvbkbc@gmail.com, guoren@kernel.org, gerg@linux-m68k.org,
        geert@linux-m68k.org, dinguyen@kernel.org, deller@gmx.de,
        davem@davemloft.net, dalias@libc.org, chenhuacai@kernel.org,
        bcain@quicinc.com, arnd@arndb.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch added to mm-unstable branch
Message-Id: <20230126003609.64C8CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: use asm-generic/memory_model.h for both MMU and !MMU
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: m68k: use asm-generic/memory_model.h for both MMU and !MMU
Date: Wed, 25 Jan 2023 21:07:55 +0200

Patch series "mm, arch: add generic implementation of pfn_valid() for
FLATMEM".

Every architecture that supports FLATMEM memory model defines its own
version of pfn_valid() that essentially compares a pfn to max_mapnr.

Use mips/powerpc version implemented as static inline as a generic
implementation of pfn_valid() and drop its per-architecture definitions


This patch (of 3):

The MMU variant uses generic definitions of page_to_pfn() and
pfn_to_page(), but !MMU defines them in include/asm/page_no.h for no good
reason.

Include asm-generic/memory_model.h in the common include/asm/page.h and
drop redundant definitions.

Link: https://lkml.kernel.org/r/20230125190757.22555-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230125190757.22555-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/page.h~m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu
+++ a/arch/m68k/include/asm/page.h
@@ -62,11 +62,7 @@ extern unsigned long _ramend;
 #include <asm/page_no.h>
 #endif
 
-#ifndef CONFIG_MMU
-#define __phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
-#define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
-#endif
-
 #include <asm-generic/getorder.h>
+#include <asm-generic/memory_model.h>
 
 #endif /* _M68K_PAGE_H */
--- a/arch/m68k/include/asm/page_mm.h~m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu
+++ a/arch/m68k/include/asm/page_mm.h
@@ -134,7 +134,6 @@ extern int m68k_virt_to_node_shift;
 })
 
 #define ARCH_PFN_OFFSET (m68k_memory[0].addr >> PAGE_SHIFT)
-#include <asm-generic/memory_model.h>
 
 #define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && (unsigned long)(kaddr) < (unsigned long)high_memory)
 #define pfn_valid(pfn)		virt_addr_valid(pfn_to_virt(pfn))
--- a/arch/m68k/include/asm/page_no.h~m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu
+++ a/arch/m68k/include/asm/page_no.h
@@ -25,8 +25,6 @@ extern unsigned long memory_end;
 #define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
 #define page_to_virt(page)	__va(((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET))
 
-#define pfn_to_page(pfn)	virt_to_page(pfn_to_virt(pfn))
-#define page_to_pfn(page)	virt_to_pfn(page_to_virt(page))
 #define pfn_valid(pfn)	        ((pfn) < max_mapnr)
 
 #define	virt_addr_valid(kaddr)	(((unsigned long)(kaddr) >= PAGE_OFFSET) && \
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

