From: akpm@linux-foundation.org
Subject: + printk-ignore-too-long-messages.patch added to -mm tree
Date: Fri, 18 Apr 2014 12:03:48 -0700
Message-ID: <53517714.UcRt29SHuS4HOknQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaDRTDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kay@vrfy.org, jkosina@suse.cz, jack@suse.cz, pmladek@suse.cz

Subject: + printk-ignore-too-long-messages.patch added to -mm tree
To: pmladek@suse.cz,jack@suse.cz,jkosina@suse.cz,kay@vrfy.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:03:48 -0700


The patch titled
     Subject: printk: ignore too long messages
has been added to the -mm tree.  Its filename is
     printk-ignore-too-long-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-ignore-too-long-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-ignore-too-long-messages.patch

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
Subject: printk: ignore too long messages

There was no check for too long messages.  The check for free space always
passed when first_seq and next_seq were equal.  Enough free space was not
guaranteed, though.

log_store() might be called to store messages up to 64kB + 64kB + 16B. 
This is sum of maximal text_len, dict_len values, and the size of the
structure printk_log.

On the other hand, the minimal size for the main log buffer currently is
4kB and it is enforced only by Kconfig.

The good news is that the usage looks safe right now.  log_store() is
called only from vprintk_emit() and cont_flush().  Here the "text" part is
always passed via a static buffer and the length is limited to
LOG_LINE_MAX which is 1024.  The "dict" part is NULL in most cases.  The
only exceptions is when vprintk_emit() is called from printk_emit() and
dev_vprintk_emit().  But printk_emit() is currently used only in
devkmsg_writev() and here "dict" is NULL as well.  In dev_vprintk_emit(),
"dict" is limited by the static buffer "hdr" of the size 128 bytes.  It
meas that the current maximal printed text is 1024B + 128B + 16B and it
always fit the log buffer.

But it is only matter of time when someone calls printk_emit() with unsafe
parameters, especially the "dict" one.

This patch adds a check for the free space when the buffer is empty.  It
reuses the already existing log_has_space() function but it has to add an
extra parameter.  It defines whether the buffer is empty.  Note that the
same values of "first_idx" and "next_idx" might also mean that the buffer
is full.

If the buffer is empty, we must respect the current position of the
indexes.  We cannot reset them to the beginning of the buffer.  Otherwise,
the functions reading the buffer would get crazy.

The question is what to do when the message is too long.  This patch uses
the easiest solution and just ignores the problematic message.  Let's do
something better in a followup patch.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff -puN kernel/printk/printk.c~printk-ignore-too-long-messages kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-ignore-too-long-messages
+++ a/kernel/printk/printk.c
@@ -297,12 +297,20 @@ static u32 log_next(u32 idx)
 	return idx + msg->len;
 }
 
-/* check whether there is enough free space for the given message */
-static int logbuf_has_space(u32 msg_size)
+/*
+ * Check whether there is enough free space for the given message.
+ *
+ * The same values of first_idx and next_idx mean that the buffer
+ * is either empty or full.
+ *
+ * If the buffer is empty, we must respect the position of the indexes.
+ * They cannot be reset to the beginning of the buffer.
+ */
+static int logbuf_has_space(u32 msg_size, bool empty)
 {
 	u32 free;
 
-	if (log_next_idx > log_first_idx)
+	if (log_next_idx > log_first_idx || empty)
 		free = max(log_buf_len - log_next_idx, log_first_idx);
 	else
 		free = log_first_idx - log_next_idx;
@@ -314,15 +322,21 @@ static int logbuf_has_space(u32 msg_size
 	return free >= msg_size + sizeof(struct printk_log);
 }
 
-static void log_make_free_space(u32 msg_size)
+static int log_make_free_space(u32 msg_size)
 {
 	while (log_first_seq < log_next_seq) {
-		if (logbuf_has_space(msg_size))
-			return;
+		if (logbuf_has_space(msg_size, false))
+			return 0;
 		/* drop old messages until we have enough continuous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
+
+	/* sequence numbers are equal, so the log buffer is empty */
+	if (logbuf_has_space(msg_size, true))
+		return 0;
+
+	return -ENOMEM;
 }
 
 /* insert record into the buffer, discard old ones, update heads */
@@ -339,7 +353,9 @@ static void log_store(int facility, int
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
-	log_make_free_space(size);
+	/* if message does not fit empty log buffer, ignore it */
+	if (log_make_free_space(size))
+		return;
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch

