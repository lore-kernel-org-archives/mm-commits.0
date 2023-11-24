Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DB8C61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjKXRpR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 12:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjKXRpQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 12:45:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100321988
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 09:45:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DD8C433C8;
        Fri, 24 Nov 2023 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700847922;
        bh=0XqBDI8EbrwiTxkXuatm8hN6Lnzjsm9fQc0V4xSIZRc=;
        h=Date:To:From:Subject:From;
        b=HNfoixJkAEM3BD0zQpVuUrAwy/TQ9HX9uaedXkqsEFHC3uwBLi0ZbU/1p97a47WMp
         klm6FkUQkwMNQuy+lA+XOa3gtnzozmKbH2XUdQJYPkbAj5G0QCdwvg7XgHTAnVuNEe
         jgjTsazFjRnemO2xyWhqfhSvyhj8bCgACA75zdhk=
Date:   Fri, 24 Nov 2023 09:45:22 -0800
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
Subject: + makefileextrawarn-turn-on-missing-prototypes-globally.patch added to mm-nonmm-unstable branch
Message-Id: <20231124174522.A1DD8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile.extrawarn: turn on missing-prototypes globally
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     makefileextrawarn-turn-on-missing-prototypes-globally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/makefileextrawarn-turn-on-missing-prototypes-globally.patch

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
Subject: Makefile.extrawarn: turn on missing-prototypes globally
Date: Thu, 23 Nov 2023 12:05:06 +0100

Over the years we went from > 1000 of warnings to under 100 earlier this
year, and I sent patches to address all the ones that I saw with compile
testing randcom configs on arm64, arm and x86 kernels.  This is a really
useful warning, as it catches real bugs when there are mismatched
prototypes.  In particular with kernel control flow integrity enabled,
those are no longer allowed.

I have done extensive testing to ensure that there are no new build errors
or warnings on any configuration of x86, arm and arm64 builds.  I also
made sure that at least both the normal defconfig and an allmodconfig
build is clean for arc, csky, loongarch, m68k, microblaze, openrisc,
parisc, powerpc, riscv, s390, and xtensa, with the respective maintainers
doing most of the patches.

At this point, there are five architectures with a number of known
regressions: alpha, nios2, mips, sh and sparc.  In the previous version of
this patch, I had turned off the missing prototype warnings for the 15
architectures that still had issues, but since there are only five left, I
think we can leave the rest to the maintainers (Cc'd here) as well.

Link: https://lkml.kernel.org/r/20231123110506.707903-7-arnd@kernel.org
Link: https://lore.kernel.org/lkml/20230810141947.1236730-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com> # RISC-V
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.extrawarn~makefileextrawarn-turn-on-missing-prototypes-globally
+++ a/scripts/Makefile.extrawarn
@@ -17,6 +17,8 @@ KBUILD_CFLAGS += -Wno-format-security
 KBUILD_CFLAGS += -Wno-trigraphs
 KBUILD_CFLAGS += $(call cc-disable-warning,frame-address,)
 KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
+KBUILD_CFLAGS += -Wmissing-declarations
+KBUILD_CFLAGS += -Wmissing-prototypes
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += -Wframe-larger-than=$(CONFIG_FRAME_WARN)
@@ -95,10 +97,8 @@ export KBUILD_EXTRA_WARN
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
 KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
-KBUILD_CFLAGS += -Wmissing-declarations
 KBUILD_CFLAGS += $(call cc-option, -Wrestrict)
 KBUILD_CFLAGS += -Wmissing-format-attribute
-KBUILD_CFLAGS += -Wmissing-prototypes
 KBUILD_CFLAGS += -Wold-style-definition
 KBUILD_CFLAGS += -Wmissing-include-dirs
 KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
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

