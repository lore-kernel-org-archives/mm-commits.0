From: akpm@linux-foundation.org
Subject: + uml-tidy-processc-fix.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:12:25 -0700
Message-ID: <200704070112.l371CP9n024480@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXDGBM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: tidy process.c (fix)
has been added to the -mm tree.  Its filename is
     uml-tidy-processc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
