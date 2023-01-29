Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28018C05027
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 22:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbjA2WXB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 17:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbjA2WW7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 17:22:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A5CB464
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 14:22:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD765B80DB9
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 22:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC40C433D2;
        Sun, 29 Jan 2023 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675030974;
        bh=pJMjJQkmbuPfOMzHi6K5AoppEmnFzP9cyxdx8JQAAwc=;
        h=Date:To:From:Subject:From;
        b=Q6AYK9xDQaOaQmFAtqNS8LnBRK3ho9LSWXzVc5zZxpqIMGgCCWo/0WVB8/6M/ptTK
         fW6+wcdUmfaCSdv8R4yGSC3p3UoS4eJFwtvn7Mxu4N8JePFAjxz5a0m/6dQDwMYOWw
         S6OIB8Ty+YUhpV3qSyy73FJc6oI0ZhEEV0BHYrFQ=
Date:   Sun, 29 Jan 2023 14:22:53 -0800
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
Subject: + arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch added to mm-unstable branch
Message-Id: <20230129222254.7DC40C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: include asm-generic/memory_model.h from page.h rather than memory.h
has been added to the -mm mm-unstable branch.  Its filename is
     arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch

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
Subject: arm: include asm-generic/memory_model.h from page.h rather than memory.h
Date: Sun, 29 Jan 2023 14:42:32 +0200

Patch series "mm, arch: add generic implementation of pfn_valid() for
FLATMEM", v2.

Every architecture that supports FLATMEM memory model defines its own
version of pfn_valid() that essentially compares a pfn to max_mapnr.

Use mips/powerpc version implemented as static inline as a generic
implementation of pfn_valid() and drop its per-architecture definitions


This patch (of 4):

Makes it consistent with other architectures and allows for generic
definition of pfn_valid() in asm-generic/memory_model.h with clear
override in arch/arm/include/asm/page.h

Link: https://lkml.kernel.org/r/20230129124235.209895-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230129124235.209895-2-rppt@kernel.org
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


--- a/arch/arm/include/asm/memory.h~arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh
+++ a/arch/arm/include/asm/memory.h
@@ -386,6 +386,4 @@ static inline unsigned long __virt_to_id
 
 #endif
 
-#include <asm-generic/memory_model.h>
-
 #endif
--- a/arch/arm/include/asm/page.h~arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh
+++ a/arch/arm/include/asm/page.h
@@ -158,6 +158,7 @@ typedef struct page *pgtable_t;
 
 #ifdef CONFIG_HAVE_ARCH_PFN_VALID
 extern int pfn_valid(unsigned long);
+#define pfn_valid pfn_valid
 #endif
 
 #include <asm/memory.h>
@@ -167,5 +168,6 @@ extern int pfn_valid(unsigned long);
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #include <asm-generic/getorder.h>
+#include <asm-generic/memory_model.h>
 
 #endif
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch
arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

