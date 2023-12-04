Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A428C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjLDTVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjLDTVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EACAAC
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:30 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22E3C433C7;
        Mon,  4 Dec 2023 19:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717689;
        bh=elVH/udG/8bcAn70zmXbsMRnKbsH2hEDae+h5UyqN+4=;
        h=Date:To:From:Subject:From;
        b=WEC6h6hvUbm8NivUvBSdX7OxgNsFOrrWkXYrP5rxDP+/t0xCOueVYZXZsQMhST2TE
         ZIH/KNAGa+FTjmqlwYg84nX5eOcewQ+ISrzRLV2kQhuXpKAbTKRLQ6TtkppM4pDKpp
         gv3fIHbYtP0rL5wl576Xdh2E9aVjlhf8j3x3o6ek=
Date:   Mon, 04 Dec 2023 11:21:29 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-add-missing-declarations-for-trap-handlers.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192129.C22E3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: add missing declarations for trap handlers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-add-missing-declarations-for-trap-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-add-missing-declarations-for-trap-handlers.patch

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
Subject: mips: add missing declarations for trap handlers
Date: Mon, 4 Dec 2023 12:56:53 +0100

These exception handlers are all called from assembly code, so they don't
normally need a declaration, but without one we now get warnings:

arch/mips/mm/fault.c:323:17: error: no previous prototype for 'do_page_fault' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:447:17: error: no previous prototype for 'do_be' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:752:17: error: no previous prototype for 'do_ov' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:874:17: error: no previous prototype for 'do_fpe' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1027:17: error: no previous prototype for 'do_bp' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1114:17: error: no previous prototype for 'do_tr' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1151:17: error: no previous prototype for 'do_ri' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1402:17: error: no previous prototype for 'do_cpu' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1507:17: error: no previous prototype for 'do_msa_fpe' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1527:17: error: no previous prototype for 'do_msa' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1548:17: error: no previous prototype for 'do_mdmx' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1560:17: error: no previous prototype for 'do_watch' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1587:17: error: no previous prototype for 'do_mcheck' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1612:17: error: no previous prototype for 'do_mt' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1648:17: error: no previous prototype for 'do_dsp' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1656:17: error: no previous prototype for 'do_reserved' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1832:17: error: no previous prototype for 'cache_parity_error' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1880:17: error: no previous prototype for 'do_ftlb' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1909:17: error: no previous prototype for 'do_gsexc' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1944:6: error: no previous prototype for 'ejtag_exception_handler' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1989:17: error: no previous prototype for 'nmi_exception_handler' [-Werror=missing-prototypes]
arch/mips/kernel/unaligned.c:1516:17: error: no previous prototype for 'do_ade' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-4-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/traps.h |   24 ++++++++++++++++++++++++
 arch/mips/kernel/r4k-bugs64.c |    1 +
 arch/mips/kernel/unaligned.c  |    1 +
 arch/mips/mm/fault.c          |    1 +
 4 files changed, 27 insertions(+)

--- a/arch/mips/include/asm/traps.h~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/include/asm/traps.h
@@ -39,4 +39,28 @@ extern char except_vec_nmi[];
 	register_nmi_notifier(&fn##_nb);				\
 })
 
+asmlinkage void do_ade(struct pt_regs *regs);
+asmlinkage void do_be(struct pt_regs *regs);
+asmlinkage void do_ov(struct pt_regs *regs);
+asmlinkage void do_fpe(struct pt_regs *regs, unsigned long fcr31);
+asmlinkage void do_bp(struct pt_regs *regs);
+asmlinkage void do_tr(struct pt_regs *regs);
+asmlinkage void do_ri(struct pt_regs *regs);
+asmlinkage void do_cpu(struct pt_regs *regs);
+asmlinkage void do_msa_fpe(struct pt_regs *regs, unsigned int msacsr);
+asmlinkage void do_msa(struct pt_regs *regs);
+asmlinkage void do_mdmx(struct pt_regs *regs);
+asmlinkage void do_watch(struct pt_regs *regs);
+asmlinkage void do_mcheck(struct pt_regs *regs);
+asmlinkage void do_mt(struct pt_regs *regs);
+asmlinkage void do_dsp(struct pt_regs *regs);
+asmlinkage void do_reserved(struct pt_regs *regs);
+asmlinkage void do_ftlb(void);
+asmlinkage void do_gsexc(struct pt_regs *regs, u32 diag1);
+asmlinkage void do_daddi_ov(struct pt_regs *regs);
+
+asmlinkage void cache_parity_error(void);
+asmlinkage void ejtag_exception_handler(struct pt_regs *regs);
+asmlinkage void __noreturn nmi_exception_handler(struct pt_regs *regs);
+
 #endif /* _ASM_TRAPS_H */
--- a/arch/mips/kernel/r4k-bugs64.c~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/kernel/r4k-bugs64.c
@@ -14,6 +14,7 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/setup.h>
+#include <asm/traps.h>
 
 static char bug64hit[] __initdata =
 	"reliable operation impossible!\n%s";
--- a/arch/mips/kernel/unaligned.c~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/kernel/unaligned.c
@@ -91,6 +91,7 @@
 #include <asm/inst.h>
 #include <asm/unaligned-emul.h>
 #include <asm/mmu_context.h>
+#include <asm/traps.h>
 #include <linux/uaccess.h>
 
 #include "access-helper.h"
--- a/arch/mips/mm/fault.c~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/mm/fault.c
@@ -26,6 +26,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
+#include <asm/traps.h>
 #include <linux/kdebug.h>
 
 int show_unhandled_signals = 1;
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

