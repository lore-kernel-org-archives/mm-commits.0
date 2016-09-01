From: akpm@linux-foundation.org
Subject: [patch 09/14] printk/nmi: avoid direct printk()-s from
 __printk_nmi_flush()
Date: Thu, 01 Sep 2016 16:15:04 -0700
Message-ID: <57c8b678.0yB85EESu5IgAPHk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbcIAXPF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 19:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky.work@gmail.com, jack@suse.cz, pmladek@suse.com, sergey.senozhatsky@gmail.com

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: printk/nmi: avoid direct printk()-s from __printk_nmi_flush()

__printk_nmi_flush() can be called from nmi_panic(), therefore it has to
test whether it's executed in NMI context and thus must route the messages
through deferred printk() or via direct printk().  This is to avoid
potential deadlocks, as described in cf9b1106c81c45cde ("printk/nmi: flush
NMI messages on the system panic").

However there remain two places where __printk_nmi_flush() does
unconditional direct printk() calls:

 - pr_err("printk_nmi_flush: internal error ...")
 - pr_cont("\n")

Factor out print_nmi_seq_line() parts into a new printk_nmi_flush_line()
function, which takes care of in_nmi(), and use it in __printk_nmi_flush()
for printing and error-reporting.

Link: http://lkml.kernel.org/r/20160830161354.581-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff -puN kernel/printk/nmi.c~printk-nmi-avoid-direct-printk-s-from-__printk_nmi_flush kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-avoid-direct-printk-s-from-__printk_nmi_flush
+++ a/kernel/printk/nmi.c
@@ -99,27 +99,33 @@ again:
 	return add;
 }
 
-/*
- * printk one line from the temporary buffer from @start index until
- * and including the @end index.
- */
-static void print_nmi_seq_line(struct nmi_seq_buf *s, int start, int end)
+static void printk_nmi_flush_line(const char *text, int len)
 {
-	const char *buf = s->buffer + start;
-
 	/*
 	 * The buffers are flushed in NMI only on panic.  The messages must
 	 * go only into the ring buffer at this stage.  Consoles will get
 	 * explicitly called later when a crashdump is not generated.
 	 */
 	if (in_nmi())
-		printk_deferred("%.*s", (end - start) + 1, buf);
+		printk_deferred("%.*s", len, text);
 	else
-		printk("%.*s", (end - start) + 1, buf);
+		printk("%.*s", len, text);
 
 }
 
 /*
+ * printk one line from the temporary buffer from @start index until
+ * and including the @end index.
+ */
+static void printk_nmi_flush_seq_line(struct nmi_seq_buf *s,
+					int start, int end)
+{
+	const char *buf = s->buffer + start;
+
+	printk_nmi_flush_line(buf, (end - start) + 1);
+}
+
+/*
  * Flush data from the associated per_CPU buffer. The function
  * can be called either via IRQ work or independently.
  */
@@ -150,9 +156,11 @@ more:
 	 * the buffer an unexpected way. If we printed something then
 	 * @len must only increase.
 	 */
-	if (i && i >= len)
-		pr_err("printk_nmi_flush: internal error: i=%d >= len=%zu\n",
-		       i, len);
+	if (i && i >= len) {
+		const char *msg = "printk_nmi_flush: internal error\n";
+
+		printk_nmi_flush_line(msg, strlen(msg));
+	}
 
 	if (!len)
 		goto out; /* Someone else has already flushed the buffer. */
@@ -166,14 +174,14 @@ more:
 	/* Print line by line. */
 	for (; i < size; i++) {
 		if (s->buffer[i] == '\n') {
-			print_nmi_seq_line(s, last_i, i);
+			printk_nmi_flush_seq_line(s, last_i, i);
 			last_i = i + 1;
 		}
 	}
 	/* Check if there was a partial line. */
 	if (last_i < size) {
-		print_nmi_seq_line(s, last_i, size - 1);
-		pr_cont("\n");
+		printk_nmi_flush_seq_line(s, last_i, size - 1);
+		printk_nmi_flush_line("\n", strlen("\n"));
 	}
 
 	/*
_
