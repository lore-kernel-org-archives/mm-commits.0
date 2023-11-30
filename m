Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E6DC10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377296AbjK3Xij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377293AbjK3Xij (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951E610FA
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DD4C433C7;
        Thu, 30 Nov 2023 23:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387524;
        bh=Ch+SYTcasdCH6O2ky+Wu36zk+/n7qFanYtDumoIB5iQ=;
        h=Date:To:From:Subject:From;
        b=tap1Y1CEFaUG+TFv2FrgyLYxVO/gwAOUB1QmGZ1IgWrYAp2ZY/YNrEwEgHohUFa7H
         /ss3AcHZ+vJVAwyGiarEyWGmdZsY4bkVf5/aFW4FGcJV1vd780RwSmwgPT7Y0oNDPe
         P42zKKyZCRcTQC/KideDQKNOCjWU46GI98y7q0uY=
Date:   Thu, 30 Nov 2023 15:38:43 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-time-mark-time_init_deferred-as-static.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233844.33DD4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: time: mark time_init_deferred() as static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-time-mark-time_init_deferred-as-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-time-mark-time_init_deferred-as-static.patch

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
Subject: hexagon: time: mark time_init_deferred() as static
Date: Thu, 30 Nov 2023 15:58:22 -0700

Clang warns:

  arch/hexagon/kernel/time.c:163:13: warning: no previous prototype for function 'time_init_deferred' [-Wmissing-prototypes]
    163 | void __init time_init_deferred(void)
        |             ^
  arch/hexagon/kernel/time.c:163:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    163 | void __init time_init_deferred(void)
        | ^
        | static

This function is not used outside of this translation unit so mark it as
static to resolve the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-9-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/kernel/time.c~hexagon-time-mark-time_init_deferred-as-static
+++ a/arch/hexagon/kernel/time.c
@@ -161,7 +161,7 @@ static irqreturn_t timer_interrupt(int i
  * This runs just before the delay loop is calibrated, and
  * is used for delay calibration.
  */
-void __init time_init_deferred(void)
+static void __init time_init_deferred(void)
 {
 	struct resource *resource = NULL;
 	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
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

