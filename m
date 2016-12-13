From: akpm@linux-foundation.org
Subject: [patch 106/123] printk/sound: handle more message headers
Date: Mon, 12 Dec 2016 16:45:53 -0800
Message-ID: <584f44c1.nnv6HXfZCU6a9PIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbcLMApy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, tiwai@suse.com

From: Petr Mladek <pmladek@suse.com>
Subject: printk/sound: handle more message headers

4bcc595ccd80decb4245096e ("printk: reinstate KERN_CONT for printing
continuation lines") allows to define more message headers for a single
message.  The motivation is that continuous lines might get mixed. 
Therefore it make sense to define the right log level for every piece of a
cont line.

This patch allows to copy only the real message level.  We should ignore
KERN_CONT because <filename:line> is added for each message.  By other
words, we want to know where each piece of the line comes from.

[pmladek@suse.com: fix a check of the valid message level]
  Link: http://lkml.kernel.org/r/20161111183444.GE2145@dhcp128.suse.cz
Link: http://lkml.kernel.org/r/1478695291-12169-5-git-send-email-pmladek@suse.com
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

 sound/core/misc.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN sound/core/misc.c~printk-sound-handle-more-message-headers sound/core/misc.c
--- a/sound/core/misc.c~printk-sound-handle-more-message-headers
+++ a/sound/core/misc.c
@@ -71,6 +71,7 @@ void __snd_printk(unsigned int level, co
 	int kern_level;
 	struct va_format vaf;
 	char verbose_fmt[] = KERN_DEFAULT "ALSA %s:%d %pV";
+	bool level_found = false;
 #endif
 
 #ifdef CONFIG_SND_DEBUG
@@ -83,15 +84,22 @@ void __snd_printk(unsigned int level, co
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	kern_level = printk_get_level(format);
-	if (kern_level) {
-		const char *end_of_header = printk_skip_level(format);
-		memcpy(verbose_fmt, format, end_of_header - format);
+	while ((kern_level = printk_get_level(vaf.fmt)) != 0) {
+		const char *end_of_header = printk_skip_level(vaf.fmt);
+
+		/* Ignore KERN_CONT. We print filename:line for each piece. */
+		if (kern_level >= '0' && kern_level <= '7') {
+			memcpy(verbose_fmt, vaf.fmt, end_of_header - vaf.fmt);
+			level_found = true;
+		}
+
 		vaf.fmt = end_of_header;
-	} else if (level)
+	}
+
+	if (!level_found && level)
 		memcpy(verbose_fmt, KERN_DEBUG, sizeof(KERN_DEBUG) - 1);
-	printk(verbose_fmt, sanity_file_name(path), line, &vaf);
 
+	printk(verbose_fmt, sanity_file_name(path), line, &vaf);
 #else
 	vprintk(format, args);
 #endif
_
