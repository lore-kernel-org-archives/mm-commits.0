Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06724C10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377288AbjK3Xiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377302AbjK3Xim (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFD510E2
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5F1C433C7;
        Thu, 30 Nov 2023 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387527;
        bh=r9qKQWgU74w2cXIz1Ld9OlX3zmHQH+DGAvWRb0eWJ5I=;
        h=Date:To:From:Subject:From;
        b=Nn/2XBnBNd4TGZ6vdjQrWoEa0M6cYmKMgpqE3/Nvle1pUkIaeYUf8XFq/hm5f7Uxl
         B/5svLDseurQth52S7ykBujpZjV3Xm3v0r3G0sAJPoaGfSF08XRFBEjervIt0cXFY+
         z2UG2PB389npI4JquYifkvtieRBtvBDQslv/+VU0=
Date:   Thu, 30 Nov 2023 15:38:47 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-reset-include-linux-rebooth-for-prototypes.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233847.8E5F1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: reset: include linux/reboot.h for prototypes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-reset-include-linux-rebooth-for-prototypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-reset-include-linux-rebooth-for-prototypes.patch

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
Subject: hexagon: reset: include linux/reboot.h for prototypes
Date: Thu, 30 Nov 2023 15:58:25 -0700

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/reset.c:9:6: warning: no previous prototype for function 'machine_power_off' [-Wmissing-prototypes]
      9 | void machine_power_off(void)
        |      ^
  arch/hexagon/kernel/reset.c:9:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      9 | void machine_power_off(void)
        | ^
        | static
  arch/hexagon/kernel/reset.c:15:6: warning: no previous prototype for function 'machine_halt' [-Wmissing-prototypes]
     15 | void machine_halt(void)
        |      ^
  arch/hexagon/kernel/reset.c:15:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     15 | void machine_halt(void)
        | ^
        | static
  arch/hexagon/kernel/reset.c:19:6: warning: no previous prototype for function 'machine_restart' [-Wmissing-prototypes]
     19 | void machine_restart(char *cmd)
        |      ^
  arch/hexagon/kernel/reset.c:19:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     19 | void machine_restart(char *cmd)
        | ^
        | static
  3 warnings generated.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-12-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/reset.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/reset.c~hexagon-reset-include-linux-rebooth-for-prototypes
+++ a/arch/hexagon/kernel/reset.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/reboot.h>
 #include <linux/smp.h>
 #include <asm/hexagon_vm.h>
 
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

