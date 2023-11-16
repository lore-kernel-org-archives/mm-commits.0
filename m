Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D124C47071
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjKPV52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbjKPV51 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:57:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B0D194
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:57:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE57C433C8;
        Thu, 16 Nov 2023 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700171843;
        bh=85ez1i2XYeDTIEFXr2mmkQ3vrV6Ivu71MU191ea4kRw=;
        h=Date:To:From:Subject:From;
        b=W+H0sf28HZ8d9T/rEmqP2KhaEdC22wFpkn+etBs4zDLCfieFrsUWy1uc9JW9MDb8n
         LXVadIzQGpyUh95xrbB6k2DI0vOuX9VAGHHNqDQLzZvCJ/XvSSQMg9mfQwH/WpzkP9
         SNSs7/h/IYNUJQv2Zw3yxyrs9fdvvrJ/3iPDwuw0=
Date:   Thu, 16 Nov 2023 13:57:22 -0800
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        arnd@arndb.de, hca@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-remove-arch_thread_stack_allocator.patch added to mm-nonmm-unstable branch
Message-Id: <20231116215723.6FE57C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch: remove ARCH_THREAD_STACK_ALLOCATOR
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-remove-arch_thread_stack_allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-remove-arch_thread_stack_allocator.patch

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
From: Heiko Carstens <hca@linux.ibm.com>
Subject: arch: remove ARCH_THREAD_STACK_ALLOCATOR
Date: Thu, 16 Nov 2023 14:36:36 +0100

Patch series "Remove unused code after IA-64 removal".

While looking into something different I noticed that there are a couple
of Kconfig options which were only selected by IA-64 and which are now
unused.

So remove them and simplify the code a bit.


This patch (of 3):

IA-64 was the only architecture which selected ARCH_THREAD_STACK_ALLOCATOR.
IA-64 was removed with commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture"). Therefore remove support for ARCH_THREAD_STACK_ALLOCATOR as
well.

Link: https://lkml.kernel.org/r/20231116133638.1636277-1-hca@linux.ibm.com
Link: https://lkml.kernel.org/r/20231116133638.1636277-2-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |    4 ----
 kernel/fork.c |   20 --------------------
 2 files changed, 24 deletions(-)

--- a/arch/Kconfig~arch-remove-arch_thread_stack_allocator
+++ a/arch/Kconfig
@@ -320,10 +320,6 @@ config HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	  should be implemented. Without this, the entire thread_struct
 	  field in task_struct will be left whitelisted.
 
-# Select if arch has its private alloc_thread_stack() function
-config ARCH_THREAD_STACK_ALLOCATOR
-	bool
-
 # Select if arch wants to size task_struct dynamically via arch_task_struct_size:
 config ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	bool
--- a/kernel/fork.c~arch-remove-arch_thread_stack_allocator
+++ a/kernel/fork.c
@@ -179,8 +179,6 @@ static inline void free_task_struct(stru
 }
 #endif
 
-#ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
-
 /*
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
  * kmemcache based allocator.
@@ -412,24 +410,6 @@ void thread_stack_cache_init(void)
 }
 
 # endif /* THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK) */
-#else /* CONFIG_ARCH_THREAD_STACK_ALLOCATOR */
-
-static int alloc_thread_stack_node(struct task_struct *tsk, int node)
-{
-	unsigned long *stack;
-
-	stack = arch_alloc_thread_stack_node(tsk, node);
-	tsk->stack = stack;
-	return stack ? 0 : -ENOMEM;
-}
-
-static void free_thread_stack(struct task_struct *tsk)
-{
-	arch_free_thread_stack(tsk);
-	tsk->stack = NULL;
-}
-
-#endif /* !CONFIG_ARCH_THREAD_STACK_ALLOCATOR */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
_

Patches currently in -mm which might be from hca@linux.ibm.com are

arch-remove-arch_thread_stack_allocator.patch
arch-remove-arch_task_struct_allocator.patch
arch-remove-arch_task_struct_on_stack.patch

