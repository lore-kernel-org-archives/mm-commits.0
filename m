From: akpm@linux-foundation.org
Subject: [merged] ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:05 -0700
Message-ID: <20120326193205.71515A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35450 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2CZTcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:06 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so831445vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
has been removed from the -mm tree.  Its filename was
     ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code

Exchange PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which makes
PT_option bits contiguous and therefore makes code in ptrace_setoptions()
much simpler.

Every PTRACE_O_TRACEevent is defined to (1 << PTRACE_EVENT_event)
instead of using explicit numeric constants, to ensure we don't
mess up relationship between bit positions and event ids.

PT_EVENT_FLAG_SHIFT was not particularly useful, PT_OPT_FLAG_SHIFT with
value of PT_EVENT_FLAG_SHIFT-1 is easier to use.

PT_TRACE_MASK constant is nuked, the only its use is replaced by
(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT).

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   33 +++++++++++++++------------------
 kernel/ptrace.c        |   31 ++++++++-----------------------
 2 files changed, 23 insertions(+), 41 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code
+++ a/include/linux/ptrace.h
@@ -54,17 +54,6 @@
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
 
-/* options set using PTRACE_SETOPTIONS */
-#define PTRACE_O_TRACESYSGOOD	0x00000001
-#define PTRACE_O_TRACEFORK	0x00000002
-#define PTRACE_O_TRACEVFORK	0x00000004
-#define PTRACE_O_TRACECLONE	0x00000008
-#define PTRACE_O_TRACEEXEC	0x00000010
-#define PTRACE_O_TRACEVFORKDONE	0x00000020
-#define PTRACE_O_TRACEEXIT	0x00000040
-
-#define PTRACE_O_MASK		0x0000007f
-
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
@@ -74,6 +63,17 @@
 #define PTRACE_EVENT_EXIT	6
 #define PTRACE_EVENT_STOP	7
 
+/* options set using PTRACE_SETOPTIONS */
+#define PTRACE_O_TRACESYSGOOD	1
+#define PTRACE_O_TRACEFORK	(1 << PTRACE_EVENT_FORK)
+#define PTRACE_O_TRACEVFORK	(1 << PTRACE_EVENT_VFORK)
+#define PTRACE_O_TRACECLONE	(1 << PTRACE_EVENT_CLONE)
+#define PTRACE_O_TRACEEXEC	(1 << PTRACE_EVENT_EXEC)
+#define PTRACE_O_TRACEVFORKDONE	(1 << PTRACE_EVENT_VFORK_DONE)
+#define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
+
+#define PTRACE_O_MASK		0x0000007f
+
 #include <asm/ptrace.h>
 
 #ifdef __KERNEL__
@@ -88,13 +88,12 @@
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
-#define PT_TRACESYSGOOD	0x00000004
-#define PT_PTRACE_CAP	0x00000008	/* ptracer can follow suid-exec */
+#define PT_PTRACE_CAP	0x00000004	/* ptracer can follow suid-exec */
 
+#define PT_OPT_FLAG_SHIFT	3
 /* PT_TRACE_* event enable flags */
-#define PT_EVENT_FLAG_SHIFT	4
-#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
-
+#define PT_EVENT_FLAG(event)	(1 << (PT_OPT_FLAG_SHIFT + (event)))
+#define PT_TRACESYSGOOD		PT_EVENT_FLAG(0)
 #define PT_TRACE_FORK		PT_EVENT_FLAG(PTRACE_EVENT_FORK)
 #define PT_TRACE_VFORK		PT_EVENT_FLAG(PTRACE_EVENT_VFORK)
 #define PT_TRACE_CLONE		PT_EVENT_FLAG(PTRACE_EVENT_CLONE)
@@ -102,8 +101,6 @@
 #define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 
-#define PT_TRACE_MASK	0x000003f4
-
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
 #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
diff -puN kernel/ptrace.c~ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code
+++ a/kernel/ptrace.c
@@ -262,7 +262,7 @@ static int ptrace_attach(struct task_str
 
 	/*
 	 * Protect exec's credential calculations against our interference;
-	 * interference; SUID, SGID and LSM creds get determined differently
+	 * SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
@@ -528,31 +528,16 @@ int ptrace_writedata(struct task_struct 
 
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
+	unsigned flags;
+
 	if (data & ~(unsigned long)PTRACE_O_MASK)
 		return -EINVAL;
 
-	child->ptrace &= ~PT_TRACE_MASK;
-
-	if (data & PTRACE_O_TRACESYSGOOD)
-		child->ptrace |= PT_TRACESYSGOOD;
-
-	if (data & PTRACE_O_TRACEFORK)
-		child->ptrace |= PT_TRACE_FORK;
-
-	if (data & PTRACE_O_TRACEVFORK)
-		child->ptrace |= PT_TRACE_VFORK;
-
-	if (data & PTRACE_O_TRACECLONE)
-		child->ptrace |= PT_TRACE_CLONE;
-
-	if (data & PTRACE_O_TRACEEXEC)
-		child->ptrace |= PT_TRACE_EXEC;
-
-	if (data & PTRACE_O_TRACEVFORKDONE)
-		child->ptrace |= PT_TRACE_VFORK_DONE;
