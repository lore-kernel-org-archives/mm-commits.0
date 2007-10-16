From: akpm@linux-foundation.org
Subject: - uml-remove-sysdep-threadh.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:21 -0700
Message-ID: <200710162037.l9GKbLoh015285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935254AbXJPVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove sysdep/thread.h
has been removed from the -mm tree.  Its filename was
     uml-remove-sysdep-threadh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: remove sysdep/thread.h
From: Jeff Dike <jdike@addtoit.com>

This patch removes thread.h, which turns out not to be needed any more.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/kernel-offsets.h |    1 -
 arch/um/include/sysdep-i386/sigcontext.h     |    3 ++-
 arch/um/include/sysdep-i386/thread.h         |    8 --------
 arch/um/include/sysdep-x86_64/thread.h       |    6 ------
 arch/um/sys-i386/ptrace_user.c               |    1 -
 5 files changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/um/include/sysdep-i386/kernel-offsets.h~uml-remove-sysdep-threadh arch/um/include/sysdep-i386/kernel-offsets.h
--- a/arch/um/include/sysdep-i386/kernel-offsets.h~uml-remove-sysdep-threadh
+++ a/arch/um/include/sysdep-i386/kernel-offsets.h
@@ -17,6 +17,5 @@
 
 void foo(void)
 {
-	OFFSET(HOST_TASK_DEBUGREGS, task_struct, thread.arch.debugregs);
 #include <common-offsets.h>
 }
diff -puN arch/um/include/sysdep-i386/sigcontext.h~uml-remove-sysdep-threadh arch/um/include/sysdep-i386/sigcontext.h
--- a/arch/um/include/sysdep-i386/sigcontext.h~uml-remove-sysdep-threadh
+++ a/arch/um/include/sysdep-i386/sigcontext.h
@@ -7,7 +7,8 @@
 #define __SYS_SIGCONTEXT_I386_H
 
 #include "uml-config.h"
-#include <sysdep/sc.h>
+#include "skas.h"
+#include "sysdep/sc.h"
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
diff -puN arch/um/include/sysdep-i386/thread.h~uml-remove-sysdep-threadh /dev/null
--- a/arch/um/include/sysdep-i386/thread.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __UM_THREAD_H
-#define __UM_THREAD_H
-
-#include <kern_constants.h>
-
-#define TASK_DEBUGREGS(task) ((unsigned long *) &(((char *) (task))[HOST_TASK_DEBUGREGS]))
-
-#endif
diff -puN arch/um/include/sysdep-x86_64/thread.h~uml-remove-sysdep-threadh /dev/null
--- a/arch/um/include/sysdep-x86_64/thread.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_THREAD_H
-#define __UM_THREAD_H
-
-#include <kern_constants.h>
-
-#endif
diff -puN arch/um/sys-i386/ptrace_user.c~uml-remove-sysdep-threadh arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-remove-sysdep-threadh
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -11,7 +11,6 @@
 /* Grr, asm/user.h includes asm/ptrace.h, so has to follow ptrace_user.h */
 #include <asm/user.h>
 #include "kern_util.h"
-#include "sysdep/thread.h"
 #include "user.h"
 #include "os.h"
 #include "uml-config.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
