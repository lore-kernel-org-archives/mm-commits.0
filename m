From: akpm@linux-foundation.org
Subject: [patch 103/123] printk/NMI: handle continuous lines and missing
 newline
Date: Mon, 12 Dec 2016 16:45:44 -0800
Message-ID: <584f44b8.SrO/eUPJAMVaysLr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, tiwai@suse.com

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
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joe Perches <joe@perches.com>
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
@@ -114,16 +114,51 @@ static void printk_nmi_flush_line(const
 
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
@@ -136,8 +171,8 @@ static void __printk_nmi_flush(struct ir
 		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct nmi_seq_buf *s = container_of(work, struct nmi_seq_buf, work);
 	unsigned long flags;
-	size_t len, size;
-	int i, last_i;
+	size_t len;
+	int i;
 
 	/*
 	 * The lock has two functions. First, one reader has to flush all
@@ -155,12 +190,14 @@ more:
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
@@ -168,22 +205,7 @@ more:
 
 	/* Make sure that data has been written up to the @len */
 	smp_rmb();
-
-	size = min(len, sizeof(s->buffer));
-	last_i = i;
