From: akpm@linux-foundation.org
Subject: + uml-dont-kill-pid-0.patch added to -mm tree
Date: Wed, 12 Dec 2007 13:20:04 -0800
Message-ID: <200712122120.lBCLK4KW030258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbXLLVUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 16:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: don't kill pid 0
has been added to the -mm tree.  Its filename is
     uml-dont-kill-pid-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: don't kill pid 0
From: Jeff Dike <jdike@addtoit.com>

A bit of defensive programming - during development, it ocassionally
happens that a call to init_new_context is missed, resulting in
context holding a host pid of zero.  When that address space is torn
down, destroy_context does a kill(0), which instantly kills the whole
UML without any errors whatsoever.

This patch add a check for pids less than 2, to also catch 1 and
negative pids.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/mmu.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/skas/mmu.c~uml-dont-kill-pid-0 arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-dont-kill-pid-0
+++ a/arch/um/kernel/skas/mmu.c
@@ -164,8 +164,20 @@ void destroy_context(struct mm_struct *m
 
 	if (proc_mm)
 		os_close_file(mmu->id.u.mm_fd);
-	else
+	else {
+		/*
+		 * If init_new_context wasn't called, this will be
+		 * zero, resulting in a kill(0), which will result in the
+		 * whole UML suddenly dying.  Also, cover negative and
+		 * 1 cases, since they shouldn't happen either.
+		 */
+		if (mmu->id.u.pid < 2) {
+			printk(KERN_ERR "corrupt mm_context - pid = %d\n",
+			       mmu->id.u.pid);
+			return;
+		}
 		os_kill_ptraced_process(mmu->id.u.pid, 1);
+	}
 
 	if (skas_needs_stub)
 		free_page(mmu->id.stack);
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
