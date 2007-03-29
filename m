From: akpm@linux-foundation.org
Subject: - fix-utrace-utrace-tracehook-um.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:47 -0700
Message-ID: <200703292339.l2TNdlRQ015458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945954AbXC2Xj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix utrace-utrace-tracehook-um
has been removed from the -mm tree.  Its filename was
     fix-utrace-utrace-tracehook-um.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix utrace-utrace-tracehook-um
From: Jeff Dike <jdike@addtoit.com>

When auditing is configured there are some mismatched types in ptrace.c

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/um/kernel/ptrace.c~fix-utrace-utrace-tracehook-um arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~fix-utrace-utrace-tracehook-um
+++ a/arch/um/kernel/ptrace.c
@@ -48,8 +48,8 @@ void do_syscall_trace(struct pt_regs *re
 		secure_computing(PT_REGS_SYSCALL_NR(regs));
 
 	if (unlikely(current->audit_context) && entryexit)
-		audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(regs)),
-				   UPT_SYSCALL_RET(regs));
+		audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(&regs->regs)),
+				   UPT_SYSCALL_RET(&regs->regs));
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, entryexit);
@@ -61,9 +61,9 @@ void do_syscall_trace(struct pt_regs *re
 
 	if (unlikely(current->audit_context) && !entryexit)
 		audit_syscall_entry(HOST_AUDIT_ARCH,
-					    UPT_SYSCALL_NR(regs),
-					    UPT_SYSCALL_ARG1(regs),
-					    UPT_SYSCALL_ARG2(regs),
-					    UPT_SYSCALL_ARG3(regs),
-					    UPT_SYSCALL_ARG4(regs));
+				    UPT_SYSCALL_NR(&regs->regs),
+				    UPT_SYSCALL_ARG1(&regs->regs),
+				    UPT_SYSCALL_ARG2(&regs->regs),
+				    UPT_SYSCALL_ARG3(&regs->regs),
+				    UPT_SYSCALL_ARG4(&regs->regs));
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
