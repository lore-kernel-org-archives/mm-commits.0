From: akpm@linux-foundation.org
Subject: + printk-nmi-handle-continuous-lines-and-missing-newline.patch
 added to -mm tree
Date: Wed, 09 Nov 2016 14:35:43 -0800
Message-ID: <5823a4bf.4ove4BPCohxjm9fK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbcKIWfp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 17:35:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/NMI: handle continuous lines and missing newline
has been added to the -mm tree.  Its filename is
     printk-nmi-handle-continuous-lines-and-missing-newline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-nmi-handle-continuous-lines-and-missing-newline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-nmi-handle-continuous-lines-and-missing-newline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk/NMI: handle continuous lines and missing newline

4bcc595ccd80decb4245 ("printk: reinstate KERN_CONT for printing
continuation lines") added back KERN_CONT message header.  As a result it
might appear in the middle of the line when the parts are squashed via the
temporary NMI buffer.

A reasonable solution seems to be to split the text in the NNI temporary
not only by newlines but also by the message headers.

Another solution would be to filter out KERN_CONT when writing to the
temporary buffer.  But this would complicate the lockless handling.  Also
it would not solve problems with a missing newline that was there even
before the KERN_CONT stuff.

This patch moves the temporary buffer handling into separate function.  I
played with it and it seems that using the char pointers make the code
easier to read.

Also it prints the final newline as a continuous line.

Finally, it moves handling of the s->len overflow into the paranoid check.
And allows to recover from the disaster.

Link: http://lkml.kernel.org/r/1478695291-12169-2-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Joe Perches <joe@perches.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |   78 ++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff -puN kernel/printk/nmi.c~printk-nmi-handle-continuous-lines-and-missing-newline kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-handle-continuous-lines-and-missing-newline
+++ a/kernel/printk/nmi.c
@@ -113,16 +113,51 @@ static void printk_nmi_flush_line(const
 
 }
 
-/*
- * printk one line from the temporary buffer from @start index until
- * and including the @end index.
- */
-static void printk_nmi_flush_seq_line(struct nmi_seq_buf *s,
-					int start, int end)
+/* printk part of the temporary buffer line by line */
+static int printk_nmi_flush_buffer(const char *start, size_t len)
 {
-	const char *buf = s->buffer + start;
+	const char *c, *end;
+	bool header;
+
+	c = start;
+	end = start + len;
+	header = true;
+
+	/* Print line by line. */
+	while (c < end) {
+		if (*c == '\n') {
+			printk_nmi_flush_line(start, c - start + 1);
+			start = ++c;
+			header = true;
+			continue;
+		}
+
+		/* Handle continuous lines or missing new line. */
+		if ((c + 1 < end) && printk_get_level(c)) {
+			if (header) {
+				c = printk_skip_level(c);
+				continue;
+			}
+
+			printk_nmi_flush_line(start, c - start);
+			start = c++;
+			header = true;
+			continue;
+		}
+
+		header = false;
+		c++;
+	}
 
-	printk_nmi_flush_line(buf, (end - start) + 1);
+	/* Check if there was a partial line. Ignore pure header. */
+	if (start < end && !header) {
+		static const char newline[] = KERN_CONT "\n";
+
+		printk_nmi_flush_line(start, end - start);
+		printk_nmi_flush_line(newline, strlen(newline));
+	}
+
+	return len;
 }
 
 /*
@@ -135,8 +170,8 @@ static void __printk_nmi_flush(struct ir
 		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct nmi_seq_buf *s = container_of(work, struct nmi_seq_buf, work);
 	unsigned long flags;
-	size_t len, size;
-	int i, last_i;
+	size_t len;
+	int i;
 
 	/*
 	 * The lock has two functions. First, one reader has to flush all
@@ -154,12 +189,14 @@ more:
 	/*
 	 * This is just a paranoid check that nobody has manipulated
 	 * the buffer an unexpected way. If we printed something then
-	 * @len must only increase.
+	 * @len must only increase. Also it should never overflow the
+	 * buffer size.
 	 */
-	if (i && i >= len) {
+	if ((i && i >= len) || len > sizeof(s->buffer)) {
 		const char *msg = "printk_nmi_flush: internal error\n";
 
 		printk_nmi_flush_line(msg, strlen(msg));
+		len = 0;
 	}
 
 	if (!len)
@@ -167,22 +204,7 @@ more:
 
 	/* Make sure that data has been written up to the @len */
 	smp_rmb();
-
-	size = min(len, sizeof(s->buffer));
-	last_i = i;
-
-	/* Print line by line. */
-	for (; i < size; i++) {
-		if (s->buffer[i] == '\n') {
-			printk_nmi_flush_seq_line(s, last_i, i);
-			last_i = i + 1;
-		}
-	}
-	/* Check if there was a partial line. */
-	if (last_i < size) {
-		printk_nmi_flush_seq_line(s, last_i, size - 1);
-		printk_nmi_flush_line("\n", strlen("\n"));
-	}
+	i += printk_nmi_flush_buffer(s->buffer + i, len - i);
 
 	/*
 	 * Check that nothing has got added in the meantime and truncate
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-sound-handle-more-message-headers.patch

