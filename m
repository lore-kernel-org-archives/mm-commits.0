From: akpm@linux-foundation.org
Subject: [merged] printk-remove-obsolete-check-for-log-level-c.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:48 -0700
Message-ID: <533f08e0.zgJuxvhQ4lPzqFl4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaDDTct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: [merged] printk-remove-obsolete-check-for-log-level-c.patch removed from -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:48 -0700


The patch titled
     Subject: printk: remove obsolete check for log level "c"
has been removed from the -mm tree.  Its filename was
     printk-remove-obsolete-check-for-log-level-c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

