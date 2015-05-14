From: akpm@linux-foundation.org
Subject: + printk-factor-out-message-formatting-from-devkmsg_read.patch
 added to -mm tree
Date: Thu, 14 May 2015 13:28:50 -0700
Message-ID: <55550582.uN0OmZMa+nYIZbHW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbbENU2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: factor out message formatting from devkmsg_read()
has been added to the -mm tree.  Its filename is
     printk-factor-out-message-formatting-from-devkmsg_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-factor-out-message-formatting-from-devkmsg_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-factor-out-message-formatting-from-devkmsg_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: printk: factor out message formatting from devkmsg_read()

The extended message formatting used for /dev/kmsg will be used implement
extended consoles.  Factor out msg_print_ext_header() and
msg_print_ext_body() from devkmsg_read().

This is pure restructuring.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |  146 +++++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 66 deletions(-)

diff -puN kernel/printk/printk.c~printk-factor-out-message-formatting-from-devkmsg_read kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-factor-out-message-formatting-from-devkmsg_read
+++ a/kernel/printk/printk.c
@@ -511,6 +511,81 @@ static void append_char(char **pp, char
 		*(*pp)++ = c;
 }
 
+static ssize_t msg_print_ext_header(char *buf, size_t size,
+				    struct printk_log *msg, u64 seq,
+				    enum log_flags prev_flags)
+{
+	u64 ts_usec = msg->ts_nsec;
+	char cont = '-';
+
+	do_div(ts_usec, 1000);
+
+	/*
+	 * If we couldn't merge continuation line fragments during the print,
+	 * export the stored flags to allow an optional external merge of the
+	 * records. Merging the records isn't always neccessarily correct, like
+	 * when we hit a race during printing. In most cases though, it produces
+	 * better readable output. 'c' in the record flags mark the first
+	 * fragment of a line, '+' the following.
+	 */
+	if (msg->flags & LOG_CONT && !(prev_flags & LOG_CONT))
+		cont = 'c';
+	else if ((msg->flags & LOG_CONT) ||
+		 ((prev_flags & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
+		cont = '+';
+
+	return scnprintf(buf, size, "%u,%llu,%llu,%c;",
+		       (msg->facility << 3) | msg->level, seq, ts_usec, cont);
+}
+
+static ssize_t msg_print_ext_body(char *buf, size_t size,
+				  char *dict, size_t dict_len,
+				  char *text, size_t text_len)
+{
+	char *p = buf, *e = buf + size;
+	size_t i;
+
+	/* escape non-printable characters */
+	for (i = 0; i < text_len; i++) {
+		unsigned char c = text[i];
+
+		if (c < ' ' || c >= 127 || c == '\\')
+			p += scnprintf(p, e - p, "\\x%02x", c);
+		else
+			append_char(&p, e, c);
+	}
+	append_char(&p, e, '\n');
+
+	if (dict_len) {
+		bool line = true;
+
+		for (i = 0; i < dict_len; i++) {
+			unsigned char c = dict[i];
+
+			if (line) {
+				append_char(&p, e, ' ');
+				line = false;
+			}
+
+			if (c == '\0') {
+				append_char(&p, e, '\n');
+				line = true;
+				continue;
+			}
+
+			if (c < ' ' || c >= 127 || c == '\\') {
+				p += scnprintf(p, e - p, "\\x%02x", c);
+				continue;
+			}
+
+			append_char(&p, e, c);
+		}
+		append_char(&p, e, '\n');
+	}
+
+	return p - buf;
+}
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -575,19 +650,12 @@ static ssize_t devkmsg_read(struct file
 {
 	struct devkmsg_user *user = file->private_data;
 	struct printk_log *msg;
-	char *p, *e;
-	u64 ts_usec;
-	size_t i;
-	char cont = '-';
 	size_t len;
 	ssize_t ret;
 
 	if (!user)
 		return -EBADF;
 
-	p = user->buf;
-	e = user->buf + sizeof(user->buf);
-
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
@@ -617,71 +685,17 @@ static ssize_t devkmsg_read(struct file
 	}
 
 	msg = log_from_idx(user->idx);
-	ts_usec = msg->ts_nsec;
-	do_div(ts_usec, 1000);
+	len = msg_print_ext_header(user->buf, sizeof(user->buf),
+				   msg, user->seq, user->prev);
+	len += msg_print_ext_body(user->buf + len, sizeof(user->buf) - len,
+				  log_dict(msg), msg->dict_len,
+				  log_text(msg), msg->text_len);
 
-	/*
-	 * If we couldn't merge continuation line fragments during the print,
-	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always neccessarily correct, like
-	 * when we hit a race during printing. In most cases though, it produces
-	 * better readable output. 'c' in the record flags mark the first
-	 * fragment of a line, '+' the following.
-	 */
-	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
-		cont = 'c';
-	else if ((msg->flags & LOG_CONT) ||
-		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
-		cont = '+';
-
-	p += scnprintf(p, e - p, "%u,%llu,%llu,%c;",
-		       (msg->facility << 3) | msg->level,
-		       user->seq, ts_usec, cont);
 	user->prev = msg->flags;
-
-	/* escape non-printable characters */
-	for (i = 0; i < msg->text_len; i++) {
-		unsigned char c = log_text(msg)[i];
-
-		if (c < ' ' || c >= 127 || c == '\\')
-			p += scnprintf(p, e - p, "\\x%02x", c);
-		else
-			append_char(&p, e, c);
-	}
-	append_char(&p, e, '\n');
-
-	if (msg->dict_len) {
-		bool line = true;
-
-		for (i = 0; i < msg->dict_len; i++) {
-			unsigned char c = log_dict(msg)[i];
-
-			if (line) {
-				append_char(&p, e, ' ');
-				line = false;
-			}
-
-			if (c == '\0') {
-				append_char(&p, e, '\n');
-				line = true;
-				continue;
-			}
-
-			if (c < ' ' || c >= 127 || c == '\\') {
-				p += scnprintf(p, e - p, "\\x%02x", c);
-				continue;
-			}
-
-			append_char(&p, e, c);
-		}
-		append_char(&p, e, '\n');
-	}
-
 	user->idx = log_next(user->idx);
 	user->seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
 
-	len = p - user->buf;
 	if (len > count) {
 		ret = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

