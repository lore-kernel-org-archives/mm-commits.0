Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544A3C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 17:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjKXRpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 12:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjKXRpK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 12:45:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9741718
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 09:45:14 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5A5C433C8;
        Fri, 24 Nov 2023 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700847914;
        bh=ikafU/GBfZGQBCwL9cFjYmHppp0PYWi7ywgRqvhFKGI=;
        h=Date:To:From:Subject:From;
        b=yTgMgOSEL/wF2oPzQTKSjzZR6SmuEi3PI3Uyzihg72inV9DS6yDy4OcgqZ4WkQZaH
         73vpu31v8H1X3UJcPuFUHuXP6YLyp4o4UY8TMQhwO1DMSSQq4A+NiJ21u+pxu+B6ff
         3IVFwqAVd/tmaJ3IoJO+Vd5y+lDpca+u/oQqczvA=
Date:   Fri, 24 Nov 2023 09:45:13 -0800
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
Subject: + jffs2-mark-__jffs2_dbg_superblock_counts-static.patch added to mm-nonmm-unstable branch
Message-Id: <20231124174514.6B5A5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: jffs2: mark __jffs2_dbg_superblock_counts() static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     jffs2-mark-__jffs2_dbg_superblock_counts-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jffs2-mark-__jffs2_dbg_superblock_counts-static.patch

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
Subject: jffs2: mark __jffs2_dbg_superblock_counts() static
Date: Thu, 23 Nov 2023 12:05:02 +0100

This function is only called locally and does not need to be global. 
Since there is no external prototype, gcc warns about the non-static
definition:

fs/jffs2/debug.c:160:6: error: no previous prototype for '__jffs2_dbg_superblock_counts' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231123110506.707903-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jffs2/debug.c~jffs2-mark-__jffs2_dbg_superblock_counts-static
+++ a/fs/jffs2/debug.c
@@ -157,7 +157,7 @@ __jffs2_dbg_prewrite_paranoia_check(stru
 	kfree(buf);
 }
 
-void __jffs2_dbg_superblock_counts(struct jffs2_sb_info *c)
+static void __jffs2_dbg_superblock_counts(struct jffs2_sb_info *c)
 {
 	struct jffs2_eraseblock *jeb;
 	uint32_t free = 0, dirty = 0, used = 0, wasted = 0,
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

