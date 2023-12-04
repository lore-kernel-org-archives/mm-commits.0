Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EECAC46CA0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjLDTVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbjLDTVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F894107
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A125AC433C8;
        Mon,  4 Dec 2023 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717717;
        bh=y08QGnZlaorZQGdrYk6cQOoABmCq+6waW4fWK5e9RDY=;
        h=Date:To:From:Subject:From;
        b=x4jdOFNo3Igr8zTFo4+4q6gFSaFxKTQ6qV4Uiv2gAblHLK+yLPGHejjP13gOmU5Fl
         A5u4EantzciNnzidNEQ+amBLXG95+JEHYlY4BkCSOYjXj1pwrTiA8EJ1Io8W2uXo80
         NWVP3eZlBbtTOpJZyGe22r9/3hZIFVDAMk+8wB5c=
Date:   Mon, 04 Dec 2023 11:21:57 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-remove-extraneous-asm-generic-iomaph-include.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192157.A125AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: remove extraneous asm-generic/iomap.h include
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-remove-extraneous-asm-generic-iomaph-include.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-remove-extraneous-asm-generic-iomaph-include.patch

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
Subject: mips: remove extraneous asm-generic/iomap.h include
Date: Mon, 4 Dec 2023 12:57:06 +0100

When this file is included before defining readq(), it misses the
declarations for a couple of functions that now become unusable:

lib/iomap.c:156:5: warning: no previous prototype for 'ioread64_lo_hi' [-Wmissing-prototypes]
lib/iomap.c:163:5: warning: no previous prototype for 'ioread64_hi_lo' [-Wmissing-prototypes]
lib/iomap.c:170:5: warning: no previous prototype for 'ioread64be_lo_hi' [-Wmissing-prototypes]
lib/iomap.c:178:5: warning: no previous prototype for 'ioread64be_hi_lo' [-Wmissing-prototypes]
lib/iomap.c:264:6: warning: no previous prototype for 'iowrite64_lo_hi' [-Wmissing-prototypes]
lib/iomap.c:272:6: warning: no previous prototype for 'iowrite64_hi_lo' [-Wmissing-prototypes]
lib/iomap.c:280:6: warning: no previous prototype for 'iowrite64be_lo_hi' [-Wmissing-prototypes]
lib/iomap.c:288:6: warning: no previous prototype for 'iowrite64be_hi_lo' [-Wmissing-prototypes]

The file is included again later from asm-generic/io.h, so dropping the initial
include statement makes it do the right thing, both for avoiding the warning
and for actually providing these functions.

Link: https://lkml.kernel.org/r/20231204115710.2247097-17-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/io.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/mips/include/asm/io.h~mips-remove-extraneous-asm-generic-iomaph-include
+++ a/arch/mips/include/asm/io.h
@@ -207,8 +207,6 @@ void iounmap(const volatile void __iomem
 #define ioremap_wc(offset, size)					\
 	ioremap_prot((offset), (size), boot_cpu_data.writecombine)
 
-#include <asm-generic/iomap.h>
-
 #if defined(CONFIG_CPU_CAVIUM_OCTEON)
 #define war_io_reorder_wmb()		wmb()
 #else
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

