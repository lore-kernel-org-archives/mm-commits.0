From: akpm@linux-foundation.org
Subject: [merged]
 printk-factor-out-message-formatting-from-devkmsg_read.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:47:18 -0700
Message-ID: <5591aed6.jyEoKwHNDyFZPesk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbF2UrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: factor out message formatting from devkmsg_read()
has been removed from the -mm tree.  Its filename was
     printk-factor-out-message-formatting-from-devkmsg_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Petr Mladek <pmladek@suse.cz>
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
