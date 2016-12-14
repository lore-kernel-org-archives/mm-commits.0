From: akpm@linux-foundation.org
Subject: [merged] printk-sound-handle-more-message-headers.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:27:22 -0800
Message-ID: <58519d1a.NehkbL30oENdInnm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756534AbcLNT2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/sound: handle more message headers
has been removed from the -mm tree.  Its filename was
     printk-sound-handle-more-message-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from pmladek@suse.com are

kdb-remove-unused-kdb_event-handling.patch
kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus.patch
kdb-call-vkdb_printf-from-vprintk_default-only-when-wanted.patch

