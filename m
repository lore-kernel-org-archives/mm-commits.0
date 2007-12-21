From: akpm@linux-foundation.org
Subject: + uml-header-untangling-fix.patch added to -mm tree
Date: Fri, 21 Dec 2007 02:12:40 -0800
Message-ID: <200712211012.lBLACeYg008283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755024AbXLUKMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 05:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     UML: add asm/fixmap.h include
has been added to the -mm tree.  Its filename is
     uml-header-untangling-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UML: add asm/fixmap.h include
From: Jeff Dike <jdike@addtoit.com>

um_uaccess.h refers to FIXADDR_USER_*, so it should include fixmap.h.

I also changed the non-UML includes to use <> instead of "".

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/um_uaccess.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/include/um_uaccess.h~uml-header-untangling-fix arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-header-untangling-fix
+++ a/arch/um/include/um_uaccess.h
@@ -6,7 +6,8 @@
 #ifndef __ARCH_UM_UACCESS_H
 #define __ARCH_UM_UACCESS_H
 
-#include "asm/elf.h"
+#include <asm/elf.h>
+#include <asm/fixmap.h>
 #include "sysdep/archsetjmp.h"
 
 #define __under_task_size(addr, size) \
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
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
uml-header-untangling-fix.patch
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
