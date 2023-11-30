Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D67C10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377306AbjK3Xiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377315AbjK3Xiv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F5F1704
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9CBC433C9;
        Thu, 30 Nov 2023 23:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387535;
        bh=jQUkq6PPwsxTcAB8vc4WN/4O9HR5VxU2m1xfClAsSbY=;
        h=Date:To:From:Subject:From;
        b=n8g8l9kzMT8MJEL7+wu1bgQfIOztU6lR4OnBHZWErQb5pUeHQvC8pFu/UKFH/l0fp
         ZhpmiDsquUhT5wbGQphUEnoG+Ms44CMHjBZjsxo4us7wg7aIWyo0nJHgy8xOmXfBjc
         lvqs1t1Y6c9K/XrTgSJb+EDHKsF9f+ebA6VavsQU=
Date:   Thu, 30 Nov 2023 15:38:54 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233855.3D9CBC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: traps: add internal prototypes for functions only called from asm
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch

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
Subject: hexagon: traps: add internal prototypes for functions only called from asm
Date: Thu, 30 Nov 2023 15:58:32 -0700

Clang warns:

  arch/hexagon/kernel/traps.c:284:6: warning: no previous prototype for function 'do_genex' [-Wmissing-prototypes]
    284 | void do_genex(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:284:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    284 | void do_genex(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:341:6: warning: no previous prototype for function 'do_trap0' [-Wmissing-prototypes]
    341 | void do_trap0(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:341:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    341 | void do_trap0(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:418:6: warning: no previous prototype for function 'do_machcheck' [-Wmissing-prototypes]
    418 | void do_machcheck(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:418:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    418 | void do_machcheck(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:428:6: warning: no previous prototype for function 'do_debug_exception' [-Wmissing-prototypes]
    428 | void do_debug_exception(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:428:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    428 | void do_debug_exception(struct pt_regs *regs)
        | ^
        | static

These functions are only called from assembly or this translation unit,
so just add prototypes right above the definitions to silence the
warnings.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-19-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/traps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/hexagon/kernel/traps.c~hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm
+++ a/arch/hexagon/kernel/traps.c
@@ -281,6 +281,7 @@ static void cache_error(struct pt_regs *
 /*
  * General exception handler
  */
+void do_genex(struct pt_regs *regs);
 void do_genex(struct pt_regs *regs)
 {
 	/*
@@ -331,6 +332,7 @@ void do_genex(struct pt_regs *regs)
 	}
 }
 
+void do_trap0(struct pt_regs *regs);
 void do_trap0(struct pt_regs *regs)
 {
 	syscall_fn syscall;
@@ -408,6 +410,7 @@ void do_trap0(struct pt_regs *regs)
 /*
  * Machine check exception handler
  */
+void do_machcheck(struct pt_regs *regs);
 void do_machcheck(struct pt_regs *regs)
 {
 	/* Halt and catch fire */
@@ -418,6 +421,7 @@ void do_machcheck(struct pt_regs *regs)
  * Treat this like the old 0xdb trap.
  */
 
+void do_debug_exception(struct pt_regs *regs);
 void do_debug_exception(struct pt_regs *regs)
 {
 	regs->hvmer.vmest &= ~HVM_VMEST_CAUSE_MSK;
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

