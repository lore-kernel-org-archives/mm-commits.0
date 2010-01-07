From: akpm@linux-foundation.org
Subject: [merged] fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch removed from -mm tree
Date: Thu, 07 Jan 2010 13:10:21 -0800
Message-ID: <201001072110.o07LALLB017665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159Ab0AGVLN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:11:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, david_mccullough@mcafee.com, dhowells@redhat.com, gerg@uclinux.org, jie.zhang@analog.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     fdpic: respect PT_GNU_STACK exec protection markings when creating NOMMU stack
has been removed from the -mm tree.  Its filename was
     fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fdpic: respect PT_GNU_STACK exec protection markings when creating NOMMU stack
From: Mike Frysinger <vapier@gentoo.org>

The current code will load the stack size and protection markings, but
then only use the markings in the MMU code path.  The NOMMU code path
always passes PROT_EXEC to the mmap() call.  While this doesn't matter to
most people whilst the code is running, it will cause a pointless icache
flush when starting every FDPIC application.  Typically this icache flush
will be of a region on the order of 128KB in size, or may be the entire
icache, depending on the facilities available on the CPU.

In the case where the arch default behaviour seems to be desired
(EXSTACK_DEFAULT), we probe VM_STACK_FLAGS for VM_EXEC to determine
whether we should be setting PROT_EXEC or not.

For arches that support an MPU (Memory Protection Unit - an MMU without
the virtual mapping capability), setting PROT_EXEC or not will make an
important

It should be noted that this change also affects the executability of the
brk region, since ELF-FDPIC has that share with the stack.  However, this
is probably irrelevant as NOMMU programs aren't likely to use the brk
region, preferring instead allocation via mmap().

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jie Zhang <jie.zhang@analog.com>
Cc: David McCullough <david_mccullough@mcafee.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/page.h |    5 +++++
 arch/frv/include/asm/page.h      |    2 --
 fs/binfmt_elf_fdpic.c            |   13 +++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff -puN arch/blackfin/include/asm/page.h~fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack arch/blackfin/include/asm/page.h
--- a/arch/blackfin/include/asm/page.h~fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack
+++ a/arch/blackfin/include/asm/page.h
@@ -10,4 +10,9 @@
 #include <asm-generic/page.h>
 #define MAP_NR(addr) (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT)
 
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
 #endif
diff -puN arch/frv/include/asm/page.h~fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack arch/frv/include/asm/page.h
--- a/arch/frv/include/asm/page.h~fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack
+++ a/arch/frv/include/asm/page.h
@@ -63,12 +63,10 @@ extern unsigned long max_pfn;
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 
-#ifdef CONFIG_MMU
 #define VM_DATA_DEFAULT_FLAGS \
 	(VM_READ | VM_WRITE | \
 	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-#endif
 
 #endif /* __ASSEMBLY__ */
 
diff -puN fs/binfmt_elf_fdpic.c~fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack
+++ a/fs/binfmt_elf_fdpic.c
@@ -171,6 +171,9 @@ static int load_elf_fdpic_binary(struct 
 #ifdef ELF_FDPIC_PLAT_INIT
 	unsigned long dynaddr;
 #endif
+#ifndef CONFIG_MMU
+	unsigned long stack_prot;
+#endif
 	struct file *interpreter = NULL; /* to shut gcc up */
 	char *interpreter_name = NULL;
 	int executable_stack;
@@ -316,6 +319,8 @@ static int load_elf_fdpic_binary(struct 
 	 * defunct, deceased, etc. after this point we have to exit via
 	 * error_kill */
 	set_personality(PER_LINUX_FDPIC);
+	if (elf_read_implies_exec(&exec_params.hdr, executable_stack))
+		current->personality |= READ_IMPLIES_EXEC;
 	set_binfmt(&elf_fdpic_format);
 
 	current->mm->start_code = 0;
@@ -377,9 +382,13 @@ static int load_elf_fdpic_binary(struct 
 	if (stack_size < PAGE_SIZE * 2)
 		stack_size = PAGE_SIZE * 2;
 
+	stack_prot = PROT_READ | PROT_WRITE;
+	if (executable_stack == EXSTACK_ENABLE_X ||
+	    (executable_stack == EXSTACK_DEFAULT && VM_STACK_FLAGS & VM_EXEC))
+		stack_prot |= PROT_EXEC;
+
 	down_write(&current->mm->mmap_sem);
-	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
-					 PROT_READ | PROT_WRITE | PROT_EXEC,
+	current->mm->start_brk = do_mmap(NULL, 0, stack_size, stack_prot,
 					 MAP_PRIVATE | MAP_ANONYMOUS |
 					 MAP_UNINITIALIZED | MAP_GROWSDOWN,
 					 0);
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch

