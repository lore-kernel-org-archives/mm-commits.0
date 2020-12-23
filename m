Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AE8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AE422573
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLWBtb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLWBta (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 20:49:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D40C52256F;
        Wed, 23 Dec 2020 01:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608688130;
        bh=LOGMzroGHtn844gh/D9qe37BILudgjd+8bBnn1vcP7k=;
        h=Date:From:To:Subject:From;
        b=cmL2rxKVxhK/aKHzdmEr6RRU+tYEi/Ums7/2MBwWfCHIRh1RlzK8HS6oeA0p6aXAE
         DRgjbBDd41HLrg8ACReiKgPU1E/VjvIWFC+nASjoVfFtwGuTC83/bPP1PIERYC0qso
         K+1mpTGTcf0WL2GfL/zkRbI4ahwWFJ6KOIjbFih4=
Date:   Tue, 22 Dec 2020 17:48:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, richard@nod.at, jdike@addtoit.com,
        arnd@arndb.de, anton.ivanov@cambridgegreys.com,
        christophe.leroy@csgroup.eu
Subject:  + mm-remove-arch_remap-and-mm-arch-hooksh.patch added to
 -mm tree
Message-ID: <20201223014849.JSqV1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove arch_remap() and mm-arch-hooks.h
has been added to the -mm tree.  Its filename is
     mm-remove-arch_remap-and-mm-arch-hooksh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-arch_remap-and-mm-arch-hooksh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-arch_remap-and-mm-arch-hooksh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: remove arch_remap() and mm-arch-hooks.h

powerpc was the last provider of arch_remap() and the last user of
mm-arch-hooks.h.

Since commit 526a9c4a7234 ("powerpc/vdso: Provide vdso_remap()"),
arch_remap() hence mm-arch-hooks.h are not used anymore.

Remove them.

Link: https://lkml.kernel.org/r/320d7a9ed7b379a6e0edf16d539bc22447272e65.1608299993.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/Kbuild          |    1 -
 include/asm-generic/Kbuild          |    1 -
 include/asm-generic/mm-arch-hooks.h |   16 ----------------
 include/linux/mm-arch-hooks.h       |   22 ----------------------
 mm/mremap.c                         |    3 ---
 5 files changed, 43 deletions(-)

--- a/arch/um/include/asm/Kbuild~mm-remove-arch_remap-and-mm-arch-hooksh
+++ a/arch/um/include/asm/Kbuild
@@ -14,7 +14,6 @@ generic-y += irq_regs.h
 generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += mcs_spinlock.h
-generic-y += mm-arch-hooks.h
 generic-y += mmiowb.h
 generic-y += module.lds.h
 generic-y += param.h
--- a/include/asm-generic/Kbuild~mm-remove-arch_remap-and-mm-arch-hooksh
+++ a/include/asm-generic/Kbuild
@@ -34,7 +34,6 @@ mandatory-y += kmap_size.h
 mandatory-y += kprobes.h
 mandatory-y += linkage.h
 mandatory-y += local.h
-mandatory-y += mm-arch-hooks.h
 mandatory-y += mmiowb.h
 mandatory-y += mmu.h
 mandatory-y += mmu_context.h
--- a/include/asm-generic/mm-arch-hooks.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Architecture specific mm hooks
- */
-
-#ifndef _ASM_GENERIC_MM_ARCH_HOOKS_H
-#define _ASM_GENERIC_MM_ARCH_HOOKS_H
-
-/*
- * This file should be included through arch/../include/asm/Kbuild for
- * the architecture which doesn't need specific mm hooks.
- *
- * In that case, the generic hooks defined in include/linux/mm-arch-hooks.h
- * are used.
- */
-
-#endif /* _ASM_GENERIC_MM_ARCH_HOOKS_H */
--- a/include/linux/mm-arch-hooks.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Generic mm no-op hooks.
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- */
-#ifndef _LINUX_MM_ARCH_HOOKS_H
-#define _LINUX_MM_ARCH_HOOKS_H
-
-#include <asm/mm-arch-hooks.h>
-
-#ifndef arch_remap
-static inline void arch_remap(struct mm_struct *mm,
-			      unsigned long old_start, unsigned long old_end,
-			      unsigned long new_start, unsigned long new_end)
-{
-}
-#define arch_remap arch_remap
-#endif
-
-#endif /* _LINUX_MM_ARCH_HOOKS_H */
--- a/mm/mremap.c~mm-remove-arch_remap-and-mm-arch-hooksh
+++ a/mm/mremap.c
@@ -22,7 +22,6 @@
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
-#include <linux/mm-arch-hooks.h>
 #include <linux/userfaultfd_k.h>
 
 #include <asm/cacheflush.h>
@@ -562,8 +561,6 @@ static unsigned long move_vma(struct vm_
 		new_addr = err;
 	} else {
 		mremap_userfaultfd_prep(new_vma, uf);
-		arch_remap(mm, old_addr, old_addr + old_len,
-			   new_addr, new_addr + new_len);
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-remove-arch_remap-and-mm-arch-hooksh.patch

