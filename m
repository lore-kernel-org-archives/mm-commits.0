From: akpm@linux-foundation.org
Subject: + um-disable-scan_elf_aux-on-x86_64.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:15 -0700
Message-ID: <201107222255.p6MMtFvw020035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: disable scan_elf_aux() on x86_64
has been added to the -mm tree.  Its filename is
     um-disable-scan_elf_aux-on-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: disable scan_elf_aux() on x86_64
From: Richard Weinberger <richard@nod.at>

Reusing the host's vDSO makes only sense on x86_32.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/Makefile  |    4 +++-
 arch/um/os-Linux/elf_aux.c |    7 +------
 arch/um/os-Linux/main.c    |    4 ++++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN arch/um/os-Linux/Makefile~um-disable-scan_elf_aux-on-x86_64 arch/um/os-Linux/Makefile
--- a/arch/um/os-Linux/Makefile~um-disable-scan_elf_aux-on-x86_64
+++ a/arch/um/os-Linux/Makefile
@@ -3,10 +3,12 @@
 # Licensed under the GPL
 #
 
-obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
+obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
 	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
 
+obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
+
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
 	tty.o tls.o uaccess.o umid.o util.o
diff -puN arch/um/os-Linux/elf_aux.c~um-disable-scan_elf_aux-on-x86_64 arch/um/os-Linux/elf_aux.c
--- a/arch/um/os-Linux/elf_aux.c~um-disable-scan_elf_aux-on-x86_64
+++ a/arch/um/os-Linux/elf_aux.c
@@ -14,16 +14,11 @@
 #include "mem_user.h"
 #include <kern_constants.h>
 
-/* Use the one from the kernel - the host may miss it, if having old headers. */
-#if UM_ELF_CLASS == UM_ELFCLASS32
 typedef Elf32_auxv_t elf_auxv_t;
-#else
-typedef Elf64_auxv_t elf_auxv_t;
-#endif
 
 /* These are initialized very early in boot and never changed */
 char * elf_aux_platform;
-long elf_aux_hwcap;
+extern long elf_aux_hwcap;
 unsigned long vsyscall_ehdr;
 unsigned long vsyscall_end;
 unsigned long __kernel_vsyscall;
diff -puN arch/um/os-Linux/main.c~um-disable-scan_elf_aux-on-x86_64 arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~um-disable-scan_elf_aux-on-x86_64
+++ a/arch/um/os-Linux/main.c
@@ -21,6 +21,8 @@
 #define STACKSIZE (8 * 1024 * 1024)
 #define THREAD_NAME_LEN (256)
 
+long elf_aux_hwcap;
+
 static void set_stklim(void)
 {
 	struct rlimit lim;
@@ -143,7 +145,9 @@ int __init main(int argc, char **argv, c
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
 
+#ifdef CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA
 	scan_elf_aux(envp);
+#endif
 
 	do_uml_initcalls();
 	ret = linux_main(argc, argv);
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
um-disable-scan_elf_aux-on-x86_64.patch
um-set-__have_arch_gate_area-for-i386.patch
um-set-__have_arch_gate_area-for-x86_64.patch
um-implement-a-x86_64-vdso.patch
um-ajdust-size-of-pid_buf.patch
um-remove-dead-code.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

