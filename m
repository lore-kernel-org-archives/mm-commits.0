From: akpm@linux-foundation.org
Subject: [merged] m68k-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:07 -0700
Message-ID: <201107260753.p6Q7rAM3003210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1GZHx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, geert@linux-m68k.org, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68k, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     m68k-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/processor.h |    4 ----
 arch/m68k/kernel/process_mm.c     |    2 +-
 arch/m68k/kernel/process_no.c     |    2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/m68k/include/asm/processor.h~m68k-exec-remove-redundant-set_fsuser_ds arch/m68k/include/asm/processor.h
--- a/arch/m68k/include/asm/processor.h~m68k-exec-remove-redundant-set_fsuser_ds
+++ a/arch/m68k/include/asm/processor.h
@@ -105,9 +105,6 @@ struct thread_struct {
 static inline void start_thread(struct pt_regs * regs, unsigned long pc,
 				unsigned long usp)
 {
-	/* reads from user space */
-	set_fs(USER_DS);
-
 	regs->pc = pc;
 	regs->sr &= ~0x2000;
 	wrusp(usp);
@@ -129,7 +126,6 @@ extern int handle_kernel_fault(struct pt
 
 #define start_thread(_regs, _pc, _usp)                  \
 do {                                                    \
-	set_fs(USER_DS); /* reads from user space */    \
 	(_regs)->pc = (_pc);                            \
 	((struct switch_stack *)(_regs))[-1].a6 = 0;    \
 	reformat(_regs);                                \
diff -puN arch/m68k/kernel/process_mm.c~m68k-exec-remove-redundant-set_fsuser_ds arch/m68k/kernel/process_mm.c
--- a/arch/m68k/kernel/process_mm.c~m68k-exec-remove-redundant-set_fsuser_ds
+++ a/arch/m68k/kernel/process_mm.c
@@ -185,7 +185,7 @@ EXPORT_SYMBOL(kernel_thread);
 void flush_thread(void)
 {
 	unsigned long zero = 0;
-	set_fs(USER_DS);
+
 	current->thread.fs = __USER_DS;
 	if (!FPU_IS_EMU)
 		asm volatile (".chip 68k/68881\n\t"
diff -puN arch/m68k/kernel/process_no.c~m68k-exec-remove-redundant-set_fsuser_ds arch/m68k/kernel/process_no.c
--- a/arch/m68k/kernel/process_no.c~m68k-exec-remove-redundant-set_fsuser_ds
+++ a/arch/m68k/kernel/process_no.c
@@ -158,7 +158,7 @@ void flush_thread(void)
 #ifdef CONFIG_FPU
 	unsigned long zero = 0;
 #endif
-	set_fs(USER_DS);
+
 	current->thread.fs = __USER_DS;
 #ifdef CONFIG_FPU
 	if (!FPU_IS_EMU)
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
linux-next.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch

