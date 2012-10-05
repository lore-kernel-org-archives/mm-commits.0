From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-h8300.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:18 -0700
Message-ID: <20121005201218.ACA2F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45609 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:19 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236268vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/h8300
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-h8300.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/h8300

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/sys_h8300.c     |    1 +
 arch/h8300/kernel/timer/itu.c     |    2 +-
 arch/h8300/kernel/timer/timer16.c |    2 +-
 arch/h8300/kernel/timer/timer8.c  |    2 +-
 arch/h8300/kernel/timer/tpu.c     |    2 +-
 arch/h8300/platform/h8300h/irq.c  |    4 ++--
 arch/h8300/platform/h8s/irq.c     |    4 ++--
 7 files changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/h8300/kernel/sys_h8300.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -51,6 +51,7 @@ asmlinkage void syscall_print(void *dumm
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff -puN arch/h8300/kernel/timer/itu.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/kernel/timer/itu.c
--- a/arch/h8300/kernel/timer/itu.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/kernel/timer/itu.c
@@ -62,7 +62,7 @@ static struct irqaction itu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int __initconst divide_rate[] = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff -puN arch/h8300/kernel/timer/timer16.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/kernel/timer/timer16.c
--- a/arch/h8300/kernel/timer/timer16.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/kernel/timer/timer16.c
@@ -57,7 +57,7 @@ static struct irqaction timer16_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int __initconst divide_rate[] = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff -puN arch/h8300/kernel/timer/timer8.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/kernel/timer/timer8.c
--- a/arch/h8300/kernel/timer/timer8.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/kernel/timer/timer8.c
@@ -77,7 +77,7 @@ static struct irqaction timer8_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {8, 64, 8192};
+static const int __initconst divide_rate[] = {8, 64, 8192};
 
 void __init h8300_timer_setup(void)
 {
diff -puN arch/h8300/kernel/timer/tpu.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/kernel/timer/tpu.c
--- a/arch/h8300/kernel/timer/tpu.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/kernel/timer/tpu.c
@@ -66,7 +66,7 @@ static struct irqaction tpu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {
+static const int __initconst divide_rate[] = {
 #if CONFIG_H8300_TPU_CH == 0
 	1,4,16,64,0,0,0,0,
 #elif (CONFIG_H8300_TPU_CH == 1) || (CONFIG_H8300_TPU_CH == 5)
diff -puN arch/h8300/platform/h8300h/irq.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/platform/h8300h/irq.c
--- a/arch/h8300/platform/h8300h/irq.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/platform/h8300h/irq.c
@@ -14,14 +14,14 @@
 #include <asm/gpio-internal.h>
 #include <asm/regs306x.h>
 
-const int __initdata h8300_saved_vectors[] = {
+const int __initconst h8300_saved_vectors[] = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRAP3_VEC,	/* TRAPA #3 is GDB breakpoint */
 #endif
 	-1,
 };
 
-const h8300_vector __initdata h8300_trap_table[] = {
+const h8300_vector __initconst h8300_trap_table[] = {
 	0, 0, 0, 0, 0, 0, 0, 0,
 	system_call,
 	0,
diff -puN arch/h8300/platform/h8s/irq.c~sections-fix-section-conflicts-in-arch-h8300 arch/h8300/platform/h8s/irq.c
--- a/arch/h8300/platform/h8s/irq.c~sections-fix-section-conflicts-in-arch-h8300
+++ a/arch/h8300/platform/h8s/irq.c
@@ -18,7 +18,7 @@
 #include <asm/regs267x.h>
 
 /* saved vector list */
-const int __initdata h8300_saved_vectors[]={
+const int __initconst h8300_saved_vectors[] = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRACE_VEC,
 	TRAP3_VEC,
@@ -27,7 +27,7 @@ const int __initdata h8300_saved_vectors
 };
 
 /* trap entry table */
-const H8300_VECTOR __initdata h8300_trap_table[] = {
+const H8300_VECTOR __initconst h8300_trap_table[] = {
 	0,0,0,0,0,
 	trace_break,  /* TRACE */
 	0,0,
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

