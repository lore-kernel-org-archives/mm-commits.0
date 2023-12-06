Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A71C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 16:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442645AbjLFQEx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 11:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442670AbjLFQEu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 11:04:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920FB10C9
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 08:04:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D68C433C7;
        Wed,  6 Dec 2023 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701878686;
        bh=2rrNNFsYm6uAgrpbeDqAc3U3D++125lsJ4zb68YNwp4=;
        h=Date:To:From:Subject:From;
        b=U59vt4z2wZXGF6Et5I8gwkEeFfOsqm+apK5e2zqY+WWzS2UUuHZd1kr1kGMlACu9o
         GCn7TsiucNF6nXYHpL/PQElxXMwSYxyIznZwCrCmlJv93GYLm2Vl4TCayxu2lFyeu9
         fyE8BTqeuATSwWMMk9HaZuW6T0+dKj0rrX/p49Es=
Date:   Wed, 06 Dec 2023 08:04:46 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mips-remove-extraneous-asm-generic-iomaph-include.patch removed from -mm tree
Message-Id: <20231206160446.C0D68C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: remove extraneous asm-generic/iomap.h include
has been removed from the -mm tree.  Its filename was
     mips-remove-extraneous-asm-generic-iomaph-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

