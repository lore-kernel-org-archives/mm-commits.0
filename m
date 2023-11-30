Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160D0C10DCE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377262AbjK3Xia (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377259AbjK3Xi3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC50810E2
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55296C433C7;
        Thu, 30 Nov 2023 23:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387515;
        bh=ywHZzfpJ41fZqojKX1cPSTH1YpaO6+dFcr4FZJqA38E=;
        h=Date:To:From:Subject:From;
        b=isPXhHMh3C0Hs+vkYkY3N6khF42faeizCTLdfw/gcsjn42fVtqgljGSLO8PQPB3Lx
         jnIgHj3WJUPvI3iGykFLICVWcxVgjcmpVxLAB+NvLmq8V9Ocbvb67KGGRCQ8LqIpCr
         f2QkgIvi+YpCx7UFEqZG7xVPPAISVO+jCq5mMRmk=
Date:   Thu, 30 Nov 2023 15:38:34 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-uaccess-remove-clear_user_hexagon.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233835.55296C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: uaccess: remove clear_user_hexagon()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-uaccess-remove-clear_user_hexagon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-uaccess-remove-clear_user_hexagon.patch

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
Subject: hexagon: uaccess: remove clear_user_hexagon()
Date: Thu, 30 Nov 2023 15:58:14 -0700

Patch series "hexagon: Fix up instances of -Wmissing-prototypes".

This series fixes all the instances of -Wmissing-prototypes in
arch/hexagon, as it is about to be enabled globally in a default build.


This patch (of 19):

Clang warns:

  arch/hexagon/mm/uaccess.c:39:15: warning: no previous prototype for function 'clear_user_hexagon' [-Wmissing-prototypes]
     39 | unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
        |               ^
  arch/hexagon/mm/uaccess.c:39:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     39 | unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
        | ^
        | static
  1 warning generated.

This function appears to have been unused since it was introduced in
commit 7567746e1c0d ("Hexagon: Add user access functions"), so remove it.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org
Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-1-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/uaccess.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/hexagon/mm/uaccess.c~hexagon-uaccess-remove-clear_user_hexagon
+++ a/arch/hexagon/mm/uaccess.c
@@ -35,11 +35,3 @@ __kernel_size_t __clear_user_hexagon(voi
 
 	return count;
 }
-
-unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
-{
-	if (!access_ok(dest, count))
-		return count;
-	else
-		return __clear_user_hexagon(dest, count);
-}
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

