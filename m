From: akpm@linux-foundation.org
Subject: + printk-shrink-too-long-messages.patch added to -mm tree
Date: Fri, 18 Apr 2014 12:03:50 -0700
Message-ID: <53517716.gXofViSxMIdqEhSV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaDRTDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kay@vrfy.org, jkosina@suse.cz, jack@suse.cz, pmladek@suse.cz

Subject: + printk-shrink-too-long-messages.patch added to -mm tree
To: pmladek@suse.cz,jack@suse.cz,jkosina@suse.cz,kay@vrfy.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:03:50 -0700


The patch titled
     Subject: printk: shrink too long messages
has been added to the -mm tree.  Its filename is
     printk-shrink-too-long-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-shrink-too-long-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-shrink-too-long-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: printk: shrink too long messages

We might want to print at least part of too long messages and add some
warning for debugging purpose.

The question is how long the shrunken message should be.  If we use the
whole buffer, it might get rotated too soon.  Let's try to use only 1/4 of
the buffer for now.

Also shrink the whole dictionary.  We do not want to parse it or break it
in the middle of some pair of values.  It would not cause any real harm
but still.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   42 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~printk-shrink-too-long-messages kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-shrink-too-long-messages
+++ a/kernel/printk/printk.c
@@ -351,6 +351,32 @@ static u32 msg_used_size(u16 text_len, u
 	return size;
 }
 
+/*
+ * Define how much of the log buffer we could take at maximum. The value
+ * must be greater than two. Note that only half of the buffer is available
+ * when the index points to the middle.
+ */
+#define MAX_LOG_TAKE_PART 4
+static const char trunc_msg[] = "<truncated>";
+
+static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
+			u16 *dict_len, u32 *pad_len)
+{
+	/*
+	 * The message should not take the whole buffer. Otherwise, it might
+	 * get removed too soon.
+	 */
+	u32 max_text_len = log_buf_len / MAX_LOG_TAKE_PART;
+	if (*text_len > max_text_len)
+		*text_len = max_text_len;
+	/* enable the warning message */
+	*trunc_msg_len = strlen(trunc_msg);
+	/* disable the "dict" completely */
+	*dict_len = 0;
+	/* compute the size again, count also the warning message */
+	return msg_used_size(*text_len + *trunc_msg_len, 0, pad_len);
+}
+
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
@@ -359,13 +385,19 @@ static void log_store(int facility, int
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
+	u16 trunc_msg_len = 0;
 
 	/* number of '\0' padding bytes to next message */
 	size = msg_used_size(text_len, dict_len, &pad_len);
 
-	/* if message does not fit empty log buffer, ignore it */
-	if (log_make_free_space(size))
-		return;
+	if (log_make_free_space(size)) {
+		/* truncate the message if it is too long for empty buffer */
+		size = truncate_msg(&text_len, &trunc_msg_len,
+				    &dict_len, &pad_len);
+		/* survive when the log buffer is too small for trunc_msg */
+		if (log_make_free_space(size))
+			return;
+	}
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
@@ -381,6 +413,10 @@ static void log_store(int facility, int
 	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
+	if (trunc_msg_len) {
+		memcpy(log_text(msg) + text_len, trunc_msg, trunc_msg_len);
+		msg->text_len += trunc_msg_len;
+	}
 	memcpy(log_dict(msg), dict, dict_len);
 	msg->dict_len = dict_len;
 	msg->facility = facility;
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch

