Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8ACC197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjKPV5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjKPV5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:57:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467A111F
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:57:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF3BC433C7;
        Thu, 16 Nov 2023 21:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700171846;
        bh=TiJr7403RdZiGlK4svrM0e0wGniI6EBuz5OapGSz0bg=;
        h=Date:To:From:Subject:From;
        b=W2bRcF2hHWCNdrPhN5ewTwg6HosqDU8wlQVCGiB1/hzNp3SY6OtnXUe3vxUuYGbEr
         jEcPZytHM97YUKhz3fcAqQGrgoYm64R/xnq8/MpWt6ZHpnWlCb4UFU/+9cpba3chM/
         pZ8QBg4F0Gm4rdq8a9TNtD+53VDl4iH8uB6P3PnY=
Date:   Thu, 16 Nov 2023 13:57:25 -0800
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        arnd@arndb.de, hca@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-remove-arch_task_struct_on_stack.patch added to mm-nonmm-unstable branch
Message-Id: <20231116215726.BEF3BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch: remove ARCH_TASK_STRUCT_ON_STACK
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-remove-arch_task_struct_on_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-remove-arch_task_struct_on_stack.patch

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
Subject: arch: remove ARCH_TASK_STRUCT_ON_STACK
Date: Thu, 16 Nov 2023 14:36:38 +0100

IA-64 was the only architecture which selected ARCH_TASK_STRUCT_ON_STACK.
IA-64 was removed with commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture"). Therefore remove support for ARCH_TASK_STRUCT_ON_STACK
as well.

Note: this also reveals a potential bug in powerpc code, which makes use of
__init_task_data without selecting ARCH_TASK_STRUCT_ON_STACK which makes
__init_task_data a no-op. This is broken since commit d11ed3ab3166 ("Expand
INIT_TASK() in init/init_task.c and remove") from 2018 and needs to be
addressed separately.

Link: https://lkml.kernel.org/r/20231116133638.1636277-4-hca@linux.ibm.com
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                 |    4 ----
 arch/powerpc/kexec/core_64.c |    3 +--
 include/linux/init_task.h    |    7 -------
 include/linux/sched.h        |    2 --
 init/init_task.c             |   10 ++--------
 5 files changed, 3 insertions(+), 23 deletions(-)

--- a/arch/Kconfig~arch-remove-arch_task_struct_on_stack
+++ a/arch/Kconfig
@@ -301,10 +301,6 @@ config ARCH_HAS_DMA_CLEAR_UNCACHED
 config ARCH_HAS_CPU_FINALIZE_INIT
 	bool
 
-# Select if arch init_task must go in the __init_task_data section
-config ARCH_TASK_STRUCT_ON_STACK
-	bool
-
 config HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	bool
 	help
--- a/arch/powerpc/kexec/core_64.c~arch-remove-arch_task_struct_on_stack
+++ a/arch/powerpc/kexec/core_64.c
@@ -283,8 +283,7 @@ static void kexec_prepare_cpus(void)
  * We could use a smaller stack if we don't care about anything using
  * current, but that audit has not been performed.
  */
-static union thread_union kexec_stack __init_task_data =
-	{ };
+static union thread_union kexec_stack = { };
 
 /*
  * For similar reasons to the stack above, the kexecing CPU needs to be on a
--- a/include/linux/init_task.h~arch-remove-arch_task_struct_on_stack
+++ a/include/linux/init_task.h
@@ -37,13 +37,6 @@ extern struct cred init_cred;
 
 #define INIT_TASK_COMM "swapper"
 
-/* Attach to the init_task data structure for proper alignment */
-#ifdef CONFIG_ARCH_TASK_STRUCT_ON_STACK
-#define __init_task_data __section(".data..init_task")
-#else
-#define __init_task_data /**/
-#endif
-
 /* Attach to the thread_info data structure for proper alignment */
 #define __init_thread_info __section(".data..init_thread_info")
 
--- a/include/linux/sched.h~arch-remove-arch_task_struct_on_stack
+++ a/include/linux/sched.h
@@ -1955,9 +1955,7 @@ extern void ia64_set_curr_task(int cpu,
 void yield(void);
 
 union thread_union {
-#ifndef CONFIG_ARCH_TASK_STRUCT_ON_STACK
 	struct task_struct task;
-#endif
 #ifndef CONFIG_THREAD_INFO_IN_TASK
 	struct thread_info thread_info;
 #endif
--- a/init/init_task.c~arch-remove-arch_task_struct_on_stack
+++ a/init/init_task.c
@@ -51,8 +51,7 @@ static struct sighand_struct init_sighan
 };
 
 #ifdef CONFIG_SHADOW_CALL_STACK
-unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)]
-		__init_task_data = {
+unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)] = {
 	[(SCS_SIZE / sizeof(long)) - 1] = SCS_END_MAGIC
 };
 #endif
@@ -61,12 +60,7 @@ unsigned long init_shadow_call_stack[SCS
  * Set up the first task table, touch at your own risk!. Base=0,
  * limit=0x1fffff (=2MB)
  */
-struct task_struct init_task
-#ifdef CONFIG_ARCH_TASK_STRUCT_ON_STACK
-	__init_task_data
-#endif
-	__aligned(L1_CACHE_BYTES)
-= {
+struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	.thread_info	= INIT_THREAD_INFO(init_task),
 	.stack_refcount	= REFCOUNT_INIT(1),
_

Patches currently in -mm which might be from hca@linux.ibm.com are

arch-remove-arch_thread_stack_allocator.patch
arch-remove-arch_task_struct_allocator.patch
arch-remove-arch_task_struct_on_stack.patch

