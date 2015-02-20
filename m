From: akpm@linux-foundation.org
Subject: +
 printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch added to -mm tree
Date: Fri, 20 Feb 2015 13:30:38 -0800
Message-ID: <54e7a77e.g8KKMjEdCPdvATlb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbbBTVaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 16:30:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, bp@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: comment pr_cont() stating it is only to continue a line
has been added to the -mm tree.  Its filename is
     printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: printk: comment pr_cont() stating it is only to continue a line

KERN_CONT is nicely commented in kern_levels.h, but pr_cont() is now used
more often, and it lacks the comment stating what it is used for.  It can
be confused as continuing the log level, but that is not its purpose.  Its
purpose is to continue a line that had no newline enclosed.  This should
be documented by pr_cont() as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/printk.h~printk-comment-pr_cont-stating-it-is-only-to-continue-a-line include/linux/printk.h
--- a/include/linux/printk.h~printk-comment-pr_cont-stating-it-is-only-to-continue-a-line
+++ a/include/linux/printk.h
@@ -255,6 +255,11 @@ extern asmlinkage void dump_stack(void)
 	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
 	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/*
+ * Like KERN_CONT, pr_cont() should only be used when continuing
+ * a line with no newline ('\n') enclosed. Otherwise it defaults
+ * back to KERN_DEFAULT.
+ */
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch
linux-next.patch

