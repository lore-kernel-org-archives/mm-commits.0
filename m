Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F7CC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27BE361205
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346746AbhIIVGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348075AbhIIVGJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B814E611BD;
        Thu,  9 Sep 2021 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221499;
        bh=xrG38aeW9OMrgSygGsR7iFL5LynLi2T17pgRSBlWec4=;
        h=Date:From:To:Subject:From;
        b=WGQ/MlK5zfQNTl70+FK6p+09d72/ZSe7GyMKD1MQs3tgm8+ocVs0SQ9aiYwHHfXu8
         VYbLXXeJzACM8AyfLlPXGRYyL8fqr7otGZRyCDGUf88DUuYZAnC1WIqdOv1XfzRbkW
         BMErsHIkgki5MCrSIc0Gh1PFHxIn8RmkNP0qtiKM=
Date:   Thu, 09 Sep 2021 14:04:58 -0700
From:   akpm@linux-foundation.org
To:     anton.ivanov@cambridgegreys.com, benh@kernel.crashing.org,
        deller@gmx.de, James.Bottomley@HansenPartnership.com,
        jdike@addtoit.com, jonas@southpole.se, ley.foon.tan@intel.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        palmerdabbelt@google.com, paulus@samba.org, richard@nod.at,
        rmk+kernel@armlinux.org.uk, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, wangkefeng.wang@huawei.com,
        ysato@users.sourceforge.jp
Subject:  [merged] trap-cleanup-trap_init.patch removed from -mm
 tree
Message-ID: <20210909210458.I7-87YxJi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: trap: cleanup trap_init()
has been removed from the -mm tree.  Its filename was
     trap-cleanup-trap_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: trap: cleanup trap_init()

There are some empty trap_init() definitions in different ARCHs, Introduce
a new weak trap_init() function to clean them up.

Link: https://lkml.kernel.org/r/20210812123602.76356-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>	[arm32]
Acked-by: Vineet Gupta						[arc]
Acked-by: Michael Ellerman <mpe@ellerman.id.au>			[powerpc]
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <palmerdabbelt@google.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/traps.c      |    5 -----
 arch/arm/kernel/traps.c      |    5 -----
 arch/h8300/kernel/traps.c    |    4 ----
 arch/hexagon/kernel/traps.c  |    4 ----
 arch/nds32/kernel/traps.c    |    5 -----
 arch/nios2/kernel/traps.c    |    5 -----
 arch/openrisc/kernel/traps.c |    5 -----
 arch/parisc/kernel/traps.c   |    4 ----
 arch/powerpc/kernel/traps.c  |    5 -----
 arch/riscv/kernel/traps.c    |    5 -----
 arch/um/kernel/trap.c        |    4 ----
 init/main.c                  |    2 ++
 12 files changed, 2 insertions(+), 51 deletions(-)

--- a/arch/arc/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/arc/kernel/traps.c
@@ -20,11 +20,6 @@
 #include <asm/unaligned.h>
 #include <asm/kprobes.h>
 
-void __init trap_init(void)
-{
-	return;
-}
-
 void die(const char *str, struct pt_regs *regs, unsigned long address)
 {
 	show_kernel_fault_diag(str, regs, address);
--- a/arch/arm/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/arm/kernel/traps.c
@@ -781,11 +781,6 @@ void abort(void)
 	panic("Oops failed to kill thread");
 }
 
-void __init trap_init(void)
-{
-	return;
-}
-
 #ifdef CONFIG_KUSER_HELPERS
 static void __init kuser_init(void *vectors)
 {
--- a/arch/h8300/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/h8300/kernel/traps.c
@@ -39,10 +39,6 @@ void __init base_trap_init(void)
 {
 }
 
-void __init trap_init(void)
-{
-}
-
 asmlinkage void set_esp0(unsigned long ssp)
 {
 	current->thread.esp0 = ssp;
--- a/arch/hexagon/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/hexagon/kernel/traps.c
@@ -28,10 +28,6 @@
 #define TRAP_SYSCALL	1
 #define TRAP_DEBUG	0xdb
 
-void __init trap_init(void)
-{
-}
-
 #ifdef CONFIG_GENERIC_BUG
 /* Maybe should resemble arch/sh/kernel/traps.c ?? */
 int is_valid_bugaddr(unsigned long addr)
--- a/arch/nds32/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/nds32/kernel/traps.c
@@ -183,11 +183,6 @@ void __pgd_error(const char *file, int l
 }
 
 extern char *exception_vector, *exception_vector_end;
-void __init trap_init(void)
-{
-	return;
-}
-
 void __init early_trap_init(void)
 {
 	unsigned long ivb = 0;
--- a/arch/nios2/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/nios2/kernel/traps.c
@@ -105,11 +105,6 @@ void show_stack(struct task_struct *task
 	printk("%s\n", loglvl);
 }
 
-void __init trap_init(void)
-{
-	/* Nothing to do here */
-}
-
 /* Breakpoint handler */
 asmlinkage void breakpoint_c(struct pt_regs *fp)
 {
--- a/arch/openrisc/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/openrisc/kernel/traps.c
@@ -231,11 +231,6 @@ void unhandled_exception(struct pt_regs
 	die("Oops", regs, 9);
 }
 
-void __init trap_init(void)
-{
-	/* Nothing needs to be done */
-}
-
 asmlinkage void do_trap(struct pt_regs *regs, unsigned long address)
 {
 	force_sig_fault(SIGTRAP, TRAP_BRKPT, (void __user *)regs->pc);
--- a/arch/parisc/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/parisc/kernel/traps.c
@@ -859,7 +859,3 @@ void  __init early_trap_init(void)
 
 	initialize_ivt(&fault_vector_20);
 }
-
-void __init trap_init(void)
-{
-}
--- a/arch/powerpc/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/powerpc/kernel/traps.c
@@ -2215,11 +2215,6 @@ DEFINE_INTERRUPT_HANDLER(kernel_bad_stac
 	die("Bad kernel stack pointer", regs, SIGABRT);
 }
 
-void __init trap_init(void)
-{
-}
-
-
 #ifdef CONFIG_PPC_EMULATED_STATS
 
 #define WARN_EMULATED_SETUP(type)	.type = { .name = #type }
--- a/arch/riscv/kernel/traps.c~trap-cleanup-trap_init
+++ a/arch/riscv/kernel/traps.c
@@ -199,11 +199,6 @@ int is_valid_bugaddr(unsigned long pc)
 }
 #endif /* CONFIG_GENERIC_BUG */
 
-/* stvec & scratch is already set from head.S */
-void __init trap_init(void)
-{
-}
-
 #ifdef CONFIG_VMAP_STACK
 static DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)],
 		overflow_stack)__aligned(16);
--- a/arch/um/kernel/trap.c~trap-cleanup-trap_init
+++ a/arch/um/kernel/trap.c
@@ -311,7 +311,3 @@ void winch(int sig, struct siginfo *unus
 {
 	do_IRQ(WINCH_IRQ, regs);
 }
-
-void trap_init(void)
-{
-}
--- a/init/main.c~trap-cleanup-trap_init
+++ a/init/main.c
@@ -777,6 +777,8 @@ void __init __weak poking_init(void) { }
 
 void __init __weak pgtable_cache_init(void) { }
 
+void __init __weak trap_init(void) { }
+
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


