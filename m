From: akpm@linux-foundation.org
Subject: - utrace-uml-make-uml-compile-with-utrace-enabled.patch removed from -mm tree
Date: Wed, 25 Apr 2007 14:32:50 -0700
Message-ID: <200704252132.l3PLWoDF013516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993119AbXDYVdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 17:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     utrace: uml: make UML compile with utrace enabled
has been removed from the -mm tree.  Its filename was
     utrace-uml-make-uml-compile-with-utrace-enabled.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: utrace: uml: make UML compile with utrace enabled
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

* The prototype of arch_ptrace doesn't match the one in include/linux/ptrace.h.
* utrace_um_native is referred to by utrace_native_view but never defined.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/ptrace.c~utrace-uml-make-uml-compile-with-utrace-enabled arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~utrace-uml-make-uml-compile-with-utrace-enabled
+++ a/arch/um/kernel/ptrace.c
@@ -16,7 +16,12 @@ void ptrace_disable(struct task_struct *
 { 
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+const struct utrace_regset_view utrace_um_native;
+
+int arch_ptrace(long *request, struct task_struct *child,
+		       struct utrace_attached_engine *engine,
+		       unsigned long addr, unsigned long data,
+		       long *retval)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
uml-eliminate-temporary-buffer-in-eth_configure.patch
uml-replace-one-element-array-with-zero-element-array.patch
uml-fix-umid-in-xterm-titles.patch
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
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
git-gccbug.patch
