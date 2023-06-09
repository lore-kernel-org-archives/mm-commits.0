Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB799C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjFIXNM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXNL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:13:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6812733
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFAB61411
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC93C433D2;
        Fri,  9 Jun 2023 23:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352389;
        bh=xwFIhTUgaSwrc3EWSN8Jr3rRN5jWis95tW+/KbmdJ4U=;
        h=Date:To:From:Subject:From;
        b=VXImL+aeDvNxJYGnfjbdDA21gku+jX7u1NP0shLZZbJtM9CdtPBIDJ9huq/aS37/W
         Zys7eM0RXKreJa7NiiuGKXn/iiRaooBvVf5jT3idJ843uqy965kwzZ/nix1coabh0x
         d8J1XF94LysG5Ne1hljDPce6edvtVSjuGNZmdE7U=
Date:   Fri, 09 Jun 2023 16:13:08 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        richard.henderson@linaro.org, npiggin@gmail.com,
        mpe@ellerman.id.au, monstr@monstr.eu, mattst88@gmail.com,
        linux@armlinux.org.uk, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hca@linux.ibm.com, hannes@cmpxchg.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org, deller@gmx.de,
        davem@davemloft.net, dalias@libc.org, chris@zankel.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, arnd@arndb.de, agordeev@linux.ibm.com,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] cachestat-wire-up-cachestat-for-other-architectures-fix.patch removed from -mm tree
Message-Id: <20230609231309.7FC93C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: wire up cachestat for arm64
has been removed from the -mm tree.  Its filename was
     cachestat-wire-up-cachestat-for-other-architectures-fix.patch

This patch was dropped because it was folded into cachestat-wire-up-cachestat-for-other-architectures.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: arm64: wire up cachestat for arm64
Date: Thu, 11 May 2023 02:28:43 -0700

cachestat is a new syscall that was previously wired in for most
architectures:

https://lore.kernel.org/lkml/20230503013608.2431726-1-nphamcs@gmail.com/
https://lore.kernel.org/linux-mm/20230510195806.2902878-1-nphamcs@gmail.com/

However, those patches miss arm64, which has its own syscall table in
arch/arm64.  This patch wires cachestat in for arm64's compat layer. 
Native support uses the generic syscall numbers already.

Link: https://lkml.kernel.org/r/20230511092843.3896327-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd.h   |    2 +-
 arch/arm64/include/asm/unistd32.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/unistd32.h~cachestat-wire-up-cachestat-for-other-architectures-fix
+++ a/arch/arm64/include/asm/unistd32.h
@@ -907,6 +907,8 @@ __SYSCALL(__NR_process_mrelease, sys_pro
 __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
 #define __NR_set_mempolicy_home_node 450
 __SYSCALL(__NR_set_mempolicy_home_node, sys_set_mempolicy_home_node)
+#define __NR_cachestat 451
+__SYSCALL(__NR_cachestat, sys_cachestat)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~cachestat-wire-up-cachestat-for-other-architectures-fix
+++ a/arch/arm64/include/asm/unistd.h
@@ -39,7 +39,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		451
+#define __NR_compat_syscalls		452
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
_

Patches currently in -mm which might be from nphamcs@gmail.com are

workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
cachestat-implement-cachestat-syscall.patch
cachestat-wire-up-cachestat-for-other-architectures.patch
selftests-add-selftests-for-cachestat.patch

