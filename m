From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-sound-handle-more-message-headers-fix.patch removed from -mm tree
Date: Mon, 12 Dec 2016 16:26:15 -0800
Message-ID: <584f4027.N0kQnbUAAqXIKDSA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAZb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:25:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/sound: Fix a check of the valid message level
has been removed from the -mm tree.  Its filename was
     printk-sound-handle-more-message-headers-fix.patch

This patch was dropped because it was folded into printk-sound-handle-more-message-headers.patch

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk/sound: Fix a check of the valid message level

Huh, this was a childish mistake.

Link: http://lkml.kernel.org/r/20161111183444.GE2145@dhcp128.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/core/misc.c~printk-sound-handle-more-message-headers-fix sound/core/misc.c
--- a/sound/core/misc.c~printk-sound-handle-more-message-headers-fix
+++ a/sound/core/misc.c
@@ -88,7 +88,7 @@ void __snd_printk(unsigned int level, co
 		const char *end_of_header = printk_skip_level(vaf.fmt);
 
 		/* Ignore KERN_CONT. We print filename:line for each piece. */
-		if (kern_level >= '0' || kern_level <= '7') {
+		if (kern_level >= '0' && kern_level <= '7') {
 			memcpy(verbose_fmt, vaf.fmt, end_of_header - vaf.fmt);
 			level_found = true;
 		}
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch
printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-sound-handle-more-message-headers.patch

