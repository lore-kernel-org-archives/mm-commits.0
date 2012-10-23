From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-add-printk_logc.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:28 -0700
Message-ID: <20121023200428.A4177100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52672 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2JWUEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:30 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so529302qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add printk_log.c
has been removed from the -mm tree.  Its filename was
     printk-add-printk_logc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: add printk_log.c

Move print_log variables and functions into a separate file.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/Makefile     |    1 
 kernel/printk/printk.c     |  128 ------------------------------
 kernel/printk/printk_log.c |  149 +++++++++++++++++++++++++++++++++++
 3 files changed, 150 insertions(+), 128 deletions(-)

diff -puN kernel/printk/Makefile~printk-add-printk_logc kernel/printk/Makefile
--- a/kernel/printk/Makefile~printk-add-printk_logc
+++ a/kernel/printk/Makefile
@@ -1,2 +1,3 @@
 obj-y	= printk.o
+obj-y	+= printk_log.o
 obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
diff -puN kernel/printk/printk.c~printk-add-printk_logc kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-printk_logc
+++ a/kernel/printk/printk.c
@@ -121,12 +121,6 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
 
-/*
- * The printk_logbuf_lock protects kmsg buffer, indices, counters. It is also
- * used in interesting ways to provide interlocking in console_unlock();
- */
-DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
-
 #ifdef CONFIG_PRINTK
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
@@ -134,139 +128,17 @@ static u32 syslog_idx;
 static enum printk_log_flags syslog_prev;
 static size_t syslog_partial;
 
-/* index and sequence number of the first record stored in the buffer */
-u64 printk_log_first_seq;
-u32 printk_log_first_idx;
-
-/* index and sequence number of the next record to store in the buffer */
-u64 printk_log_next_seq;
-u32 printk_log_next_idx;
-
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
 static enum printk_log_flags console_prev;
 
-/* the next printk record to read after the last 'clear' command */
-u64 printk_log_clear_seq;
-u32 printk_log_clear_idx;
-
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
 
-/* record buffer */
-char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(PRINTK_LOG_ALIGN);
-char *printk_log_buf = __printk_log_buf;
-u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
-
 /* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
-/* human readable text of the record */
-char *printk_log_text(const struct printk_log *msg)
-{
-	return (char *)msg + sizeof(struct printk_log);
-}
-
-/* optional key/value pair dictionary attached to the record */
-char *printk_log_dict(const struct printk_log *msg)
-{
-	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
-}
-
-/* get record by index; idx must point to valid msg */
-struct printk_log *printk_log_from_idx(u32 idx)
-{
-	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
-
-	/*
-	 * A length == 0 record is the end of buffer marker. Wrap around and
-	 * read the message at the start of the buffer.
-	 */
-	if (!msg->len)
-		return (struct printk_log *)printk_log_buf;
-	return msg;
-}
-
-/* get next record; idx must point to valid msg */
-u32 printk_log_next(u32 idx)
-{
-	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
-
-	/* length == 0 indicates the end of the buffer; wrap */
-	/*
-	 * A length == 0 record is the end of buffer marker. Wrap around and
-	 * read the message at the start of the buffer as *this* one, and
-	 * return the one after that.
-	 */
-	if (!msg->len) {
-		msg = (struct printk_log *)printk_log_buf;
-		return msg->len;
-	}
-	return idx + msg->len;
-}
-
-/* insert record into the buffer, discard old ones, update heads */
-void printk_log_store(int facility, int level,
-		      enum printk_log_flags flags, u64 ts_nsec,
-		      const char *dict, u16 dict_len,
-		      const char *text, u16 text_len)
-{
-	struct printk_log *msg;
-	u32 size, pad_len;
-
-	/* number of '\0' padding bytes to next message */
-	size = sizeof(struct printk_log) + text_len + dict_len;
-	pad_len = (-size) & (PRINTK_LOG_ALIGN - 1);
-	size += pad_len;
-
-	while (printk_log_first_seq < printk_log_next_seq) {
-		u32 free;
-
-		if (printk_log_next_idx > printk_log_first_idx)
-			free = max(printk_log_buf_len - printk_log_next_idx, printk_log_first_idx);
-		else
-			free = printk_log_first_idx - printk_log_next_idx;
-
-		if (free > size + sizeof(struct printk_log))
-			break;
-
-		/* drop old messages until we have enough contiuous space */
-		printk_log_first_idx = printk_log_next(printk_log_first_idx);
-		printk_log_first_seq++;
-	}
-
-	if (printk_log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
-		/*
-		 * This message + an additional empty header does not fit
-		 * at the end of the buffer. Add an empty header with len == 0
-		 * to signify a wrap around.
-		 */
-		memset(printk_log_buf + printk_log_next_idx, 0, sizeof(struct printk_log));
-		printk_log_next_idx = 0;
-	}
-
-	/* fill message */
-	msg = (struct printk_log *)(printk_log_buf + printk_log_next_idx);
-	memcpy(printk_log_text(msg), text, text_len);
-	msg->text_len = text_len;
-	memcpy(printk_log_dict(msg), dict, dict_len);
-	msg->dict_len = dict_len;
-	msg->facility = facility;
-	msg->level = level & 7;
-	msg->flags = flags & 0x1f;
-	if (ts_nsec > 0)
-		msg->ts_nsec = ts_nsec;
-	else
-		msg->ts_nsec = local_clock();
-	memset(printk_log_dict(msg) + dict_len, 0, pad_len);
-	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
-
-	/* insert message */
-	printk_log_next_idx += msg->len;
-	printk_log_next_seq++;
-}
-
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
diff -puN /dev/null kernel/printk/printk_log.c
--- /dev/null
+++ a/kernel/printk/printk_log.c
@@ -0,0 +1,149 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/kexec.h>
+
+#include "printk_log.h"
+
+/*
+ * The printk_logbuf_lock protects kmsg buffer, indices, counters. It is also
+ * used in interesting ways to provide interlocking in console_unlock();
+ */
+DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
+
+#ifdef CONFIG_PRINTK
+
+/* index and sequence number of the first record stored in the buffer */
+u64 printk_log_first_seq;
+u32 printk_log_first_idx;
+
+/* index and sequence number of the next record to store in the buffer */
+u64 printk_log_next_seq;
+u32 printk_log_next_idx;
+
+/* the next printk record to read after the last 'clear' command */
+u64 printk_log_clear_seq;
+u32 printk_log_clear_idx;
+
+/* record buffer */
+char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(PRINTK_LOG_ALIGN);
+char *printk_log_buf = __printk_log_buf;
+u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
+
+/* human readable text of the record */
+char *printk_log_text(const struct printk_log *msg)
+{
+	return (char *)msg + sizeof(struct printk_log);
+}
+
+/* optional key/value pair dictionary attached to the record */
+char *printk_log_dict(const struct printk_log *msg)
+{
+	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
+}
+
+/* get record by index; idx must point to valid msg */
+struct printk_log *printk_log_from_idx(u32 idx)
+{
+	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
+
+	/*
+	 * A length == 0 record is the end of buffer marker. Wrap around and
+	 * read the message at the start of the buffer.
+	 */
+	if (!msg->len)
+		return (struct printk_log *)printk_log_buf;
+	return msg;
+}
+
+/* get next record; idx must point to valid msg */
+u32 printk_log_next(u32 idx)
+{
+	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
+
+	/* length == 0 indicates the end of the buffer; wrap */
+	/*
+	 * A length == 0 record is the end of buffer marker. Wrap around and
+	 * read the message at the start of the buffer as *this* one, and
+	 * return the one after that.
+	 */
+	if (!msg->len) {
+		msg = (struct printk_log *)printk_log_buf;
+		return msg->len;
+	}
+	return idx + msg->len;
+}
+
+/* insert record into the buffer, discard old ones, update heads */
+void printk_log_store(int facility, int level,
+		      enum printk_log_flags flags, u64 ts_nsec,
+		      const char *dict, u16 dict_len,
+		      const char *text, u16 text_len)
+{
+	struct printk_log *msg;
+	u32 size, pad_len;
+
+	/* number of '\0' padding bytes to next message */
+	size = sizeof(struct printk_log) + text_len + dict_len;
+	pad_len = (-size) & (PRINTK_LOG_ALIGN - 1);
+	size += pad_len;
+
+	while (printk_log_first_seq < printk_log_next_seq) {
+		u32 free;
+
+		if (printk_log_next_idx > printk_log_first_idx)
+			free = max(printk_log_buf_len - printk_log_next_idx, printk_log_first_idx);
+		else
+			free = printk_log_first_idx - printk_log_next_idx;
+
+		if (free > size + sizeof(struct printk_log))
+			break;
+
+		/* drop old messages until we have enough contiuous space */
+		printk_log_first_idx = printk_log_next(printk_log_first_idx);
+		printk_log_first_seq++;
+	}
+
+	if (printk_log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
+		/*
+		 * This message + an additional empty header does not fit
+		 * at the end of the buffer. Add an empty header with len == 0
+		 * to signify a wrap around.
+		 */
+		memset(printk_log_buf + printk_log_next_idx, 0, sizeof(struct printk_log));
+		printk_log_next_idx = 0;
+	}
+
+	/* fill message */
+	msg = (struct printk_log *)(printk_log_buf + printk_log_next_idx);
+	memcpy(printk_log_text(msg), text, text_len);
+	msg->text_len = text_len;
+	memcpy(printk_log_dict(msg), dict, dict_len);
+	msg->dict_len = dict_len;
+	msg->facility = facility;
+	msg->level = level & 7;
+	msg->flags = flags & 0x1f;
+	if (ts_nsec > 0)
+		msg->ts_nsec = ts_nsec;
+	else
+		msg->ts_nsec = local_clock();
+	memset(printk_log_dict(msg) + dict_len, 0, pad_len);
+	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
+
+	/* insert message */
+	printk_log_next_idx += msg->len;
+	printk_log_next_seq++;
+}
+
+#else /* CONFIG_PRINTK */
+
+#define LOG_LINE_MAX		0
+#define PREFIX_MAX		0
+#define LOG_LINE_MAX 0
+u64 printk_log_first_seq;
+u32 printk_log_first_idx;
+u64 printk_log_next_seq;
+struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
+u32 printk_log_next(u32 idx) { return 0; }
+
+#endif /* CONFIG_PRINTK */
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

