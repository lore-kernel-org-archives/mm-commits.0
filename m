From: akpm@linux-foundation.org
Subject: + printk-prefix-print_time-and-msg_print_text-with-printk_.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:17:25 -0700
Message-ID: <20121018231726.3D520100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64603 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2JRXR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:17:27 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so1147953qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:17:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: prefix print_time and msg_print_text with printk_
has been added to the -mm tree.  Its filename is
     printk-prefix-print_time-and-msg_print_text-with-printk_.patch

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
Subject: printk: prefix print_time and msg_print_text with printk_

Make these static functions global and prefix them with printk_.
Create declarations for these functions in printk_log.h

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c     |   43 +++++++++++++++++++----------------
 kernel/printk/printk_log.h |    4 +++
 2 files changed, 28 insertions(+), 19 deletions(-)

diff -puN kernel/printk/printk.c~printk-prefix-print_time-and-msg_print_text-with-printk_ kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-prefix-print_time-and-msg_print_text-with-printk_
+++ a/kernel/printk/printk.c
@@ -318,7 +318,7 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static size_t print_time(u64 ts, char *buf)
+size_t printk_print_time(u64 ts, char *buf)
 {
 	unsigned long rem_nsec;
 
@@ -352,11 +352,11 @@ static size_t print_prefix(const struct 
 		}
 	}
 
-	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
+	len += printk_print_time(msg->ts_nsec, buf ? buf + len : NULL);
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg,
+size_t printk_msg_print_text(const struct printk_log *msg,
 			     enum printk_log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
@@ -445,8 +445,8 @@ static int syslog_print(char __user *buf
 
 		skip = syslog_partial;
 		msg = printk_log_from_idx(syslog_idx);
-		n = msg_print_text(msg, syslog_prev, true, text,
-				   PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
+		n = printk_msg_print_text(msg, syslog_prev, true, text,
+					  PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = printk_log_next(syslog_idx);
@@ -512,7 +512,7 @@ static int syslog_print_all(char __user 
 		while (seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
 
-			len += msg_print_text(msg, prev, true, NULL, 0);
+			len += printk_msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
 			idx = printk_log_next(idx);
 			seq++;
@@ -525,7 +525,7 @@ static int syslog_print_all(char __user 
 		while (len > size && seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
 
-			len -= msg_print_text(msg, prev, true, NULL, 0);
+			len -= printk_msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
 			idx = printk_log_next(idx);
 			seq++;
@@ -540,8 +540,8 @@ static int syslog_print_all(char __user 
 			struct printk_log *msg = printk_log_from_idx(idx);
 			int textlen;
 
-			textlen = msg_print_text(msg, prev, true, text,
-						 PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
+			textlen = printk_msg_print_text(msg, prev, true, text,
+							PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
@@ -685,7 +685,7 @@ int do_syslog(int type, char __user *buf
 			while (seq < printk_log_next_seq) {
 				struct printk_log *msg = printk_log_from_idx(idx);
 
-				error += msg_print_text(msg, prev, true, NULL, 0);
+				error += printk_msg_print_text(msg, prev, true, NULL, 0);
 				idx = printk_log_next(idx);
 				seq++;
 				prev = msg->flags;
@@ -936,7 +936,7 @@ static size_t cont_print_text(char *text
 	size_t len;
 
 	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
+		textlen += printk_print_time(cont.ts_nsec, text);
 		size -= textlen;
 	}
 
@@ -1186,9 +1186,14 @@ static struct cont {
 struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg,
+size_t printk_print_time(u64 ts, char *buf) { return 0; }
+size_t printk_msg_print_text(const struct printk_log *msg,
 			     enum printk_log_flags prev,
-			     bool syslog, char *buf, size_t size) { return 0; }
+			     bool syslog, char *buf, size_t size)
+{
+	return 0;
+}
+
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
 #endif /* CONFIG_PRINTK */
@@ -1549,8 +1554,8 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_prev, false,
-				     text, sizeof(text));
+		len = printk_msg_print_text(msg, console_prev, false,
+					    text, sizeof(text));
 		console_idx = printk_log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
@@ -2104,7 +2109,7 @@ bool kmsg_dump_get_line_nolock(struct km
 		goto out;
 
 	msg = printk_log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
+	l = printk_msg_print_text(msg, 0, syslog, line, size);
 
 	dumper->cur_idx = printk_log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -2200,7 +2205,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = printk_log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, true, NULL, 0);
+		l += printk_msg_print_text(msg, prev, true, NULL, 0);
 		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
@@ -2213,7 +2218,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	while (l > size && seq < dumper->next_seq) {
 		struct printk_log *msg = printk_log_from_idx(idx);
 
-		l -= msg_print_text(msg, prev, true, NULL, 0);
+		l -= printk_msg_print_text(msg, prev, true, NULL, 0);
 		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
@@ -2228,7 +2233,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = printk_log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
+		l += printk_msg_print_text(msg, prev, syslog, buf + l, size - l);
 		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
diff -puN kernel/printk/printk_log.h~printk-prefix-print_time-and-msg_print_text-with-printk_ kernel/printk/printk_log.h
--- a/kernel/printk/printk_log.h~printk-prefix-print_time-and-msg_print_text-with-printk_
+++ a/kernel/printk/printk_log.h
@@ -115,5 +115,9 @@ void printk_log_store(int facility, int 
 		      enum printk_log_flags flags, u64 ts_nsec,
 		      const char *dict, u16 dict_len,
 		      const char *text, u16 text_len);
+size_t printk_print_time(u64 ts, char *buf);
+size_t printk_msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
+			     bool syslog, char *buf, size_t size);
 
 #endif
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

