Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A273BC7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 03:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbjELDli (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 May 2023 23:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239829AbjELDl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2023 23:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C744ED2
        for <mm-commits@vger.kernel.org>; Thu, 11 May 2023 20:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8539164ED1
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 03:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0171C433EF;
        Fri, 12 May 2023 03:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683862885;
        bh=P16+IwVMtfyUPkqxgEWeldp6thsUUDBJzASKZEQzzWE=;
        h=Date:To:From:Subject:From;
        b=QNp1aisnbuscgjs6XlnjdRsIcIOaLN2ayGMQCPOKfRZQlui2Ar7Md012VM/ZRMGU9
         qK9o8bkRgmW+GRbbXANu3b+MXW0QlOiFvSQhGorFudA2iJkz5PvahTTDUtQVad3pIN
         xzVIFB5ENwQ+bBRz2VP5fBtiLXoUG957YWYQIJQs=
Date:   Thu, 11 May 2023 20:41:25 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        richard.henderson@linaro.org, npiggin@gmail.com,
        mpe@ellerman.id.au, monstr@monstr.eu, mattst88@gmail.com,
        linux@armlinux.org.uk, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hca@linux.ibm.com, hannes@cmpxchg.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org, deller@gmx.de,
        davem@davemloft.net, dalias@libc.org, chris@zankel.net,
        christophe.leroy@csgroup.eu, borntraeger@linux.ibm.com,
        arnd@arndb.de, agordeev@linux.ibm.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cachestat-wire-up-cachestat-for-other-architectures-fix.patch added to mm-unstable branch
Message-Id: <20230512034125.D0171C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: wire up cachestat for arm64
has been added to the -mm mm-unstable branch.  Its filename is
     cachestat-wire-up-cachestat-for-other-architectures-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cachestat-wire-up-cachestat-for-other-architectures-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: arm64: wire up cachestat for arm64
Date: Thu, 11 May 2023 02:28:43 -0700

cachestat is a new syscall that was previously wired in for most
architectures:

https://lore.kernel.org/lkml/20230503013608.2431726-1-nphamcs@gmail.com/
https://lore.kernel.org/linux-mm/20230510195806.2902878-1-nphamcs@gmail.com/

However, those patches miss arm64, which has its own syscall table in arch/arm64.
This patch wires cachestat in for arm64.

Link: https://lkml.kernel.org/r/20230511092843.3896327-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
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

zsmalloc-move-lru-update-from-zs_map_object-to-zs_malloc.patch
workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
cachestat-implement-cachestat-syscall.patch
cachestat-implement-cachestat-syscall-fix.patch
cachestat-wire-up-cachestat-for-other-architectures.patch
cachestat-wire-up-cachestat-for-other-architectures-fix.patch
selftests-add-selftests-for-cachestat.patch

