From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-rename-and-move-2-defines-to-printk_logh.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:35 -0700
Message-ID: <20121023200436.108E320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46705 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab2JWUEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:37 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so256704wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: rename and move 2 #defines to printk_log.h
has been removed from the -mm tree.  Its filename was
     printk-rename-and-move-2-defines-to-printk_logh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: rename and move 2 #defines to printk_log.h

Rename the LOG_LINE_MAX and PREFIX_MAX #defines with PRINTK_ prefixes.
Move the defines to printk_log.h
Remove duplicate define too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c     |   24 ++++++++++--------------
 kernel/printk/printk_log.h |    3 +++
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-and-move-2-defines-to-printk_logh kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-and-move-2-defines-to-printk_logh
+++ a/kernel/printk/printk.c
@@ -133,9 +133,6 @@ static u64 console_seq;
 static u32 console_idx;
 static enum printk_log_flags console_prev;
 
-#define PREFIX_MAX		32
-#define LOG_LINE_MAX		1024 - PREFIX_MAX
-
 /* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -158,7 +155,7 @@ static ssize_t devkmsg_writev(struct kio
 	size_t len = iov_length(iv, count);
 	ssize_t ret = len;
 
-	if (len > LOG_LINE_MAX)
+	if (len > PRINTK_LOG_LINE_MAX)
 		return -EINVAL;
 	buf = kmalloc(len+1, GFP_KERNEL);
 	if (buf == NULL)
@@ -721,7 +718,7 @@ static int syslog_print(char __user *buf
 	struct printk_log *msg;
 	int len = 0;
 
-	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
+	text = kmalloc(PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
@@ -745,7 +742,7 @@ static int syslog_print(char __user *buf
 		skip = syslog_partial;
 		msg = printk_log_from_idx(syslog_idx);
 		n = msg_print_text(msg, syslog_prev, true, text,
-				   LOG_LINE_MAX + PREFIX_MAX);
+				   PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = printk_log_next(syslog_idx);
@@ -784,7 +781,7 @@ static int syslog_print_all(char __user 
 	char *text;
 	int len = 0;
 
-	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
+	text = kmalloc(PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
@@ -840,7 +837,7 @@ static int syslog_print_all(char __user 
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
-						 LOG_LINE_MAX + PREFIX_MAX);
+						 PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
@@ -1160,7 +1157,7 @@ static inline void printk_delay(void)
  * reached the console in case of a kernel crash.
  */
 static struct cont {
-	char buf[LOG_LINE_MAX];
+	char buf[PRINTK_LOG_LINE_MAX];
 	size_t len;			/* length == 0 means unused buffer */
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
@@ -1262,7 +1259,7 @@ asmlinkage int vprintk_emit(int facility
 			    const char *fmt, va_list args)
 {
 	static int recursion_bug;
-	static char textbuf[LOG_LINE_MAX];
+	static char textbuf[PRINTK_LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len;
 	enum printk_log_flags lflags = 0;
@@ -1465,9 +1462,8 @@ EXPORT_SYMBOL(printk);
 
 #else /* CONFIG_PRINTK */
 
-#define LOG_LINE_MAX		0
-#define PREFIX_MAX		0
-#define LOG_LINE_MAX 0
+#define PRINTK_LOG_LINE_MAX	0
+#define PRINTK_PREFIX_MAX		0
 static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
@@ -1793,7 +1789,7 @@ out:
  */
 void console_unlock(void)
 {
-	static char text[LOG_LINE_MAX + PREFIX_MAX];
+	static char text[PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
diff -puN kernel/printk/printk_log.h~printk-rename-and-move-2-defines-to-printk_logh kernel/printk/printk_log.h
--- a/kernel/printk/printk_log.h~printk-rename-and-move-2-defines-to-printk_logh
+++ a/kernel/printk/printk_log.h
@@ -92,6 +92,9 @@ struct printk_log {
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 
+#define PRINTK_PREFIX_MAX	32
+#define PRINTK_LOG_LINE_MAX	(1024 - PRINTK_PREFIX_MAX)
+
 extern raw_spinlock_t printk_logbuf_lock;
 extern wait_queue_head_t printk_log_wait;
 extern u64 printk_log_first_seq;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
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

