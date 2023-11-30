Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FE6C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377313AbjK3Xiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377299AbjK3Xil (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B16510DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724E8C433CC;
        Thu, 30 Nov 2023 23:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387526;
        bh=C/qxjNnyK1iBWn08V0E9CXLS0PR7ZCZGOCgPoIn82lQ=;
        h=Date:To:From:Subject:From;
        b=QkSWQEB2hV893cK+6brwdGWWFD+K6yRHWw4+sXYvP3muVfru4XGCZ3DxdKI1KKo5E
         BZmhjxs1FFiDeZl3tx/JVBAayf90Y86SCp+YQTkzDBYNiihhHTW9Ot9adOaS3A9TSN
         zzveRdKhxUQ/h8+lyYghiiARdZrqL2cyAOhpGhww=
Date:   Thu, 30 Nov 2023 15:38:45 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233846.724E8C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: signal: switch to SYSCALL_DEFINE0 for sys_rt_sigreturn()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: signal: switch to SYSCALL_DEFINE0 for sys_rt_sigreturn()
Date: Thu, 30 Nov 2023 15:58:24 -0700

Clang warns:

  arch/hexagon/kernel/signal.c:223:16: warning: no previous prototype for function 'sys_rt_sigreturn' [-Wmissing-prototypes]
    223 | asmlinkage int sys_rt_sigreturn(void)
        |                ^
  arch/hexagon/kernel/signal.c:223:12: note: declare 'static' if the function is not intended to be used outside of this translation unit
    223 | asmlinkage int sys_rt_sigreturn(void)
        |            ^
        |            static
  1 warning generated.

Switch to the SYSCALL_DEFINE0() macro, which automatically declares a
prototype.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-11-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/kernel/signal.c~hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn
+++ a/arch/hexagon/kernel/signal.c
@@ -220,7 +220,7 @@ no_restart:
  * Architecture-specific wrappers for signal-related system calls
  */
 
-asmlinkage int sys_rt_sigreturn(void)
+SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch
hexagon-uaccess-remove-clear_user_hexagon.patch
hexagon-mm-mark-paging_init-as-static.patch
hexagon-mm-include-asm-setuph-for-setup_arch_memorys-prototype.patch
hexagon-smp-mark-handle_ipi-and-start_secondary-as-static.patch
hexagon-vm_fault-mark-do_page_fault-as-static.patch
hexagon-vm_fault-include-asm-vm_faulth-for-prototypes.patch
hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch
hexagon-time-include-asm-timeh-for-prototypes.patch
hexagon-time-mark-time_init_deferred-as-static.patch
hexagon-time-include-asm-delayh-for-prototypes.patch
hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch
hexagon-reset-include-linux-rebooth-for-prototypes.patch
hexagon-process-include-linux-cpuh-for-arch_cpu_idle-prototype.patch
hexagon-process-add-internal-prototype-for-do_work_pending.patch
hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch
hexagon-vm_events-remove-unused-dummy_handler.patch
hexagon-irq-add-prototype-for-arch_do_irq.patch
hexagon-traps-remove-sys_syscall.patch
hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch

