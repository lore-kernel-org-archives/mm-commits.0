From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-move-functions-printk_print_time-and-printk_msg_print_text.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:45 -0700
Message-ID: <20121023200446.15B015C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43491 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab2JWUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:48 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so256773eek.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: move functions printk_print_time and printk_msg_print_text
has been removed from the -mm tree.  Its filename was
     printk-move-functions-printk_print_time-and-printk_msg_print_text.patch

This patch was dropped because an updated version will be merged

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

linux-next.patch
printk-add-printk_syslogc-and-h.patch
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

