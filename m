From: akpm@linux-foundation.org
Subject: + printk-move-functions-printk_print_time-and-printk_msg_print_text.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:17:28 -0700
Message-ID: <20121018231729.24DF4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64603 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2JRXR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:17:29 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so1147953qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:17:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: move functions printk_print_time and printk_msg_print_text
has been added to the -mm tree.  Its filename is
     printk-move-functions-printk_print_time-and-printk_msg_print_text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: move functions printk_print_time and printk_msg_print_text

Move these functions to printk_log.
Move the static function print_prefix too.
Add "#include <linux/moduleparam.h>" to printk_log.c.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c     |  112 ----------------------------------
 kernel/printk/printk_log.c |  114 +++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 112 deletions(-)

diff -puN kernel/printk/printk.c~printk-move-functions-printk_print_time-and-printk_msg_print_text kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-move-functions-printk_print_time-and-printk_msg_print_text
+++ a/kernel/printk/printk.c
@@ -311,111 +311,6 @@ static int check_syslog_permissions(int 
 	return 0;
 }
 
-#if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
-#else
-static bool printk_time;
-#endif
-module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
-
-size_t printk_print_time(u64 ts, char *buf)
-{
-	unsigned long rem_nsec;
-
-	if (!printk_time)
-		return 0;
-
-	if (!buf)
-		return 15;
-
-	rem_nsec = do_div(ts, 1000000000);
-	return sprintf(buf, "[%5lu.%06lu] ",
-		       (unsigned long)ts, rem_nsec / 1000);
-}
-
-static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
-{
-	size_t len = 0;
-	unsigned int prefix = (msg->facility << 3) | msg->level;
-
-	if (syslog) {
-		if (buf) {
-			len += sprintf(buf, "<%u>", prefix);
-		} else {
-			len += 3;
-			if (prefix > 999)
-				len += 3;
-			else if (prefix > 99)
-				len += 2;
-			else if (prefix > 9)
-				len++;
-		}
-	}
-
-	len += printk_print_time(msg->ts_nsec, buf ? buf + len : NULL);
-	return len;
-}
-
-size_t printk_msg_print_text(const struct printk_log *msg,
-			     enum printk_log_flags prev,
-			     bool syslog, char *buf, size_t size)
-{
-	const char *text = printk_log_text(msg);
-	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
-	size_t len = 0;
-
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
-		prefix = false;
-
-	if (msg->flags & LOG_CONT) {
-		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
-			prefix = false;
-
-		if (!(msg->flags & LOG_NEWLINE))
-			newline = false;
-	}
-
-	do {
-		const char *next = memchr(text, '\n', text_size);
-		size_t text_len;
-
-		if (next) {
-			text_len = next - text;
-			next++;
-			text_size -= next - text;
-		} else {
-			text_len = text_size;
-		}
-
-		if (buf) {
-			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1 >= size - len)
-				break;
-
-			if (prefix)
-				len += print_prefix(msg, syslog, buf + len);
-			memcpy(buf + len, text, text_len);
-			len += text_len;
-			if (next || newline)
-				buf[len++] = '\n';
-		} else {
-			/* SYSLOG_ACTION_* buffer size only calculation */
-			if (prefix)
-				len += print_prefix(msg, syslog, NULL);
-			len += text_len;
-			if (next || newline)
-				len++;
-		}
-
-		prefix = true;
-		text = next;
-	} while (text);
-
-	return len;
-}
-
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
@@ -1186,13 +1081,6 @@ static struct cont {
 struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-size_t printk_print_time(u64 ts, char *buf) { return 0; }
-size_t printk_msg_print_text(const struct printk_log *msg,
-			     enum printk_log_flags prev,
-			     bool syslog, char *buf, size_t size)
-{
-	return 0;
-}
 
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
diff -puN kernel/printk/printk_log.c~printk-move-functions-printk_print_time-and-printk_msg_print_text kernel/printk/printk_log.c
--- a/kernel/printk/printk_log.c~printk-move-functions-printk_print_time-and-printk_msg_print_text
+++ a/kernel/printk/printk_log.c
@@ -2,6 +2,8 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/kexec.h>
+#include <linux/moduleparam.h>
+#include <linux/stat.h>
 
 #include "printk_log.h"
 
@@ -135,6 +137,111 @@ void printk_log_store(int facility, int 
 	printk_log_next_seq++;
 }
 
+#if defined(CONFIG_PRINTK_TIME)
+static bool printk_time = 1;
+#else
+static bool printk_time;
+#endif
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
+
+size_t printk_print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	if (!printk_time)
+		return 0;
+
+	if (!buf)
+		return 15;
+
+	rem_nsec = do_div(ts, 1000000000);
+	return sprintf(buf, "[%5lu.%06lu] ",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
+static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
+{
+	size_t len = 0;
+	unsigned int prefix = (msg->facility << 3) | msg->level;
+
+	if (syslog) {
+		if (buf) {
+			len += sprintf(buf, "<%u>", prefix);
+		} else {
+			len += 3;
+			if (prefix > 999)
+				len += 3;
+			else if (prefix > 99)
+				len += 2;
+			else if (prefix > 9)
+				len++;
+		}
+	}
+
+	len += printk_print_time(msg->ts_nsec, buf ? buf + len : NULL);
+	return len;
+}
+
+size_t printk_msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
+			     bool syslog, char *buf, size_t size)
+{
+	const char *text = printk_log_text(msg);
+	size_t text_size = msg->text_len;
+	bool prefix = true;
+	bool newline = true;
+	size_t len = 0;
+
+	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+		prefix = false;
+
+	if (msg->flags & LOG_CONT) {
+		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
+			prefix = false;
+
+		if (!(msg->flags & LOG_NEWLINE))
+			newline = false;
+	}
+
+	do {
+		const char *next = memchr(text, '\n', text_size);
+		size_t text_len;
+
+		if (next) {
+			text_len = next - text;
+			next++;
+			text_size -= next - text;
+		} else {
+			text_len = text_size;
+		}
+
+		if (buf) {
+			if (print_prefix(msg, syslog, NULL) +
+			    text_len + 1 >= size - len)
+				break;
+
+			if (prefix)
+				len += print_prefix(msg, syslog, buf + len);
+			memcpy(buf + len, text, text_len);
+			len += text_len;
+			if (next || newline)
+				buf[len++] = '\n';
+		} else {
+			/* SYSLOG_ACTION_* buffer size only calculation */
+			if (prefix)
+				len += print_prefix(msg, syslog, NULL);
+			len += text_len;
+			if (next || newline)
+				len++;
+		}
+
+		prefix = true;
+		text = next;
+	} while (text);
+
+	return len;
+}
+
 #else /* CONFIG_PRINTK */
 
 #define LOG_LINE_MAX		0
@@ -145,5 +252,12 @@ u32 printk_log_first_idx;
 u64 printk_log_next_seq;
 struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 u32 printk_log_next(u32 idx) { return 0; }
+size_t printk_print_time(u64 ts, char *buf) { return 0; }
+size_t printk_msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
+			     bool syslog, char *buf, size_t size)
+{
+	return 0;
+}
 
 #endif /* CONFIG_PRINTK */
_

Patches currently in -mm which might be from joe@perches.com are

printk-move-to-separate-directory-for-easier-modification.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
printk-rename-log_buf-and-__log_buf_len.patch
printk-rename-log_first-and-log_next-variables.patch
printk-rename-log_foo-variables-and-functions.patch
printk-rename-enum-log_flags-to-printk_log_flags.patch
printk-rename-log_wait-to-printk_log_wait.patch
printk-rename-logbuf_lock-to-printk_logbuf_lock.patch
printk-rename-clear_seq-and-clear_idx-variables.patch
printk-remove-static-from-printk_-variables.patch
printk-rename-log_align-to-printk_log_align.patch
printk-add-and-use-printk_logh.patch
printk-add-printk_logc.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

