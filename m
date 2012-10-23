From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-rename-enum-log_flags-to-printk_log_flags.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:05 -0700
Message-ID: <20121023200405.939651E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59288 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab2JWUEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:07 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so530734vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: rename enum log_flags to printk_log_flags
has been removed from the -mm tree.  Its filename was
     printk-rename-enum-log_flags-to-printk_log_flags.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: rename enum log_flags to printk_log_flags

Make this generic enum more specific to the printk subsystem.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-enum-log_flags-to-printk_log_flags kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-enum-log_flags-to-printk_log_flags
+++ a/kernel/printk/printk.c
@@ -187,7 +187,7 @@ static int console_may_schedule;
  * separated by ',', and find the message after the ';' character.
  */
 
-enum log_flags {
+enum printk_log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
 	LOG_NEWLINE	= 2,	/* text ended with a newline */
 	LOG_PREFIX	= 4,	/* text started with a prefix */
@@ -214,7 +214,7 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
+static enum printk_log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -228,7 +228,7 @@ static u32 printk_log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags console_prev;
+static enum printk_log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -297,7 +297,7 @@ static u32 printk_log_next(u32 idx)
 
 /* insert record into the buffer, discard old ones, update heads */
 static void printk_log_store(int facility, int level,
-			     enum log_flags flags, u64 ts_nsec,
+			     enum printk_log_flags flags, u64 ts_nsec,
 			     const char *dict, u16 dict_len,
 			     const char *text, u16 text_len)
 {
@@ -360,7 +360,7 @@ static void printk_log_store(int facilit
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
+	enum printk_log_flags prev;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -872,7 +872,8 @@ static size_t print_prefix(const struct 
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
 	const char *text = printk_log_text(msg);
@@ -1009,7 +1010,7 @@ static int syslog_print_all(char __user 
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
-		enum log_flags prev;
+		enum printk_log_flags prev;
 
 		if (clear_seq < printk_log_first_seq) {
 			/* messages are gone, move to first available one */
@@ -1194,7 +1195,7 @@ int do_syslog(int type, char __user *buf
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
-			enum log_flags prev = syslog_prev;
+			enum printk_log_flags prev = syslog_prev;
 
 			error = 0;
 			while (seq < printk_log_next_seq) {
@@ -1383,11 +1384,11 @@ static struct cont {
 	u64 ts_nsec;			/* time of first print */
 	u8 level;			/* log level of first message */
 	u8 facility;			/* log level of first message */
-	enum log_flags flags;		/* prefix, newline flags */
+	enum printk_log_flags flags;	/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
-static void cont_flush(enum log_flags flags)
+static void cont_flush(enum printk_log_flags flags)
 {
 	if (cont.flushed)
 		return;
@@ -1481,7 +1482,7 @@ asmlinkage int vprintk_emit(int facility
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len;
-	enum log_flags lflags = 0;
+	enum printk_log_flags lflags = 0;
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
@@ -1688,11 +1689,11 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags syslog_prev;
+static enum printk_log_flags syslog_prev;
 static u64 printk_log_first_seq;
 static u32 printk_log_first_idx;
 static u64 printk_log_next_seq;
-static enum log_flags console_prev;
+static enum printk_log_flags console_prev;
 static struct cont {
 	size_t len;
 	size_t cons;
@@ -1702,7 +1703,8 @@ static struct cont {
 static struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 static u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2688,7 +2690,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
-	enum log_flags prev;
+	enum printk_log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
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
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

