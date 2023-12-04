Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCC6C10DC3
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjLDTVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbjLDTVk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9126CFA
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315ECC433CA;
        Mon,  4 Dec 2023 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717706;
        bh=drbqGCzkHrQJr6z+rfr2CG1Elo+EJYf7Gr/xJ08nS2U=;
        h=Date:To:From:Subject:From;
        b=xGHjODfKbsDS0FpTK08HawyzicRn1jrJZ7wdXeVUfiBsMSa0nTHDW08xms7VeClcx
         a0cOTEZnDX/lfGPxwYIxPS0nkC0N9NbidC/ZSdEFvp/pYrPymhzCJ16OXKKr9QPYEd
         0xiHJERyxZiEJlz+1O0T8BcGX19zdiuZBFfIwGwg=
Date:   Mon, 04 Dec 2023 11:21:45 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-fix-tlb_init-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192146.315ECC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: fix tlb_init() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-fix-tlb_init-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-fix-tlb_init-prototype.patch

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
Subject: mips: fix tlb_init() prototype
Date: Mon, 4 Dec 2023 12:57:01 +0100

There are two definitions for tlb_init(), but no global declaration:

arch/mips/mm/tlb-r4k.c:552:6: error: no previous prototype for 'tlb_init' [-Werror=missing-prototypes]
arch/mips/mm/tlb-r3k.c:244:6: error: no previous prototype for 'tlb_init' [-Werror=missing-prototypes]

Move the declaration to asm/setup.h and included it as needed.

Link: https://lkml.kernel.org/r/20231204115710.2247097-12-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/setup.h |    1 +
 arch/mips/kernel/traps.c      |    2 --
 arch/mips/mm/tlb-r3k.c        |    1 +
 arch/mips/mm/tlb-r4k.c        |    1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/setup.h~mips-fix-tlb_init-prototype
+++ a/arch/mips/include/asm/setup.h
@@ -27,5 +27,6 @@ extern unsigned long ebase;
 extern unsigned int hwrena;
 extern void per_cpu_trap_init(bool);
 extern void cpu_cache_init(void);
+extern void tlb_init(void);
 
 #endif /* __SETUP_H */
--- a/arch/mips/kernel/traps.c~mips-fix-tlb_init-prototype
+++ a/arch/mips/kernel/traps.c
@@ -2157,8 +2157,6 @@ void *set_vi_handler(int n, vi_handler_t
 	return set_vi_srs_handler(n, addr, 0);
 }
 
-extern void tlb_init(void);
-
 /*
  * Timer interrupt
  */
--- a/arch/mips/mm/tlb-r3k.c~mips-fix-tlb_init-prototype
+++ a/arch/mips/mm/tlb-r3k.c
@@ -23,6 +23,7 @@
 #include <asm/io.h>
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
+#include <asm/setup.h>
 #include <asm/tlbex.h>
 
 #undef DEBUG_TLB
--- a/arch/mips/mm/tlb-r4k.c~mips-fix-tlb_init-prototype
+++ a/arch/mips/mm/tlb-r4k.c
@@ -24,6 +24,7 @@
 #include <asm/tlb.h>
 #include <asm/tlbex.h>
 #include <asm/tlbmisc.h>
+#include <asm/setup.h>
 
 /*
  * LOONGSON-2 has a 4 entry itlb which is a subset of jtlb, LOONGSON-3 has
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

