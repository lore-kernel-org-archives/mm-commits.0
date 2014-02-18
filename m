From: akpm@linux-foundation.org
Subject: + printk-remove-obsolete-check-for-log-level-c.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:03:43 -0800
Message-ID: <5303caaf.iiTbfWgnLn9xbKAc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaBRVDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: + printk-remove-obsolete-check-for-log-level-c.patch added to -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:03:43 -0800


The patch titled
     Subject: printk: remove obsolete check for log level "c"
has been added to the -mm tree.  Its filename is
     printk-remove-obsolete-check-for-log-level-c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-remove-obsolete-check-for-log-level-c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-remove-obsolete-check-for-log-level-c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: printk: remove obsolete check for log level "c"

The kernel log level "c" was removed in 61e99ab8e35a88b8 ("printk: remove
the now unnecessary "C" annotation for KERN_CONT").  It is no longer
detected in printk_get_level().  Hence we do not need to check it in
vprintk_emit.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-remove-obsolete-check-for-log-level-c kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-remove-obsolete-check-for-log-level-c
+++ a/kernel/printk/printk.c
@@ -1560,8 +1560,6 @@ asmlinkage int vprintk_emit(int facility
 					level = kern_level - '0';
 			case 'd':	/* KERN_DEFAULT */
 				lflags |= LOG_PREFIX;
-			case 'c':	/* KERN_CONT */
-				break;
 			}
 			text_len -= end_of_header - text;
 			text = (char *)end_of_header;
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch

