Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406DFC197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjKPV53 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbjKPV52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:57:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83886189
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:57:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0EFC433C7;
        Thu, 16 Nov 2023 21:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700171845;
        bh=zD4hGH2KoTD97xxauAyqf7kh4kdnPIthVgTUzvKtXaE=;
        h=Date:To:From:Subject:From;
        b=hv0ImZ2sq9E78A5ihcpLrk1A+SpR4K7aV52xdegIn3Q+1LxobNrpttmbPQ/GfR8J2
         GT3tYIDPCwJJ2zdxAdUaPIKPo8h/b8Qj4LnpPzI5eWXogLk3lOjaGUgAeM6e7vY7HU
         /P6aWa7Ri/7JeXwLF8o+EodlDIyaYY34UmCjn8kM=
Date:   Thu, 16 Nov 2023 13:57:24 -0800
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        arnd@arndb.de, hca@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-remove-arch_task_struct_allocator.patch added to mm-nonmm-unstable branch
Message-Id: <20231116215725.0F0EFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch: remove ARCH_TASK_STRUCT_ALLOCATOR
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-remove-arch_task_struct_allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-remove-arch_task_struct_allocator.patch

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
Subject: arch: remove ARCH_TASK_STRUCT_ALLOCATOR
Date: Thu, 16 Nov 2023 14:36:37 +0100

IA-64 was the only architecture which selected ARCH_TASK_STRUCT_ALLOCATOR.
IA-64 was removed with commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture"). Therefore remove support for ARCH_THREAD_STACK_ALLOCATOR
as well.

Link: https://lkml.kernel.org/r/20231116133638.1636277-3-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |    5 -----
 kernel/fork.c |    6 ------
 2 files changed, 11 deletions(-)

--- a/arch/Kconfig~arch-remove-arch_task_struct_allocator
+++ a/arch/Kconfig
@@ -305,13 +305,8 @@ config ARCH_HAS_CPU_FINALIZE_INIT
 config ARCH_TASK_STRUCT_ON_STACK
 	bool
 
-# Select if arch has its private alloc_task_struct() function
-config ARCH_TASK_STRUCT_ALLOCATOR
-	bool
-
 config HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	bool
-	depends on !ARCH_TASK_STRUCT_ALLOCATOR
 	help
 	  An architecture should select this to provide hardened usercopy
 	  knowledge about what region of the thread_struct should be
--- a/kernel/fork.c~arch-remove-arch_task_struct_allocator
+++ a/kernel/fork.c
@@ -165,7 +165,6 @@ void __weak arch_release_task_struct(str
 {
 }
 
-#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static struct kmem_cache *task_struct_cachep;
 
 static inline struct task_struct *alloc_task_struct_node(int node)
@@ -177,7 +176,6 @@ static inline void free_task_struct(stru
 {
 	kmem_cache_free(task_struct_cachep, tsk);
 }
-#endif
 
 /*
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
@@ -1019,7 +1017,6 @@ static void set_max_threads(unsigned int
 int arch_task_struct_size __read_mostly;
 #endif
 
-#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static void task_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
 	/* Fetch thread_struct whitelist for the architecture. */
@@ -1034,12 +1031,10 @@ static void task_struct_whitelist(unsign
 	else
 		*offset += offsetof(struct task_struct, thread);
 }
-#endif /* CONFIG_ARCH_TASK_STRUCT_ALLOCATOR */
 
 void __init fork_init(void)
 {
 	int i;
-#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
@@ -1052,7 +1047,6 @@ void __init fork_init(void)
 			arch_task_struct_size, align,
 			SLAB_PANIC|SLAB_ACCOUNT,
 			useroffset, usersize, NULL);
-#endif
 
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
_

Patches currently in -mm which might be from hca@linux.ibm.com are

arch-remove-arch_thread_stack_allocator.patch
arch-remove-arch_task_struct_allocator.patch
arch-remove-arch_task_struct_on_stack.patch

