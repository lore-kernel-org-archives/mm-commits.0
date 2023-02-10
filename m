Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6743CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjBJA4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjBJAy7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C296F22F
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A34A4B82397
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57712C433D2;
        Fri, 10 Feb 2023 00:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990439;
        bh=oIZmxrVSKuS4F6vcwRyzVQOfGARhxgF4iIdOReApIWI=;
        h=Date:To:From:Subject:From;
        b=DmCYCwN43kjvV63QkHA/pbQOCLsI+qIVbQbp7tXc9feYQRlre4YUYCJ4YZMOrfg2d
         81rWlqxO+uk7wpMrZbecHKaE4q0M96juFxR9U3IxuI4h2LLEwTlk9HkpmeXbDrvMnx
         +eSPezPPU2iaY3jXrSZeDX6jEx5Auh4LBQfuKGYc=
Date:   Thu, 09 Feb 2023 16:53:58 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vgupta@kernel.org, tsbogend@alpha.franken.de, shorne@gmail.com,
        richard@nod.at, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mattst88@gmail.com, linux@armlinux.org.uk,
        kernel@xen0n.name, jcmvbkbc@gmail.com, guoren@kernel.org,
        gerg@linux-m68k.org, geert@linux-m68k.org, dinguyen@kernel.org,
        deller@gmx.de, david@redhat.com, davem@davemloft.net,
        dalias@libc.org, chenhuacai@loongson.cn, chenhuacai@kernel.org,
        bcain@quicinc.com, arnd@arndb.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch removed from -mm tree
Message-Id: <20230210005359.57712C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k: use asm-generic/memory_model.h for both MMU and !MMU
has been removed from the -mm tree.  Its filename was
     m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: m68k: use asm-generic/memory_model.h for both MMU and !MMU
Date: Sun, 29 Jan 2023 14:42:33 +0200

The MMU variant uses generic definitions of page_to_pfn() and
pfn_to_page(), but !MMU defines them in include/asm/page_no.h for no good
reason.

Include asm-generic/memory_model.h in the common include/asm/page.h and
drop redundant definitions.

Link: https://lkml.kernel.org/r/20230129124235.209895-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page.h    |    6 +-----
 arch/m68k/include/asm/page_mm.h |    1 -
 arch/m68k/include/asm/page_no.h |    2 --
 3 files changed, 1 insertion(+), 8 deletions(-)

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


