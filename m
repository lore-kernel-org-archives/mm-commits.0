Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BEAC05027
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 22:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbjA2WXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 17:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbjA2WXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 17:23:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A717C11E8F
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 14:23:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08B60CE106E
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 22:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C9BC433EF;
        Sun, 29 Jan 2023 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675030979;
        bh=CVMjnduguMQyGs1qZX8ANrMQ6hYzmGwk+B1wNAAhP1M=;
        h=Date:To:From:Subject:From;
        b=O1ZvLjy13f8OhUHojZ5WRgpaUKbbxJ0AjrPuZSNgCiLBgEw0lX/41quz8fayTlaQP
         /QaOaoBJ2aFn/cvEOjFcZoWR6UtIJfPn2BuRbPU6hMMzn56C2u0mwSHD0tXuAYykaM
         BRe4XA7PkeXA7OX/GMl2GzIbWgh9lSMa5Q7XEaho=
Date:   Sun, 29 Jan 2023 14:22:58 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vgupta@kernel.org, tsbogend@alpha.franken.de, shorne@gmail.com,
        richard@nod.at, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mattst88@gmail.com, linux@armlinux.org.uk,
        kernel@xen0n.name, jcmvbkbc@gmail.com, guoren@kernel.org,
        gerg@linux-m68k.org, geert@linux-m68k.org, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        chenhuacai@loongson.cn, chenhuacai@kernel.org, bcain@quicinc.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-drop-definition-of-pfn_valid-for-discontigmem.patch added to mm-unstable branch
Message-Id: <20230129222259.18C9BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: drop definition of pfn_valid() for DISCONTIGMEM
has been added to the -mm mm-unstable branch.  Its filename is
     mips-drop-definition-of-pfn_valid-for-discontigmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-drop-definition-of-pfn_valid-for-discontigmem.patch

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
Subject: mips: drop definition of pfn_valid() for DISCONTIGMEM
Date: Sun, 29 Jan 2023 14:42:34 +0200

There is a stale definition of pfn_valid() for DISCONTINGMEM memory model
guarded !FLATMEM && !SPARSEMEM && NUMA ifdefery.

Remove everything but definition of pfn_valid() for FLATMEM.

Link: https://lkml.kernel.org/r/20230129124235.209895-4-rppt@kernel.org
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


--- a/arch/mips/include/asm/page.h~mips-drop-definition-of-pfn_valid-for-discontigmem
+++ a/arch/mips/include/asm/page.h
@@ -235,21 +235,6 @@ static inline int pfn_valid(unsigned lon
 	return pfn >= pfn_offset && pfn < max_mapnr;
 }
 
-#elif defined(CONFIG_SPARSEMEM)
-
-/* pfn_valid is defined in linux/mmzone.h */
-
-#elif defined(CONFIG_NUMA)
-
-#define pfn_valid(pfn)							\
-({									\
-	unsigned long __pfn = (pfn);					\
-	int __n = pfn_to_nid(__pfn);					\
-	((__n >= 0) ? (__pfn < NODE_DATA(__n)->node_start_pfn +		\
-			       NODE_DATA(__n)->node_spanned_pages)	\
-		    : 0);						\
-})
-
 #endif
 
 #define virt_to_pfn(kaddr)   	PFN_DOWN(virt_to_phys((void *)(kaddr)))
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch
arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

