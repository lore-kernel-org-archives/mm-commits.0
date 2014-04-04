From: akpm@linux-foundation.org
Subject: [merged]
 printk-add-comment-about-tricky-check-for-text-buffer-size.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:32:50 -0700
Message-ID: <533f08e2.R9upVDYn0+UjZ51+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaDDTcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: [merged] printk-add-comment-about-tricky-check-for-text-buffer-size.patch removed from -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:50 -0700


The patch titled
     Subject: printk: add comment about tricky check for text buffer size
has been removed from the -mm tree.  Its filename was
     printk-add-comment-about-tricky-check-for-text-buffer-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: printk: add comment about tricky check for text buffer size

There is no check for potential "text_len" overflow.  It is not needed
because only valid level is detected.  It took me some time to understand
why.  It would deserve a comment ;-)

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/printk/printk.c~printk-add-comment-about-tricky-check-for-text-buffer-size kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-comment-about-tricky-check-for-text-buffer-size
+++ a/kernel/printk/printk.c
@@ -1561,6 +1561,11 @@ asmlinkage int vprintk_emit(int facility
 			case 'd':	/* KERN_DEFAULT */
 				lflags |= LOG_PREFIX;
 			}
+			/*
+			 * No need to check length here because vscnprintf
+			 * put '\0' at the end of the string. Only valid and
+			 * newly printed level is detected.
+			 */
 			text_len -= end_of_header - text;
 			text = (char *)end_of_header;
 		}
_

Patches currently in -mm which might be from pmladek@suse.cz are

origin.patch
linux-next.patch

