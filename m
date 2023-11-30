Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37317C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 23:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377291AbjK3Xij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 18:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377290AbjK3Xig (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 18:38:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A20310DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 15:38:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED584C433C9;
        Thu, 30 Nov 2023 23:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701387522;
        bh=JjW3NfvtIziG7/pidyObGavpIwEtfpUTISQtYsILSu0=;
        h=Date:To:From:Subject:From;
        b=Zbx8RgXW+RvN0Ko+jGgHXoYCQLEjuifkLrxttt3WR6AJGjCNoO4mFJo2BAfxJF2du
         s6oSiUvcvF3zvhtBz6tnE7owX+u5ZILwalWTarereMNp8w1CFQnjUQ+cCXMHEau+pa
         KUdtZEGa7SO6P3MF66WEejfJnkCygi98MMSYNBdU=
Date:   Thu, 30 Nov 2023 15:38:41 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, arnd@arndb.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch added to mm-nonmm-unstable branch
Message-Id: <20231130233841.ED584C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: vm_tlb: include asm/tlbflush.h for prototypes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch

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
Subject: hexagon: vm_tlb: include asm/tlbflush.h for prototypes
Date: Thu, 30 Nov 2023 15:58:20 -0700

Clang warns about several missing prototypes that are declared in this
header:

  arch/hexagon/mm/vm_tlb.c:25:6: warning: no previous prototype for function 'flush_tlb_range' [-Wmissing-prototypes]
     25 | void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
        |      ^
  arch/hexagon/mm/vm_tlb.c:25:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     25 | void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:37:6: warning: no previous prototype for function 'flush_tlb_one' [-Wmissing-prototypes]
     37 | void flush_tlb_one(unsigned long vaddr)
        |      ^
  arch/hexagon/mm/vm_tlb.c:37:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     37 | void flush_tlb_one(unsigned long vaddr)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:47:6: warning: no previous prototype for function 'tlb_flush_all' [-Wmissing-prototypes]
     47 | void tlb_flush_all(void)
        |      ^
  arch/hexagon/mm/vm_tlb.c:47:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     47 | void tlb_flush_all(void)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:56:6: warning: no previous prototype for function 'flush_tlb_mm' [-Wmissing-prototypes]
     56 | void flush_tlb_mm(struct mm_struct *mm)
        |      ^
  arch/hexagon/mm/vm_tlb.c:56:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     56 | void flush_tlb_mm(struct mm_struct *mm)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:66:6: warning: no previous prototype for function 'flush_tlb_page' [-Wmissing-prototypes]
     66 | void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
        |      ^
  arch/hexagon/mm/vm_tlb.c:66:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     66 | void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:78:6: warning: no previous prototype for function 'flush_tlb_kernel_range' [-Wmissing-prototypes]
     78 | void flush_tlb_kernel_range(unsigned long start, unsigned long end)
        |      ^
  arch/hexagon/mm/vm_tlb.c:78:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     78 | void flush_tlb_kernel_range(unsigned long start, unsigned long end)
        | ^
        | static
  6 warnings generated.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-7-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/vm_tlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/mm/vm_tlb.c~hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes
+++ a/arch/hexagon/mm/vm_tlb.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <asm/page.h>
 #include <asm/hexagon_vm.h>
+#include <asm/tlbflush.h>
 
 /*
  * Initial VM implementation has only one map active at a time, with
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

