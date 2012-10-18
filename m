From: akpm@linux-foundation.org
Subject: + printk-rename-and-move-2-defines-to-printk_logh.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:17:17 -0700
Message-ID: <20121018231718.1C53E100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37118 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2JRXRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:17:18 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so1078707vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:17:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: rename and move 2 #defines to printk_log.h
has been added to the -mm tree.  Its filename is
     printk-rename-and-move-2-defines-to-printk_logh.patch

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

