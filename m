From: akpm@linux-foundation.org
Subject: + lib-bugc-use-common-warn-helper.patch added to -mm tree
Date: Tue, 23 Feb 2016 15:03:14 -0800
Message-ID: <56cce532.cPOMCyMHAX0DkIht%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbcBWXDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 18:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, chuhu@redhat.com, heiko.carstens@de.ibm.com, prarit@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bug.c: use common WARN helper
has been added to the -mm tree.  Its filename is
     lib-bugc-use-common-warn-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bugc-use-common-warn-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bugc-use-common-warn-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: lib/bug.c: use common WARN helper

The traceoff_on_warning option doesn't have any effect on s390, powerpc,
arm64, parisc, and sh because there are two different types of WARN
implementations:

1) The above mentioned architectures treat WARN() as a special case of a
   BUG() exception.  They handle warnings in report_bug() in lib/bug.c.

2) All other architectures just call warn_slowpath_*() directly.  Their
   warnings are handled in warn_slowpath_common() in kernel/panic.c.

Support traceoff_on_warning on all architectures and prevent any future
divergence by using a single common function to emit the warning.

Also remove the '()' from '%pS()', because the parentheses look funky:

  [   45.607629] WARNING: at /root/warn_mod/warn_mod.c:17 .init_dummy+0x20/0x40 [warn_mod]()

Reported-by: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    6 +++++
 kernel/panic.c            |   41 ++++++++++++++++++++++--------------
 lib/bug.c                 |   26 +---------------------
 3 files changed, 34 insertions(+), 39 deletions(-)

diff -puN include/asm-generic/bug.h~lib-bugc-use-common-warn-helper include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~lib-bugc-use-common-warn-helper
+++ a/include/asm-generic/bug.h
@@ -81,6 +81,12 @@ extern void warn_slowpath_null(const cha
 	do { printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
 
+/* used internally by panic.c */
+struct warn_args;
+
+void __warn(const char *file, int line, void *caller, unsigned taint,
+	    struct pt_regs *regs, struct warn_args *args);
+
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
diff -puN kernel/panic.c~lib-bugc-use-common-warn-helper kernel/panic.c
--- a/kernel/panic.c~lib-bugc-use-common-warn-helper
+++ a/kernel/panic.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/console.h>
+#include <linux/bug.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -449,20 +450,25 @@ void oops_exit(void)
 	kmsg_dump(KMSG_DUMP_OOPS);
 }
 
-#ifdef WANT_WARN_ON_SLOWPATH
-struct slowpath_args {
+struct warn_args {
 	const char *fmt;
 	va_list args;
 };
 
-static void warn_slowpath_common(const char *file, int line, void *caller,
-				 unsigned taint, struct slowpath_args *args)
+void __warn(const char *file, int line, void *caller, unsigned taint,
+	    struct pt_regs *regs, struct warn_args *args)
 {
 	disable_trace_on_warning();
 
 	pr_warn("------------[ cut here ]------------\n");
-	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
-		raw_smp_processor_id(), current->pid, file, line, caller);
+
+	if (file)
+		pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS\n",
+			raw_smp_processor_id(), current->pid, file, line,
+			caller);
+	else
+		pr_warn("WARNING: CPU: %d PID: %d at %pS\n",
+			raw_smp_processor_id(), current->pid, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);
@@ -479,20 +485,27 @@ static void warn_slowpath_common(const c
 	}
 
 	print_modules();
-	dump_stack();
+
+	if (regs)
+		show_regs(regs);
+	else
+		dump_stack();
+
 	print_oops_end_marker();
+
 	/* Just a warning, don't kill lockdep. */
 	add_taint(taint, LOCKDEP_STILL_OK);
 }
 
+#ifdef WANT_WARN_ON_SLOWPATH
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
-	struct slowpath_args args;
+	struct warn_args args;
 
 	args.fmt = fmt;
 	va_start(args.args, fmt);
-	warn_slowpath_common(file, line, __builtin_return_address(0),
-			     TAINT_WARN, &args);
+	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL,
+	       &args);
 	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
@@ -500,20 +513,18 @@ EXPORT_SYMBOL(warn_slowpath_fmt);
 void warn_slowpath_fmt_taint(const char *file, int line,
 			     unsigned taint, const char *fmt, ...)
 {
-	struct slowpath_args args;
+	struct warn_args args;
 
 	args.fmt = fmt;
 	va_start(args.args, fmt);
-	warn_slowpath_common(file, line, __builtin_return_address(0),
-			     taint, &args);
+	__warn(file, line, __builtin_return_address(0), taint, NULL, &args);
 	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
 void warn_slowpath_null(const char *file, int line)
 {
-	warn_slowpath_common(file, line, __builtin_return_address(0),
-			     TAINT_WARN, NULL);
+	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
diff -puN lib/bug.c~lib-bugc-use-common-warn-helper lib/bug.c
--- a/lib/bug.c~lib-bugc-use-common-warn-helper
+++ a/lib/bug.c
@@ -167,30 +167,8 @@ enum bug_trap_type report_bug(unsigned l
 
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
-		pr_warn("------------[ cut here ]------------\n");
-
-		if (file)
-			pr_warn("WARNING: at %s:%u\n", file, line);
-		else
-			pr_warn("WARNING: at %p [verbose debug info unavailable]\n",
-				(void *)bugaddr);
-
-		if (panic_on_warn) {
-			/*
-			 * This thread may hit another WARN() in the panic path.
-			 * Resetting this prevents additional WARN() from
-			 * panicking the system on this thread.  Other threads
-			 * are blocked by the panic_mutex in panic().
-			 */
-			panic_on_warn = 0;
-			panic("panic_on_warn set ...\n");
-		}
