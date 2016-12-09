From: akpm@linux-foundation.org
Subject: + printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch
 added to -mm tree
Date: Fri, 09 Dec 2016 13:31:31 -0800
Message-ID: <584b22b3.w8bZeqsDBH31wFaL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbcLIVaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2016 16:30:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/NMI: fix up handling of the full nmi log buffer
has been added to the -mm tree.  Its filename is
     printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch

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

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch
printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers-fix.patch
printk-sound-handle-more-message-headers.patch
printk-sound-handle-more-message-headers-fix.patch
kdb-remove-unused-kdb_event-handling.patch
kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus.patch
kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted.patch

