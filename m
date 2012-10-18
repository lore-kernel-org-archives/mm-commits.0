From: akpm@linux-foundation.org
Subject: + printk-rename-clear_seq-and-clear_idx-variables.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:16:55 -0700
Message-ID: <20121018231656.CEA6120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43513 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2JRXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:16:59 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so558205wey.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:16:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: rename clear_seq and clear_idx variables
has been added to the -mm tree.  Its filename is
     printk-rename-clear_seq-and-clear_idx-variables.patch

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
Subject: printk: rename clear_seq and clear_idx variables

Make these variables more specific to the printk log subsystem
adding prefix printk_log_.  This allows them to become non-static.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-clear_seq-and-clear_idx-variables kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-clear_seq-and-clear_idx-variables
+++ a/kernel/printk/printk.c
@@ -231,8 +231,8 @@ static u32 console_idx;
 static enum printk_log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
-static u64 clear_seq;
-static u32 clear_idx;
+static u64 printk_log_clear_seq;
+static u32 printk_log_clear_idx;
 
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
@@ -566,8 +566,8 @@ static loff_t devkmsg_llseek(struct file
 		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
 		 * changes no global state, and does not clear anything.
 		 */
-		user->idx = clear_idx;
-		user->seq = clear_seq;
+		user->idx = printk_log_clear_idx;
+		user->seq = printk_log_clear_seq;
 		break;
 	case SEEK_END:
 		/* after the last record */
@@ -1012,18 +1012,18 @@ static int syslog_print_all(char __user 
 		u32 idx;
 		enum printk_log_flags prev;
 
-		if (clear_seq < printk_log_first_seq) {
+		if (printk_log_clear_seq < printk_log_first_seq) {
 			/* messages are gone, move to first available one */
-			clear_seq = printk_log_first_seq;
-			clear_idx = printk_log_first_idx;
+			printk_log_clear_seq = printk_log_first_seq;
+			printk_log_clear_idx = printk_log_first_idx;
 		}
 
 		/*
 		 * Find first record that fits, including all following records,
 		 * into the user-provided buffer for this dump.
 		 */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = printk_log_clear_seq;
+		idx = printk_log_clear_idx;
 		prev = 0;
 		while (seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
@@ -1035,8 +1035,8 @@ static int syslog_print_all(char __user 
 		}
 
 		/* move first record forward until length fits into the buffer */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = printk_log_clear_seq;
+		idx = printk_log_clear_idx;
 		prev = 0;
 		while (len > size && seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
@@ -1083,8 +1083,8 @@ static int syslog_print_all(char __user 
 	}
 
 	if (clear) {
-		clear_seq = printk_log_next_seq;
-		clear_idx = printk_log_next_idx;
+		printk_log_clear_seq = printk_log_next_seq;
+		printk_log_clear_idx = printk_log_next_idx;
 	}
 	raw_spin_unlock_irq(&printk_logbuf_lock);
 
@@ -2566,8 +2566,8 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		dumper->active = true;
 
 		raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
-		dumper->cur_seq = clear_seq;
-		dumper->cur_idx = clear_idx;
+		dumper->cur_seq = printk_log_clear_seq;
+		dumper->cur_idx = printk_log_clear_idx;
 		dumper->next_seq = printk_log_next_seq;
 		dumper->next_idx = printk_log_next_idx;
 		raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
@@ -2774,8 +2774,8 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
  */
 void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 {
-	dumper->cur_seq = clear_seq;
-	dumper->cur_idx = clear_idx;
+	dumper->cur_seq = printk_log_clear_seq;
+	dumper->cur_idx = printk_log_clear_idx;
 	dumper->next_seq = printk_log_next_seq;
 	dumper->next_idx = printk_log_next_idx;
 }
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

