From: akpm@linux-foundation.org
Subject: + h8300-trival-patches.patch added to -mm tree
Date: Wed, 30 May 2007 20:43:17 -0700
Message-ID: <200705310343.l4V3hGg1011657@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862AbXEaDn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 23:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300 trival patches
has been added to the -mm tree.  Its filename is
     h8300-trival-patches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: h8300 trival patches
From: Yoshinori Sato <ysato@users.sourceforge.jp>

- warning fix.
- call trace area check fix.
- There is no meaning, ' & ' it deletes

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/sys_h8300.c |    4 ++--
 arch/h8300/kernel/traps.c     |    2 +-
 include/asm-h8300/processor.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/h8300/kernel/sys_h8300.c~h8300-trival-patches arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~h8300-trival-patches
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -288,9 +288,9 @@ asmlinkage void syscall_print(void *dumm
 int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 {
 	register long res __asm__("er0");
+	register char *const *_c __asm__("er3") = envp;
+	register char *const *_b __asm__("er2") = argv;
 	register const char * _a __asm__("er1") = filename;
-	register void *_b __asm__("er2") = argv;
-	register void *_c __asm__("er3") = envp;
 	__asm__ __volatile__ ("mov.l %1,er0\n\t"
 			"trapa	#0\n\t"
 			: "=r" (res)
diff -puN arch/h8300/kernel/traps.c~h8300-trival-patches arch/h8300/kernel/traps.c
--- a/arch/h8300/kernel/traps.c~h8300-trival-patches
+++ a/arch/h8300/kernel/traps.c
@@ -136,7 +136,7 @@ void show_stack(struct task_struct *task
 	printk("\nCall Trace:");
 	i = 0;
 	stack = esp;
-	while (((unsigned long)stack & (THREAD_SIZE - 1)) == 0) {
+	while (((unsigned long)stack & (THREAD_SIZE - 1)) != 0) {
 		addr = *stack++;
 		/*
 		 * If the address is either in the text segment of the
diff -puN include/asm-h8300/processor.h~h8300-trival-patches include/asm-h8300/processor.h
--- a/include/asm-h8300/processor.h~h8300-trival-patches
+++ a/include/asm-h8300/processor.h
@@ -78,7 +78,7 @@ struct thread_struct {
 do {							        \
 	set_fs(USER_DS);           /* reads from user space */  \
   	(_regs)->pc = (_pc);				        \
-	(_regs)->ccr &= 0x00;	   /* clear kernel flag */      \
+	(_regs)->ccr = 0x00;	   /* clear all flags */        \
 	(_regs)->er5 = current->mm->start_data;	/* GOT base */  \
 	wrusp((unsigned long)(_usp) - sizeof(unsigned long)*3);	\
 } while(0)
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
h8300-trival-patches.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
