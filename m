From: akpm@osdl.org
Subject: - uml-add-generic-bug-support.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:53 -0800
Message-ID: <200612082000.kB8K0r3q001787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426226AbWLHUBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     UML: add generic BUG support
has been removed from the -mm tree.  Its filename was
     uml-add-generic-bug-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UML: add generic BUG support
From: Jeff Dike <jdike@addtoit.com>

The BUG changes in -mm3 need some arch support.  This patch adds the UML
support needed.  For the most part, it was stolen from the underlying
architecture.  The exception is the kernel eip < PAGE_OFFSET test, which is
wrong for skas mode UMLs.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/Kconfig             |    5 +++++
 arch/um/sys-i386/Makefile   |    2 +-
 arch/um/sys-i386/bug.c      |   20 ++++++++++++++++++++
 arch/um/sys-x86_64/Makefile |    2 +-
 arch/um/sys-x86_64/bug.c    |   20 ++++++++++++++++++++
 include/asm-um/bug.h        |    4 +++-
 6 files changed, 50 insertions(+), 3 deletions(-)

diff -puN arch/um/Kconfig~uml-add-generic-bug-support arch/um/Kconfig
--- a/arch/um/Kconfig~uml-add-generic-bug-support
+++ a/arch/um/Kconfig
@@ -47,6 +47,11 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
diff -puN arch/um/sys-i386/Makefile~uml-add-generic-bug-support arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~uml-add-generic-bug-support
+++ a/arch/um/sys-i386/Makefile
@@ -1,4 +1,4 @@
-obj-y = bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
+obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o sigcontext.o syscalls.o sysrq.o \
 	sys_call_table.o tls.o
 
diff -puN /dev/null arch/um/sys-i386/bug.c
--- /dev/null
+++ a/arch/um/sys-i386/bug.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2006 Jeff Dike (jdike@addtoit.com)
+ * Licensed under the GPL V2
+ */
+
+#include <linux/uaccess.h>
+
+/* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
+ * that's not relevent in skas mode.
+ */
+
+int is_valid_bugaddr(unsigned long eip)
+{
+	unsigned short ud2;
+
+	if (probe_kernel_address((unsigned short __user *)eip, ud2))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
diff -puN arch/um/sys-x86_64/Makefile~uml-add-generic-bug-support arch/um/sys-x86_64/Makefile
--- a/arch/um/sys-x86_64/Makefile~uml-add-generic-bug-support
+++ a/arch/um/sys-x86_64/Makefile
@@ -4,7 +4,7 @@
 # Licensed under the GPL
 #
 
-obj-y = bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
+obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	setjmp.o sigcontext.o signal.o syscalls.o syscall_table.o sysrq.o \
 	ksyms.o tls.o
 
diff -puN /dev/null arch/um/sys-x86_64/bug.c
--- /dev/null
+++ a/arch/um/sys-x86_64/bug.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2006 Jeff Dike (jdike@addtoit.com)
+ * Licensed under the GPL V2
+ */
+
+#include <linux/uaccess.h>
+
+/* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
+ * that's not relevent in skas mode.
+ */
+
+int is_valid_bugaddr(unsigned long eip)
+{
+	unsigned short ud2;
+
+	if (probe_kernel_address((unsigned short __user *)eip, ud2))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
diff -puN include/asm-um/bug.h~uml-add-generic-bug-support include/asm-um/bug.h
--- a/include/asm-um/bug.h~uml-add-generic-bug-support
+++ a/include/asm-um/bug.h
@@ -1,4 +1,6 @@
 #ifndef __UM_BUG_H
 #define __UM_BUG_H
-#include <asm-generic/bug.h>
+
+#include <asm/arch/bug.h>
+
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field.patch
tty-switch-to-ktermios.patch
x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-fix-prototypes.patch

