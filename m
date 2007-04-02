From: akpm@linux-foundation.org
Subject: + uml-kernel_thread-shouldnt-panic.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:46:28 -0700
Message-ID: <200704022146.l32LkSYb010306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48377 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965973AbXDBVqb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: kernel_thread shouldn't panic
has been added to the -mm tree.  Its filename is
     uml-kernel_thread-shouldnt-panic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: kernel_thread shouldn't panic
From: Jeff Dike <jdike@addtoit.com>

kernel_thread() should just return an error value on do_fork failure, not
panic.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/um/kernel/process.c~uml-kernel_thread-shouldnt-panic arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-kernel_thread-shouldnt-panic
+++ a/arch/um/kernel/process.c
@@ -97,8 +97,6 @@ int kernel_thread(int (*fn)(void *), voi
 	current->thread.request.u.thread.arg = arg;
 	pid = do_fork(CLONE_VM | CLONE_UNTRACED | flags, 0,
 		      &current->thread.regs, 0, NULL, NULL);
-	if(pid < 0)
-		panic("do_fork failed in kernel_thread, errno = %d", pid);
 	return pid;
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
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
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
