From: akpm@linux-foundation.org
Subject: - better-interface-for-hooking-early-initcalls.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:16 -0700
Message-ID: <200807262114.m6QLEGQ2019681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbYGZVOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eduard.munteanu@linux360.ro, tzanussi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Better interface for hooking early initcalls
has been removed from the -mm tree.  Its filename was
     better-interface-for-hooking-early-initcalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Better interface for hooking early initcalls
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Added early initcall (pre-SMP) support, using an identical interface to
that of regular initcalls.  Functions called from do_pre_smp_initcalls()
could be converted to use this cleaner interface.

This is required by CPU hotplug, because early users have to register
notifiers before going SMP.  One such CPU hotplug user is the relay
interface with buffer-only channels, which needs to register such a
notifier, to be usable in early code.  This in turn is used by kmemtrace.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    2 ++
 include/linux/init.h              |    7 +++++++
 init/main.c                       |   13 +++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~better-interface-for-hooking-early-initcalls include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~better-interface-for-hooking-early-initcalls
+++ a/include/asm-generic/vmlinux.lds.h
@@ -359,6 +359,8 @@
 	}
 
 #define INITCALLS							\
+	*(.initcallearly.init)						\
+	__early_initcall_end = .;					\
   	*(.initcall0.init)						\
   	*(.initcall0s.init)						\
   	*(.initcall1.init)						\
diff -puN include/linux/init.h~better-interface-for-hooking-early-initcalls include/linux/init.h
--- a/include/linux/init.h~better-interface-for-hooking-early-initcalls
+++ a/include/linux/init.h
@@ -170,6 +170,13 @@ extern void (*late_time_init)(void);
 	__attribute__((__section__(".initcall" level ".init"))) = fn
 
 /*
+ * Early initcalls run before initializing SMP.
+ *
+ * Only for built-in code, not modules.
+ */
+#define early_initcall(fn)		__define_initcall("early",fn,early)
+
+/*
  * A "pure" initcall has no dependencies on anything else, and purely
  * initializes variables that couldn't be statically initialized.
  *
diff -puN init/main.c~better-interface-for-hooking-early-initcalls init/main.c
--- a/init/main.c~better-interface-for-hooking-early-initcalls
+++ a/init/main.c
@@ -743,13 +743,13 @@ static void __init do_one_initcall(initc
 }
 
 
-extern initcall_t __initcall_start[], __initcall_end[];
+extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
 
 static void __init do_initcalls(void)
 {
 	initcall_t *call;
 
-	for (call = __initcall_start; call < __initcall_end; call++)
+	for (call = __early_initcall_end; call < __initcall_end; call++)
 		do_one_initcall(*call);
 
 	/* Make sure there is no pending stuff from the initcall sequence */
@@ -783,6 +783,14 @@ static int __init nosoftlockup_setup(cha
 }
 __setup("nosoftlockup", nosoftlockup_setup);
 
+static void __init __do_pre_smp_initcalls(void)
+{
+	initcall_t *call;
+
+	for (call = __initcall_start; call < __early_initcall_end; call++)
+		do_one_initcall(*call);
+}
+
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
@@ -865,6 +873,7 @@ static int __init kernel_init(void * unu
 
 	smp_prepare_cpus(setup_max_cpus);
 
+	__do_pre_smp_initcalls();
 	do_pre_smp_initcalls();
 
 	smp_init();
_

Patches currently in -mm which might be from eduard.munteanu@linux360.ro are

origin.patch

