From: akpm@linux-foundation.org
Subject: [patch 102/123] printk/NMI: fix up handling of the full nmi log
 buffer
Date: Mon, 12 Dec 2016 16:45:40 -0800
Message-ID: <584f44b4.LZOO7oKVVB1Fq3Nx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, tiwai@suse.com

From: Petr Mladek <pmladek@suse.com>
Subject: printk/NMI: fix up handling of the full nmi log buffer

vsnprintf() adds the trailing '\0' but it does not count it into the
number of printed characters.  The result is that there is one byte less
space for the real characters in the buffer.

The broken check for the free space might cause that we will repeatedly
try to print 1 character into the buffer, never reach the full buffer, and
do not count the messages as missed.

Also vsnprintf() returns the number of characters that would be printed if
the buffer was big enough.  As a result, s->len might be bigger than the
size of the buffer[*].  And the printk() function might return bigger len
than it really printed.  Both problems are fixed by using vscnprintf()
instead.

Note that I though about increasing the number of missed messages even
when the message was shrunken.  But it made the code even more
complicated.  I think that it is not worth it.  Shrunken messages are
usually easy to recognize.  And it should be a corner case.

[*] The overflown s->len value is crazy and unexpected.  I "made a
mistake" and reported this situation as an internal error when fixed
handling of PR_CONT headers in some other patch.

Link: http://lkml.kernel.org/r/20161208174912.GA17042@linux.suse
Signed-off-by: Petr Mladek <pmladek@suse.com>
CcL Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/printk/nmi.c~printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer
+++ a/kernel/printk/nmi.c
@@ -67,7 +67,8 @@ static int vprintk_nmi(const char *fmt,
 again:
 	len = atomic_read(&s->len);
 
-	if (len >= sizeof(s->buffer)) {
+	/* The trailing '\0' is not counted into len. */
+	if (len >= sizeof(s->buffer) - 1) {
 		atomic_inc(&nmi_message_lost);
 		return 0;
 	}
@@ -79,7 +80,7 @@ again:
 	if (!len)
 		smp_rmb();
 
-	add = vsnprintf(s->buffer + len, sizeof(s->buffer) - len, fmt, args);
+	add = vscnprintf(s->buffer + len, sizeof(s->buffer) - len, fmt, args);
 
 	/*
 	 * Do it once again if the buffer has been flushed in the meantime.
_
