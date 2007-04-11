From: akpm@linux-foundation.org
Subject: + uml-dont-try-to-handle-signals-on-initial-process-stack.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:25:43 -0700
Message-ID: <200704112025.l3BKPiZt013573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXDKUZr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: don't try to handle signals on initial process stack
has been added to the -mm tree.  Its filename is
     uml-dont-try-to-handle-signals-on-initial-process-stack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: don't try to handle signals on initial process stack
From: Jeff Dike <jdike@addtoit.com>

Code running on the initial UML stack can't receive or process signals since
current must be valid when IRQs are handled, and there is no current for this
stack.

So, instead of using UML_LONGJMP and UML_SETJMP, which are careful to save and
restore signal state, and, as a side-effect, handle any deferred signals,
start_idle_thread must use the bare equivalents, which don't do anything with
signals.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-dont-try-to-handle-signals-on-initial-process-stack arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-dont-try-to-handle-signals-on-initial-process-stack
+++ a/arch/um/os-Linux/skas/process.c
@@ -494,7 +494,15 @@ int start_idle_thread(void *stack, jmp_b
 		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGALRM,
 		    SIGVTALRM, -1);
 
-	n = UML_SETJMP(&initial_jmpbuf);
+	/*
+	 * Can't use UML_SETJMP or UML_LONGJMP here because they save
+	 * and restore signals, with the possible side-effect of
+	 * trying to handle any signals which came when they were
+	 * blocked, which can't be done on this stack.
+	 * Signals must be blocked when jumping back here and restored
+	 * after returning to the jumper.
+	 */
+	n = setjmp(initial_jmpbuf);
 	switch(n){
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
@@ -504,7 +512,7 @@ int start_idle_thread(void *stack, jmp_b
 		break;
 	case INIT_JMP_CALLBACK:
 		(*cb_proc)(cb_arg);
-		UML_LONGJMP(cb_back, 1);
+		longjmp(*cb_back, 1);
 		break;
 	case INIT_JMP_HALT:
 		kmalloc_ok = 0;
@@ -515,7 +523,7 @@ int start_idle_thread(void *stack, jmp_b
 	default:
 		panic("Bad sigsetjmp return in start_idle_thread - %d\n", n);
 	}
-	UML_LONGJMP(switch_buf, 1);
+	longjmp(*switch_buf, 1);
 }
 
 void initial_thread_cb_skas(void (*proc)(void *), void *arg)
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
