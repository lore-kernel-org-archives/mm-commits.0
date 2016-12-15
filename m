From: akpm@linux-foundation.org
Subject: [merged]
 kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:46:27 -0800
Message-ID: <5852e503.0KsTzdUGvnTO6rUl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756173AbcLOSqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, daniel.thompson@linaro.org, jason.wessel@windriver.com, peterz@infradead.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: call vkdb_printf() from vprintk_default() only when wanted
has been removed from the -mm tree.  Its filename was
     kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kdb: call vkdb_printf() from vprintk_default() only when wanted

kdb_trap_printk allows to pass normal printk() messages to kdb via
vkdb_printk().  For example, it is used to get backtrace using the classic
show_stack(), see kdb_show_stack().

vkdb_printf() tries to avoid a potential infinite loop by disabling the
trap.  But this approach is racy, for example:

CPU1					CPU2

vkdb_printf()
  // assume that kdb_trap_printk == 0
  saved_trap_printk = kdb_trap_printk;
  kdb_trap_printk = 0;

					kdb_show_stack()
					  kdb_trap_printk++;

Problem1: Now, a nested printk() on CPU0 calls vkdb_printf()
	  even when it should have been disabled. It will not
	  cause a deadlock but...

   // using the outdated saved value: 0
   kdb_trap_printk = saved_trap_printk;

					  kdb_trap_printk--;

Problem2: Now, kdb_trap_printk == -1 and will stay like this.
   It means that all messages will get passed to kdb from
   now on.

This patch removes the racy saved_trap_printk handling.  Instead, the
recursion is prevented by a check for the locked CPU.

The solution is still kind of racy.  A non-related printk(), from another
process, might get trapped by vkdb_printf().  And the wanted printk()
might not get trapped because kdb_printf_cpu is assigned.  But this
problem existed even with the original code.

A proper solution would be to get_cpu() before setting kdb_trap_printk and
trap messages only from this CPU.  I am not sure if it is worth the
effort, though.

In fact, the race is very theoretical.  When kdb is running any of the
commands that use kdb_trap_printk there is a single active CPU and the
other CPUs should be in a holding pen inside kgdb_cpu_enter().

The only time this is violated is when there is a timeout waiting for the
other CPUs to report to the holding pen.

Finally, note that the situation is a bit schizophrenic.  vkdb_printf()
explicitly allows recursion but only from KDB code that calls kdb_printf()
directly.  On the other hand, the generic printk() recursion is not
allowed because it might cause an infinite loop.  This is why we could not
hide the decision inside vkdb_printf() easily.

Link: http://lkml.kernel.org/r/1480412276-16690-4-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdb.h       |    1 +
 kernel/debug/kdb/kdb_io.c |    9 ++-------
 kernel/printk/printk.c    |    3 ++-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN include/linux/kdb.h~kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted include/linux/kdb.h
--- a/include/linux/kdb.h~kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted
+++ a/include/linux/kdb.h
@@ -161,6 +161,7 @@ enum kdb_msgsrc {
 };
 
 extern int kdb_trap_printk;
+extern int kdb_printf_cpu;
 extern __printf(2, 0) int vkdb_printf(enum kdb_msgsrc src, const char *fmt,
 				      va_list args);
 extern __printf(1, 2) int kdb_printf(const char *, ...);
diff -puN kernel/debug/kdb/kdb_io.c~kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted kernel/debug/kdb/kdb_io.c
--- a/kernel/debug/kdb/kdb_io.c~kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted
+++ a/kernel/debug/kdb/kdb_io.c
@@ -30,6 +30,7 @@
 char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
+int kdb_printf_cpu = -1;
 
 static int kgdb_transition_check(char *buffer)
 {
@@ -554,24 +555,19 @@ int vkdb_printf(enum kdb_msgsrc src, con
 	int linecount;
 	int colcount;
 	int logging, saved_loglevel = 0;
-	int saved_trap_printk;
 	int retlen = 0;
 	int fnd, len;
 	int this_cpu, old_cpu;
-	static int kdb_printf_cpu = -1;
 	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
 	char *moreprompt = "more> ";
 	struct console *c = console_drivers;
 	unsigned long uninitialized_var(flags);
 
-	local_irq_save(flags);
-	saved_trap_printk = kdb_trap_printk;
-	kdb_trap_printk = 0;
-
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
 	 * even if it is interleaved with any other text.
 	 */
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 	for (;;) {
 		old_cpu = cmpxchg(&kdb_printf_cpu, -1, this_cpu);
@@ -849,7 +845,6 @@ kdb_print_out:
 		console_loglevel = saved_loglevel;
 	/* kdb_printf_cpu locked the code above. */
 	smp_store_release(&kdb_printf_cpu, old_cpu);
-	kdb_trap_printk = saved_trap_printk;
 	local_irq_restore(flags);
 	return retlen;
 }
diff -puN kernel/printk/printk.c~kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted kernel/printk/printk.c
--- a/kernel/printk/printk.c~kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted
+++ a/kernel/printk/printk.c
@@ -1926,7 +1926,8 @@ int vprintk_default(const char *fmt, va_
 	int r;
 
 #ifdef CONFIG_KGDB_KDB
-	if (unlikely(kdb_trap_printk)) {
+	/* Allow to pass printk() to kdb but avoid a recursion. */
+	if (unlikely(kdb_trap_printk && kdb_printf_cpu < 0)) {
 		r = vkdb_printf(KDB_MSGSRC_PRINTK, fmt, args);
 		return r;
 	}
_

Patches currently in -mm which might be from pmladek@suse.com are


