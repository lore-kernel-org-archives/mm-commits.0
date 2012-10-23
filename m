From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-remove-static-from-printk_-variables.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:18 -0700
Message-ID: <20121023200418.AA749100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37585 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2JWUEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:20 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so114787qae.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: remove static from printk_ variables
has been removed from the -mm tree.  Its filename was
     printk-remove-static-from-printk_-variables.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: remove static from printk_ variables

Allow a separation of functions and variables into
multiple files.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   46 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN kernel/printk/printk.c~printk-remove-static-from-printk_-variables kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-remove-static-from-printk_-variables
+++ a/kernel/printk/printk.c
@@ -208,7 +208,7 @@ struct printk_log {
  * The printk_logbuf_lock protects kmsg buffer, indices, counters. It is also
  * used in interesting ways to provide interlocking in console_unlock();
  */
-static DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
+DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
 
 #ifdef CONFIG_PRINTK
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
@@ -218,12 +218,12 @@ static enum printk_log_flags syslog_prev
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
-static u64 printk_log_first_seq;
-static u32 printk_log_first_idx;
+u64 printk_log_first_seq;
+u32 printk_log_first_idx;
 
 /* index and sequence number of the next record to store in the buffer */
-static u64 printk_log_next_seq;
-static u32 printk_log_next_idx;
+u64 printk_log_next_seq;
+u32 printk_log_next_idx;
 
 /* the next printk record to write to the console */
 static u64 console_seq;
@@ -231,8 +231,8 @@ static u32 console_idx;
 static enum printk_log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
-static u64 printk_log_clear_seq;
-static u32 printk_log_clear_idx;
+u64 printk_log_clear_seq;
+u32 printk_log_clear_idx;
 
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
@@ -244,27 +244,27 @@ static u32 printk_log_clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-static char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
-static char *printk_log_buf = __printk_log_buf;
-static u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
+char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
+char *printk_log_buf = __printk_log_buf;
+u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 
 /* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 /* human readable text of the record */
-static char *printk_log_text(const struct printk_log *msg)
+char *printk_log_text(const struct printk_log *msg)
 {
 	return (char *)msg + sizeof(struct printk_log);
 }
 
 /* optional key/value pair dictionary attached to the record */
-static char *printk_log_dict(const struct printk_log *msg)
+char *printk_log_dict(const struct printk_log *msg)
 {
 	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
 }
 
 /* get record by index; idx must point to valid msg */
-static struct printk_log *printk_log_from_idx(u32 idx)
+struct printk_log *printk_log_from_idx(u32 idx)
 {
 	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
@@ -278,7 +278,7 @@ static struct printk_log *printk_log_fro
 }
 
 /* get next record; idx must point to valid msg */
-static u32 printk_log_next(u32 idx)
+u32 printk_log_next(u32 idx)
 {
 	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
@@ -296,10 +296,10 @@ static u32 printk_log_next(u32 idx)
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static void printk_log_store(int facility, int level,
-			     enum printk_log_flags flags, u64 ts_nsec,
-			     const char *dict, u16 dict_len,
-			     const char *text, u16 text_len)
+void printk_log_store(int facility, int level,
+		      enum printk_log_flags flags, u64 ts_nsec,
+		      const char *dict, u16 dict_len,
+		      const char *text, u16 text_len)
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
@@ -1690,9 +1690,9 @@ static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum printk_log_flags syslog_prev;
-static u64 printk_log_first_seq;
-static u32 printk_log_first_idx;
-static u64 printk_log_next_seq;
+u64 printk_log_first_seq;
+u32 printk_log_first_idx;
+u64 printk_log_next_seq;
 static enum printk_log_flags console_prev;
 static struct cont {
 	size_t len;
@@ -1700,8 +1700,8 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
-static struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
-static u32 printk_log_next(u32 idx) { return 0; }
+struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
+u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 static size_t msg_print_text(const struct printk_log *msg,
 			     enum printk_log_flags prev,
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
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

