From: akpm@linux-foundation.org
Subject: + printk-sound-handle-more-message-headers-fix.patch added to -mm tree
Date: Mon, 14 Nov 2016 16:47:06 -0800
Message-ID: <582a5b0a.FixuI1BFG3+yUiio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755155AbcKOArH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 19:47:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/sound: Fix a check of the valid message level
has been added to the -mm tree.  Its filename is
     printk-sound-handle-more-message-headers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-sound-handle-more-message-headers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-sound-handle-more-message-headers-fix.patch

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

printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-sound-handle-more-message-headers.patch
printk-sound-handle-more-message-headers-fix.patch

