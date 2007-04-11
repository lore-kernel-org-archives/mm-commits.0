From: akpm@linux-foundation.org
Subject: + uml-dump-core-on-panic.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:25:41 -0700
Message-ID: <200704112025.l3BKPgJc013570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXDKUZs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: dump core on panic
has been added to the -mm tree.  Its filename is
     uml-dump-core-on-panic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: dump core on panic
From: Jeff Dike <jdike@addtoit.com>

Dump core after a panic.  This will provide better debugging information than
is currently available.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h     |    1 +
 arch/um/kernel/um_arch.c |    2 +-
 arch/um/os-Linux/util.c  |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/um/include/os.h~uml-dump-core-on-panic arch/um/include/os.h
--- a/arch/um/include/os.h~uml-dump-core-on-panic
+++ a/arch/um/include/os.h
@@ -279,6 +279,7 @@ extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
 extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
+extern void os_dump_core(void);
 
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
diff -puN arch/um/kernel/um_arch.c~uml-dump-core-on-panic arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-dump-core-on-panic
+++ a/arch/um/kernel/um_arch.c
@@ -474,7 +474,7 @@ static int panic_exit(struct notifier_bl
 	show_regs(&(current->thread.regs));
 	bust_spinlocks(0);
 	uml_exitcode = 1;
-	machine_halt();
+	os_dump_core();
 	return 0;
 }
 
diff -puN arch/um/os-Linux/util.c~uml-dump-core-on-panic arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-dump-core-on-panic
+++ a/arch/um/os-Linux/util.c
@@ -119,3 +119,9 @@ int setjmp_wrapper(void (*proc)(void *, 
 	va_end(args);
 	return n;
 }
+
+void os_dump_core(void)
+{
+	signal(SIGSEGV, SIG_DFL);
+	abort();
+}
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
