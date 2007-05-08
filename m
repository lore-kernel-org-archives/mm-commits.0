From: akpm@linux-foundation.org
Subject: - uml-create-archh.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:17 -0700
Message-ID: <200705080006.l4806HjQ009171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967458AbXEHALq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: create arch.h
has been removed from the -mm tree.  Its filename was
     uml-create-archh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: create arch.h
From: Jeff Dike <jdike@addtoit.com>

This patch moves the declarations of the architecture hooks from user_util.h
to a new header, arch.c, and adds the necessary includes to files which need
those declarations.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/arch.h      |   15 +++++++++++++++
 arch/um/include/user_util.h |    4 ----
 arch/um/kernel/trap.c       |    1 +
 arch/um/kernel/um_arch.c    |    1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

diff -puN /dev/null arch/um/include/arch.h
--- /dev/null
+++ a/arch/um/include/arch.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __ARCH_H__
+#define __ARCH_H__
+
+#include "sysdep/ptrace.h"
+
+extern void arch_check_bugs(void);
+extern int arch_fixup(unsigned long address, void *sc_ptr);
+extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
+
+#endif
diff -puN arch/um/include/user_util.h~uml-create-archh arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~uml-create-archh
+++ a/arch/um/include/user_util.h
@@ -65,10 +65,6 @@ extern int attach(int pid);
 extern void kill_child_dead(int pid);
 extern int cont(int pid);
 extern void check_sigio(void);
-extern void arch_check_bugs(void);
-extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
-extern int arch_fixup(unsigned long address, void *sc_ptr);
-extern void arch_init_thread(void);
 extern int raw(int fd);
 
 #endif
diff -puN arch/um/kernel/trap.c~uml-create-archh arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-create-archh
+++ a/arch/um/kernel/trap.c
@@ -20,6 +20,7 @@
 #include "sysdep/sigcontext.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "arch.h"
 #include "kern.h"
 #include "chan_kern.h"
 #include "mconsole_kern.h"
diff -puN arch/um/kernel/um_arch.c~uml-create-archh arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-create-archh
+++ a/arch/um/kernel/um_arch.c
@@ -28,6 +28,7 @@
 #include "asm/current.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "arch.h"
 #include "kern.h"
 #include "mem_user.h"
 #include "mem.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
