From: akpm@linux-foundation.org
Subject: [merged] asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:22 -0700
Message-ID: <201105271956.p4RJuR8h017558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879Ab1E0T5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dongdong.deng@windriver.com, hpa@zytor.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@redhat.com, oleg@redhat.com, sshtylyov@mvista.com, tglx@linutronix


The patch titled
     asm-generic/ptrace.h: start a common low level ptrace helper
has been removed from the -mm tree.  Its filename was
     asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/ptrace.h: start a common low level ptrace helper
From: Mike Frysinger <vapier@gentoo.org>

This is a series of low level ptrace unification steps to make it easier
for common code (like KGDB) to poke at register state.  This also avoids
having to duplicate higher level operations for most ports which don't
have special needs for accessing things.


This patch:

This implements a bunch of helper funcs for poking the registers of a
ptrace structure.  Now common code should be able to portably update
specific registers (like kgdb updating the PC).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/ptrace.h |   74 +++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff -puN /dev/null include/asm-generic/ptrace.h
--- /dev/null
+++ a/include/asm-generic/ptrace.h
@@ -0,0 +1,74 @@
+/*
+ * Common low level (register) ptrace helpers
+ *
+ * Copyright 2004-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __ASM_GENERIC_PTRACE_H__
+#define __ASM_GENERIC_PTRACE_H__
+
+#ifndef __ASSEMBLY__
+
+/* Helpers for working with the instruction pointer */
+#ifndef GET_IP
+#define GET_IP(regs) ((regs)->pc)
+#endif
+#ifndef SET_IP
+#define SET_IP(regs, val) (GET_IP(regs) = (val))
+#endif
+
+static inline unsigned long instruction_pointer(struct pt_regs *regs)
+{
+	return GET_IP(regs);
+}
+static inline void instruction_pointer_set(struct pt_regs *regs,
+                                           unsigned long val)
+{
+	SET_IP(regs, val);
+}
+
+#ifndef profile_pc
+#define profile_pc(regs) instruction_pointer(regs)
+#endif
+
+/* Helpers for working with the user stack pointer */
+#ifndef GET_USP
+#define GET_USP(regs) ((regs)->usp)
+#endif
+#ifndef SET_USP
+#define SET_USP(regs, val) (GET_USP(regs) = (val))
+#endif
+
+static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+{
+	return GET_USP(regs);
+}
+static inline void user_stack_pointer_set(struct pt_regs *regs,
+                                          unsigned long val)
+{
+	SET_USP(regs, val);
+}
+
+/* Helpers for working with the frame pointer */
+#ifndef GET_FP
+#define GET_FP(regs) ((regs)->fp)
+#endif
+#ifndef SET_FP
+#define SET_FP(regs, val) (GET_FP(regs) = (val))
+#endif
+
+static inline unsigned long frame_pointer(struct pt_regs *regs)
+{
+	return GET_FP(regs);
+}
+static inline void frame_pointer_set(struct pt_regs *regs,
+                                     unsigned long val)
+{
+	SET_FP(regs, val);
+}
+
+#endif /* __ASSEMBLY__ */
+
+#endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch

