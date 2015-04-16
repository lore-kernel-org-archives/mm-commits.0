From: akpm@linux-foundation.org
Subject: [merged]
 printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:54:37 -0700
Message-ID: <552fe94d.FOJNH9y32WewYtXk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbbDPQtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, bp@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: comment pr_cont() stating it is only to continue a line
has been removed from the -mm tree.  Its filename was
     printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
util_macrosh-add-find_closest-macro.patch
documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch
hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch
hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch
linux-next.patch

