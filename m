Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898C0C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 17:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjKXRpH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 12:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjKXRpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 12:45:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43ED1718
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 09:45:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048BC433C8;
        Fri, 24 Nov 2023 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700847912;
        bh=pe6Is7T8RR9Z14b1WyIdsjt9cSBt3Fm1Ggxcb8W+tk0=;
        h=Date:To:From:Subject:From;
        b=u0EfStcaWPQwqd6ym+qHxgvZFWifbsa2L+aHBkkiEUC3iuVDhON5b14/jXXc55FeJ
         9n+dCQGgTLe7De+5wjyiMGHCVa50tK5i3H8ejkOnb499dqbaOwI5ud1ijgNx0tSKj4
         GxEmlXCDjIiDI9mtnjzRyPxCqRwMX5Vx/e07yrnU=
Date:   Fri, 24 Nov 2023 09:45:11 -0800
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
Subject: + ida-make-ida_dump-static.patch added to mm-nonmm-unstable branch
Message-Id: <20231124174512.7048BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ida: make 'ida_dump' static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ida-make-ida_dump-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ida-make-ida_dump-static.patch

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
Subject: ida: make 'ida_dump' static
Date: Thu, 23 Nov 2023 12:05:01 +0100

Patch series "Treewide: enable -Wmissing-prototypes", v3.

At this point, there are five architectures with a number of known
regressions: alpha, nios2, mips, sh and sparc.  In the previous version of
this patch, I had turned off the missing prototype warnings for the 15
architectures that still had issues, but since there are only five left, I
think we can leave the rest to the maintainers (Cc'd here) as well.

The series is also likely to cause occasional build regressions on
linux-next as developers add new code that misses prototypes.  Hopefully
this should be resolved by the time the patches make it into a release and
everyone gets the warnings right away.  


This patch (of 6):

There is no global declaration for ida_dump() and no other callers, so
make it static to avoid this warning:

lib/test_ida.c:16:6: error: no previous prototype for 'ida_dump'

Link: https://lkml.kernel.org/r/20231123110506.707903-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20231123110506.707903-2-arnd@kernel.org
Fixes: 8ab8ba38d488 ("ida: Start new test_ida module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Kees Cook <keescook@chromium.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_ida.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_ida.c~ida-make-ida_dump-static
+++ a/lib/test_ida.c
@@ -13,7 +13,7 @@ static unsigned int tests_run;
 static unsigned int tests_passed;
 
 #ifdef __KERNEL__
-void ida_dump(struct ida *ida) { }
+static void ida_dump(struct ida *ida) { }
 #endif
 #define IDA_BUG_ON(ida, x) do {						\
 	tests_run++;							\
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

