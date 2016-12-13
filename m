From: akpm@linux-foundation.org
Subject: [patch 104/123] printk/kdb: handle more message headers
Date: Mon, 12 Dec 2016 16:45:47 -0800
Message-ID: <584f44bb.SE1HWOa8phV0a/lE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAps (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, tiwai@suse.com

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
