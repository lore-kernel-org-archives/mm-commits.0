From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-prerequisite-timestamp.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:59 -0700
Message-ID: <200708250518.l7P5Ixxg031926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872AbXHYFbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure - prerequisite: timestamp
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-prerequisite-timestamp.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure - prerequisite: timestamp
From: Martin Peschke <mp3@de.ibm.com>

Separate the timestamp code out from printk.  Thus, other components, like the
statistics infrastructure, can also make use of it and provide similar
timestamps.  It just makes sense to have one timestamp format throughout the
kernel.

The original piece of code was a bit promiscuous, IMHO.  Please accept the
little cleanup that comes with my patch.

And I think that I have fixed a printed_len related miscalculation. 
printed_len needs to be increased if no valid log level has been found and a
log level prefix has been added by printk().  Otherwise, printed_len must not
be increased.  The old code did it the other way around (in the timestamp
case).

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
DESC
restore correct print_len calculation in printk
EDESC

This fixes the following miscalculation that has been introduced by my
statistics-infrastructure-prerequisite-timestamp.patch:

print_len loses 3 in the 'got log level'-case due to a surplus
substraction.  It also loses 3 in the other case due to adding a log level
substring that is not entered in the books.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    8 ++++
 kernel/printk.c         |   74 +++++++++++++++-----------------------
 2 files changed, 38 insertions(+), 44 deletions(-)

diff -puN include/linux/jiffies.h~statistics-infrastructure-prerequisite-timestamp include/linux/jiffies.h
--- a/include/linux/jiffies.h~statistics-infrastructure-prerequisite-timestamp
+++ a/include/linux/jiffies.h
@@ -278,4 +278,12 @@ extern u64 nsec_to_clock_t(u64 x);
 
 #define TIMESTAMP_SIZE	30
 
+static inline int nsec_to_timestamp(char *s, unsigned long long t)
+{
+	unsigned long nsec_rem = do_div(t, NSEC_PER_SEC);
+	return sprintf(s, "[%5lu.%06lu]", (unsigned long)t,
+		       nsec_rem/NSEC_PER_USEC);
+}
+#define TIMESTAMP_SIZE	30
+
 #endif
diff -puN kernel/printk.c~statistics-infrastructure-prerequisite-timestamp kernel/printk.c
--- a/kernel/printk.c~statistics-infrastructure-prerequisite-timestamp
+++ a/kernel/printk.c
@@ -527,7 +527,7 @@ asmlinkage int vprintk(const char *fmt, 
 	int printed_len;
 	char *p;
 	static char printk_buf[1024];
-	static int log_level_unknown = 1;
+	static int new_line = 1;
 
 	preempt_disable();
 	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
@@ -546,59 +546,45 @@ asmlinkage int vprintk(const char *fmt, 
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
-	 * appropriate log level tags, we insert them here
+	 * appropriate log level tags, we insert them here.
 	 */
 	for (p = printk_buf; *p; p++) {
-		if (log_level_unknown) {
-                        /* log_level_unknown signals the start of a new line */
+		if (new_line) {
+			/* The log level token is first. */
+			int loglev_char;
+			if (p[0] == '<' && p[1] >='0' &&
+			    p[1] <= '7' && p[2] == '>') {
+				loglev_char = p[1];
+				p += 3;
+			} else	{
+				loglev_char = default_message_loglevel + '0';
+				printed_len += 3;
+			}
+			emit_log_char('<');
+			emit_log_char(loglev_char);
+			emit_log_char('>');
+			/* A timestamp, if requested, goes next. */
 			if (printk_time) {
-				int loglev_char;
-				char tbuf[50], *tp;
-				unsigned tlen;
-				unsigned long long t;
-				unsigned long nanosec_rem;
-
-				/*
-				 * force the log level token to be
-				 * before the time output.
-				 */
-				if (p[0] == '<' && p[1] >='0' &&
-				   p[1] <= '7' && p[2] == '>') {
-					loglev_char = p[1];
-					p += 3;
-					printed_len -= 3;
-				} else {
-					loglev_char = default_message_loglevel
-						+ '0';
-				}
-				t = printk_clock();
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf,
-						"<%c>[%5lu.%06lu] ",
-						loglev_char,
-						(unsigned long)t,
-						nanosec_rem/1000);
-
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
+				char tbuf[TIMESTAMP_SIZE], *tp;
+				printed_len += nsec_to_timestamp(tbuf,
+							printk_clock());
+				for (tp = tbuf; *tp; tp++)
 					emit_log_char(*tp);
-				printed_len += tlen;
-			} else {
-				if (p[0] != '<' || p[1] < '0' ||
-				   p[1] > '7' || p[2] != '>') {
-					emit_log_char('<');
-					emit_log_char(default_message_loglevel
-						+ '0');
-					emit_log_char('>');
-					printed_len += 3;
-				}
+				emit_log_char(' ');
+				printed_len++;
 			}
-			log_level_unknown = 0;
+			new_line = 0;
 			if (!*p)
 				break;
 		}
+		/*
+		 * Once we are done with special strings at the head of
+		 * each line, we just keep copying characters until
+		 * we come across another line and need to start over.
+		 */
 		emit_log_char(*p);
 		if (*p == '\n')
-			log_level_unknown = 1;
+			new_line = 1;
 	}
 
 	if (!down_trylock(&console_sem)) {
_

Patches currently in -mm which might be from mp3@de.ibm.com are
