From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-h8300.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:44 -0700
Message-ID: <20120913233645.3DC9D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:57579 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088Ab2IMXgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:46 -0400
Received: by vbis24 with SMTP id s24so388964vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, ysato@users.sourceforge.jp


The patch titled
     Subject: sections: fix section conflicts in arch/h8300
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-h8300.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/h8300

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
+const int __initconst h8300_saved_vectors[]={
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

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

