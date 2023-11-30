Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA65C46CA3
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377303AbjK3Xix (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377306AbjK3Xiu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEB510FA
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:51 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2E5C433CA;
        Thu, 30 Nov 2023 23:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387530;
        bh=ofO4je9d1fhkDWUNxzH9g9xPNQ2jM0HF/6dXQ/aB3E0=;
        h=Date:To:From:Subject:From;
        b=QTSYhk6h8koLiWoGaXikZmQpWtOiPhN0C1hmDcK9Y/yuDIyAolhpw+nHwDJJJ3sgQ
         8nZO5foPuoEFGha7l2HqINbGjvVxpqshvrjXtf+zvK4UXTJ/lN7od71wG18JZ2g5b5
         Z9h7MWlt6w5SXXmagPh74/J4yaLEPZviNNCZikxs=
Date:   Thu, 30 Nov 2023 15:38:50 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233850.BB2E5C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: vdso: include asm/elf.h for arch_setup_additional_pages() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch

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
Subject: hexagon: vdso: include asm/elf.h for arch_setup_additional_pages() prototype
Date: Thu, 30 Nov 2023 15:58:28 -0700

Clang warns:

  arch/hexagon/kernel/vdso.c:49:5: warning: no previous prototype for function 'arch_setup_additional_pages' [-Wmissing-prototypes]
     49 | int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
        |     ^
  arch/hexagon/kernel/vdso.c:49:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     49 | int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
        | ^
        | static
  1 warning generated.

Include the header that declares the prototype to clear up the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-15-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/vdso.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/vdso.c~hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype
+++ a/arch/hexagon/kernel/vdso.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/binfmts.h>
 
+#include <asm/elf.h>
 #include <asm/vdso.h>
 
 static struct page *vdso_page;
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

