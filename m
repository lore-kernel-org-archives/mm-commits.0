Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F89C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Nov 2023 16:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjKMQnj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Nov 2023 11:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKMQni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2023 11:43:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31174D53;
        Mon, 13 Nov 2023 08:43:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AFCC433C7;
        Mon, 13 Nov 2023 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699893814;
        bh=VV9L2BIh1A1TDShp08tq5N8z6K6agwYg9sCR8dbKvIM=;
        h=Date:To:From:Subject:From;
        b=d1gPoVitIlkekE/lHH0I+OpcmgwMibM7DmkzdC6keIfbSH36bis10NzOQ/Dyw9DGE
         ZJRu9aMTxCnLFCwAoyTA2wUNK/4bYww9Ba4JLbmNNexJ9JsVp4ak89lq0Jswmx2kG9
         Xfk5gq6bmMZmhMXc+iQEwhZpDAgycOHedM81OapE=
Date:   Mon, 13 Nov 2023 08:43:34 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matoro_mailinglist_kernel@matoro.tk, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-fix-mmap_base-calculation-when-stack-grows-upwards.patch added to mm-hotfixes-unstable branch
Message-Id: <20231113164334.C2AFCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: fix mmap_base calculation when stack grows upwards
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     parisc-fix-mmap_base-calculation-when-stack-grows-upwards.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-fix-mmap_base-calculation-when-stack-grows-upwards.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Helge Deller <deller@gmx.de>
Subject: parisc: fix mmap_base calculation when stack grows upwards
Date: Mon, 13 Nov 2023 11:12:57 +0100

Matoro reported various userspace crashes on the parisc platform with kernel
6.6 and bisected it to commit 3033cd430768 ("parisc: Use generic mmap top-down
layout and brk randomization").

That commit switched parisc to use the common infrastructure to calculate
mmap_base, but missed that the mmap_base() function takes care for
architectures where the stack grows downwards only.

Fix the mmap_base() calculation to include the stack-grows-upwards case
and thus fix the userspace crashes on parisc.

Link: https://lkml.kernel.org/r/ZVH2qeS1bG7/1J/l@p100
Fixes: 3033cd430768 ("parisc: Use generic mmap top-down layout and brk randomization")
Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig                 |    6 +++---
 arch/parisc/include/asm/elf.h       |   10 +---------
 arch/parisc/include/asm/processor.h |    2 ++
 arch/parisc/kernel/sys_parisc.c     |    2 +-
 mm/util.c                           |   10 ++++++++++
 5 files changed, 17 insertions(+), 13 deletions(-)

--- a/arch/parisc/include/asm/elf.h~parisc-fix-mmap_base-calculation-when-stack-grows-upwards
+++ a/arch/parisc/include/asm/elf.h
@@ -349,15 +349,7 @@ struct pt_regs;	/* forward declaration..
 
 #define ELF_HWCAP	0
 
-/* Masks for stack and mmap randomization */
-#define BRK_RND_MASK	(is_32bit_task() ? 0x07ffUL : 0x3ffffUL)
-#define MMAP_RND_MASK	(is_32bit_task() ? 0x1fffUL : 0x3ffffUL)
-#define STACK_RND_MASK	MMAP_RND_MASK
-
-struct mm_struct;
-extern unsigned long arch_randomize_brk(struct mm_struct *);
-#define arch_randomize_brk arch_randomize_brk
-
+#define STACK_RND_MASK	0x7ff	/* 8MB of VA */
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 struct linux_binprm;
--- a/arch/parisc/include/asm/processor.h~parisc-fix-mmap_base-calculation-when-stack-grows-upwards
+++ a/arch/parisc/include/asm/processor.h
@@ -47,6 +47,8 @@
 
 #ifndef __ASSEMBLY__
 
+struct rlimit;
+unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
--- a/arch/parisc/Kconfig~parisc-fix-mmap_base-calculation-when-stack-grows-upwards
+++ a/arch/parisc/Kconfig
@@ -140,11 +140,11 @@ config ARCH_MMAP_RND_COMPAT_BITS_MIN
 	default 8
 
 config ARCH_MMAP_RND_BITS_MAX
-	default 24 if 64BIT
-	default 17
+	default 18 if 64BIT
+	default 13
 
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
-	default 17
+	default 13
 
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
--- a/arch/parisc/kernel/sys_parisc.c~parisc-fix-mmap_base-calculation-when-stack-grows-upwards
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsign
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-static unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
 {
 	unsigned long stack_base;
 
--- a/mm/util.c~parisc-fix-mmap_base-calculation-when-stack-grows-upwards
+++ a/mm/util.c
@@ -414,6 +414,15 @@ static int mmap_is_legacy(struct rlimit
 
 static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	/*
+	 * For an upwards growing stack the calculation is much simpler.
+	 * Memory for the maximum stack size is reserved at the top of the
+	 * task. mmap_base starts directly below the stack and grows
+	 * downwards.
+	 */
+	return PAGE_ALIGN_DOWN(mmap_upper_limit(rlim_stack) - rnd);
+#else
 	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_guard_gap;
 
@@ -431,6 +440,7 @@ static unsigned long mmap_base(unsigned
 		gap = MAX_GAP;
 
 	return PAGE_ALIGN(STACK_TOP - gap - rnd);
+#endif
 }
 
 void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
_

Patches currently in -mm which might be from deller@gmx.de are

parisc-fix-mmap_base-calculation-when-stack-grows-upwards.patch

