Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F266C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjLDTVv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjLDTVr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AEFFF
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB757C433C9;
        Mon,  4 Dec 2023 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717711;
        bh=jXzg5BHVXbX82MSmaKtiKKfTxudgmHNEew0YSPyyENI=;
        h=Date:To:From:Subject:From;
        b=CrHMWbpg+lE47pJngLIIq3GXV64T0fEmQXMnt+mDjRZa/G8v3FmmqMKUTaVN7G5iz
         zJh5b0867d+O9N40MiSqQHNuRM0sQyW7ywI8HacnMDHsnHVJgjuQBUeF3zXGePayAW
         1O7w8HUdN25NBpzFO3jyJhUV4pUhnKkzeF2bP54M=
Date:   Mon, 04 Dec 2023 11:21:51 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-add-missing-declarations.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192151.CB757C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: add missing declarations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-add-missing-declarations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-add-missing-declarations.patch

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
Subject: mips: add missing declarations
Date: Mon, 4 Dec 2023 12:57:03 +0100

These are three more functions that are only called from assembler and
only need a declaration to avoid the -Wmissing-prototypes warnings:

arch/mips/kernel/signal.c:904:17: error: no previous prototype for 'do_notify_resume' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:370:6: error: no previous prototype for 'show_registers' [-Werror=missing-prototypes]
arch/mips/kernel/smp.c:352:17: error: no previous prototype for 'start_secondary' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-14-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/processor.h |    2 ++
 arch/mips/include/asm/signal.h    |    1 +
 arch/mips/include/asm/smp.h       |    2 ++
 3 files changed, 5 insertions(+)

--- a/arch/mips/include/asm/processor.h~mips-add-missing-declarations
+++ a/arch/mips/include/asm/processor.h
@@ -402,4 +402,6 @@ extern int mips_set_process_fp_mode(stru
 #define GET_FP_MODE(task)		mips_get_process_fp_mode(task)
 #define SET_FP_MODE(task,value)		mips_set_process_fp_mode(task, value)
 
+void show_registers(struct pt_regs *regs);
+
 #endif /* _ASM_PROCESSOR_H */
--- a/arch/mips/include/asm/signal.h~mips-add-missing-declarations
+++ a/arch/mips/include/asm/signal.h
@@ -31,5 +31,6 @@ extern struct mips_abi mips_abi_32;
 
 extern int protected_save_fp_context(void __user *sc);
 extern int protected_restore_fp_context(void __user *sc);
+void do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags);
 
 #endif /* _ASM_SIGNAL_H */
--- a/arch/mips/include/asm/smp.h~mips-add-missing-declarations
+++ a/arch/mips/include/asm/smp.h
@@ -63,6 +63,8 @@ extern asmlinkage void smp_bootstrap(voi
 
 extern void calculate_cpu_foreign_map(void);
 
+asmlinkage void start_secondary(void);
+
 /*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
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

