Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DBCC10DC1
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjLDTVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbjLDTVu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8696E10F
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22240C433C8;
        Mon,  4 Dec 2023 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717714;
        bh=6TzUUDaZiQPNB57E+PYufVY328pEUSldxjvZwVYr2lA=;
        h=Date:To:From:Subject:From;
        b=NUl/idZGLzCM2AADMiOkMJEJGXb6+mHZfRVGwTwIeM5sZ8z3AIosjle48oUEQ3cjr
         StfodQI3Vicrqo1PYFFoYkhM5zfc350rIB4TVJO6P/nKgvbI1EEFpnrnN8sOkN02Cr
         e7N44iF1g7FzM8kmQK6yZeQJpnDf5QBLFFb0QKHw=
Date:   Mon, 04 Dec 2023 11:21:53 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-spram-fix-missing-prototype-warning-for-spram_config.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192154.22240C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: spram: fix missing prototype warning for spram_config
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-spram-fix-missing-prototype-warning-for-spram_config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-spram-fix-missing-prototype-warning-for-spram_config.patch

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
Subject: mips: spram: fix missing prototype warning for spram_config
Date: Mon, 4 Dec 2023 12:57:04 +0100

arch/mips/kernel/spram.c:194:6: error: no previous prototype for 'spram_config' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-15-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/spram.h |    2 +-
 arch/mips/kernel/spram.c      |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/spram.h~mips-spram-fix-missing-prototype-warning-for-spram_config
+++ a/arch/mips/include/asm/spram.h
@@ -3,7 +3,7 @@
 #define _MIPS_SPRAM_H
 
 #if defined(CONFIG_MIPS_SPRAM)
-extern __init void spram_config(void);
+extern void spram_config(void);
 #else
 static inline void spram_config(void) { }
 #endif /* CONFIG_MIPS_SPRAM */
--- a/arch/mips/kernel/spram.c~mips-spram-fix-missing-prototype-warning-for-spram_config
+++ a/arch/mips/kernel/spram.c
@@ -12,6 +12,7 @@
 #include <asm/mipsregs.h>
 #include <asm/r4kcache.h>
 #include <asm/hazards.h>
+#include <asm/spram.h>
 
 /*
  * These definitions are correct for the 24K/34K/74K SPRAM sample
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

