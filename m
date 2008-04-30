From: akpm@linux-foundation.org
Subject: - proper-__do_softirq-prototype.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:09 -0700
Message-ID: <200804300540.m3U5e9mt028935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbYD3Fki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     proper __do_softirq() prototype
has been removed from the -mm tree.  Its filename was
     proper-__do_softirq-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper __do_softirq() prototype
From: Adrian Bunk <bunk@kernel.org>

Add a proper prototype for __do_softirq() in include/linux/interrupt.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/irq.c    |    2 --
 arch/sh/kernel/irq.c      |    2 --
 arch/x86/kernel/irq_32.c  |    2 --
 include/asm-powerpc/irq.h |    2 --
 include/linux/interrupt.h |    1 +
 5 files changed, 1 insertion(+), 8 deletions(-)

diff -puN arch/s390/kernel/irq.c~proper-__do_softirq-prototype arch/s390/kernel/irq.c
--- a/arch/s390/kernel/irq.c~proper-__do_softirq-prototype
+++ a/arch/s390/kernel/irq.c
@@ -60,8 +60,6 @@ init_IRQ(void)
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */
-extern void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags, old, new;
diff -puN arch/sh/kernel/irq.c~proper-__do_softirq-prototype arch/sh/kernel/irq.c
--- a/arch/sh/kernel/irq.c~proper-__do_softirq-prototype
+++ a/arch/sh/kernel/irq.c
@@ -200,8 +200,6 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-extern asmlinkage void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff -puN arch/x86/kernel/irq_32.c~proper-__do_softirq-prototype arch/x86/kernel/irq_32.c
--- a/arch/x86/kernel/irq_32.c~proper-__do_softirq-prototype
+++ a/arch/x86/kernel/irq_32.c
@@ -190,8 +190,6 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-extern asmlinkage void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff -puN include/asm-powerpc/irq.h~proper-__do_softirq-prototype include/asm-powerpc/irq.h
--- a/include/asm-powerpc/irq.h~proper-__do_softirq-prototype
+++ a/include/asm-powerpc/irq.h
@@ -619,8 +619,6 @@ struct pt_regs;
 
 #define __ARCH_HAS_DO_SOFTIRQ
 
-extern void __do_softirq(void);
-
 #ifdef CONFIG_IRQSTACKS
 /*
  * Per-cpu stacks for handling hard and soft interrupts.
diff -puN include/linux/interrupt.h~proper-__do_softirq-prototype include/linux/interrupt.h
--- a/include/linux/interrupt.h~proper-__do_softirq-prototype
+++ a/include/linux/interrupt.h
@@ -289,6 +289,7 @@ struct softirq_action
 };
 
 asmlinkage void do_softirq(void);
+asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

