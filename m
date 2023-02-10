Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD28C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjBJA4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjBJAy7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763116F206
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1211F61BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B59C433D2;
        Fri, 10 Feb 2023 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990437;
        bh=TKea2JWfNMlwmlFufEU3iv/h/co3qGVnDoXgJ77C8po=;
        h=Date:To:From:Subject:From;
        b=KWZD/oZ38G6QbEhdePPqenPAVtd2ENRkFgy1jvoR8gR8PpbgMJxQSXG9JaeHq41j+
         dxuvP9OCCpxODoRuaptW9IZSZj/Au5yUkCjh14mJCjoitwge++ov9lUCx34h7IZMOO
         WykFmXQ+u/vgYRJx29EbaeTHOgg48wa6CHpOu/r4=
Date:   Thu, 09 Feb 2023 16:53:56 -0800
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
Subject: [merged mm-stable] arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch removed from -mm tree
Message-Id: <20230210005357.65B59C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm: include asm-generic/memory_model.h from page.h rather than memory.h
has been removed from the -mm tree.  Its filename was
     arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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

 arch/arm/include/asm/memory.h |    2 --
 arch/arm/include/asm/page.h   |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

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


