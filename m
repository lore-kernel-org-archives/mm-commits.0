From: akpm@linux-foundation.org
Subject: + uml-get-rid-of-syscall-counters.patch added to -mm tree
Date: Wed, 12 Dec 2007 13:20:06 -0800
Message-ID: <200712122120.lBCLK6lH030261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbXLLVUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 16:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: get rid of syscall counters
has been added to the -mm tree.  Its filename is
     uml-get-rid-of-syscall-counters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: get rid of syscall counters
From: Jeff Dike <jdike@addtoit.com>

Get rid of some syscall counters which haven't been useful in ages.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h        |    1 -
 arch/um/kernel/skas/syscall.c      |    3 ---
 arch/um/kernel/syscall.c           |    3 ---
 include/asm-um/processor-generic.h |    2 --
 4 files changed, 9 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-get-rid-of-syscall-counters arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-get-rid-of-syscall-counters
+++ a/arch/um/include/kern_util.h
@@ -13,7 +13,6 @@ extern int uml_exitcode;
 
 extern int ncpus;
 extern int kmalloc_ok;
-extern int nsyscalls;
 
 #define UML_ROUND_UP(addr) \
 	((((unsigned long) addr) + PAGE_SIZE - 1) & PAGE_MASK)
diff -puN arch/um/kernel/skas/syscall.c~uml-get-rid-of-syscall-counters arch/um/kernel/skas/syscall.c
--- a/arch/um/kernel/skas/syscall.c~uml-get-rid-of-syscall-counters
+++ a/arch/um/kernel/skas/syscall.c
@@ -17,9 +17,6 @@ void handle_syscall(struct uml_pt_regs *
 
 	syscall_trace(r, 0);
 
-	current->thread.nsyscalls++;
-	nsyscalls++;
-
 	/*
 	 * This should go in the declaration of syscall, but when I do that,
 	 * strace -f -c bash -c 'ls ; ls' breaks, sometimes not tracing
diff -puN arch/um/kernel/syscall.c~uml-get-rid-of-syscall-counters arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-get-rid-of-syscall-counters
+++ a/arch/um/kernel/syscall.c
@@ -13,9 +13,6 @@
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
 
-/*  Unlocked, I don't care if this is a bit off */
-int nsyscalls = 0;
-
 long sys_fork(void)
 {
 	long ret;
diff -puN include/asm-um/processor-generic.h~uml-get-rid-of-syscall-counters include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-get-rid-of-syscall-counters
+++ a/include/asm-um/processor-generic.h
@@ -26,7 +26,6 @@ struct thread_struct {
 	 * as of 2.6.11).
 	 */
 	int forking;
-	int nsyscalls;
 	struct pt_regs regs;
 	int singlestep_syscall;
 	void *fault_addr;
@@ -58,7 +57,6 @@ struct thread_struct {
 #define INIT_THREAD \
 { \
 	.forking		= 0, \
-	.nsyscalls		= 0, \
 	.regs		   	= EMPTY_REGS,	\
 	.fault_addr		= NULL, \
 	.prev_sched		= NULL, \
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-runtime-detection-of-host-vmsplit-on-i386.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
