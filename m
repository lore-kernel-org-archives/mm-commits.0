From: akpm@linux-foundation.org
Subject: + printk-implement-support-for-extended-console-drivers.patch
 added to -mm tree
Date: Thu, 14 May 2015 13:28:52 -0700
Message-ID: <55550584.bJ5CtA8nx5/cIo4c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbbENU2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: implement support for extended console drivers
has been added to the -mm tree.  Its filename is
     printk-implement-support-for-extended-console-drivers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-implement-support-for-extended-console-drivers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-implement-support-for-extended-console-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: printk: implement support for extended console drivers

printk log_buf keeps various metadata for each message including its
sequence number and timestamp.  The metadata is currently available only
through /dev/kmsg and stripped out before passed onto console drivers.  We
want this metadata to be available to console drivers too so that console
consumers can get full information including the metadata and dictionary,
which among other things can be used to detect whether messages got lost
in transit.

This patch implements support for extended console drivers.  Consoles can
indicate that they want extended messages by setting the new CON_EXTENDED
flag and they'll be fed messages formatted the same way as /dev/kmsg.

 "<level>,<sequnum>,<timestamp>,<contflag>;<message text>\n"

If extended consoles exist, in-kernel fragment assembly is disabled.  This
ensures that all messages emitted to consoles have full metadata including
sequence number.  The contflag carries enough information to reassemble
the fragments from the reader side trivially.  Note that this only affects
/dev/kmsg.  Regular console and /proc/kmsg outputs are not affected by
this change.

* Extended message formatting for console drivers is enabled iff there
  are registered extended consoles.

* Comment describing /dev/kmsg message format updated to add missing
  contflag field and help distinguishing variable from verbatim terms.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/dev-kmsg |    9 +++
 include/linux/console.h            |    1 
 kernel/printk/printk.c             |   66 +++++++++++++++++++++++----
 3 files changed, 68 insertions(+), 8 deletions(-)

diff -puN Documentation/ABI/testing/dev-kmsg~printk-implement-support-for-extended-console-drivers Documentation/ABI/testing/dev-kmsg
--- a/Documentation/ABI/testing/dev-kmsg~printk-implement-support-for-extended-console-drivers
+++ a/Documentation/ABI/testing/dev-kmsg
@@ -98,4 +98,13 @@ Description:	The /dev/kmsg character dev
 		logic is used internally when messages are printed to the
 		console, /proc/kmsg or the syslog() syscall.
 
+		By default, kernel tries to avoid fragments by concatenating
+		when it can and fragments are rare; however, when extended
+		console support is enabled, the in-kernel concatenation is
+		disabled and /dev/kmsg output will contain more fragments. If
+		the log consumer performs concatenation, the end result
+		should be the same. In the future, the in-kernel concatenation
+		may be removed entirely and /dev/kmsg users are recommended to
+		implement fragment handling.
+
 Users:		dmesg(1), userspace kernel log consumers
diff -puN include/linux/console.h~printk-implement-support-for-extended-console-drivers include/linux/console.h
--- a/include/linux/console.h~printk-implement-support-for-extended-console-drivers
+++ a/include/linux/console.h
@@ -115,6 +115,7 @@ static inline int con_debug_leave(void)
 #define CON_BOOT	(8)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
 #define CON_BRL		(32) /* Used for a braille device */
+#define CON_EXTENDED	(64) /* Use the extended output format a la /dev/kmsg */
 
 struct console {
 	char	name[16];
diff -puN kernel/printk/printk.c~printk-implement-support-for-extended-console-drivers kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-implement-support-for-extended-console-drivers
+++ a/kernel/printk/printk.c
@@ -85,6 +85,18 @@ static struct lockdep_map console_lock_d
 #endif
 
 /*
+ * Number of registered extended console drivers.
+ *
+ * If extended consoles are present, in-kernel cont reassembly is disabled
+ * and each fragment is stored as a separate log entry with proper
+ * continuation flag so that every emitted message has full metadata.  This
+ * doesn't change the result for regular consoles or /proc/kmsg.  For
+ * /dev/kmsg, as long as the reader concatenates messages according to
+ * consecutive continuation flags, the end result should be the same too.
+ */
+static int nr_ext_console_drivers;
+
+/*
  * Helper macros to handle lockdep when locking/unlocking console_sem. We use
  * macros instead of functions so that _RET_IP_ contains useful information.
  */
@@ -195,7 +207,7 @@ static int console_may_schedule;
  * need to be changed in the future, when the requirements change.
  *
  * /dev/kmsg exports the structured data in the following line format:
- *   "level,sequnum,timestamp;<message text>\n"
+ *   "<level>,<sequnum>,<timestamp>,<contflag>;<message text>\n"
  *
  * The optional key/value pairs are attached as continuation lines starting
  * with a space character and terminated by a newline. All possible
@@ -1417,7 +1429,9 @@ SYSCALL_DEFINE3(syslog, int, type, char
  * log_buf[start] to log_buf[end - 1].
  * The console_lock must be held.
  */
-static void call_console_drivers(int level, const char *text, size_t len)
+static void call_console_drivers(int level,
+				 const char *ext_text, size_t ext_len,
+				 const char *text, size_t len)
 {
 	struct console *con;
 
@@ -1438,7 +1452,10 @@ static void call_console_drivers(int lev
 		if (!cpu_online(smp_processor_id()) &&
 		    !(con->flags & CON_ANYTIME))
 			continue;
-		con->write(con, text, len);
+		if (con->flags & CON_EXTENDED)
+			con->write(con, ext_text, ext_len);
+		else
+			con->write(con, text, len);
 	}
 }
 
@@ -1581,8 +1598,12 @@ static bool cont_add(int facility, int l
 	if (cont.len && cont.flushed)
 		return false;
 
-	if (cont.len + len > sizeof(cont.buf)) {
-		/* the line gets too long, split it up in separate records */
+	/*
+	 * If ext consoles are present, flush and skip in-kernel
+	 * continuation.  See nr_ext_console_drivers definition.  Also, if
+	 * the line gets too long, split it up in separate records.
+	 */
+	if (nr_ext_console_drivers || cont.len + len > sizeof(cont.buf)) {
 		cont_flush(LOG_CONT);
 		return false;
 	}
@@ -1917,9 +1938,19 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
+static char *log_text(const struct printk_log *msg) { return NULL; }
+static char *log_dict(const struct printk_log *msg) { return NULL; }
 static struct printk_log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
-static void call_console_drivers(int level, const char *text, size_t len) {}
+static ssize_t msg_print_ext_header(char *buf, size_t size,
+				    struct printk_log *msg, u64 seq,
+				    enum log_flags prev_flags) { return 0; }
+static ssize_t msg_print_ext_body(char *buf, size_t size,
+				  char *dict, size_t dict_len,
+				  char *text, size_t text_len) { return 0; }
+static void call_console_drivers(int level,
+				 const char *ext_text, size_t ext_len,
+				 const char *text, size_t len) {}
 static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
@@ -2172,7 +2203,7 @@ static void console_cont_flush(char *tex
 	len = cont_print_text(text, size);
 	raw_spin_unlock(&logbuf_lock);
 	stop_critical_timings();
-	call_console_drivers(cont.level, text, len);
+	call_console_drivers(cont.level, NULL, 0, text, len);
 	start_critical_timings();
 	local_irq_restore(flags);
 	return;
@@ -2196,6 +2227,7 @@ out:
  */
 void console_unlock(void)
 {
+	static char ext_text[CONSOLE_EXT_LOG_MAX];
 	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
@@ -2214,6 +2246,7 @@ void console_unlock(void)
 again:
 	for (;;) {
 		struct printk_log *msg;
+		size_t ext_len = 0;
 		size_t len;
 		int level;
 
@@ -2259,13 +2292,22 @@ skip:
 		level = msg->level;
 		len += msg_print_text(msg, console_prev, false,
 				      text + len, sizeof(text) - len);
+		if (nr_ext_console_drivers) {
+			ext_len = msg_print_ext_header(ext_text,
+						sizeof(ext_text),
+						msg, console_seq, console_prev);
+			ext_len += msg_print_ext_body(ext_text + ext_len,
+						sizeof(ext_text) - ext_len,
+						log_dict(msg), msg->dict_len,
+						log_text(msg), msg->text_len);
+		}
 		console_idx = log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
-		call_console_drivers(level, text, len);
+		call_console_drivers(level, ext_text, ext_len, text, len);
 		start_critical_timings();
 		local_irq_restore(flags);
 	}
@@ -2521,6 +2563,11 @@ void register_console(struct console *ne
 		newcon->next = console_drivers->next;
 		console_drivers->next = newcon;
 	}
+
+	if (newcon->flags & CON_EXTENDED)
+		if (!nr_ext_console_drivers++)
+			pr_info("printk: continuation disabled due to ext consoles, expect more fragments in /dev/kmsg\n");
+
 	if (newcon->flags & CON_PRINTBUFFER) {
 		/*
 		 * console_unlock(); will print out the buffered messages
@@ -2593,6 +2640,9 @@ int unregister_console(struct console *c
 		}
 	}
 
+	if (!res && (console->flags & CON_EXTENDED))
+		nr_ext_console_drivers--;
+
 	/*
 	 * If this isn't the last console and it has CON_CONSDEV set, we
 	 * need to set it on the next preferred console.
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

