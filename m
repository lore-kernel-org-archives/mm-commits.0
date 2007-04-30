From: akpm@linux-foundation.org
Subject: - uml-tidy-processc-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:22:46 -0700
Message-ID: <200704301922.l3UJMlgt012745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946713AbXD3TWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:22:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: tidy process.c (fix)
has been removed from the -mm tree.  Its filename was
     uml-tidy-processc-fix.patch

This patch was dropped because it was folded into uml-tidy-processc.patch

------------------------------------------------------
Subject: uml: tidy process.c (fix)
From: Jeff Dike <jdike@addtoit.com>

Use only one ifdef to mark stack_sp as being tt mode only.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/include/kern_util.h~uml-tidy-processc-fix arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-tidy-processc-fix
+++ a/arch/um/include/kern_util.h
@@ -8,6 +8,7 @@
 
 #include "sysdep/ptrace.h"
 #include "sysdep/faultinfo.h"
+#include "uml-config.h"
 
 typedef void (*kern_hndl)(int, union uml_pt_regs *);
 
@@ -33,7 +34,7 @@ extern int nsyscalls;
 	UML_ROUND_DOWN(((unsigned long) addr) + PAGE_SIZE - 1)
 
 extern int kernel_fork(unsigned long flags, int (*fn)(void *), void * arg);
-#if defined(CONFIG_MODE_TT) || defined(UML_CONFIG_MODE_TT)
+#ifdef UML_CONFIG_MODE_TT
 extern unsigned long stack_sp(unsigned long page);
 #endif
 extern int kernel_thread_proc(void *data);
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
array_size-check-for-type.patch
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
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
