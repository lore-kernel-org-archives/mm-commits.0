Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296CAC10DC3
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjLDTVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbjLDTVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78626116
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:56 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B05C433C9;
        Mon,  4 Dec 2023 19:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717716;
        bh=EFKvSNeo5Car3TXV8jms2cZY9j6ROYX/2PP+ZERLHNI=;
        h=Date:To:From:Subject:From;
        b=0kIQK7yl/TU+Rr+NsSLLd6LDE3qzYnUpT2D+Wi6DQoIRjTrkv3wzUeIAwlBfUlZ0R
         zsNTWeIXFCW7dy8UbV3jhuohFLfvTpGvBgZelddhie5pNb8D4ZcdsHQRGlvEYjBk35
         wotrO26jc5UxiL46Q6JCaDTKVIep8zd5rm07syac=
Date:   Mon, 04 Dec 2023 11:21:55 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-mt-include-asm-mips_mth.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192156.18B05C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: mt: include asm/mips_mt.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-mt-include-asm-mips_mth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-mt-include-asm-mips_mth.patch

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
Subject: mips: mt: include asm/mips_mt.h
Date: Mon, 4 Dec 2023 12:57:05 +0100

These two functions have a global prototype but the header is not included
before the function definitions:

arch/mips/kernel/mips-mt.c:50:6: error: no previous prototype for 'mips_mt_regdump' [-Werror=missing-prototypes]
arch/mips/kernel/mips-mt.c:159:6: error: no previous prototype for 'mips_mt_set_cpuoptions' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-16-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-mt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/mips-mt.c~mips-mt-include-asm-mips_mth
+++ a/arch/mips/kernel/mips-mt.c
@@ -19,6 +19,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/r4kcache.h>
 #include <asm/cacheflush.h>
+#include <asm/mips_mt.h>
 
 int vpelimit;
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
arch-turn-off-werror-for-architectures-with-known-warnings.patch
mips-decompress-fix-add-missing-prototypes.patch
mips-add-asm-syscallsh-header.patch
mips-add-missing-declarations-for-trap-handlers.patch
mips-rs870e-stop-exporting-local-functions.patch
mips-signal-move-sigcontext-declarations-to-header.patch
mips-mark-local-function-static-if-possible.patch
mips-move-build_tlb_refill_handler-prototype.patch
mips-move-jump_label_apply_nops-declaration-to-header.patch
mips-unhide-uasm_in_compat_space_p-declaration.patch
mips-fix-setup_zero_pages-prototype.patch
mips-fix-tlb_init-prototype.patch
mips-move-cache-declarations-into-header.patch
mips-add-missing-declarations.patch
mips-spram-fix-missing-prototype-warning-for-spram_config.patch
mips-mt-include-asm-mips_mth.patch
mips-remove-extraneous-asm-generic-iomaph-include.patch
mips-suspend-include-linux-suspendh-as-needed.patch
mips-hide-conditionally-unused-functions.patch
mips-smp-fix-setup_profiling_timer-prototype.patch
mips-kexec-include-linux-rebooth.patch
ida-make-ida_dump-static.patch
jffs2-mark-__jffs2_dbg_superblock_counts-static.patch
sched-fair-move-unused-stub-functions-to-header.patch
x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch
usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

