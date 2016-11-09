From: akpm@linux-foundation.org
Subject: + printk-kdb-handle-more-message-headers.patch added to -mm tree
Date: Wed, 09 Nov 2016 14:35:46 -0800
Message-ID: <5823a4c2.a9aPGzQ0WzFh/Xo8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752674AbcKIWfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 17:35:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/kdb: handle more message headers
has been added to the -mm tree.  Its filename is
     printk-kdb-handle-more-message-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-kdb-handle-more-message-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-kdb-handle-more-message-headers.patch

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
Subject: printk/kdb: handle more message headers

4bcc595ccd80decb4245096e ("printk: reinstate KERN_CONT for printing
continuation lines") allows to define more message headers for a single
message.  The motivation is that continuous lines might get mixed. 
Therefore it make sense to define the right log level for every piece of a
cont line.

This patch introduces printk_skip_headers() that will skip all headers and
uses it in the kdb code instead of printk_skip_level().

This approach helps to fix other printk_skip_level() users independently.

Link: http://lkml.kernel.org/r/1478695291-12169-3-git-send-email-pmladek@suse.com
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

 include/linux/printk.h    |    8 ++++++++
 kernel/debug/kdb/kdb_io.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/printk.h~printk-kdb-handle-more-message-headers include/linux/printk.h
--- a/include/linux/printk.h~printk-kdb-handle-more-message-headers
+++ a/include/linux/printk.h
@@ -31,6 +31,14 @@ static inline const char *printk_skip_le
 	return buffer;
 }
 
+static inline const char *printk_skip_headers(const char *buffer)
+{
+	while (printk_get_level(buffer))
+		buffer = printk_skip_level(buffer);
+
+	return buffer;
+}
+
 #define CONSOLE_EXT_LOG_MAX	8192
 
 /* printk's without a loglevel use this.. */
diff -puN kernel/debug/kdb/kdb_io.c~printk-kdb-handle-more-message-headers kernel/debug/kdb/kdb_io.c
--- a/kernel/debug/kdb/kdb_io.c~printk-kdb-handle-more-message-headers
+++ a/kernel/debug/kdb/kdb_io.c
@@ -697,7 +697,7 @@ kdb_printit:
 	 * Write to all consoles.
 	 */
 	retlen = strlen(kdb_buffer);
-	cp = (char *) printk_skip_level(kdb_buffer);
+	cp = (char *) printk_skip_headers(kdb_buffer);
 	if (!dbg_kdb_mode && kgdb_connected) {
 		gdbstub_msg_write(cp, retlen - (cp - kdb_buffer));
 	} else {
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-sound-handle-more-message-headers.patch

