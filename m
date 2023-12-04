Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1131C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjLDTVV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjLDTVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35069AC
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA12C433C7;
        Mon,  4 Dec 2023 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717684;
        bh=o9FskBLWjDiZlj7hl+jTsLjRHbRFPulleE5Zv+8mzB4=;
        h=Date:To:From:Subject:From;
        b=IT//PDWTVvmpRn4GmtKxPxNG+Zn/mHlJBKPewGcOk/jLJ1V9tFYoRzfaoZ/GCwNbt
         hRIS9BnBl/Jc49edjDAUU4+tJftVrDB48g7+OJbofNo0zg9203cGyPFAjCrrHCR9C0
         l4/CFC54tzbsMHO5pOZtXel1DRbFfLCJe2r3M4yM=
Date:   Mon, 04 Dec 2023 11:21:24 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-add-asm-syscallsh-header.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192124.CAA12C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: add asm/syscalls.h header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-add-asm-syscallsh-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-add-asm-syscallsh-header.patch

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
Subject: mips: add asm/syscalls.h header
Date: Mon, 4 Dec 2023 12:56:52 +0100

System call prototypes are generally in linux/syscalls.h, but there are a
couple of mips specific entry points that are missing there:

arch/mips/kernel/signal.c:636:17: error: no previous prototype for 'sys_sigreturn' [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:673:17: error: no previous prototype for 'sys_rt_sigreturn' [-Werror=missing-prototypes]
arch/mips/kernel/syscall.c:51:16: error: no previous prototype for 'sysm_pipe' [-Werror=missing-prototypes]
arch/mips/kernel/mips-mt-fpaff.c:65:17: error: no previous prototype for 'mipsmt_sys_sched_setaffinity' [-Werror=missing-prototypes]
arch/mips/kernel/mips-mt-fpaff.c:157:17: error: no previous prototype for 'mipsmt_sys_sched_getaffinity' [-Werror=missing-prototypes]

Add these to a new asm/syscalls.h as we have in other architectures.

Link: https://lkml.kernel.org/r/20231204115710.2247097-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/syscalls.h |   33 +++++++++++++++++++++++++++++
 arch/mips/kernel/linux32.c       |    1 
 arch/mips/kernel/mips-mt-fpaff.c |    1 
 arch/mips/kernel/signal.c        |    1 
 arch/mips/kernel/signal32.c      |    1 
 arch/mips/kernel/signal_n32.c    |    1 
 arch/mips/kernel/signal_o32.c    |    1 
 arch/mips/kernel/syscall.c       |    1 
 8 files changed, 40 insertions(+)

--- /dev/null
+++ a/arch/mips/include/asm/syscalls.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_MIPS_SYSCALLS_H
+#define _ASM_MIPS_SYSCALLS_H
+
+#include <linux/linkage.h>
+#include <linux/compat.h>
+
+asmlinkage void sys_sigreturn(void);
+asmlinkage void sys_rt_sigreturn(void);
+asmlinkage int sysm_pipe(void);
+asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
+                                     unsigned long __user *user_mask_ptr);
+asmlinkage long mipsmt_sys_sched_getaffinity(pid_t pid, unsigned int len,
+                                     unsigned long __user *user_mask_ptr);
+asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_a2,
+				unsigned offset_a3, unsigned len_a4,
+				unsigned len_a5);
+asmlinkage long sys32_fadvise64_64(int fd, int __pad,
+				   unsigned long a2, unsigned long a3,
+				   unsigned long a4, unsigned long a5,
+				   int flags);
+asmlinkage ssize_t sys32_readahead(int fd, u32 pad0, u64 a2, u64 a3,
+				   size_t count);
+asmlinkage long sys32_sync_file_range(int fd, int __pad,
+				      unsigned long a2, unsigned long a3,
+				      unsigned long a4, unsigned long a5,
+				      int flags);
+asmlinkage void sys32_rt_sigreturn(void);
+asmlinkage void sys32_sigreturn(void);
+asmlinkage int sys32_sigsuspend(compat_sigset_t __user *uset);
+asmlinkage void sysn32_rt_sigreturn(void);
+
+#endif
--- a/arch/mips/kernel/linux32.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/linux32.c
@@ -42,6 +42,7 @@
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/mman.h>
+#include <asm/syscalls.h>
 
 #ifdef __MIPSEB__
 #define merge_64(r1, r2) ((((r1) & 0xffffffffUL) << 32) + ((r2) & 0xffffffffUL))
--- a/arch/mips/kernel/mips-mt-fpaff.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/mips-mt-fpaff.c
@@ -15,6 +15,7 @@
 #include <linux/security.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <asm/syscalls.h>
 
 /*
  * CPU mask used to set process affinity for MT VPEs/TCs with FPUs
--- a/arch/mips/kernel/signal32.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/signal32.c
@@ -18,6 +18,7 @@
 #include <asm/compat-signal.h>
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/syscalls.h>
 
 #include "signal-common.h"
 
--- a/arch/mips/kernel/signal.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/signal.c
@@ -38,6 +38,7 @@
 #include <asm/dsp.h>
 #include <asm/inst.h>
 #include <asm/msa.h>
+#include <asm/syscalls.h>
 
 #include "signal-common.h"
 
--- a/arch/mips/kernel/signal_n32.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/signal_n32.c
@@ -24,6 +24,7 @@
 #include <asm/ucontext.h>
 #include <asm/fpu.h>
 #include <asm/cpu-features.h>
+#include <asm/syscalls.h>
 
 #include "signal-common.h"
 
--- a/arch/mips/kernel/signal_o32.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/signal_o32.c
@@ -19,6 +19,7 @@
 #include <asm/dsp.h>
 #include <asm/sim.h>
 #include <asm/unistd.h>
+#include <asm/syscalls.h>
 
 #include "signal-common.h"
 
--- a/arch/mips/kernel/syscall.c~mips-add-asm-syscallsh-header
+++ a/arch/mips/kernel/syscall.c
@@ -39,6 +39,7 @@
 #include <asm/shmparam.h>
 #include <asm/sync.h>
 #include <asm/sysmips.h>
+#include <asm/syscalls.h>
 #include <asm/switch_to.h>
 
 /*
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

