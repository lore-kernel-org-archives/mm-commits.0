From: akpm@linux-foundation.org
Subject: + printk-rename-log_first-and-log_next-variables.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:16:40 -0700
Message-ID: <20121018231641.3622C10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58524 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2JRXQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:16:42 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so1147865qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:16:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: rename log_first and log_next variables
has been added to the -mm tree.  Its filename is
     printk-rename-log_first-and-log_next-variables.patch

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
Subject: printk: rename log_first and log_next variables

Make these generic names more specific to the printk
subsystem and allow these variables to become non-static.

Rename log_first_idx to printk_log_first_idx.
Rename log_first_seq to printk_log_first_seq.
Rename log_next_idx to printk_log_next_idx.
Rename log_next_seq to printk_log_next_seq.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |  150 +++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 75 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-log_first-and-log_next-variables kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-log_first-and-log_next-variables
+++ a/kernel/printk/printk.c
@@ -218,12 +218,12 @@ static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
-static u64 log_first_seq;
-static u32 log_first_idx;
+static u64 printk_log_first_seq;
+static u32 printk_log_first_idx;
 
 /* index and sequence number of the next record to store in the buffer */
-static u64 log_next_seq;
-static u32 log_next_idx;
+static u64 printk_log_next_seq;
+static u32 printk_log_next_idx;
 
 /* the next printk record to write to the console */
 static u64 console_seq;
@@ -309,34 +309,34 @@ static void log_store(int facility, int 
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
-	while (log_first_seq < log_next_seq) {
+	while (printk_log_first_seq < printk_log_next_seq) {
 		u32 free;
 
-		if (log_next_idx > log_first_idx)
-			free = max(printk_log_buf_len - log_next_idx, log_first_idx);
+		if (printk_log_next_idx > printk_log_first_idx)
+			free = max(printk_log_buf_len - printk_log_next_idx, printk_log_first_idx);
 		else
-			free = log_first_idx - log_next_idx;
+			free = printk_log_first_idx - printk_log_next_idx;
 
 		if (free > size + sizeof(struct printk_log))
 			break;
 
 		/* drop old messages until we have enough contiuous space */
-		log_first_idx = log_next(log_first_idx);
-		log_first_seq++;
+		printk_log_first_idx = log_next(printk_log_first_idx);
+		printk_log_first_seq++;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
+	if (printk_log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(printk_log_buf + log_next_idx, 0, sizeof(struct printk_log));
-		log_next_idx = 0;
+		memset(printk_log_buf + printk_log_next_idx, 0, sizeof(struct printk_log));
+		printk_log_next_idx = 0;
 	}
 
 	/* fill message */
-	msg = (struct printk_log *)(printk_log_buf + log_next_idx);
+	msg = (struct printk_log *)(printk_log_buf + printk_log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
 	memcpy(log_dict(msg), dict, dict_len);
@@ -352,8 +352,8 @@ static void log_store(int facility, int 
 	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
 
 	/* insert message */
-	log_next_idx += msg->len;
-	log_next_seq++;
+	printk_log_next_idx += msg->len;
+	printk_log_next_seq++;
 }
 
 /* /dev/kmsg - userspace message inject/listen interface */
@@ -439,7 +439,7 @@ static ssize_t devkmsg_read(struct file 
 	if (ret)
 		return ret;
 	raw_spin_lock_irq(&logbuf_lock);
-	while (user->seq == log_next_seq) {
+	while (user->seq == printk_log_next_seq) {
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
 			raw_spin_unlock_irq(&logbuf_lock);
@@ -448,16 +448,16 @@ static ssize_t devkmsg_read(struct file 
 
 		raw_spin_unlock_irq(&logbuf_lock);
 		ret = wait_event_interruptible(log_wait,
-					       user->seq != log_next_seq);
+					       user->seq != printk_log_next_seq);
 		if (ret)
 			goto out;
 		raw_spin_lock_irq(&logbuf_lock);
 	}
 
-	if (user->seq < log_first_seq) {
+	if (user->seq < printk_log_first_seq) {
 		/* our last seen message is gone, return error and reset */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = printk_log_first_idx;
+		user->seq = printk_log_first_seq;
 		ret = -EPIPE;
 		raw_spin_unlock_irq(&logbuf_lock);
 		goto out;
@@ -557,8 +557,8 @@ static loff_t devkmsg_llseek(struct file
 	switch (whence) {
 	case SEEK_SET:
 		/* the first record */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = printk_log_first_idx;
+		user->seq = printk_log_first_seq;
 		break;
 	case SEEK_DATA:
 		/*
@@ -571,8 +571,8 @@ static loff_t devkmsg_llseek(struct file
 		break;
 	case SEEK_END:
 		/* after the last record */
-		user->idx = log_next_idx;
-		user->seq = log_next_seq;
+		user->idx = printk_log_next_idx;
+		user->seq = printk_log_next_seq;
 		break;
 	default:
 		ret = -EINVAL;
@@ -592,9 +592,9 @@ static unsigned int devkmsg_poll(struct 
 	poll_wait(file, &log_wait, wait);
 
 	raw_spin_lock_irq(&logbuf_lock);
-	if (user->seq < log_next_seq) {
+	if (user->seq < printk_log_next_seq) {
 		/* return error when data has vanished underneath us */
-		if (user->seq < log_first_seq)
+		if (user->seq < printk_log_first_seq)
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
 		ret = POLLIN|POLLRDNORM;
 	}
@@ -623,8 +623,8 @@ static int devkmsg_open(struct inode *in
 	mutex_init(&user->lock);
 
 	raw_spin_lock_irq(&logbuf_lock);
-	user->idx = log_first_idx;
-	user->seq = log_first_seq;
+	user->idx = printk_log_first_idx;
+	user->seq = printk_log_first_seq;
 	raw_spin_unlock_irq(&logbuf_lock);
 
 	file->private_data = user;
@@ -665,8 +665,8 @@ void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(printk_log_buf);
 	VMCOREINFO_SYMBOL(printk_log_buf_len);
-	VMCOREINFO_SYMBOL(log_first_idx);
-	VMCOREINFO_SYMBOL(log_next_idx);
+	VMCOREINFO_SYMBOL(printk_log_first_idx);
+	VMCOREINFO_SYMBOL(printk_log_next_idx);
 	/*
 	 * Export struct printk_log size and field offsets. User space tools can
 	 * parse it and detect any changes to structure down the line.
@@ -726,7 +726,7 @@ void __init setup_log_buf(int early)
 	printk_log_buf_len = new_printk_log_buf_len;
 	printk_log_buf = new_printk_log_buf;
 	new_printk_log_buf_len = 0;
-	free = __PRINTK_LOG_BUF_LEN - log_next_idx;
+	free = __PRINTK_LOG_BUF_LEN - printk_log_next_idx;
 	memcpy(printk_log_buf, __printk_log_buf, __PRINTK_LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
@@ -946,14 +946,14 @@ static int syslog_print(char __user *buf
 		size_t skip;
 
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (syslog_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = printk_log_first_seq;
+			syslog_idx = printk_log_first_idx;
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
-		if (syslog_seq == log_next_seq) {
+		if (syslog_seq == printk_log_next_seq) {
 			raw_spin_unlock_irq(&logbuf_lock);
 			break;
 		}
@@ -1011,10 +1011,10 @@ static int syslog_print_all(char __user 
 		u32 idx;
 		enum log_flags prev;
 
-		if (clear_seq < log_first_seq) {
+		if (clear_seq < printk_log_first_seq) {
 			/* messages are gone, move to first available one */
-			clear_seq = log_first_seq;
-			clear_idx = log_first_idx;
+			clear_seq = printk_log_first_seq;
+			clear_idx = printk_log_first_idx;
 		}
 
 		/*
@@ -1024,7 +1024,7 @@ static int syslog_print_all(char __user 
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (seq < log_next_seq) {
+		while (seq < printk_log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
@@ -1037,7 +1037,7 @@ static int syslog_print_all(char __user 
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (len > size && seq < log_next_seq) {
+		while (len > size && seq < printk_log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
@@ -1047,7 +1047,7 @@ static int syslog_print_all(char __user 
 		}
 
 		/* last message fitting into this dump */
-		next_seq = log_next_seq;
+		next_seq = printk_log_next_seq;
 
 		len = 0;
 		prev = 0;
@@ -1072,18 +1072,18 @@ static int syslog_print_all(char __user 
 				len += textlen;
 			raw_spin_lock_irq(&logbuf_lock);
 
-			if (seq < log_first_seq) {
+			if (seq < printk_log_first_seq) {
 				/* messages are gone, move to next one */
-				seq = log_first_seq;
-				idx = log_first_idx;
+				seq = printk_log_first_seq;
+				idx = printk_log_first_idx;
 				prev = 0;
 			}
 		}
 	}
 
 	if (clear) {
-		clear_seq = log_next_seq;
-		clear_idx = log_next_idx;
+		clear_seq = printk_log_next_seq;
+		clear_idx = printk_log_next_idx;
 	}
 	raw_spin_unlock_irq(&logbuf_lock);
 
@@ -1122,7 +1122,7 @@ int do_syslog(int type, char __user *buf
 			goto out;
 		}
 		error = wait_event_interruptible(log_wait,
-						 syslog_seq != log_next_seq);
+						 syslog_seq != printk_log_next_seq);
 		if (error)
 			goto out;
 		error = syslog_print(buf, len);
@@ -1177,10 +1177,10 @@ int do_syslog(int type, char __user *buf
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (syslog_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = printk_log_first_seq;
+			syslog_idx = printk_log_first_idx;
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
@@ -1190,14 +1190,14 @@ int do_syslog(int type, char __user *buf
 			 * for pending data, not the size; return the count of
 			 * records, not the length.
 			 */
-			error = log_next_idx - syslog_idx;
+			error = printk_log_next_idx - syslog_idx;
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
 			enum log_flags prev = syslog_prev;
 
 			error = 0;
-			while (seq < log_next_seq) {
+			while (seq < printk_log_next_seq) {
 				struct printk_log *msg = log_from_idx(idx);
 
 				error += msg_print_text(msg, prev, true, NULL, 0);
@@ -1689,9 +1689,9 @@ static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum log_flags syslog_prev;
-static u64 log_first_seq;
-static u32 log_first_idx;
-static u64 log_next_seq;
+static u64 printk_log_first_seq;
+static u32 printk_log_first_idx;
+static u64 printk_log_next_seq;
 static enum log_flags console_prev;
 static struct cont {
 	size_t len;
@@ -1978,7 +1978,7 @@ static void console_cont_flush(char *tex
 	 * busy. The earlier ones need to be printed before this one, we
 	 * did not flush any fragment so far, so just let it queue up.
 	 */
-	if (console_seq < log_next_seq && !cont.cons)
+	if (console_seq < printk_log_next_seq && !cont.cons)
 		goto out;
 
 	len = cont_print_text(text, size);
@@ -2030,19 +2030,19 @@ again:
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		if (seen_seq != log_next_seq) {
+		if (seen_seq != printk_log_next_seq) {
 			wake_klogd = true;
-			seen_seq = log_next_seq;
+			seen_seq = printk_log_next_seq;
 		}
 
-		if (console_seq < log_first_seq) {
+		if (console_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
-			console_seq = log_first_seq;
-			console_idx = log_first_idx;
+			console_seq = printk_log_first_seq;
+			console_idx = printk_log_first_idx;
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == printk_log_next_seq)
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2093,7 +2093,7 @@ skip:
 	 * flush, no worries.
 	 */
 	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
+	retry = console_seq != printk_log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (retry && console_trylock())
@@ -2566,8 +2566,8 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		dumper->cur_seq = clear_seq;
 		dumper->cur_idx = clear_idx;
-		dumper->next_seq = log_next_seq;
-		dumper->next_idx = log_next_idx;
+		dumper->next_seq = printk_log_next_seq;
+		dumper->next_idx = printk_log_next_idx;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 		/* invoke dumper which will iterate over records */
@@ -2608,14 +2608,14 @@ bool kmsg_dump_get_line_nolock(struct km
 	if (!dumper->active)
 		goto out;
 
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < printk_log_first_seq) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = printk_log_first_seq;
+		dumper->cur_idx = printk_log_first_idx;
 	}
 
 	/* last entry */
-	if (dumper->cur_seq >= log_next_seq)
+	if (dumper->cur_seq >= printk_log_next_seq)
 		goto out;
 
 	msg = log_from_idx(dumper->cur_idx);
@@ -2696,10 +2696,10 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 		goto out;
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < printk_log_first_seq) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = printk_log_first_seq;
+		dumper->cur_idx = printk_log_first_idx;
 	}
 
 	/* last entry */
@@ -2774,8 +2774,8 @@ void kmsg_dump_rewind_nolock(struct kmsg
 {
 	dumper->cur_seq = clear_seq;
 	dumper->cur_idx = clear_idx;
-	dumper->next_seq = log_next_seq;
-	dumper->next_idx = log_next_idx;
+	dumper->next_seq = printk_log_next_seq;
+	dumper->next_idx = printk_log_next_idx;
 }
 
 /**
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

