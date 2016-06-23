From: akpm@linux-foundation.org
Subject: + printk-introduce-should_ignore_loglevel.patch added to -mm tree
Date: Thu, 23 Jun 2016 16:42:46 -0700
Message-ID: <576c73f6.386ukdnuBoyiPXpK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbcFWXmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jun 2016 19:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, calvinowens@fb.com, jack@suse.cz, pmladek@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: introduce should_ignore_loglevel()
has been added to the -mm tree.  Its filename is
     printk-introduce-should_ignore_loglevel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-introduce-should_ignore_loglevel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-introduce-should_ignore_loglevel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: introduce should_ignore_loglevel()

Due to deferred printing, console log level is inspected when the actual
printing occurs, which may provoke console_unlock() and
console_cont_flush() to waste CPU cycles on every message that has
loglevel above the current console_loglevel.

Schematically, console_unlock() does the following:

console_unlock()
{
	...
	for (;;) {
		...
		raw_spin_lock_irqsave(&logbuf_lock, flags);
skip:
		msg = log_from_idx(console_idx);

		if (msg->flags & LOG_NOCONS) {
			...
			goto skip;
		}

		level = msg->level;
		len += msg_print_text();			>> sprintfs
								   memcpy,
								   etc.

		if (nr_ext_console_drivers) {
			ext_len = msg_print_ext_header();	>> scnprintf
			ext_len += msg_print_ext_body();	>> scnprintfs
								   etc.
		}
		...
		raw_spin_unlock(&logbuf_lock);

		call_console_drivers(level, ext_text, ext_len, text, len)
		{
			if (level >= console_loglevel &&	>> drop the message
					!ignore_loglevel)
				return;

			console->write(...);
		}

		local_irq_restore(flags);
	}
	...
}

The thing here is this deferred `level >= console_loglevel' check.  We are
wasting CPU cycles on sprintfs/memcpy/etc.  preparing the messages that we
will eventually drop.

This can be huge when we register a new CON_PRINTBUFFER console, for
instance.  For every such a console register_console() resets the

	console_seq, console_idx, console_prev

and sets a `exclusive console' pointer to replay the log buffer to that
just-registered console.  And there can be a lot of messages to replay, in
the worst case most of which can be dropped after console_loglevel test.

We know messages' levels long before we call msg_print_text() and friends,
so we can just move console_loglevel check out of call_console_drivers()
and format a new message only if we are sure that it won't be dropped.

The patch factors out loglevel check into should_ignore_loglevel()
function and tests message->level and console_loglevel before formatting
functions in console_unlock() and console_cont_flush() are getting
executed.

This improves things not only for exclusive CON_PRINTBUFFER consoles, but
for every console_unlock() that attempts to print a message of level above
the console_loglevel.

Link: http://lkml.kernel.org/r/20160623163302.761-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Calvin Owens <calvinowens@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN kernel/printk/printk.c~printk-introduce-should_ignore_loglevel kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-introduce-should_ignore_loglevel
+++ a/kernel/printk/printk.c
@@ -985,6 +985,11 @@ module_param(ignore_loglevel, bool, S_IR
 MODULE_PARM_DESC(ignore_loglevel,
 		 "ignore loglevel setting (prints all kernel messages to the console)");
 
+static bool should_ignore_loglevel(int level)
+{
+	return (level >= console_loglevel && !ignore_loglevel);
+}
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */
@@ -1014,7 +1019,7 @@ static void boot_delay_msec(int level)
 	unsigned long timeout;
 
 	if ((boot_delay == 0 || system_state != SYSTEM_BOOTING)
-		|| (level >= console_loglevel && !ignore_loglevel)) {
+		|| should_ignore_loglevel(level)) {
 		return;
 	}
 
@@ -1438,8 +1443,6 @@ static void call_console_drivers(int lev
 
 	trace_console(text, len);
 
-	if (level >= console_loglevel && !ignore_loglevel)
-		return;
 	if (!console_drivers)
 		return;
 
@@ -1908,6 +1911,7 @@ static void call_console_drivers(int lev
 static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
+static bool should_ignore_loglevel(int level) { return false; }
 
 /* Still needs to be defined for users */
 DEFINE_PER_CPU(printk_func_t, printk_func);
@@ -2187,6 +2191,13 @@ static void console_cont_flush(char *tex
 	if (!cont.len)
 		goto out;
 
+	if (should_ignore_loglevel(cont.level)) {
+		cont.cons = cont.len;
+		if (cont.flushed)
+			cont.len = 0;
+		goto out;
+	}
+
 	/*
 	 * We still queue earlier records, likely because the console was
 	 * busy. The earlier ones need to be printed before this one, we
@@ -2290,10 +2301,13 @@ skip:
 			break;
 
 		msg = log_from_idx(console_idx);
-		if (msg->flags & LOG_NOCONS) {
+		level = msg->level;
+		if ((msg->flags & LOG_NOCONS) ||
+				should_ignore_loglevel(level)) {
 			/*
 			 * Skip record we have buffered and already printed
-			 * directly to the console when we received it.
+			 * directly to the console when we received it, and
+			 * record that has level above the console loglevel.
 			 */
 			console_idx = log_next(console_idx);
 			console_seq++;
@@ -2307,7 +2321,6 @@ skip:
 			goto skip;
 		}
 
-		level = msg->level;
 		len += msg_print_text(msg, console_prev, false,
 				      text + len, sizeof(text) - len);
 		if (nr_ext_console_drivers) {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-use-crypto-api-to-check-alg-availability-v3.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-delete-custom-lzo-lz4-v3.patch
zram-add-more-compression-algorithms.patch
zram-add-more-compression-algorithms-v3.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch
printk-do-not-include-interrupth.patch
printk-introduce-should_ignore_loglevel.patch

