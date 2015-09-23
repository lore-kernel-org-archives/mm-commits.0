From: akpm@linux-foundation.org
Subject: + kprobe-use-_do_fork-in-samples-to-make-them-work-again.patch
 added to -mm tree
Date: Wed, 23 Sep 2015 13:44:49 -0700
Message-ID: <56030f41.FJ6J/77ptMLrTh7T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbbIWUou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 16:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, hpa@zytor.com, jkosina@suse.com, luto@kernel.org, masami.hiramatsu.pt@hitachi.com, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, thiago.macieira@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: use _do_fork() in samples to make them work again
has been added to the -mm tree.  Its filename is
     kprobe-use-_do_fork-in-samples-to-make-them-work-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobe-use-_do_fork-in-samples-to-make-them-work-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobe-use-_do_fork-in-samples-to-make-them-work-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kprobes: use _do_fork() in samples to make them work again

3033f14ab78c32687 ("clone: support passing tls argument via C rather than
pt_regs magic") introduced _do_fork() that allowed to pass @tls parameter.

The old do_fork() is defined only for architectures that are not ready to
use this way and do not define HAVE_COPY_THREAD_TLS.

Let's use _do_fork() in the kprobe examples to make them work again on all
architectures.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thiago Macieira <thiago.macieira@intel.com>
Cc: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/jprobe_example.c    |   14 +++++++-------
 samples/kprobes/kprobe_example.c    |    6 +++---
 samples/kprobes/kretprobe_example.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN samples/kprobes/jprobe_example.c~kprobe-use-_do_fork-in-samples-to-make-them-work-again samples/kprobes/jprobe_example.c
--- a/samples/kprobes/jprobe_example.c~kprobe-use-_do_fork-in-samples-to-make-them-work-again
+++ a/samples/kprobes/jprobe_example.c
@@ -1,13 +1,13 @@
 /*
  * Here's a sample kernel module showing the use of jprobes to dump
- * the arguments of do_fork().
+ * the arguments of _do_fork().
  *
  * For more information on theory of operation of jprobes, see
  * Documentation/kprobes.txt
  *
  * Build and insert the kernel module as done in the kprobe example.
  * You will see the trace data in /var/log/messages and on the
- * console whenever do_fork() is invoked to create a new process.
+ * console whenever _do_fork() is invoked to create a new process.
  * (Some messages may be suppressed if syslogd is configured to
  * eliminate duplicate messages.)
  */
@@ -17,13 +17,13 @@
 #include <linux/kprobes.h>
 
 /*
- * Jumper probe for do_fork.
+ * Jumper probe for _do_fork.
  * Mirror principle enables access to arguments of the probed routine
  * from the probe handler.
  */
 
-/* Proxy routine having the same arguments as actual do_fork() routine */
-static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
+/* Proxy routine having the same arguments as actual _do_fork() routine */
+static long j_do_fork(unsigned long clone_flags, unsigned long stack_start,
 	      unsigned long stack_size, int __user *parent_tidptr,
 	      int __user *child_tidptr)
 {
@@ -36,9 +36,9 @@ static long jdo_fork(unsigned long clone
 }
 
 static struct jprobe my_jprobe = {
-	.entry			= jdo_fork,
+	.entry			= j_do_fork,
 	.kp = {
-		.symbol_name	= "do_fork",
+		.symbol_name	= "_do_fork",
 	},
 };
 
diff -puN samples/kprobes/kprobe_example.c~kprobe-use-_do_fork-in-samples-to-make-them-work-again samples/kprobes/kprobe_example.c
--- a/samples/kprobes/kprobe_example.c~kprobe-use-_do_fork-in-samples-to-make-them-work-again
+++ a/samples/kprobes/kprobe_example.c
@@ -1,13 +1,13 @@
 /*
  * NOTE: This example is works on x86 and powerpc.
  * Here's a sample kernel module showing the use of kprobes to dump a
- * stack trace and selected registers when do_fork() is called.
+ * stack trace and selected registers when _do_fork() is called.
  *
  * For more information on theory of operation of kprobes, see
  * Documentation/kprobes.txt
  *
  * You will see the trace data in /var/log/messages and on the console
- * whenever do_fork() is invoked to create a new process.
+ * whenever _do_fork() is invoked to create a new process.
  */
 
 #include <linux/kernel.h>
@@ -16,7 +16,7 @@
 
 /* For each probe you need to allocate a kprobe structure */
 static struct kprobe kp = {
-	.symbol_name	= "do_fork",
+	.symbol_name	= "_do_fork",
 };
 
 /* kprobe pre_handler: called just before the probed instruction is executed */
diff -puN samples/kprobes/kretprobe_example.c~kprobe-use-_do_fork-in-samples-to-make-them-work-again samples/kprobes/kretprobe_example.c
--- a/samples/kprobes/kretprobe_example.c~kprobe-use-_do_fork-in-samples-to-make-them-work-again
+++ a/samples/kprobes/kretprobe_example.c
@@ -7,7 +7,7 @@
  *
  * usage: insmod kretprobe_example.ko func=<func_name>
  *
- * If no func_name is specified, do_fork is instrumented
+ * If no func_name is specified, _do_fork is instrumented
  *
  * For more information on theory of operation of kretprobes, see
  * Documentation/kprobes.txt
@@ -25,7 +25,7 @@
 #include <linux/limits.h>
 #include <linux/sched.h>
 
-static char func_name[NAME_MAX] = "do_fork";
+static char func_name[NAME_MAX] = "_do_fork";
 module_param_string(func, func_name, NAME_MAX, S_IRUGO);
 MODULE_PARM_DESC(func, "Function to kretprobe; this module will report the"
 			" function's execution time");
_

Patches currently in -mm which might be from pmladek@suse.com are

kprobe-use-_do_fork-in-samples-to-make-them-work-again.patch

