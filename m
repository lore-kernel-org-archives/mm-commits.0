From: akpm@linux-foundation.org
Subject: + printk-btrfs-handle-more-message-headers.patch added to -mm
 tree
Date: Wed, 09 Nov 2016 14:35:48 -0800
Message-ID: <5823a4c4.+nIeDbAB7UpvWZ0i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753767AbcKIWft (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 17:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, clm@fb.com, dsterba@suse.com, jason.wessel@windriver.com, jbacik@fb.com, joe@perches.com, perex@perex.cz, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/btrfs: Handle more message headers
has been added to the -mm tree.  Its filename is
     printk-btrfs-handle-more-message-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-btrfs-handle-more-message-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-btrfs-handle-more-message-headers.patch

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
Subject: printk/btrfs: Handle more message headers

4bcc595ccd80decb4245096e ("printk: reinstate KERN_CONT for printing
continuation lines") allows to define more message headers for a single
message.  The motivation is that continuous lines might get mixed. 
Therefore it make sense to define the right log level for every piece of a
cont line.

The current btrfs_printk() macros do not support continuous lines at the
moment.  But better be prepared for a custom messages and avoid potential
"lvl" buffer overflow.

This patch iterates over the entire message header.  It is interested only
into the message level like the original code.

This patch also introduces PRINTK_MAX_SINGLE_HEADER_LEN.  Three bytes are
enough for the message level header at the moment.  But it used to be
three, see the commit 04d2c8c83d0e3ac5f ("printk: convert the format for
KERN_<LEVEL> to a 2 byte pattern").

Also I fixed the default ratelimit level.  It looked very strange when it
was different from the default log level.

Link: http://lkml.kernel.org/r/1478695291-12169-4-git-send-email-pmladek@suse.com
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

 fs/btrfs/super.c       |   26 +++++++++++++++-----------
 include/linux/printk.h |    2 ++
 2 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/btrfs/super.c~printk-btrfs-handle-more-message-headers fs/btrfs/super.c
--- a/fs/btrfs/super.c~printk-btrfs-handle-more-message-headers
+++ a/fs/btrfs/super.c
@@ -202,27 +202,31 @@ static struct ratelimit_state printk_lim
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
-	char lvl[4];
+	char lvl[PRINTK_MAX_SINGLE_HEADER_LEN + 1];
 	struct va_format vaf;
 	va_list args;
-	const char *type = logtypes[4];
+	const char *type = NULL;
 	int kern_level;
 	struct ratelimit_state *ratelimit;
 
 	va_start(args, fmt);
 
-	kern_level = printk_get_level(fmt);
-	if (kern_level) {
+	while ((kern_level = printk_get_level(fmt)) != 0) {
 		size_t size = printk_skip_level(fmt) - fmt;
-		memcpy(lvl, fmt,  size);
-		lvl[size] = '\0';
+
+		if (kern_level >= '0' || kern_level <= '7') {
+			memcpy(lvl, fmt,  size);
+			lvl[size] = '\0';
+			type = logtypes[kern_level - '0'];
+			ratelimit = &printk_limits[kern_level - '0'];
+		}
 		fmt += size;
-		type = logtypes[kern_level - '0'];
-		ratelimit = &printk_limits[kern_level - '0'];
-	} else {
+	}
+
+	if (!type) {
 		*lvl = '\0';
-		/* Default to debug output */
-		ratelimit = &printk_limits[7];
+		type = logtypes[4];
+		ratelimit = &printk_limits[4];
 	}
 
 	vaf.fmt = fmt;
diff -puN include/linux/printk.h~printk-btrfs-handle-more-message-headers include/linux/printk.h
--- a/include/linux/printk.h~printk-btrfs-handle-more-message-headers
+++ a/include/linux/printk.h
@@ -10,6 +10,8 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define PRINTK_MAX_SINGLE_HEADER_LEN 2
+
 static inline int printk_get_level(const char *buffer)
 {
 	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-sound-handle-more-message-headers.patch

