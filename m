Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33703C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 17:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjKXRpR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 12:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjKXRpM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 12:45:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176F1171D
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 09:45:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8094C433C8;
        Fri, 24 Nov 2023 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700847918;
        bh=nBjymJ9e1GQYxv5ws6PEjD+dnGXqV/W9H3d8czPWkCU=;
        h=Date:To:From:Subject:From;
        b=DwKYZn4P35ykkZ7rgXH09GJK/0U2wNY4WhnkzJ/RAQ6PRHDECPnqbyi46kn36bHCh
         Q57+/CGCUceVfj8gfoCgzyyfyaY70PaytmVvIuib6CMQahdkoNy7T53Ua0oMjFmYL7
         qtzgjqIFDIKBGyzDqqrKmRMP8NQGiQH2HlOmnYaA=
Date:   Fri, 24 Nov 2023 09:45:18 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        tudor.ambarus@linaro.org, tsbogend@alpha.franken.de,
        sfr@canb.auug.org.au, richard@nod.at, richard.henderson@linaro.org,
        peterz@infradead.org, palmer@rivosinc.com, nicolas@fjasle.eu,
        nathan@kernel.org, mpe@ellerman.id.au, mattst88@gmail.com,
        masahiroy@kernel.org, keescook@chromium.org,
        ink@jurassic.park.msu.ru, gregkh@linuxfoundation.org,
        glaubitz@physik.fu-berlin.de, dwmw2@infradead.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        chengzhihao1@huawei.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20231124174518.A8094C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: sta2x11: include header for sta2x11_get_instance() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: x86: sta2x11: include header for sta2x11_get_instance() prototype
Date: Thu, 23 Nov 2023 12:05:04 +0100

sta2x11_get_instance() is a global function declared in asm/sta2x11.h, but
this header is not included before the definition, causing a warning:

arch/x86/pci/sta2x11-fixup.c:95:26: error: no previous prototype for 'sta2x11_get_instance' [-Werror=missing-prototypes]

Add the missing #include.

Link: https://lkml.kernel.org/r/20231123110506.707903-5-arnd@kernel.org
Fixes: 83125a3a189e ("x86, platform: Initial support for sta2x11 I/O hub")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/sta2x11-fixup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/pci/sta2x11-fixup.c~x86-sta2x11-include-header-for-sta2x11_get_instance-prototype
+++ a/arch/x86/pci/sta2x11-fixup.c
@@ -14,6 +14,7 @@
 #include <linux/dma-map-ops.h>
 #include <linux/swiotlb.h>
 #include <asm/iommu.h>
+#include <asm/sta2x11.h>
 
 #define STA2X11_SWIOTLB_SIZE (4*1024*1024)
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
kexec-fix-kexec_file-dependencies-fix.patch
ida-make-ida_dump-static.patch
jffs2-mark-__jffs2_dbg_superblock_counts-static.patch
sched-fair-move-unused-stub-functions-to-header.patch
x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch
usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

